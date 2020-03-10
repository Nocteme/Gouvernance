<#
.SYNOPSIS
ajoute une entite a GLPI
.DESCRIPTION
Ajoute une entite fille a GLPI et lui donne une description et un nom
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> Add-GLPIEntitie -session $session.session_token -apptoken $app_token -GlpiUri $urlGLPI
.INPUTS
.OUTPUTS
#>
function Remove-GLPIEntitie(){
   [CmdletBinding()]
    param(
	[Parameter(Mandatory=$true)][string]$id

    )

    $uri = "$($Global:session.GlpiUri)/apirest.php/entity/$($id)"

    $TableItems = @{} ; 
    $TableItems."input" = $properties ;

    $JsonItem = ConvertTo-Json $TableItems 
    $GlpiEntities      = Invoke-RestMethod -method delete -uri $uri -Headers @{"session-token"=$Global:session.session_token; "App-Token" = $Global:session.apptoken} -Body $JsonItem -ContentType 'application/json'

    return $GLPIEntity 

}