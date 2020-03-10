#######################################
#                                                                                              #
#                 Gouvernance Creation teams                       #
#                                                                                              #
#######################################

#######################################
# Var 
#######################################
#Url site
$SiteURL = "https://sf2inc.sharepoint.com/sites/GouvernanceTeams/"
#Nom de la teams
$ListName="Teams"
#TABLEAU
$Tab_Obj_Teams = @()
$Tab_URLSP = @()

#######################################
# connection 
#######################################
#TEAMS
Write-Host "Connection a Teams" -ForegroundColor Green
$securePassword= Get-Content -Path 'C:\Users\dolme\Desktop\powershell  SF2I\Password.pswd' | ConvertTo-SecureString
$mycreds = New-Object System.Management.Automation.PSCredential ("adm_lbras@sf2i.nc", $securePassword)
Connect-MicrosoftTeams -Credential $mycreds 
#PNP
Write-Host "Connection a PNP" -ForegroundColor Green
$securePassword= Get-Content -Path 'C:\Users\dolme\Desktop\powershell  SF2I\Password.pswd' | ConvertTo-SecureString
$mycreds = New-Object System.Management.Automation.PSCredential ("adm_lbras@sf2i.nc", $securePassword)
Connect-PnPOnline -Url $SiteURL -Credentials $mycreds 


#######################################
# Lire entré SP (celle sans id)
#######################################
#recuperé l'index de la ligne sans id
try{
    $Liste_Teams =Get-PnPListItem -List Teams
    if($Liste_Teams -ne $null)
    {
        Write-Host "List Recupéré" -ForegroundColor Green
    }
    else
    {
        Write-Host "Probleme de liste" -ForegroundColor Red
    }
}Catch{}


#recuperation du contexte de la liste
try{
    $context = Get-PnPContext
    foreach ($items in $Liste_Teams)
    {
        $context.Load($item)
        $context.ExecuteQuery()
    }
}Catch{}

#test ID
Foreach($Items in $Liste_Teams)
{
    $IDEquipe = $items["IDEquipe"]
    if ([String]::IsNullOrEmpty($IDEquipe))
    {
        #recuperation de la ligne sans id equipe
        $Obj_List_Teams = New-Object -TypeName PSCustomObject -Property @{
            Type = $items["Type_Equipe"]
            Societe = $items["Societe"]
            NomEquipe = $items["Equipe"]
            Description  = $items["Description"]
            owner = $items["Author"]
            id = $items["ID"]
            Pays = $items["Pays"]
            ChkCom = $items["Equipe_Dedier_Com"]
        }
        $Tab_Obj_Teams += $Obj_List_Teams
    }
}

#verification du tableau
if ($Tab_Obj_Teams[0].Type -eq $null)
{
    Write-Host "Ancune Lignes Sans ID" -ForegroundColor Yellow
}
else
{
    Write-Host "Lignes Sans ID Trouvé" -ForegroundColor Green
    Write-Host $Tab_Obj_Teams -ForegroundColor Gray
}

#######################################
# creation SP avec nom personalisé
#######################################
#var utile pour creation SP
foreach($items in $Tab_Obj_Teams){

#GEstion de la checkBox
if($items.ChkCom -eq $true)
{
    $Equipe_Dedier_Com = "EXT"
}
else
{
    $Equipe_Dedier_Com = "INT"
}

#gestion de la syntaxe (SNC-INT-CLI OPT
$NameSp = "$($items.Societe[0])$($items.Pays)-$($Equipe_Dedier_Com)-$($items.Type) $($items.NomEquipe)"
$DescSP = "$($items.Description)"
$NameSpSpaceless = $NameSp -replace "-", "" 
$NameSpSpaceless = $NameSpSpaceless -replace " ", "_" 
Write-Host $NameSpSpaceless -ForegroundColor Yellow


#creation du site avec url personalise
Write-Host "site en cours de creation" -ForegroundColor Green
$urlSP = New-PnPSite -Type TeamSite -Title $NameSp -Description $DescSP -Alias $NameSpSpaceless 
Write-Host "URL $urlSP" -ForegroundColor Yellow
Start-Sleep -Seconds 40
$group = Get-UnifiedGroup |where {$_.DisplayName -eq $NameSp}


#######################################
# creation Teams avec les information de la liste SP
#######################################
Write-Host "creation de la Team" -ForegroundColor Yellow
$idTeam = New-Team -GroupId $group.ExternalDirectoryObjectId
Write-Host "creation réussi $($idTeam.GroupId )"

#######################################
# Assigné le proprietaire au teams (Field Cree par)
#######################################

Add-TeamUser -GroupId $idTeam.GroupId -User $items.owner.Email -Role Owner

#######################################
# Maj de la liste SP
#######################################

Set-PnPListItem -List Teams -Identity $items.id -Values @{ "IDEquipe" = $idTeam.GroupId}
}