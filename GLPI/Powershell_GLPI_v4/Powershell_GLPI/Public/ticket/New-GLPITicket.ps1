<#
.SYNOPSIS
Cree un nouveau ticket GLPI
.DESCRIPTION
Cree un nouveau ticket GLPI en utilisant la methode New_GLPIItem
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.EXAMPLE
PS C:\> New-GLPITicket -session $session.session_token -apptoken $apptoken
.INPUTS
.OUTPUTS
#> 
function New-GLPITicket(){
   [CmdletBinding()]
   param(
   )

   New_GLPIItem -ItemType "Ticket"
}