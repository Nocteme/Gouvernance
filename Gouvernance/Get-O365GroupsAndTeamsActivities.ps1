#########################################################################################################################################################
#
# Script objectives : 
#   - Check Office 365 groups and Microsoft Teams activity on your tenant
#   - Export reports of Office 365 groups and Microsoft Teams status
#
# Description :
#   - Check Office 365 group inbox activity to get the date of the last conversation in the inbox
#   - Check SharePoint Online library to verify if it exists or not and if it is being used
#   - Check Microsoft Teams existence for each Office 365 groups
# 
# Version history : 
#  - 0.1 => 7/15/19 : Script creation | Get all Office 365 groups | Export in an HTML and CSV file
#
# Commentaires :
#   - SharePoint Online PowerShell module must be loaded
#   - Exchange Online PowerShell module must be loaded
#   - Microsoft Teams PowerShell module must be loaded
#
#########################################################################################################################################################

# Script variables
$NumberOfDays = 90
$ObsoleteDate = (Get-Date).AddDays(-$NumberOfDays)
$TodayDate = (Get-Date)
$Groups = Get-UnifiedGroup | Sort-Object DisplayName
$Teams = @{ }
# Get all the Microsoft Teams Teams
Get-Team | ForEach-Object { $Teams.Add($_.GroupId, $_.DisplayName) }
$ObsoleteGroups = 0
$Report = @()
$HtmlReportFile = "c:\_me\temp\GroupsActivityReport.html"
$CsvReportFile = "c:\_me\temp\GroupsActivityReport.csv"

# Html header and style for export
$htmlhead = "<html>
	   <style>
	   Body {font-family: Arial; font-size: 8pt;}
	   H1 {font-size: 22px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
	   H2 {font-size: 18px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
	   H3 {font-size: 16px; font-family: 'Segoe UI Light','Segoe UI','Lucida Grande',Verdana,Arial,Helvetica,sans-serif;}
	   Table {border: 1px solid #7d7df7a1; border-collapse: collapse; font-size: 8pt; margin-left: auto; margin-right : auto;}
	   TH {border: 1px solid #004d99; background: #8cb3d9; padding: 5px; color: #000000;}
	   TD {border: 1px solid #004d99; padding: 5px; }
	   </style>
	   <body>
           <div align=center>
           <p><h1>Office 365 Groups and Teams Activity Report</h1></p>
           <p><h3>Generated: " + $TodayDate + "</h3></p></div>"

Write-Host
Write-Host "####################################"
Write-Host "Checking your PowerShell modules ..."
Write-Host "####################################"

# Check SharePoint Online PowerShell module connection
Try { $SPOCheck = (Get-SPOTenant ) }
Catch {
    Write-Host " - Not connected to SPO ! Please, connect to SPO and try again." -ForegroundColor Yellow
    Break 
}
# Check Exchange Online PowerShell module connection
Try { $EXOCheck = (Get-OrganizationConfig).Name }
Catch {
    Write-Host " - Not connected to EXO ! Please, connect to EXO and try again." -ForegroundColor Yellow
    Break 
}
# Check Microsoft Teams PowerShell module connection
Try { $MSTeamsCheck = (Get-Team) }
Catch {
    Write-Host " - Not connected to MS Teams ! Please, connect to MS Teams and try again." -ForegroundColor Yellow
    Break 
}

Write-Host
Write-Host "Your PowerShell session is connected to SharePoint Online, Exchange Online and Microsoft Teams :)" -ForegroundColor Green
Write-Host
Write-Host "#############################################"
Write-Host "Listing your O365 Groups & MS Teams Teams ..."
Write-Host "#############################################"
Write-Host "Office 365 Groups & Teams :"

# Loop for all Office 365 Groups and Microsoft Teams
ForEach ($Group in $Groups) {
    Write-Host " - Group $($Group.DisplayName)"
    # Variables used in the loop for each group
    #$ObsoleteReportLine = $Group.DisplayName
    #$SPOStatus = "Normal"
    $SharePointActivity = "Document library in use"
    #$NumberWarnings = 0
    $NumberofTeamsChats = 0
    #$TeamChatData = $Null
    $IsTeamsEnabled = $False
    #$LastItemAddedtoTeams = "No chats"
    #$MailboxStatus = $Null

    # Check the Office 365 group owner
    $GroupOwner = $Group.ManagedBy
    If ([string]::IsNullOrWhiteSpace($GroupOwner) -and [string]::IsNullOrEmpty($GroupOwner)) {
        $GroupOwner = "No Owners !"
    }
    Else {
        $GroupOwnerName = ""
        foreach ($Owner in $GroupOwner) {
            $OwnerDisplayName = (Get-Mailbox -Identity $Owner).DisplayName
            $GroupOwnerName += $OwnerDisplayName + " "
        }
        $GroupOwner = $GroupOwnerName
    }

    # Check SharePoint document library activities
    If ($Null -ne $Group.SharePointDocumentsUrl) {
        $SPOSite = (Get-SPOSite -Identity $Group.SharePointDocumentsUrl.replace("/Documents partages", "")) # /Documents partages if in french
        #Write-Host "Checking SPO Site" $SPOSite.Title "..."       
        $AuditCheck = $Group.SharePointDocumentsUrl + "/*"
        $AuditRecords = 0
        $AuditRecords = (Search-UnifiedAuditLog -RecordType SharePointFileOperation -StartDate $ObsoleteDate -EndDate $TodayDate -ObjectId $AuditCheck -SessionCommand ReturnNextPreviewPage)

        If ($Null -eq $AuditRecords) {
            # If there is no audit record, the Office 365 group is potentially not used
            $SharePointActivity = "No SPO activities in the last $NumberOfDays days"
        }
    }
    Else {
        #Write-Host "SharePoint has never been used for the group" $Group.DisplayName 
        $SharePointActivity = "No SPO document library created"
    }

    # If Team-Enabled set to true, check the last chat date in the record
    If ($Teams.ContainsKey($Group.ExternalDirectoryObjectId) -eq $True) {
        $IsTeamsEnabled = $True
        $TeamChatData = (Get-MailboxFolderStatistics -Identity $Group.Alias -IncludeOldestAndNewestItems -FolderScope ConversationHistory)
        If ($TeamChatData.ItemsInFolder[1] -ne 0) {
            $LastTeamsChat = $TeamChatData.NewestItemReceivedDate[1].ToShortDateString()
            $NumberofTeamsChats = $TeamChatData.ItemsInFolder[1]
        }
    }

    # Get Office 365 inbox activity to view if there are a lot of conversations
    $Data = (Get-MailboxFolderStatistics -Identity $Group.Alias -IncludeOldestAndNewestITems -FolderScope Inbox)
    $LastEmailActivity = $Data.NewestItemReceivedDate
    $NumberOfEmails = $Data.ItemsInFolder
    $MailboxStatus = "Normal"
  
    If ($LastEmailActivity -le $ObsoleteDate) {
        $MailboxStatus = "Group inbox not recently used"
    }
    Else {
        # Check if there is more than 10 mails received.
        # Less than 10 may means that the Office 365 groups is not used anymore
        If ($Data.ItemsInFolder -lt 10) {
            $MailboxStatus = "Low number of emails received in the inbox"
        }
    }
  
    # Generate an PSCustomObject exportable (for HTML and CSV purpose)
    $ReportLine = [PSCustomObject]@{
        GroupName          = $Group.DisplayName
        GroupOwner         = $GroupOwner
        MembersCount       = $Group.GroupMemberCount
        GuestsCount        = $Group.GroupExternalMemberCount
        Description        = $Group.Notes
        Classification     = $Group.Classification
        MailboxStatus      = $MailboxStatus
        EmailsCount        = $NumberOfEmails
        LastEmailReceived  = $LastEmailActivity
        TeamEnabled        = $IsTeamsEnabled
        LastTeamsChat      = $LastTeamsChat
        TeamsChatCount     = $NumberofTeamsChats
        #LastConversation    = $LastConversation
        #NumberConversations = $NumberConversations
        SharePointActivity = $SharePointActivity
        #SPOStatus           = $SPOStatus
        #NumberWarnings      = $NumberWarnings
        #Status              = $Status
    }
    $LastTeamsChat = ""
    $Report += $ReportLine  
}
# End of the loop for all Office 365 groups and Microsoft Teams

Write-Host

#Write-Host $ObsoleteGroups "obsolete group document libraries found out of" $Groups.Count "checked"

$htmlbody = $Report | ConvertTo-Html -Fragment
$htmlreport = $htmlhead + $htmlbody
$htmlreport | Out-File $HtmlReportFile  -Encoding UTF8
$Report | Export-CSV -NoTypeInformation $CsvReportFile -Encoding Default