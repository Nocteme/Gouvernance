<#
.SYNOPSIS
Ajoute des donnees au corp du ticket GLPI (html encode)
.DESCRIPTION
Ajoute des donnees a un ticket GLPI en utilisant set-GlpiField et retourne le resulta dans une variable $Item
.PARAMETER session
session_token envoye par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id de l'item a modifie
.PARAMETER content
titre du champ a modifier
.EXAMPLE
PS C:\> set-GLPIItemContent -session $global:session.session_token -apptoken $apptoken -ItemID $ItemID -content $content 
.INPUTS
.OUTPUTS
#>
function set-GLPIItemContent(){
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID,
        [Parameter(Mandatory=$true)][string]$content
    )

    $item = set-GlpiItemField -GlpiUri $Global:session.GlpiUri -session $Global:session.session_token -apptoken $Global:session.apptoken -ItemID $ItemID -fieldTitle "content" -fieldValue $content

    return $item 
}