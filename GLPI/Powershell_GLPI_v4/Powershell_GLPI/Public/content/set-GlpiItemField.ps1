<#
.SYNOPSIS
Genère des donnees au corp du ticket GLPI (html encode)
.DESCRIPTION
Genère des donnees a un ticket GLPI et retourne le resulta dans une variable $Item qui est utilise par set-GLPIItemContent
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id de l'item a modifie
.PARAMETER fieldTitle
titre du corps du ticket
.PARAMETER fieldValue
Texte en dessous du titre
.EXAMPLE
PS C:\> set-GlpiField -session $global:session.session_token -apptoken $apptoken -ItemID $ItemID -fieldTitle $fieldTitle  -fieldValue $fieldValue
.INPUTS
.OUTPUTS
#>
function set-GlpiField (){
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID,
        [Parameter(Mandatory=$true)][string]$fieldTitle,
        [Parameter(Mandatory=$true)][string]$fieldValue

    )
    
    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$($ItemID)"

    $body_input = @{} 
    $body_input[$fieldTitle] = $fieldValue
    $body = @{} ; 
    $body["input"] = $body_input
    
    $header = @{} ;
    $header['session-token'] = $Global:session.session_token 
    $header['app-token'] = $Global:session.apptoken

    $body = ConvertTo-Json -InputObject $body -Depth 2 -Compress
    $item = Invoke-RestMethod -uri $Uri -Headers $header -Method Put -Body $body

    return $item

     
}