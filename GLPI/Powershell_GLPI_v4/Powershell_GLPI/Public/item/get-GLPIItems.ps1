<#
.SYNOPSIS
Liste les items en fonction de leurs types
.DESCRIPTION
Retourne une liste d'items en fonction du type d'items demandes et la retourne dans $GlpiItems
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemType
Type d'items a rechercher (objet) dans GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> get-GLPIItems -session $session.session_token -apptoken $aptoken -ItemType $itemType -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
function get-GLPIItems(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemType
    )

    $body  =  get-GlpiGenerateHearder
    $uri = "$($Global:session.GlpiUri)/apirest.php/$($ItemType)/?expand_drodpowns=true"
    $GlpiItems      = Invoke-RestMethod -uri $uri -body $body 

    return $GlpiItems 
}