#import modul GLPI
Import-Module -Name Powershell_GLPI 


#username de connection au GLPI
$username = "glpi"
#Pswrd de connection au GLPI
$Pswrd = "d9dc61422f91622c6ad351c9fbe6b1dd43e1139ce5ec4f203b7b969602d85f34"
#chemin d'acces du fichier XML 
$Path = "D:\XML\AddEntity.xml"
#Nom de la societe
$societe = "ikigai.nc" #mettre nom de domaine voulue ici ex : ikigai.nc


$UrlGlpi = "http://13.75.174.32"#url GLPI
$apptoken = "LyvgsknhitS5vlZS7zyVQniBk1TeNkNFfb80ODxa"
$UserToken = "FruzVSHf3wzmCxTfgbbAoSmzsxDYmRxuXn1Dnqi4"



#recupere les donnees d'une session
$Global:session = Get-GLPISession -UrlGlpi $UrlGlpi -apptoken $apptoken -user_token $UserToken

#creation d'entite avec XML
add-EntitiesFromXML -Path $Path 


<# 
Creation de une seule entité (manuelement) :



$properties = @{}
$properties["name"] = Nom Entité
$properties["comment"] = Description entité
$properties["mail_domain"] = Domaine de messagerie représentant l'entité
$properties["entity_ldapfilter"] = Filtre LDAP associé à l'entité (si nécessaire)
$properties["admin_email"] = Courriel de l'administrateur
$properties["admin_reply"] = Courriel de réponse (si nécessaire)
$properties["tag"] = Information de l'outil d'inventaire (TAG) représentant l'entité
$properties["entities_id"] = ID de l'entité parente (0 = root ect...)


Add-GLPIEntitie -properties $properties

#>
<# 
Modification d'une entité existante :


$properties = @{}
$properties["name"] = Nom Entité
$properties["comment"] = Description entité
$properties["mail_domain"] = Domaine de messagerie représentant l'entité
$properties["entity_ldapfilter"] = Filtre LDAP associé à l'entité (si nécessaire)
$properties["admin_email"] = Courriel de l'administrateur
$properties["admin_reply"] = Courriel de réponse (si nécessaire)
$properties["tag"] = Information de l'outil d'inventaire (TAG) représentant l'entité

Set-GLPIEntitie -id $id -properties $properties 



#>

