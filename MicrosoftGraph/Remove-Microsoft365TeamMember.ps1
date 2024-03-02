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