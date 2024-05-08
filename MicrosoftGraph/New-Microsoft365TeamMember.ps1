<#
.SYNOPSIS
    Adds a new member to a Microsoft 365 team.
.DESCRIPTION
    This function adds a new member to a Microsoft 365 team.
.PARAMETER Microsoft365Teams
    Specifies the Microsoft 365 team to which the member will be added.
.PARAMETER Microsoft365User
    Specifies the Microsoft 365 user to be added as a member to the team.
.EXAMPLE
    $team | New-Microsoft365TeamMember -Microsoft365User $user
    Adds the user represented by $user as a member to the Microsoft 365 team represented by $team.
#>
function New-Microsoft365TeamMember {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [PSCustomObject] $Microsoft365Teams,
        [Parameter(Mandatory=$true)]
        [PSCustomObject] $Microsoft365User
    )
    
    begin {
        
    }
    
    process {
        $params = @{
            "@odata.type" = "#microsoft.graph.aadUserConversationMember"
            roles = @(
                "member"
            )
            "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('$($Microsoft365User.Id)')"
        }
        
        New-MgTeamMember -TeamId $Microsoft365Teams.Id -BodyParameter $params
    }
    
    end {
        
    }
}