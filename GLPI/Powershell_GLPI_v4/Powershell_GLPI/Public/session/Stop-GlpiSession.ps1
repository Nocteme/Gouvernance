<#
.SYNOPSIS
Stop une session GLPI
.DESCRIPTION
Kill une session GLPI grace a la methode Invoke-RestMethod et retourne le token de la session
.PARAMETER session
session_token envoye par la methode Get-GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> Stop-GlpiSession -session $session.session_token -apptoken $aptoken -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
function Stop-GlpiSession(){
   [CmdletBinding()]
   param(
        )

    $body  =  get-GlpiGenerateHeader -Verbose
    $uri = "$($Global:session.GlpiUri)/apirest.php/killSession"
    $sessionToken      = Invoke-RestMethod -Method Post -Uri $uri -Body $body
     

    return $sessionToken 
}
