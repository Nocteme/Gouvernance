
$ClientName = "Groupama Gan"
$ClientNameSansEspace = $ClientName -replace " ","" 
$UserName = "admin-team-cloud@sf2i.nc"
$pass = "2s7lble7xOWh91"

$Url = "https://sf2inc.sharepoint.com/sites/SC_$ClientNameSansEspace"

Add-PnPStoredCredential -Name AdminTenant -Username admin-team-cloud@sf2i.nc -Password (ConvertTo-SecureString -String $pass -AsPlainText -Force) 
$credAdmin = Get-PnPStoredCredential -Name AdminTenant -Type PSCredential
Connect-PnPOnline -Url "https://sf2inc-admin.sharepoint.com"-Credentials $credAdmin


Write-Host "Création du site  [SITE CLIENT] - $ClientName à l'adresse $url ..." -ForegroundColor Cyan -NoNewline

$url = New-PnPSite -Type TeamSite -Title "[SITE CLIENT] - $ClientName"    -Description "Site client documentant $ClientName" -HubSiteId "6ddc8032-6b2b-493b-a1d8-a0ec69e68af4" -alias "SC_$ClientNameSansEspace"

Connect-PnPOnline -Url $Url -Credentials $credAdmin

Write-Host "Terminé" -ForegroundColor Green 

$Nodes = Get-PnPNavigationNode 
$Nodes | % {
    $silence = Remove-PnPNavigationNode -Identity $_.id -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

#########################################################
# Creation des champs 
###########################################################
#region Ajout des colonnes de sites

Write-Host "Ajout des Colonne de sites ..." -ForegroundColor Cyan -NoNewline

$silence = Add-pnpField -InternalName "DatAchat" -DisplayName "Date d'achat" -Group "Serveur" -Type DateTime
$silence = Add-pnpField -InternalName "DateExpLic" -DisplayName "Date d'expiration des licences" -Group "Serveur" -Type DateTime
$silence = Add-pnpField -InternalName "IP" -DisplayName "IP" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "MAC" -DisplayName "MAC" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "Marque" -DisplayName "Marque" -Group "Serveur" -Type DateTime
$silence = Add-pnpField -InternalName "Modele" -DisplayName "Modèle" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "NbCPU" -DisplayName "Nb CPU" -Group "Serveur" -Type Number 
$silence = Add-pnpField -InternalName "NUmSerie" -DisplayName "Numéro de série" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "RAID" -DisplayName "RAID" -Group "Serveur" -Type Choice -Choices "Aucun","RAID 0","RAID 1","RAID 5","RAID 6","RAID 10","JBOD"
$silence = Add-pnpField -InternalName "RAM" -DisplayName "RAM (En Go)" -Group "Serveur" -Type Number
$silence = Add-pnpField -InternalName "Roles" -DisplayName "Rôles" -Group "Serveur" -Type Note
$silence = Add-pnpField -InternalName "Stockage" -DisplayName "Stockage (En Go)" -Group "Serveur" -Type Number
$silence = Add-pnpField -InternalName "CPUType" -DisplayName "Type CPU" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "TEquipement" -DisplayName "Type d'équipement" -Group "Serveur" -Type Choice -Choices "Switch","Hub","Routeur","Pare-Feu","Modem","Borne Wifi","Autre"
$silence = Add-pnpField -InternalName "TImprimante" -DisplayName "Type d'imprimante" -Group "Serveur" -Type Choice -Choices "Réseau","Non réseau"
$silence = Add-pnpField -InternalName "TServeur" -DisplayName "Type de serveur" -Group "Serveur" -Type Choice -Choices "Rack","Tour"
$silence = Add-pnpField -InternalName "MatosUser" -DisplayName "Utilisateur" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "CPUNumber" -DisplayName "Nb CPU" -Group "Serveur" -Type Number 
$silence = Add-pnpField -InternalName "Licences" -DisplayName "Licences ?" -Group "Serveur" -Type Boolean
$silence = Add-pnpField -InternalName "ContratSoc" -DisplayName "En contrat avec (société)" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "Criticite" -DisplayName "Criticité" -Group "Serveur" -Type Choice -Choices "Faible","Moyen", "Elevée", "Critique"
$silence = Add-pnpField -InternalName "NumLic" -DisplayName "Numéro de licence" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "NbLic" -DisplayName "Nombre de licence" -Group "Serveur" -Type Number
$silence = Add-pnpField -InternalName "RoleLogiciel" -DisplayName "Rôle du logiciel" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "Support" -DisplayName "Support" -Group "Serveur" -Type Note
$silence = Add-pnpField -InternalName "TLicence" -DisplayName "Type de licence" -Group "Serveur" -Type Choice -Choices "Serveur","Client", "StandAlone", "Autre"
$silence = Add-pnpField -InternalName "Version" -DisplayName "Version" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "TSauvegarde" -DisplayName "Type de sauvegarde" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "Rotation" -DisplayName "Rotation" -Group "Serveur" -Type Text
$silence = Add-pnpField -InternalName "Emplacement" -DisplayName "Emplacement de sauvegarde" -Group "Serveur" -Type Text

$silence = Add-PnPTaxonomyField -DisplayName "Niveau de mise à jour" -InternalName "NivMAJ" -TermSetPath "Espace Client|Niveau MAJ" -Group "Serveur"
$silence = Add-PnPTaxonomyField -DisplayName "Système d'exploitation" -InternalName "Exploit" -TermSetPath "Espace Client|System Exploitation" -Group "Serveur"

$silence = Add-pnpField -DisplayName "Type de procedure" -InternalName "PType" -Group "Procedure" -Type Choice -Choices "Serveur","Client", "StandAlone", "Autre"
$silence = Add-pnpField -DisplayName "Niveau" -InternalName "PNiveau" -Group "Procedure" -Type Choice -Choices "Hotline","N2", "N3", "Ingénieurie"

$silence = Add-pnpField -DisplayName "Nature" -InternalName "GI_Nature" -Group "Gestion Incidents" -Type Choice -Choices "Electrique","Messagerie", "Réseau", "Infrastructures" 
$silence = Add-pnpField -DisplayName "Début" -InternalName "GI_Debut" -Group "Gestion Incidents" -Type DateTime
$silence = Add-pnpField -DisplayName "Fin" -InternalName "GI_Fin" -Group "Gestion Incidents" -Type DateTime
$silence = Add-pnpField -DisplayName "Serveur(s) concernés" -InternalName "GI_Serveur" -Group "Gestion Incidents" -Type Text
$silence = Add-pnpField -DisplayName "Description" -InternalName "GI_Desc" -Group "Gestion Incidents" -Type Note

$silence = Add-pnpField -DisplayName "VIP" -InternalName "VIP" -Group "Gestion Incidents" -Type Boolean
$silence = Add-pnpField -InternalName "WType" -DisplayName "Type de wiki" -Group "Base de connaissance"-Type Choice -Choices "Demande","Incident","Page système"
Write-Host "Terminé" -ForegroundColor Green 

#endregion

#########################################################
# Gestion des content Type 
###########################################################
#region Ajout des types de contenu 

Write-Host "Ajout des type de contenu matériel ..." -ForegroundColor Cyan -NoNewline

$ElementContentType    = Get-PnPContentType -Identity "Élément"
$DocumentContentType   = Get-PnPContentType -Identity "Document"
$TacheContentType      = Get-PnPContentType -Identity "Tâche"
$ContactContentType    = Get-PnPContentType -Identity "Contact"
$CommentaireField      = Get-pnpField -Identity "ShortComment"

$fieldsServeurVirtuel   = @("IP","NbCPU","RAM","Stockage","Exploit","Roles","ShortComment") ; 
$fieldsServeurHard      = @("TServeur","Marque","NUmSerie","MAC","CPUType","RAID","NivMAJ","DatAchat","CPUNumber")
$fieldsEquipmentReseau  = @("Marque","NUmSerie","IP","MAC","CPUNumber","RAM","Stockage","Exploit","Roles","DatAchat","DateExpLic","TEquipement","Licences","Modele")
$fieldsImprimante       = @("Marque","TImprimante","IP","MAC","Modele","MatosUser","ContratSoc","NUmSerie","DatAchat","ShortComment")
$fieldsLogiciel         = @("Criticité","NumLic","NbLic","RoleLogiciel","Support","TLicence","MatosUser","Version") ; 
$fieldsSauvegarde       = @("TSauvegarde","Rotation","Emplacement") ; 
$filedProcedure         = @("PType","PNiveau") ; 
$fieldsIncidentsMAJ     = @("GI_Desc","GI_Nature","GI_Debut","GI_Fin","GI_Serveur","GI_Desc") ; 

$CT_VirtualServ         = Add-PnPContentType -Group "Serveur" -Name "Serveur Virtuel" -ParentContentType $ElementContentType
$fieldsServeurVirtuel   |  % {Add-PnPFieldToContentType -Field $_ -ContentType $CT_VirtualServ }

$CT_HardServer          = Add-PnPContentType -Group "Serveur" -Name "Serveur Physique" -ParentContentType $CT_VirtualServ
$fieldsServeurHard      |  % { Add-PnPFieldToContentType -Field $_ -ContentType $CT_HardServer }

$Network_Equipment      = Add-PnPContentType -Group "Serveur" -Name "Equipements reseau" -ParentContentType $ElementContentType
$fieldsEquipmentReseau  |  % { Add-PnPFieldToContentType -Field $_ -ContentType $Network_Equipment } 

$CT_Imprimante          = Add-PnPContentType -Group "Serveur" -Name "Imprimante" -ParentContentType $ElementContentType
$fieldsImprimante       |  % { Add-PnPFieldToContentType -Field $_ -ContentType $Network_Equipment } 

$CT_Logiciel            = Add-PnPContentType -Group "Serveur" -Name "Logiciel" -ParentContentType $ElementContentType
$fieldsLogiciel         |  % { Add-PnPFieldToContentType -Field $_ -ContentType $CT_Logiciel } 

$CT_Sauvegarde          = Add-PnPContentType -Group "Serveur" -Name "Sauvegarde" -ParentContentType $ElementContentType
$fieldsSauvegarde       |  % { Add-PnPFieldToContentType -Field $_ -ContentType $CT_Sauvegarde } 

$CT_Procedure           = Add-PnPContentType -Group "Procedure" -Name "Procedure" -ParentContentType $DocumentContentType
$filedProcedure         |  % { Add-PnPFieldToContentType -Field $_ -ContentType $CT_Procedure } 
 
$CT_IncidentsMAJ        = Add-PnPContentType -Group "Incidents Majeurs" -Name "Incidents Majeur" -ParentContentType $ElementContentType
$fieldsIncidentsMAJ     |  % { Add-PnPFieldToContentType -Field $_ -ContentType $CT_IncidentsMAJ } 


Add-PnPFieldToContentType -Field "VIP" -ContentType $ContactContentType 

Write-Host "Terminé" -ForegroundColor Green 

#endregion

#########################################################
# Ajout de la liste matériel et sujets et gestion des content Type 
###########################################################
#region Liste matériel  & Sujets 

Write-Host "Ajout de la liste matériel..." -ForegroundColor Cyan -NoNewline

New-PnPList -Title "Matériel" -Url "Materiel" -Template GenericList -EnableContentTypes
Add-PnPContentTypeToList -List "Matériel" -ContentType $CT_VirtualServ
Add-PnPContentTypeToList -List "Matériel" -ContentType $CT_HardServer
Add-PnPContentTypeToList -List "Matériel" -ContentType $Network_Equipment
Add-PnPContentTypeToList -List "Matériel" -ContentType $CT_Imprimante
Add-PnPContentTypeToList -List "Matériel" -ContentType $CT_Logiciel
Add-PnPContentTypeToList -List "Matériel" -ContentType $CT_Sauvegarde
Remove-PnPContentTypeFromList -List "Matériel" -ContentType "Élément"

Write-Host "Terminé" -ForegroundColor Green 

Write-Host "Ajout de la liste Sujet et sous sujet ..." -ForegroundColor Cyan -NoNewline
New-PnPList -Title "Sujet" -Url "Sujet" -Template GenericList -EnableContentTypes
New-PnPList -Title "Sous Sujet" -Url "SSujet" -Template GenericList -EnableContentTypes
Write-Host "Terminé" -ForegroundColor Green 


Write-Host "Ajout des type de contenu lié aux sujet / sous sujets ..." -ForegroundColor Cyan -NoNewline

$Ctx = Get-PnPContext
$SubjectList = Get-PnPList | where {$_.title -eq "Sujet"}
$SubSubjectList = Get-PnPList | where {$_.title -eq "Sous Sujet"}

$SubjectField = Add-pnpField -InternalName "Sujet" -DisplayName "Sujet" -Group "Base de connaissance" -Type Lookup

$SubjectField = $SubjectField.TypedObject
$SubjectField.LookupList = $SubjectList.Id
$SubjectField.LookupField = "Title"
$SubjectField.update()
$ctx.ExecuteQuery()

$SubSubjectField = Add-pnpField -InternalName "SSujet" -DisplayName "Sous Sujet" -Group "Base de connaissance"-Type Lookup
$SubSubjectField = $SubSubjectField.TypedObject
$SubSubjectField.LookupList = $SubSubjectList.Id
$SubSubjectField.LookupField = "Title"
$SubSubjectField.update()
$ctx.ExecuteQuery()


$CT_SSujet = Add-PnPContentType -Group "Base de connaissance" -Name "Sous Sujet" -ParentContentType $ElementContentType
Add-PnPFieldToContentType -Field "Sujet" -ContentType $CT_SSujet 

Add-PnPContentTypeToList -List "Sous Sujet" -ContentType $CT_SSujet
Remove-PnPContentTypeFromList -List "Sous Sujet" -ContentType "Élément"

$CT_PageDS = Get-PnPContentType -Identity "Page de site"
Add-PnPFieldToContentType -Field "Sujet" -ContentType $CT_PageDS
Add-PnPFieldToContentType -Field "SSujet" -ContentType $CT_PageDS
Add-PnPFieldToContentType -Field "WType" -ContentType $CT_PageDS

Write-Host "Terminé" -ForegroundColor Green 

#endregion

#########################################################
# Ajout de la liste Contact 
################################ ###########################
#region Ajout liste Contact

New-PnPList -Title "Contact" -Url "Contact" -Template GenericList -EnableContentTypes
$ContactContentType = Get-PnPContentType -Identity "Contact"
Add-PnPContentTypeToList -List "Contact" -ContentType $ContactContentType
Remove-PnPContentTypeFromList -List "Contact" -ContentType "Élément"


$ServeurFields = @("JobTitle","LinkFilename","FirstName", "WorkCity","VIP", "WorkPhone", "EMail" )
$View_Contact = Add-PnPView -List "Contact" -Title "Toutes les contacts" -Fields $ServeurFields -SetAsDefault


#endregion

#########################################################
# Ajout de la liste Procedure  
###########################################################
#region liste Procedure
New-PnPList -Title "Procédure" -Url "Procedure" -Template DocumentLibrary -EnableContentTypes
$ProcedureList = Get-PnPList "Procédure"
Add-PnPContentTypeToList -List "Procédure" -ContentType $CT_Procedure
Remove-PnPContentTypeFromList -List "Procédure" -ContentType "Document"


$ServeurFields = @("LinkFilename");
$ServeurFields += $filedProcedure
$View_Procedure= Add-PnPView -List "Procédure" -Title "Toutes les procédures" -Fields $ServeurFields -SetAsDefault
#endregion

#########################################################
# Ajout de la liste Documents Infra  
###########################################################
#region liste documents Infra
    $DocInfraList = New-PnPList -Title "Documents Infra" -Url "Doc_Infra" -Template DocumentLibrary -EnableContentTypes
    $docInfraView = Get-PnPView -List "Documents Infra"
#endregion

#########################################################
# Ajout de la liste TO DO  
###########################################################
#region liste TODO
New-PnPList -Title "TO DO" -Url "TO_DO" -Template GenericList -EnableContentTypes
$ProcedureList = Get-PnPList "TO DO"
Add-PnPContentTypeToList -List "TO DO" -ContentType $TacheContentType
Remove-PnPContentTypeFromList -List "TO DO" -ContentType "Élément"


$ServeurFields = @("LinkTitle","AssignedTo","StartDate");
$View_Taches= Add-PnPView -List "TO DO" -Title "Toutes les taches" -Fields $ServeurFields -SetAsDefault
#endregion

#########################################################
# Ajout de la liste incidents majeurs 
###########################################################
#region liste accidents majeurs
New-PnPList -Title "Incidents majeurs" -Url "Incidents" -Template GenericList -EnableContentTypes
$ProcedureList = Get-PnPList "Incidents majeurs"
Add-PnPContentTypeToList -List "Incidents majeurs" -ContentType $CT_IncidentsMAJ
Remove-PnPContentTypeFromList -List "Incidents majeurs" -ContentType "Élément"


$ServeurFields = @("LinkFilename");
$ServeurFields += $fieldsIncidentsMAJ
$View_IncidentsMajeurs= Add-PnPView -List "Incidents majeurs" -Title "Tous les incidents" -Fields $ServeurFields -SetAsDefault
#endregion

#########################################################
# Gestion des vues 
###########################################################
#region Vue de liste matériel
    Write-Host "Ajout des vues de listes ..." -ForegroundColor Cyan -NoNewline

    $ContentTypeName = "Serveur Virtuel"
    $ServeurFields = @("Titre")
    $ServeurFields += $fieldsServeurVirtuel
    $query = "<Where><Eq><FieldRef Name='ContentType' /><Value Type='Computed'>$ContentTypeName</Value></Eq></Where>"
    $View_VirtualServeur = Add-PnPView -List "Matériel" -Title $ContentTypeName -Fields $ServeurFields -Query $query

    $ContentTypeName = "Serveur Physique"
    $ServeurFields += $fieldsServeurHard
    $query = "<Where><Eq><FieldRef Name='ContentType' /><Value Type='Computed'>$ContentTypeName</Value></Eq></Where>"
    $View_HardServeur = Add-PnPView -List "Matériel" -Title $ContentTypeName -Fields $ServeurFields -Query $query 

    $ContentTypeName = "Equipements Reseau"
    $ServeurFields = @("Titre")
    $ServeurFields += $fieldsEquipmentReseau
    $query = "<Where><Eq><FieldRef Name='ContentType' /><Value Type='Computed'>$ContentTypeName</Value></Eq></Where>"
    $View_NetworkEquipment = Add-PnPView -List "Matériel" -Title $ContentTypeName -Fields $ServeurFields -Query $query 

    $ContentTypeName = "Imprimantes"
    $ServeurFields = @("Titre")
    $ServeurFields += $fieldsImprimante
    $query = "<Where><Eq><FieldRef Name='ContentType' /><Value Type='Computed'>$ContentTypeName</Value></Eq></Where>"
    $View_Imprimantes = Add-PnPView -List "Matériel" -Title $ContentTypeName -Fields $ServeurFields -Query $query 

    $ContentTypeName = "Logiciels"
    $ServeurFields = @("Titre")
    $ServeurFields += $fieldsLogiciel
    $query = "<Where><Eq><FieldRef Name='ContentType' /><Value Type='Computed'>$ContentTypeName</Value></Eq></Where>"
    $View_Logiciels = Add-PnPView -List "Matériel" -Title $ContentTypeName -Fields $ServeurFields -Query $query 

    $ContentTypeName = "Sauvegarde"
    $ServeurFields = @("Titre")
    $ServeurFields += $fieldsSauvegarde
    $query = "<Where><Eq><FieldRef Name='ContentType' /><Value Type='Computed'>$ContentTypeName</Value></Eq></Where>"
    $View_Sauvegarde = Add-PnPView -List "Matériel" -Title $ContentTypeName -Fields $ServeurFields -Query $query 

    #gestion des vues wiki
    $views = Get-PnPView -List "Pages du site"
    foreach ( $view in $views ) 
    {
        Remove-PnPView -Identity $view.id -List "Pages du site" -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    } 

    $ServeurFields = @("LinkFilename","WType","Sujet")
    $query = "<Where><And><IsNotNull><FieldRef Name='WType' /></IsNotNull><Neq><FieldRef Name='WType' /><Value Type='Choice'>Page système</Value></Neq></And></Where>"
    $WikiView = Add-PnPView -List "Pages du site" -Title "Incidents/Demande" -Fields $ServeurFields -Query $query -SetAsDefault
   
    $ServeurFields = @("LinkFilename","WType","Sujet")
    $query = "<Where><IsNull><FieldRef Name='WType' /></IsNull></Where>"
    $ToTryView = Add-PnPView -List "Pages du site" -Title "Non classé" -Fields $ServeurFields -Query $query

    $ServeurFields = @("LinkFilename","WType","Sujet")
    $query = "<Where><Eq><FieldRef Name='WType' /><Value Type='Choice'>Page système</Value></Eq></Where>"
    $WikiView = Add-PnPView -List "Pages du site" -Title "Pages système" -Fields $ServeurFields -Query $query




    Write-Host "Terminé" -ForegroundColor Green
#endregion

#########################################################
# Ajout de la page Fiche Cliente 
###########################################################
#region Page fiche client

Write-Host "Ajout de la page Fiche client en cours ..." -ForegroundColor Cyan -NoNewline

## Add Page using PnP PowerShell
$page = Add-PnPClientSidePage -Name "Fiche-Client.aspx" -LayoutType Article  -CommentsEnabled:$false
$silence = Set-PnPClientSidePage -Identity "Fiche-Client.aspx" -HeaderType None -Title "Fiche Client"
## Add a section the Page
Add-PnPClientSidePageSection -Page $page -SectionTemplate TwoColumn -Order 1
Add-PnPClientSidePageSection -Page $page -SectionTemplate TwoColumn -Order 2
Add-PnPClientSidePageSection -Page $page -SectionTemplate TwoColumn -Order 3
Add-PnPClientSidePageSection -Page $page -SectionTemplate TwoColumn -Order 4
## Add a Client Side Web Part

Function AddLMaterielList_WP () 
{
    param(
        $title,
        $View,
        $list,
        $page,
        $Section,
        $Column    
    )  
    
    $Id = New-Guid
    $IdWP = New-Guid

    $properties = @"
    {
	"controlType":3,
	"displayMode":2,
	"id":"$Id",
	"position":{
		"zoneIndex":$Column,
		"sectionIndex":$Section,
		"controlIndex":1},
	    "webPartId":"$IdWP",
	    "webPartData":{
		"id":"$IdWP",
		"instanceId":"$Id",
		"title":"$title",
		"description":"",
		"serverProcessedContent":{"htmlStrings":{},"searchablePlainTexts":{},"imageSources":{},"links":{}},
		"dataVersion":"1.0",
		"properties":{
			"isDocumentLibrary":false,
			"selectedListId":"$($list.Id)",
			"listTitle":"Matériel",
			"selectedListUrl":"/sites/SC_$ClientNameSansEspace/Materiel",
			"webRelativeListUrl":"/Materiel",
			"webpartHeightKey":4,
			"selectedViewId":"$($View.id)",
			"selectedFolderPath":"",
            "hideCommandBar":"true"
        }
	},
	"emphasis":{},
	"reservedHeight":459,
	"reservedWidth":744
    }
"@

    $listWP = Add-PnPClientSideWebPart -Page $page -DefaultWebPartType List -WebPartProperties $properties -Section $Section -Column $Column 
    Set-PnPClientSideWebPart -Page $page -Title $title -Identity $listWP.instanceid
}



#########################################################
# Ajout des WebPart
###########################################################

$MatosList = Get-PnPList | where {$_.title -eq "Matériel"}
$DocumentsList = Get-PnPList | where {$_.title -eq "Documents"}

AddLMaterielList_WP -page $page -title "Serveurs Physiques"     -View $View_HardServeur       -Section 1 -Column 1 -list $MatosList
AddLMaterielList_WP -page $page -title "Serveurs Virtuels"      -View $View_VirtualServeur    -Section 1 -Column 2 -list $MatosList
AddLMaterielList_WP -page $page -title "Equipements réseau"     -View $View_NetworkEquipment  -Section 2 -Column 1 -list $MatosList
AddLMaterielList_WP -page $page -title "Imprimante"             -View $View_Imprimantes       -Section 2 -Column 2 -list $MatosList
AddLMaterielList_WP -page $page -title "Logiciels"              -View $View_Logiciels         -Section 3 -Column 1 -list $MatosList
AddLMaterielList_WP -page $page -title "Sauvegarde"             -View $View_Sauvegarde        -Section 3 -Column 2 -list $MatosList


$Id = New-Guid
$IdWP = New-Guid

$webPartProperties = @"
{
   "controlType":3,
   "displayMode":2,
   "id":"a2b42b2f-39e0-4bec-800c-8ec3640a3580",
   "position":{"zoneIndex":1,"sectionIndex":1,"controlIndex":1,"layoutIndex":1},
   "webPartId":"f92bf067-bc19-489e-a556-7fe95f508720",
   "webPartData":{
      "id":"$Id",
      "instanceId":"$IdWP",
      "title":"Bibliothèque de documents",
      "description":"Ajoutez une bibliothèque de documents",
      "serverProcessedContent":{"htmlStrings":{},"searchablePlainTexts":{},"imageSources":{},"links":{}},
      "dataVersion":"1.0",
      "properties":{
         "isDocumentLibrary":true,
         "selectedListId":"$($DocInfraList.id)",
         "listTitle":"Documents infra",
         "selectedListUrl":"/sites/SC_FGProv04/Doc_Infra",
         "webRelativeListUrl":"/Doc_Infra",
         "webpartHeightKey":4,
         "selectedViewId":"$($docInfraView[0].id)",
         "selectedFolderPath":""}},

      "emphasis":{},
      "reservedHeight":500,
      "reservedWidth":744
}
"@

$Silence = Add-PnPClientSideWebPart -Page $page -DefaultWebPartType List -Section 4 -Column 1 -WebPartProperties $webPartProperties
Set-PnPClientSideWebPart -Page $page -Identity $Silence.InstanceId

$page.Save() ; 

$pageFicheClient = Get-PnPClientSidePage -Identity "Fiche-Client.aspx"
$controls = Get-PnPClientSideComponent -Page $pageFicheClient

foreach ( $control in $controls ) 
{
    $properties = $control.PropertiesJson
    $object = ConvertFrom-Json -InputObject $c.PropertiesJson
    $object.listTitle = $control.Title

    Set-PnPClientSideWebPart -Page $pageFicheClient -Identity $control.InstanceId -PropertiesJson ( ConvertTo-Json -InputObject $object ) 
}


$pageFicheClient.Save() ; 
$pageFicheClient.Publish() ; 


Write-Host "Terminé" -ForegroundColor Green 
#endregion

#########################################################
# Ajout de la page InfoClient
###########################################################
#region Page info client 
Write-Host "Ajout de la page info client en cours ..." -ForegroundColor Cyan -NoNewline
## Add Page using PnP PowerShell
$InfoCliPage = Add-PnPClientSidePage -Name "Info-Client.aspx" -LayoutType Article -CommentsEnabled:$false
$InfoCliPage = Set-PnPClientSidePage -Identity "Info-Client.aspx" -HeaderType None -Title "Info Client"
## Add a section the Page
Add-PnPClientSidePageSection -Page $InfoCliPage -SectionTemplate TwoColumn -Order 1
Add-PnPClientSidePageSection -Page $InfoCliPage -SectionTemplate TwoColumn -Order 2

$SitePagesList = Get-PnPList "SitePages"

$web = $ctx.Web
$site = $ctx.Site
$WebId = Get-PnPProperty -ClientObject $web -Property id 
$SiteId = Get-PnPProperty -ClientObject $site -Property id 

$Ext_Contact_JsonProps = @"
{  
      "controlType":3,
      "displayMode":2,
      "id":"e2d1230f-fdae-45d6-abfc-357efce7ff16",
      "position":{  
         "zoneIndex":1,
         "sectionIndex":2,
         "controlIndex":1,
         "layoutIndex":1
      },
      "webPartId":"7f718435-ee4d-431c-bdbf-9c4ff326f46e",
      "webPartData":{  
         "id":"7f718435-ee4d-431c-bdbf-9c4ff326f46e",
         "instanceId":"e2d1230f-fdae-45d6-abfc-357efce7ff16",
         "title":"Contacts",
         "description":"Affichez les personnes sélectionnées et leur profil",
         "serverProcessedContent":{  
            "htmlStrings":{  

            },
            "searchablePlainTexts":{  
               "title":"Contacts Clients",
               "persons[0].name":"JhonDoe@Externe.nc",
               "persons[1].name":"Tata.nana@Externe.nc",
               "persons[0].email":"JhonDoe@Externe.nc",
               "persons[1].email":"Tata.nana@Externe.nc",
               "persons[0].description":"John DOE \nDSI TEST Informatique ",
               "persons[1].description":"TATA Nana\nResponsable de la communication \nResponsable des sharepoint interne "
            },
            "imageSources":{  

            },
            "links":{  

            }
         },
         "dataVersion":"1.2",
         "properties":{  
            "layout":2,
            "persons":[  
               {  
                  "id":"JhonDoe@Externe.nc",
                  "upn":"",
                  "role":"JhonDoe@Externe.nc",
                  "department":"TEST",
                  "phone":"0123456789",
                  "sip":""
               },
               {  
                  "id":"Tata.nana@Externe.nc",
                  "upn":"",
                  "role":"Tata.nana@Externe.nc",
                  "department":"TEST 2",
                  "phone":"0123456789",
                  "sip":""
               }
            ]
         }
      },
      "emphasis":{  

      },
      "reservedHeight":383,
      "reservedWidth":736
   }
"@
$Int_Contact_JsonProps = @"
{ 
      "controlType":3,
      "displayMode":2,
      "id":"ab16a876-f152-448e-a52e-1e4df1bea0ed",
      "position":{  
         "zoneIndex":1,
         "sectionIndex":3,
         "controlIndex":1,
         "layoutIndex":1
      },
      "webPartId":"7f718435-ee4d-431c-bdbf-9c4ff326f46e",
      "webPartData":{  
         "id":"7f718435-ee4d-431c-bdbf-9c4ff326f46e",
         "instanceId":"ab16a876-f152-448e-a52e-1e4df1bea0ed",
         "title":"Contacts",
         "description":"Affichez les personnes sélectionnées et leur profil",
         "serverProcessedContent":{  
            "htmlStrings":{  

            },
            "searchablePlainTexts":{  
               "title":"Référent SF2I",
               "persons[0].name":"Florian GUERIN",
               "persons[0].email":"fguerin@sf2i.nc"
            },
            "imageSources":{  

            },
            "links":{  

            }
         },
         "dataVersion":"1.2",
         "properties":{  
            "layout":1,
            "persons":[  
               {  
                  "id":"i:0#.f|membership|fguerin@sf2i.nc",
                  "upn":"fguerin@sf2i.nc",
                  "role":"Consultant SharePoint et Office 365",
                  "department":"Ingenierie",
                  "phone":"",
                  "sip":""
               }
            ]
         }
      },
      "emphasis":{  

      },
      "reservedHeight":118,
      "reservedWidth":736
   }
"@

$Silence = Add-PnPClientSideWebPart -DefaultWebPartType People -WebPartProperties $Ext_Contact_JsonProps -Section 2 -Column 1 -page $InfoCliPage
$Silence = Add-PnPClientSideWebPart -DefaultWebPartType People -WebPartProperties $Int_Contact_JsonProps -Section 2 -Column 2 -page $InfoCliPage

$InfoCliPage.Save() ; 
$InfoCliPage.Publish() ; 

Write-Host "Terminé." -ForegroundColor Green
#endregion

#########################################################
# Ajout de la page Liens utiles
###########################################################
#region Page liens utiles
Write-Host "Ajout de la page liens utiles en cours ..." -ForegroundColor Cyan -NoNewline
## Add Page using PnP PowerShell
$LiensUtilesPage = Add-PnPClientSidePage -Name "Liens_Utiles.aspx" -LayoutType Article -CommentsEnabled:$false
$LiensUtilesPage = Set-PnPClientSidePage -Identity "Liens_Utiles.aspx" -HeaderType None -Title "Liens Utiles"
## Add a section the Page
Add-PnPClientSidePageSection -Page $LiensUtilesPage -SectionTemplate OneColumn -Order 1

$SitePagesList = Get-PnPList "SitePages"

$web = $ctx.Web
$site = $ctx.Site
$WebId = Get-PnPProperty -ClientObject $web -Property id 
$SiteId = Get-PnPProperty -ClientObject $site -Property id 

$LiensUtiles_JsonProps = @"
{"controlType":3,"displayMode":2,"id":"76ce9e32-0053-49e5-a918-96b1870c95f3","position":{"zoneIndex":1,"sectionIndex":1,"controlIndex":1,"layoutIndex":1},"webPartId":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd","webPartData":{"id":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd","instanceId":"76ce9e32-0053-49e5-a918-96b1870c95f3","title":"Liens rapides","description":"Ajoutez des liens vers des pages et des documents importants.","serverProcessedContent":{"htmlStrings":{},"searchablePlainTexts":{"title":""},"imageSources":{},"links":{"baseUrl":"$($web.Url)"},"componentDependencies":{"layoutComponentId":"706e33c8-af37-4e7b-9d22-6e5694d92a6f"}},"dataVersion":"2.2","properties":{"items":[],"isMigrated":true,"layoutId":"Waffle","shouldShowThumbnail":true,"buttonLayoutOptions":{"showDescription":false,"buttonTreatment":2,"iconPositionType":2,"textAlignmentVertical":2,"textAlignmentHorizontal":2,"linesOfText":2},"listLayoutOptions":{"showDescription":false,"showIcon":true},"waffleLayoutOptions":{"iconSize":1,"onlyShowThumbnail":false},"hideWebPartWhenEmpty":true,"dataProviderId":"QuickLinks","webId":"$WebId","siteId":"$SiteId"}},"emphasis":{},"reservedHeight":200,"reservedWidth":744}
"@
$Silence = Add-PnPClientSideWebPart -DefaultWebPartType QuickLinks -WebPartProperties $LiensUtiles_JsonProps -Section 1 -Column 1 -Page $LiensUtilesPage

$LiensUtilesPage.Save() ; 
$LiensUtilesPage.Publish() ; 


Write-Host "Terminé." -ForegroundColor Green

#endregion
#########################################################
# Ajout de la page suivi d'activité
###########################################################
#region Page suivi d'activité
Write-Host "Ajout de la page suivi d'activité en cours ..." -ForegroundColor Cyan -NoNewline
## Add Page using PnP PowerShell
$SuiviActivitePage = Add-PnPClientSidePage -Name "Suivi_Activité.aspx" -LayoutType Article -CommentsEnabled:$false
$SuiviActivitePage = Set-PnPClientSidePage -Identity "Suivi_Activité.aspx" -HeaderType None -Title "Suivi d'activité"
## Add a section the Page
Add-PnPClientSidePageSection -Page $SuiviActivitePage -SectionTemplate OneColumn -Order 1

$Id = New-Guid
$IdWP = New-Guid

$GroupId = Get-PnPProperty -ClientObject (get-pnpSite) -Property groupId
$SAs_JsonProps = @"
{
	"controlType":3,
	"displayMode":2,
	"id":"$Id",
	"position":{"zoneIndex":1,"sectionIndex":1,"controlIndex":1},
	"webPartId":"$IdWP",
	"webPartData":{
		"id":"$IdWP",
		"instanceId":"$Id",
		"title":"suivi d'activité",
		"description":"Afficher le calendrier du groupe",
		"serverProcessedContent":{"htmlStrings":{},"searchablePlainTexts":{},"imageSources":{},"links":{}},
		"dataVersion":"1.0",
		"properties":{
			"selectedGroupId": "$GroupId",
			"selectedGroupName": "[SITE CLIENT] - $ClientName",
			"accessType":"private",
			"showPerPage":5,
			"title":"",
			"timeSpanLimitInMonth":6
		}
	},
	"emphasis":{},
	"reservedHeight":215,
	"reservedWidth":744
}
"@
$Silence = Add-PnPClientSideWebPart -DefaultWebPartType GroupCalendar -Section 1 -Column 1 -Page $SuiviActivitePage

$SuiviActivitePage.Save() ; 
$SuiviActivitePage.Publish() ; 

Write-Host "Terminé." -ForegroundColor Green
#endregion

#########################################################
# Ajout de la page d'accueil
###########################################################
#region Page d'accueil 
Write-host "Initialisation de la page d'accueil ... " -ForegroundColor Cyan -NoNewline

$HomePage = Get-PnPClientSidePage -Identity "Home.aspx"
$HomePage.ClearPage()

$FicheclientePage = Get-PnPClientSidePage -Identity "Fiche-Client.aspx"
$SitePageList = Get-PnPList "SitePages"

$QUickLink_jsonProps = @"
{
		"controlType":3,
		"displayMode":2,
		"id":"904fbe64-5579-44b4-9cd2-f9ad9722c05b",
		"position":{"zoneIndex":1,"sectionIndex":1,"controlIndex":1},
		"webPartId":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd",
		"webPartData":{
				"id":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd",
				"instanceId":"904fbe64-5579-44b4-9cd2-f9ad9722c05b",
				"title":"Liens rapides",
				"description":"Ajoutez des liens vers des pages et des documents importants.",
				"serverProcessedContent":{
						"htmlStrings":{},
						"searchablePlainTexts":{
								"title":"",
								"items[0].title":"Contact",
								"items[1].title":"Info Client",
								"items[2].title":"Parc Client",
								"items[3].title":"WIKI",
								"items[0].description":"",
								"items[1].description":"",
								"items[2].description":"",
								"items[3].description":"",
								"items[0].altText":"",
								"items[1].altText":"",
								"items[2].altText":"",
								"items[3].altText":""
								},
								"imageSources":{},
								"links":{
										"baseUrl":"$($web.Url)",
										"items[0].sourceItem.url":"$($web.Url)/Contact",
										"items[1].sourceItem.url":"$($web.Url)/SitePages/Info-Client.aspx",
										"items[2].sourceItem.url":"$($web.Url)/SitePages/Fiche-Client.aspx",
										"items[3].sourceItem.url":"$($web.Url)/SitePages"
										},
								"componentDependencies":{ 
										"layoutComponentId":"706e33c8-af37-4e7b-9d22-6e5694d92a6f"
										}
								},
								"dataVersion":"2.2",
								"properties":{
										"items":[
												{"sourceItem":{"itemType":4,"fileExtension":"","progId":""},
												"thumbnailType":2,
												"id":4,
												"fabricReactIcon":{"iconName":"contactcard"}},
												{"sourceItem":
														{"guids":{
																"siteId":"$SiteId",
																"webId":"$WebId",
																"listId":"$($SitePageList.id)",
																"uniqueId":"$($InfoCliPage.PageListItem.FieldValues.UniqueId)"},
																"itemType":0,
																"fileExtension":".ASPX",
																"progId":null
														},
														"thumbnailType":2,
														"id":3,
														"fabricReactIcon":{"iconName":"info"}
												},
												{"sourceItem":
														{"guids":{
																"siteId":"$SiteId",
																"webId":"$WebId",
																"listId":"$($SitePageList.id)",
																"uniqueId":"$($pageFicheClient.PageListItem.FieldValues.UniqueId)"
														},
														"itemType":0,
														"fileExtension":".ASPX",
														"progId":null
														},
														"thumbnailType":2,
														"id":2,
														"fabricReactIcon":{"iconName":"devices2"}
												},
												{"sourceItem":
														{"guids":{
																"siteId":"$SiteId",
																"webId":"$WebId",
																"listId":"$($SitePageList.id)",
																"uniqueId":"$($SitePageList.Id)"
																},
																"itemType":4,
																"fileExtension":"",
																"progId":""
														},
														"thumbnailType":2,
														"id":1,
														"fabricReactIcon":{"iconName":"allapps"}
												}],
												"isMigrated":true,
												"layoutId":"Grid",
												"shouldShowThumbnail":true,
												"buttonLayoutOptions":{
														"showDescription":false,
														"buttonTreatment":2,
														"iconPositionType":2,
														"textAlignmentVertical":2,
														"textAlignmentHorizontal":2,
														"linesOfText":2
														},
												"listLayoutOptions":{
														"showDescription":false,
														"showIcon":true
												},
												"waffleLayoutOptions":{"iconSize":1,"onlyShowThumbnail":false},
												"hideWebPartWhenEmpty":true,
												"dataProviderId":"QuickLinks",
												"webId":"$WebId",
												"siteId":"$SiteId",
												"pane_link_button":0}},
												"emphasis":{},
												"reservedHeight":504,
												"reservedWidth":744
												}
"@
$ListQuickLink_WebPartProps = @"
{
"controlType":3,"displayMode":2,"id":"8317c959-62c6-474b-ba64-353a9a4029aa","position":{"zoneIndex":1,"sectionIndex":1,"controlIndex":1,"layoutIndex":1},"webPartId":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd","webPartData":{"id":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd","instanceId":"8317c959-62c6-474b-ba64-353a9a4029aa","title":"Liens rapides","description":"Ajoutez des liens vers des pages et des documents importants.","serverProcessedContent":{"htmlStrings":{},"searchablePlainTexts":{"title":""},"imageSources":{},"links":{"baseUrl":"$($web.Url)"},"componentDependencies":{"layoutComponentId":"706e33c8-af37-4e7b-9d22-6e5694d92a6f"}},"dataVersion":"2.2","properties":{"items":[],"isMigrated":true,"layoutId":"List","shouldShowThumbnail":true,"buttonLayoutOptions":{"showDescription":false,"buttonTreatment":2,"iconPositionType":2,"textAlignmentVertical":2,"textAlignmentHorizontal":2,"linesOfText":2},"listLayoutOptions":{"showDescription":false,"showIcon":true},"waffleLayoutOptions":{"iconSize":1,"onlyShowThumbnail":false},"hideWebPartWhenEmpty":true,"dataProviderId":"QuickLinks","webId":"$WebId","siteId":"$$SiteId"}},"emphasis":{},"reservedHeight":176,"reservedWidth":744
}
"@

Add-PnPClientSidePageSection -Page $HomePage -SectionTemplate TwoColumnLeft

$Silence = Add-PnPClientSideWebPart -DefaultWebPartType QuickLinks -WebPartProperties $QUickLink_jsonProps -Section 1 -Column 1 -Page $HomePage
$Silence = Add-PnPClientSideWebPart -DefaultWebPartType QuickLinks -WebPartProperties $ListQuickLink_WebPartProps -Section 1 -Column 2 -Page $HomePage

$HomePage.RemovePageHeader();
$HomePage.save();
$HomePage.Publish();

Write-host "Termminé " -ForegroundColor Green

$silence = Add-PnPNavigationNode -Title "Sites Clients" -Url "https://sf2inc.sharepoint.com/sites/ESPACESCLIENTS" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "Accueil" -Url "$($Web.Url)" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "Wiki" -Url "$($Web.Url)/sitepages" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "Suivi d'activité" -Url "$($Web.Url)/sitepages/Suivi_Activité.aspx" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "To do list" -Url "$($View_Taches.ServerRelativeUrl)" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "Incidents majeurs" -Url "$($View_IncidentsMajeurs.ServerRelativeUrl)" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "Liens utiles" -Url "$($Web.Url)/sitepages/Liens_Utiles.aspx" -Location QuickLaunch
$silence = Add-PnPNavigationNode -Title "Procédures" -Url "$($View_Procedure.ServerRelativeUrl)" -Location QuickLaunch
#endregion
