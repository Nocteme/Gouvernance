<#
.SYNOPSIS
Genère un content pour ticket au format HTML 
.DESCRIPTION
Genère un content pour ticket au format HTMLl qui sera ensuite utilise pour la construction du ticket. Retourne une variable $text
.PARAMETER tabText
text a rentre pour alimenter le ticket
.EXAMPLE
PS C:\> add-GLPIContentText -tabText $tabText
.INPUTS
.OUTPUTS
#>
function Add-GLPIContentText(){
    param(
        $tabText
    )

    $text = "<p><span style='font-family: CALIBRI;'><span class='xdlabel'>"
    foreach ($ligne in  $tabText)
    {
        $ligne = $ligne -replace '"','`'
        $text += "<span style='font-size: large;'>$ligne</span><br/>"
    }
    $text += "</span></span></p>"
    return $text 	
}