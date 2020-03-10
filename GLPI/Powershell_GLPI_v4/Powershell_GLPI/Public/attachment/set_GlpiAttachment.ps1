<#
.SYNOPSIS
affiche le status d'un ticket
.DESCRIPTION
affiche le status d'un ticket (nouveau/en cours/en attente/resolu/clot
.PARAMETER session
session_token envoyer par la methode Get_GLPISession
.PARAMETER apptoken
Jeton d'api REST GLPI
.PARAMETER ItemID
Id d'un item GLPI
.EXAMPLE
PS C:\> Get-GlpiTicketStatus -session $global:session.session_token -ItemID $ItemID
.INPUTS
.OUTPUTS
#>
function set_GlpiAttachment {
   
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$fileName
    )
    

    $header = @{} ;
    $header['Session-Token'] = $Global:session.session_token
    $header['App-Token'] = $Global:session.apptoken
    $header['Accept'] = "application/json"
    $header['Content-Type'] = "multipart/form-data"

    $body_input = @{} 
    $body_input["tickets_id"] = $TicketId
    $body_input["type"] = $typeId
    $body_input["use_notification"] = $use_notification


    $TableItems = @{} ; 
    $TableItems."input" = $body_input ;

    $JsonItem = ConvertTo-Json $TableItems 
    
    
    $uri = "$($Global:session.GlpiUri)/apirest.php/Ticket/$($ItemID)/Ticket_User"
    $GlpiUser      = Invoke-RestMethod -uri $uri -Method Post  -Headers $header -Body $JsonItem  -ContentType 'application/json'

}