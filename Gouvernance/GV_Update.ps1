#######################################
#                                                                                              #
#                   Gouvernance update teams                       #
#                                                                                              #
#######################################

#######################################
# Var 
#######################################
#url 
$SiteURL = "https://sf2inc.sharepoint.com/sites/GouvernanceTeams/"
#Nom Liste
$ListName="Teams"
#TABLEAU
#tableau teams
$Tab_Obj_Teams = @()
$TabTeamsTEmpo = @()
$TabTeams = @()
#date
$ObsoletDate = (Get-Date).AddDays(-60)
$aujourd = Get-Date


#######################################
# connection 
#######################################
#TEAMS
$securePassword= Get-Content -Path 'C:\Users\dolme\Desktop\powershell  SF2I\Password.pswd' | ConvertTo-SecureString
$mycreds = New-Object System.Management.Automation.PSCredential ("adm_lbras@sf2i.nc", 
$securePassword)
Connect-MicrosoftTeams -Credential $mycreds

#PNP
Write-Host "Connection a PNP" -ForegroundColor Green
$securePassword= Get-Content -Path 'C:\Users\dolme\Desktop\powershell  SF2I\Password.pswd' | ConvertTo-SecureString
$mycreds = New-Object System.Management.Automation.PSCredential ("adm_lbras@sf2i.nc", $securePassword)
Connect-PnPOnline -Url $SiteURL -Credentials $mycreds 

#######################################
# Récuperation des Teams
#######################################
$allTeams = Get-Team

#######################################
# Récuperation Liste SP
#######################################
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
 
 Foreach($Items in $Liste_Teams)
{
    $IDEquipe = $items["IDEquipe"]
    if (-not [String]::IsNullOrEmpty($IDEquipe))
    {
        #recuperation de la ligne sans id equipe
        $Obj_List_Teams = New-Object -TypeName PSCustomObject -Property @{
            IDE = $items["IDEquipe"]
            Equipe = $items["Equipe"]
            IDSP = $items["ID"]
        }
        $Tab_Obj_Teams += $Obj_List_Teams
    }
}


#######################################
# TEAMS 
#######################################

#######################################
# Ordonnancement des informations dans un objet
#######################################
Write-Host "Lecture des Teams" -ForegroundColor Yellow
$allTeams | ForEach-Object {

    #######################################
    # GET-TEAM
    #######################################
    #Initialisation de l'object
    $TeamsObject = New-Object -TypeName PSCustomObject -Property @{
        Key = $key
        TeamsName = $Name
        owner = @()
        membre = @()
        description = @()
        lastchat = $lastchatdate
        FileAccessed = $lastFile
        }

    #Récupération des données du get-team
    $Key = $_.GroupId
    $Name = $_.DisplayName
    $membre = @()
    $owner = @()
    $description = @()

    Write-Host $key  " | "  $Name  -ForegroundColor Gray

    #######################################
    # Récuperation des derniers chats
    #######################################
    $lastchatdate = Get-mailbox -groupmailbox "$Name" | Get-MailboxFolderStatistics -IncludeOldestAndNewestItems -FolderScope ConversationHistory
    $lastchatdate = $lastchatdate.NewestItemLastModifiedDate


    #######################################
    # GET-TEAMUSER
    #######################################
    Get-TeamUser -GroupId $_.GroupId | ForEach-Object {    
        $Nom = $_.user
        $role = $_.Role

        if ( $role -eq "Member" ){
            $membre +=$_.Name
        }
        else{
            $owner +=$_.Name
        }       
    }
    #récuperation de la description
    $description += $_.Description


    #######################################
    # Derniere acces au SP Teams
    #######################################
    $groupID =  $_.GroupId
    $Groups = Get-UnifiedGroup -Identity $groupID
    $last = $groups.SharePointDocumentsUrl
    $last = $groups.SharePointDocumentsUrl.replace("/Documents partages", "")
    $AuditCheck = $Groups.SharePointDocumentsUrl + "/*"
    $lastFile = Search-UnifiedAuditLog -RecordType SharePointFileOperation -StartDate $ObsoletDate -EndDate $aujourd -ObjectId $AuditCheck | select Operations, CreationDate |where{$_.Operations -eq "FileAccessed" }
    if($lastFile -ne $null){
        $lastFile = $lastFile.CreationDate
        $TeamsObject.FileAccessed = $lastFile[1]
     }
     else{
        $TeamsObject.FileAccessed = "Derniere utilisation il y a plus de 60 jours"
     }
   
    #######################################
    # Centralisation
    #######################################
   
    $TeamsObject.membre = $membre
    $TeamsObject.owner = $owner
    $TeamsObject.description = $description   
    Write-Host "$($TeamsObject.Key)..." -ForegroundColor Gray
    $TabTeams += $TeamsObject
}
Write-Host "/!\ Fin de la recuperation des Teams /!\" -ForegroundColor Green

#######################################
# Comparaison
#######################################
foreach($obj in $Tab_Obj_Teams)
{
    $TabTeamsTEmpo += $TabTeams |where{$_.key  -eq $obj.IDE}
    Set-Team -GroupId $obj.IDE -DisplayName $obj.Equipe
    foreach ($items in $TabTeamsTEmpo)
    {
        $max = $TabTeamsTEmpo.Length
         $update = Set-PnPListItem -List Teams -Identity $obj.IDSP -Values @{"Owner" = $items.owner;"Membre"= $items.membre ; "Description"= $items.description ;"DernierChat"= $items.lastchat;"DernierFichier"= $items.FileAccessed}
     }
 }