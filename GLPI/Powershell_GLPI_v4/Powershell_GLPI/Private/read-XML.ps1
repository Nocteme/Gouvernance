<#
.SYNOPSIS
Charge un fichier XML
.DESCRIPTION
Charge un fichier XML qui est utilise avec la methode Manage-Entities
.PARAMETER Path
chemin du fichier XML
.EXAMPLE
PS C:\> read-XML -Path $path
.EXAMPLE
PS C:\> $var = read-XML -Path $path
.INPUTS
.OUTPUTS
#>
function read-XML(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$Path
        )
        $XMLfile = $Path
        [XML]$entities = Get-Content $XMLfile
        
        return $entities
}