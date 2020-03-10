#######################################
#                                                                                              #
#                       Gouvernance SP teams                            #
#                                                                                              #
#######################################

#######################################
# Var 
#######################################
#url site
$SiteURL = "https://sf2inc.sharepoint.com/sites/GouvernanceTeams/"
#Nom de la teams
$ListName="Teams"
#Parametre de date
$ObsoletDate = (Get-Date).AddDays(-60)
$aujourd = Get-Date
#TABLEAU
#tableau de stockage teams
$TabTeams = @()

#######################################
# connection 
#######################################
#TEAMS
Write-Host "Connection a Teams" -ForegroundColor Green
$securePassword= Get-Content -Path 'C:\Users\dolme\Desktop\powershell  SF2I\Password.pswd' | ConvertTo-SecureString
$mycreds = New-Object System.Management.Automation.PSCredential ("adm_lbras@sf2i.nc", 
$securePassword)
Connect-MicrosoftTeams -Credential $mycreds;

#SHAREPOINT
Write-Host "Connection a SharePoint" -ForegroundColor Green
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$securePassword= Get-Content -Path 'C:\Users\dolme\Desktop\powershell  SF2I\Password.pswd' | ConvertTo-SecureString
$Context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("adm_lbras@sf2i.nc", $securePassword)

#EXO
#$UserCredential = Get-Credential
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session -DisableNameChecking


#######################################
# Récuperation des Teams
#######################################
Write-Host "Récupération des Teams" -ForegroundColor Yellow
$allTeams = Get-Team

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
# Partie Sharepoint
#######################################
Write-Host "/!\ Debut de l'ajout a SP /!\" -ForegroundColor Green

#find the list 
$Web = $Context.Web
$List = $web.get_lists().getByTitle($ListName)

#send data to the list
$itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation

for ($i = 0;4 -ge $i; $i++){
    $result = $TabTeams[$i].membre.Count + $TabTeams[$i].owner.Count
    $listItem = $list.addItem($itemCreateInfo)
    $listItem['IDEquipe'] = $TabTeams[$i].key
    $listItem['Equipe'] = $TabTeams[$i].TeamsName
    $listItem['NombrePers'] = $result
    $listItem['DernierFichier'] = $TabTeams[$i].FileAccessed
    $listItem['Description'] = [string]$TabTeams[$i].description
    if($TabTeams[$i].lastchat -ne $null){
        $listItem['DernierChat'] = [string]$TabTeams[$i].lastchat
    }else{
        $listItem['DernierChat'] = "aucun chat trouver"
    }
    $Owner = ""
    $member = "" 
    #run trough the owner and send them to the SP
    for($y = 0;$TabTeams[$i].owner.Length -ge $y; $y++){
        $Owner +="  "+ $TabTeams[$i].owner[$y]
        $listItem['Owner'] = $owner
    }
    #run trough the member and send them to the SP
    for($z = 0;$TabTeams[$i].membre.Length -ge $z; $z++){
        $member+="   "+ $TabTeams[$i].membre[$z]
        $listItem['Membre'] = $member
    }
    Write-Host "Membre numero $($i) ajouter"
    $listItem.update();
}

#load the list in SP
$Context.Load($listItem)
$Context.ExecuteQuery()



