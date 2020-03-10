#var connection
$UserName = "SVCNC1SHAREPOINT@heiway.net"
$pass ="WQCthjK&JGyQKE5KP.pwEz%?3"
$Url = "https://heiway.sharepoint.com/teams/NC1-TS-NC-GBNC/SAFETY-TS"

#connection automatique pnp
Write-Host "-------------Connection a PNP" -ForegroundColor Green
Add-PnPStoredCredential -Name AdminTenant -Username $UserName -Password (ConvertTo-SecureString -String $pass -AsPlainText -Force) 
$credAdmin = Get-PnPStoredCredential -Name AdminTenant -Type PSCredential
Connect-PnPOnline -Url $url -Credentials $credAdmin


$ObjCSV = @{}
$TabService = @()
$TabRisque = @()
$TabNature = @()
$TabZone = @()
$tabtempo = @()
$TabSousZone = @()

#sous liste pour les lookup
$LookListService = Get-PnPListItem -List GESTION-Services
$lookListRisque = Get-PnPListItem -List GESTION-TAGS-RISQUES
$lookListNature = Get-PnPListItem -List Gestion-NatureEven 
$lookListZone = Get-PnPListItem -List Gestion_Zone 
$lookListSousZone = Get-PnPListItem -List GESTION-TAGS-ZONES
$context = Get-PnPContext

foreach($i in $lookListSousZone){
    $context.Load($i)
    $context.ExecuteQuery()
}


for ($i = 0  ; $LookListService.Length -gt $i ; $i++){
     $title = $LookListService[$i]["Title"] 
     $objService =  [PSCustomObject]@{
        Title = $title
        id = $LookListService.id[$i]
      }
      $TabService += $objService
}
for ($i = 0  ; $lookListRisque.Length -gt $i ; $i++){
     $title = $lookListRisque[$i]["Title"] 
     $objRisque =  [PSCustomObject]@{
        Title = $title
        id = $lookListRisque.id[$i]
      }
      $TabRisque += $objRisque
}
for ($i = 0 ; $lookListNature.Length -gt $i ; $i++){
     $title =$lookListNature[$i]["Title"] 
     $objNature =  [PSCustomObject]@{
        Title = $title
        id = $lookListNature.id[$i]
      }
      $TabNature += $objNature
}
for ($i = 0  ; $lookListZone.Length -gt $i ; $i++){
     $title =$lookListZone[$i]["Title"] 
     $objZone =  [PSCustomObject]@{
        Title = $title
        id = $lookListZone.id[$i]
      }
      $TabZone += $objZone
}
for ($i = 0  ; $lookListSousZone.Length -gt $i ; $i++){
    $label = $lookListSousZone[$i]["t55w"]
    $title =$lookListSousZone[$i]["Title"]
    $id = $lookListSousZone[$i]["ID"] 
    $objSousZone = New-Object  -TypeName PSObject -Property @{
        Title = $title
        id = $id
        label = $label
      }
      $TabSousZone += $objSousZone
}
$lookListSousZone =$TabSousZone

#lecture CSV
Write-Host "-------------Lecture CSV" -ForegroundColor Green
$Path = "C:\Users\dolme\Desktop\stage"
set-location $Path
$csvImport = Import-Csv "Enregistrement et suivi des accidents, incidents et presque accidents 2018.csv" -Delimiter ";" -Encoding Default

#ajout a sharepoint
$y = 0
Write-Host "-------------Importation dans SharePoint" -ForegroundColor Green
ForEach ($item in $csvImport){
    $ObjCSV = [PSCustomObject]@{
        Etat_du_presque_accident = $item.'Etat du presque accident'
        Numero = $item.Numero
        Nature_de_evenement = $item.'Nature de l''evenement'
        date = $item.'date '
        Auteur = $item.Auteur
        Zone = $item.Zone
        Lieu = $item.Lieu
        Description_du_presque_accident = $item.'Description du presque accident'
        Risque_associe = $item.'Risque associe'
        Contre_mesure_proposee = $item.'Contre-mesure proposee'
        Qui_fait_action = $item.'QUI fait l''action ?'
        Eradication = $item.'ERADICATION ? '
        Date_de_mise_en_place_de_la_contre_mesure = $item.'Date de mise en place de la contre mesure'
        SERVICE_EN_CHARGE_DE_LA_RESOLUTION =$item.'SERVICE EN CHARGE DE LA RESOLUTION'
        GBNC_Sous_traitant= $item.'GBNC/Sous traitant '
    }

   $tabtempo = $lookListSousZone | where { $_.Title -eq $ObjCSV.Zone}
   $rand = New-Object System.Random
   $index = [int]$rand.Next(0,$tabtempo.Length)
   $index -= 1
   $index = $tabtempo[$index]
   $idSz = $lookListSousZone.IndexOf($index)
   

    $TabZone = $lookListZone |where{$_["Title"] -eq $ObjCSV.Zone}
    $idZ = $TabZone.id 
    $TabNature = $lookListNature |where{$_["Title"] -eq $ObjCSV.Nature_de_evenement}
    $idN = $TabNature.id 
    if([String]::IsNullOrEmpty($idN))
    {
        $idN = 0
    }
    $TabService = $LookListService |where{$_["Title"] -eq $ObjCSV.SERVICE_EN_CHARGE_DE_LA_RESOLUTION}
    $idS = $TabService.id
    $TabRisque = $lookListRisque |where{$_["Title"] -eq $ObjCSV.Risque_associe}
    if($TabRisque -ne $null){
        $idR = $TabRisque.id
    }else{
        $idR = $lookListRisque.id[0]
    }
    if($ObjCSV.date -ne $null){
        $date = $ObjCSV.date
        $dateTime =  [datetime]::ParseExact($date, "dd/MM/yyyy", $null)
    }
    if($ObjCSV.Date_de_mise_en_place_de_la_contre_mesure -ne $null){
        $dateMiseEnPlace = $ObjCSV.Date_de_mise_en_place_de_la_contre_mesure
        $dateMiseEnPlaceTime = [datetime]::ParseExact($dateMiseEnPlace, "dd/MM/yyyy",$null)
    }
    $Eradication = $ObjCSV.Eradication
    if([String]::IsNullOrEmpty($Eradication)){
        $Eradication = "oui"
    }

    #ST_Risques
    Add-PnPListItem -List "Evènement Safety" -Values @{"ST_PST"= 1 ;"Type_Even"=1;"ST_SsZone"=$idSz;"ST_Zone" = $idZ;"ST_Nature"=$idN;"ST_Risques"=$idR;"ST_Service_Resol"="$idS";"ST_Service" = $ObjCSV.SERVICE_EN_CHARGE_DE_LA_RESOLUTION;"Title" = $ObjCSV.Numero ; "ST_Observ"=  "i:0#.f|membership|cavall01@heiway.net";"ST_DateEven" = $dateTime; "ST_Contremesure" = $item.'Contre-mesure proposee' ; "ST_Date_MEP"= $dateMiseEnPlaceTime; "ST_Description" = $item.'Description du presque accident' ; "ST_Eradication"=$Eradication;"ST_Resp_Resol" = "i:0#.f|membership|cavall01@heiway.net"}
    
}

