<#
.SYNOPSIS
affiche le status d'un ticket
.DESCRIPTION
affiche le status d'un ticket (nouveau/en cours/en attente/resolu/clot
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id d'un item GLPI
.EXAMPLE
PS C:\> Get-GlpiTicketStatus -session $global:session.session_token -ItemID $ItemID
.INPUTS
.OUTPUTS
#>
function Get-GlpiAttachment () 
{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID
        )

    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$ItemID/Document_Item"
    $GlpiDocument      = Invoke-RestMethod -uri $uri -body $header -Method get

    $GlpiDocument | where {$_.rel -eq "Document"}

    return $GlpiDocument
}