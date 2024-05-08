<#
.SYNOPSIS
    Removes a member from a Microsoft 365 team.
.DESCRIPTION
    This function removes a member from a Microsoft 365 team.
.PARAMETER Microsoft365User
    Specifies the Microsoft 365 user to be removed from the team.
.PARAMETER Microsoft365Teams
    Specifies the Microsoft 365 team from which the user will be removed. If not specified, the user will be removed from all standard groups.
.EXAMPLE
    $user | Remove-Microsoft365TeamMember -Microsoft365Teams $team
    Removes the user represented by $user from the Microsoft 365 team represented by $team.
#>
function Remove-Microsoft365TeamMember {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [PSCustomObject] $Microsoft365User,
        [Parameter(Mandatory=$false)]
        [PSCustomObject] $Microsoft365Teams
    )

    begin {
    }
    
    process {
        # Remove team member
        if ($Microsoft365Teams) {
            # User is a team member?
            $TeamMember = Get-MgTeamMember -TeamId $Microsoft365Teams.Id -Filter "(microsoft.graph.aadUserConversationMember/userId eq '$($Microsoft365User.Id)')"
            if ($TeamMember) {
                Remove-MgGroupMember -ConversationMemberId $Microsoft365User.Id -GroupId $Microsoft365Teams.Id
            }                

        } else {
            # If not informed, remove from all standard groups
            $Microsoft365Teams = Get-MgTeam -Filter "startsWith(DisplayName, 'Somos ')"
            foreach ($Team in $Microsoft365Teams) {
                # User is a team member?
                #$TeamMember = Get-MgTeamMember -TeamId $Team.Id -Filter "(microsoft.graph.aadUserConversationMember/userId eq '$($Microsoft365User.Id)')"
                #if ($TeamMember) {
                    Remove-MgGroupTeamMember -ConversationMemberId $Microsoft365User.Id -GroupId $Team.Id -ErrorAction SilentlyContinue
                #}                
            }
        }
        
    }
    
    end {
        
    }
}