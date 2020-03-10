<#
.SYNOPSIS
Recherche un item 
.DESCRIPTION
Recherche un item en fonction de son type et de sont ID et le retourne dans $GlpiItem
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemType
Type d'items a rechercher (objet) dans GLPI
.PARAMETER ItemID
Id d'un item GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> get-GLPIItem -session $session.session_token -apptoken $aptoken -ItemType $ItemType -ItemID $ItemID -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
function get-GLPIItem(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemType,
        [Parameter(Mandatory=$true)][string]$ItemID

    )

    $body  =  get-GlpiGenerateHeader -Verbose
    $uri = "$($Global:session.GlpiUri)/apirest.php/$($ItemType)/$($ItemID)?expand_drodpowns=true&with_documents=true"
    $GlpiItem      = Invoke-RestMethod -uri $uri -body $body 

    return $GlpiItem 
}