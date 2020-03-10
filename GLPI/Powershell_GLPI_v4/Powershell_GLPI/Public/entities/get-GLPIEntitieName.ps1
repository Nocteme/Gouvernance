<#
.SYNOPSIS
Renvoie les details d'une entite
.DESCRIPTION
Renvoie les details d'une entite(nom,id,id parent) en entrant le nom de l'entite
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
URL GLPI
.PARAMETER Name
Nom de l'entite recherche
.EXAMPLE
PS C:\> get-GLPIEntitieName -session $session.session_token -apptoken $app_token -GlpiUri $urlGLPI -Name $nom
.INPUTS
.OUTPUTS
#>
function get-GLPIEntitieName(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Name
    )

    $body  =  get-GlpiGenerateHeader -Verbose
    $ActiveEntity = get-DetailGLPIActiveEntities
    $result = $tabEntity | Where {$_.name -eq $name}
        
    return $result 
}