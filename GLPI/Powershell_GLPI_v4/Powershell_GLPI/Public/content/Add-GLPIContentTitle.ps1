<#
.SYNOPSIS
Genère un titre au format HTML
.DESCRIPTION
Genère un titre au format HTML pour ensuite etre utilise dans la construction du corp du ticket. Retourne une variable $title
.PARAMETER Title
Chaine de caractere utilise pour generer le titre au format HTML
.EXAMPLE
PS C:\> Add-GLPIContentTitle -title $title
.INPUTS
.OUTPUTS
#>
function Add-GLPIContentTitle(){
    param(
        [Parameter(Mandatory=$false)][string]$title
    )
    $Title = "<p><span style='font-family: Calibri'><strong><u>$($title)</u></strong></span></p>"
    return $Title 
}