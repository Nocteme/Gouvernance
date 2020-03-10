<#
.SYNOPSIS
Liste tous les liens entre utilisateurs et tickets
.DESCRIPTION
Permets d'avoir tous les liens entre les utilisateurs et les tickets (id ticket, id user)
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id de l'item a selectioner
.PARAMETER content
titre du champ a modifier
.EXAMPLE
PS C:\> Get-GlpiItemUsers -session $session.session_token -apptoken $aptoken -ItemID $ItemID -GlpiUri $GlpiUri 
.INPUTS
.OUTPUTS
#>
function Get-GlpiItemUsers (){

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID
    )
    
    $header = @{} ;
    $header['session_token'] = $Global:session.session_token
    $header['app_token'] = $Global:session.apptoken

    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$($ItemID)/Ticket_User"
    $GlpiUsers      = Invoke-RestMethod -uri $uri -body $header -Method get

    return $GlpiUsers
}