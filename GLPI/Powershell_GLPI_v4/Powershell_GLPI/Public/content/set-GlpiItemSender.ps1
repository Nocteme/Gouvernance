<#
.SYNOPSIS
Envoie des donnees a GLPI
.DESCRIPTION
Envoie des donnees a un ticket GLPI (grace a la methode set-GlpiField) et retourne le resulta dans une variable $Item qui est utilise par set-GLPIItemContent
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
PS C:\> set-GlpiItemSender -session $global:session.session_token -apptoken $apptoken -ItemID $ItemID -content $content 
.INPUTS
.OUTPUTS
#>
function set-GlpiItemSender () {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID,
        [Parameter(Mandatory=$true)][string]$content
    )


    $item = set-GlpiItemField -GlpiUri $Global:session.GlpiUri -session $Global:session.session_token -apptoken $Global:session.apptoken -ItemID $ItemID -fieldTitle "content" -fieldValue $content

    return $item 
}