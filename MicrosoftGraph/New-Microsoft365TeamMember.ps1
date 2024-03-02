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