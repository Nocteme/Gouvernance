<#
.SYNOPSISv
Genère un header 
.DESCRIPTION
Genère un header avec les tokens de session et les tokens app et le stock puis le retourne dans un objet body
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.EXAMPLE
PS C:\> get-GlpiGenerateHeader -session $session.session_token -apptoken $aptoken
Exemple d’appel de la fonction
.INPUTS
.OUTPUTS
#>
function get-GlpiGenerateHeader(){
   [CmdletBinding()]
    param(
    )
    
    Write-Verbose "----------------------"
    Write-Verbose "session : $($Global:session.session_token)"
    Write-Verbose "apptoken : $($Global:session.apptoken)"


    $body  = @{} 
    $body.session_token = $Global:session.session_token
    $body.app_token = $Global:session.apptoken


    return $body

}
