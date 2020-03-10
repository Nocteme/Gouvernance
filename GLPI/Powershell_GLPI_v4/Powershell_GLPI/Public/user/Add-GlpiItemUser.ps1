<#
.SYNOPSIS
Permets d'attribuer des users a un ticket
.DESCRIPTION
Permets d'attribuer des users a un ticket format Json, cree des liens et atribue des etats au users sur le ticket
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id de l'item a modifie
.PARAMETER TicketId
Id du ticket a modifie
.PARAMETER users_id
Id user pour creer un lien
.PARAMETER GlpiUri
URL GLPI
.EXAMPLE
PS C:\> Add-GlpiItemUser -session $session.session_token -apptoken $aptoken -ItemID $ItemID -TicketId $TicketId -users_id $users_id -type assigned/observer/requester -use_notification true/false -GlpiUri $GlpiUri
.INPUTS
.OUTPUTS
#>
function Add-GlpiItemUser (){
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID,
        [Parameter(Mandatory=$true)][string]$TicketId,
        [Parameter(Mandatory=$true)][string]$users_id,
        [Parameter(Mandatory=$true)]
        [ValidateSet('requester','assigned','observer')]
        [string]$type,
        [Parameter(Mandatory=$true)][string]$use_notification
    )

    $typeId = "0"
    Switch ($type) 
    { 
        "requester" { $typeId = 1}  
        "assigned" { $typeId = 2}  
        "observer" { $typeId = 3}   
        Default    { $typeId = 0} 
    } 

    
    $header = @{} ;
    $header['Session-Token'] = $Global:session.session_token
    $header['App-Token'] = $Global:session.apptoken

    $body_input = @{} 
    $body_input["tickets_id"] = $TicketId
    $body_input["users_id"] = $users_id
    $body_input["type"] = $typeId
    $body_input["use_notification"] = $use_notification


    $TableItems = @{} ; 
    $TableItems."input" = $body_input ;

    $JsonItem = ConvertTo-Json $TableItems 
    
    
    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$($ItemID)/Ticket_User"
    $GlpiUser      = Invoke-RestMethod -uri $uri -Method Post  -Headers $header -Body $JsonItem  -ContentType 'application/json'

    return $GlpiUser
}