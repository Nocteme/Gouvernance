<#
.SYNOPSIS
Fonction mere XML, Lit et cree des entites depuis un fichier XML
.DESCRIPTION
Lit Un fichier XML et crees les entites graace au fonction read-XML,add-EntitiesFromXMLElement et add-EntityFromXMLElement
.PARAMETER Path
chemin du fichier XML 
.EXAMPLE
PS C:\> add-EntitiesFromXML -Path $Path
.INPUTS
.OUTPUTS
#>
function add-EntitiesFromXML(){
    param(
        [Parameter(Mandatory=$true)]$Path
        )
        $read = read-XML -Path $Path
        foreach($entitiesObj in $read.LoadEntities.entities){
        Write-Output $entitiesObj
            if ($entitiesObj.IdParent -ne $null){
                add-EntitiesFromXMLElement -entities $entitiesObj -parent $entitiesObj.IdParent
            }
        }         
}