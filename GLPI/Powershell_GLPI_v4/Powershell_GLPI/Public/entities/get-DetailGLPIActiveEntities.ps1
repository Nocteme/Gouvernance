<#
.SYNOPSIS
Renvoie les details de toutes les entites .
.DESCRIPTION
Renvoie les details d'une entite(nom,id,id parent) en entrant le nom de l'entite
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> get-GLPIEntitieName -session $global:session.session_token -apptoken $app_token -GlpiUri $urlGLPI -Name $nom
.INPUTS
.OUTPUTS
#>
function get-DetailGLPIActiveEntities(){
   [CmdletBinding()]
   
    $tabEntity = @()
    $ObjEntity = @{}
    $body  =  get-GlpiGenerateHeader -Verbose
    $entities      = Invoke-RestMethod -Method get -Uri  "$($Global:session.GlpiUri)/apirest.php/Entity" -Body $body 
    foreach ( $entity in $entities ) 
    {
        $ObjEntity = New-Object -TypeName pscustomobject -Property @{
            name =  $entity.name 
            parent = $entity.entities_id 
            id = $entity.id 
        }
        $tabEntity += $ObjEntity
    }
    return $tabEntity    
}