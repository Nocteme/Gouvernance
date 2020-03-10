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
PS C:\> Add-GLPIEntitie -session $global:session.session_token -apptoken $app_token -GlpiUri $urlGLPI
.INPUTS
.OUTPUTS
#>
<# 
Liste des propriete : 

Name = Nom du ticket
comment: Contenu du ticket
entities_id: entite parent
mail_domain : mail du domaine 

#>
function Add-GLPIEntitie(){
   [CmdletBinding()]
    param(

        [parameter(mandatory=$true)]$properties,
        [switch]$force
    )

    $uri = "$($Global:session.GlpiUri)/apirest.php/entity"

    $TableItems = @{} ; 
    $TableItems."input" = $properties ;

    $JsonItem = ConvertTo-Json $TableItems 
    $JsonItem
    $GlpiEntities      = Invoke-RestMethod -method Post -uri $uri -Headers @{"session-token"=$Global:session.session_token; "App-Token" = $Global:session.apptoken} -Body $JsonItem -ContentType 'application/json'

    return $GlpiEntities      

}