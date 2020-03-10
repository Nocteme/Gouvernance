 <#
.SYNOPSIS
Affiche les entites 
.DESCRIPTION
Recupere les entites et les retournes dans une variable $sessionToken
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.EXAMPLE
PS C:\> get-GLPIMyEntities -session $session.session_token -apptoken $aptoken 
.INPUTS
.OUTPUTS
#>
function get-GLPIMyEntities(){
   [CmdletBinding()]

    $body  =  get-GlpiGenerateHeader -Verbose
    $sessionToken      = Invoke-RestMethod -Method Post -Uri "$($Global:session.GlpiUri)/apirest.php/getMyEntities" -Body $body 

    return $sessionToken 

}