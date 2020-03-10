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
PS C:\> Get-GlpiTicketStatus -session $session.session_token -ItemID $ItemID
.INPUTS
.OUTPUTS
#>
function Get-GlpiTicketStatus () {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string]$ItemID
        )
                
    $Const_Status = @() ; 
    $Const_Status += New-Object -TypeName PsCustomObject -Property @{ID = 1 ; Libelle = "Nouveau"}
    $Const_Status += New-Object -TypeName PsCustomObject -Property @{ID = 2 ; Libelle = "En cours / attribue"}
    $Const_Status += New-Object -TypeName PsCustomObject -Property @{ID = 3 ; Libelle = "En cours / planifie"}
    $Const_Status += New-Object -TypeName PsCustomObject -Property @{ID = 4 ; Libelle = "En attente"}
    $Const_Status += New-Object -TypeName PsCustomObject -Property @{ID = 5 ; Libelle = "Resolu"} 
    $Const_Status += New-Object -TypeName PsCustomObject -Property @{ID = 6 ; Libelle = "Clot"} 
   
    
    $ticket = get-GLPIItem  -ItemType "Ticket" -ItemID $ItemID
    return $Const_Status | where {$_.Id -eq $ticket.status}

}