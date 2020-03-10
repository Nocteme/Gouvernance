<#
.SYNOPSIS
affiche les details d'une solution ticket
.DESCRIPTION
affiche les details d'une solution ticket et retourne le content en html encode
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
Url Glpi
.PARAMETER IdTicket
Id d'un item GLPI
.EXAMPLE
PS C:\> get-GLPITicketSolution -session $session.session_token -apptoken $apptoken -GlpiUri $GlpiUri -ItemID $ItemID
.INPUTS
.OUTPUTS
#>
function get-GLPITicketSolution(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$IdTicket
    )

    $body  =  get-GlpiGenerateHeader -Verbose
    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$($IdTicket)/ITILSolution/"
    $TicketSolution      = Invoke-RestMethod -Method get -Uri $uri -Body $body 

    return $TicketSolution 

}