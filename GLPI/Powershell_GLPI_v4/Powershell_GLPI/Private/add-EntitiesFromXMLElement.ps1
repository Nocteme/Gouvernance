<#
.SYNOPSIS
Lit le fichier XML 
.DESCRIPTION
Lit le fichier XML(vas dans entities puis dans entity) et utilise la methode Manage-Entity (recursivite)
.PARAMETER entities
Resulta de la fonction read-XML
.EXAMPLE
PS C:\> Manage-Entities -entities $entities
$entities = read-XML -Path $Path
.INPUTS 
.OUTPUTS
#>
function add-EntitiesFromXMLElement(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$entities,
        [parameter(mandatory=$true)]$parent 
        )
       
        foreach($i in $entities.entity){
            Write-Output "Gestion de l'entity - $($i.name) "
            add-EntityFromXMLElement -Entity $i  -Parent $parent 
        }  
}