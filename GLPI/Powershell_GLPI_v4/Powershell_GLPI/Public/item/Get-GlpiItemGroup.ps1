<#
.SYNOPSIS
affiche tout les groupes d'un items
.DESCRIPTION
affiche tout les groupes d'un items en fonction de l'id entre
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id d'un item GLPI
.EXAMPLE
PS C:\> Get-GlpiItemGroup -session $session.session_token -ItemID $ItemID
.INPUTS
.OUTPUTS
#>
function Get-GlpiItemGroup () {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID
    )
    
    $header = @{} ;
    $header['session_token'] = $Global:session.session_token
    $header['app_token'] = $Global:session.apptoken

    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$($ItemID)/group_ticket"
    $GlpiGroup      = Invoke-RestMethod -uri $uri -body $header -Method get

    return $GlpiGroup
}