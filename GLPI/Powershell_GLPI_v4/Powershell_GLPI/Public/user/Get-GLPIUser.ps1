<#
.SYNOPSIS
Recupere les users du GLPI
.DESCRIPTION
liste tous les utilisateurs du GLPI et les retourne dans $sessionToken
.PARAMETER GlpiUri
URL GLPI
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.EXAMPLE
PS C:\> Get-GLPIUser -GlpiUri $GlpiUri -session $session.session_token -apptoken $apptoken
.INPUTS
.OUTPUTS
#>      
function Get-GLPIUser(){    
   [CmdletBinding()]
   param(
        [Parameter(Mandatory=$true)][string]$Id
   )
    
    $body  =  get-GlpiGenerateHeader -Verbose
    $uri = "$($Global:session.GlpiUri)/apirest.php/User/$($id)"
    $GlpiUser      = Invoke-RestMethod -Uri $uri -Header $body 

    return $GlpiUser 
}