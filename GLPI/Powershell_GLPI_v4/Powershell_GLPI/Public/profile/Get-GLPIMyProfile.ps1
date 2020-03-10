<#
.SYNOPSIS
Recupere les profils actifs de GLPI
.DESCRIPTION
Recupere les prodils actifs et les retournes dans une variable $sessionToken
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> Get-GLPIMyProfile -session $session.session_token -apptoken $apptoken -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
function Get-GLPIMyProfile{
 
   [CmdletBinding()]
    param(
    )

    $body  =  get-GlpiGenerateHeader -Verbose
    $sessionToken      = Invoke-RestMethod -Method Post -Uri "$($Global:session.GlpiUri)/apirest.php/getActiveProfile" -Body $body 

    return $sessionToken 
 }