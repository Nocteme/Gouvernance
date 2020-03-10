<#
.SYNOPSIS
/!\ ne pas utiliser directement  /!\
--> Manage-Entities
Fonction principale de lecture de fichiers XML (recursivite)
.DESCRIPTION
Focntion principale de lecture de fichiers XML et les stocks dans un objet puis les retourne sous formr de tableau (Name,Content)
.PARAMETER Entity
Resulta du foreach de la fonction Manage-Entities
.EXAMPLE
/!\ ne pas utiliser directement  /!\
--> Manage-Entities
$entities = read-XML -Path $Path
.INPUTS
.OUTPUTS
#>
function add-EntityFromXMLElement(){
   [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]$Entity,
        [Parameter(Mandatory=$true)]$Parent
        )
        $properties = @{}
        $properties["name"] = $Entity.name
        $properties["comment"] = $Entity.content
        $properties["mail_domain"] = $Entity.mail_domain
        $properties["entity_ldapfilter"] = $Entity.entity_ldapfilter
        $properties["admin_email"] = $Entity.admin_email
        $properties["admin_reply"] = $Entity.admin_reply
        $properties["tag"] = $Entity.tag
        $properties["entities_id"] = $Parent


      try{
            if($condition -ne $false){    
            $EntityCree = Add-GLPIEntitie -properties $properties -force
        
            Stop-GlpiSession 
            start-sleep -Seconds 10
            Get-GLPISession -UrlGlpi $Global:session.GlpiUri -apptoken $Global:session.apptoken -user_token $Global:session.user_Token 
            $global:entities = $Entity
            #Write-Output $Entity.entities "Premier if"


            if($Entity.entities.entity -ne $null) {
                    foreach ( $childEntity in $Entity.entities.entity ) 
                    {
                        add-EntityFromXMLElement -Entity $childEntity  -parent $EntityCree.id
                    }
            }   
            else
            {
                foreach ( $childEntity in $Entity.entities ) 
                {
                    #Write-Output $Entity.entities "else"
                        add-EntityFromXMLElement -Entity $childEntity -Parent $EntityCree.id 
                }
            }
    }
}catch{}

}
