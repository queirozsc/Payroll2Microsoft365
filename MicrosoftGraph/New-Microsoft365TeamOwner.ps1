# Gets a list of all generated-teams
$Microsoft365Teams = Get-MgTeam -Filter "startsWith(DisplayName,  'Somos ')"

# Gets an object for nocontestar account
$Microsoft365User = Get-MgUser `
                    -ConsistencyLevel eventual `
                    -Count userCount `
                    -Search  "UserPrincipalName:nocontestar@clinicadelasamericas.com.bo" `
                    -Top 1

# Config params for owner group
$params = @{           
    "@odata.type" = "#microsoft.graph.aadUserConversationMember"
    roles = @(
        "owner"
    )
    "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('$($Microsoft365User.Id)')"
}

# Add account as owner of all groups
foreach ($Microsoft365Team in $Microsoft365Teams) { 
    New-MgTeamMember -TeamId $Microsoft365Team.Id -BodyParameter $params
}