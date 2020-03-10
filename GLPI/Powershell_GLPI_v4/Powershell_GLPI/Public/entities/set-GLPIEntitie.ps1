<#
.SYNOPSIS
update une entite a GLPI
.DESCRIPTION
update une entite fille a GLPI 
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
<# 
Liste des propriete : 

$properties = @{}
$properties["name"] = Nom Entité
$properties["comment"] = Description entité
$properties["mail_domain"] = Domaine de messagerie représentant l'entité
$properties["entity_ldapfilter"] = Filtre LDAP associé à l'entité (si nécessaire)
$properties["admin_email"] = Courriel de l'administrateur
$properties["admin_reply"] = Courriel de réponse (si nécessaire)
$properties["tag"] = Information de l'outil d'inventaire (TAG) représentant l'entité

#>
function Set-GLPIEntitie(){
   [CmdletBinding()]
    param(
	    [Parameter(Mandatory=$true)][string]$id,
        [parameter(mandatory=$true)]$properties

    )

    $uri = "$($Global:session.GlpiUri)/apirest.php/entity/$($id)"

    $TableItems = @{} ; 
    $TableItems."input" = $properties ;

    $JsonItem = ConvertTo-Json $TableItems 
    $GlpiEntities      = Invoke-RestMethod -method put -uri $uri -Headers @{"session-token"=$Global:session.session_token; "App-Token" = $Global:session.apptoken} -Body $JsonItem -ContentType 'application/json'

    return $GLPIEntity 

}