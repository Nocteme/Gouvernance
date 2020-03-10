 <#
.SYNOPSIS
Affiche les entites actives
.DESCRIPTION
Recupere les entites actives et les retournes dans une variable $sessionToken
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> get-GLPIActiveEntities -session $session.session_token -apptoken $apptoken -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
function get-GLPIActiveEntities(){
   [CmdletBinding()]

   $tabActiveEntity = @()
    $body  =  get-GlpiGenerateHeader -Verbose
    $ActiveEntity      = Invoke-RestMethod -Method get -Uri  "$($Global:session.GlpiUri)/apirest.php/getActiveEntities" -Body $body 
    foreach($entity in $ActiveEntity.active_entity.active_entities){
        $tabActiveEntity += $entity
    }

    return $tabActiveEntity 
}

