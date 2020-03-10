<#
.SYNOPSIS
Récupere le token_session 
.DESCRIPTION
Récupere le token_session grace a la méthode Invoke-RestMethode et la retourne
.PARAMETER GlpiUri
URL GLPI
.PARAMETER aptoken
peut etre récuperé dans CONFIGURATION>GENERALE>API en dessous de action choisir l'utilisateur puis dans le textfield Jeton d'application
.PARAMETER user_Token
peut etre récuperé dans ADMINISTRATION>UTILISATEURS puis choisir l'utilisateur
.EXAMPLE
PS C:\> Get-GLPISession -GlpiUri $GlpiUri -apptoken $aptoken -user_Token $user_token
.INPUTS
.OUTPUTS
#> 
function Get-GLPISession(){    
   [CmdletBinding()]
   param(
        [parameter(mandatory=$true)]$UrlGlpi,
        [parameter(mandatory=$true)]$apptoken,
        [parameter(mandatory=$true)]$user_token        
        )


    $body  = get-GlpiBodyTemplate
    $Text = ""
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    $EncodedText =[Convert]::ToBase64String($Bytes)
    
    $body['Authorization'] = $EncodedText
    $body['app_token'] = $apptoken
    $body['user_token'] = $user_token
    

 

    $session     = Invoke-RestMethod -Method Post -Uri "$($UrlGlpi)/apirest.php/initSession" -Body $body

    $Global:Session = New-Object -TypeName PsCustomObject -Property @{ session_token  = $session.session_Token ; 
                                                                       apptoken       = $apptoken ; 
                                                                       user_Token     = $user_token;
                                                                       GlpiUri        = $UrlGlpi}

 

    return $Global:Session
} 