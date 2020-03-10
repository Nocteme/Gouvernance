<#
.SYNOPSIS
Cree un item GLPI
.DESCRIPTION
Genere un objet GLPI et le retourne dans une varaible $GlpiItem
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemType
Type d'items a rechercher (objet) dans GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
.PARAMETER 
PS C:\> New-GLPIItem -session $session.session_token -apptoken $aptoken -ItemType $ItemType -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
<# 
Liste des propriete : 

Name = Nom du ticket
Content : Contenu du ticket
Type : ID du type du ticket 
time_to_own : SLA Prise en charge 
origine de la demande : $properties.requesttypes_id




#>
function New-GLPIItem(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemType,
        [parameter(mandatory=$true)]$properties
    )
    $uri = "$($Global:session.GlpiUri)/apirest.php/$($ItemType)"

    $TableItems = @{} ; 
    $TableItems."input" = $properties ;

    $JsonItem = ConvertTo-Json $TableItems -Depth 6
    $GlpiItem      = Invoke-RestMethod -method Post -uri $uri -Headers @{"session-token"=$Global:session.session_token; "App-Token" = $Global:session.apptoken} -Body $JsonItem -ContentType 'application/json'

    return $GlpiItem 
}
