<#
.SYNOPSIS
    Retrieves a Microsoft 365 team by name and optionally creates it if missing.
.DESCRIPTION
    This function retrieves a Microsoft 365 team by name. If the team does not exist and the $CreateIfMissing switch is specified, it creates a new team with the provided settings.
.PARAMETER Name
    Specifies the display name of the Microsoft 365 team to retrieve or create.
.PARAMETER CreateIfMissing
    Specifies whether to create the team if it doesn't exist. This parameter is optional and defaults to $false.
.EXAMPLE
    Get-Microsoft365Teams -Name "MyTeam"
    Retrieves the Microsoft 365 team named "MyTeam" if it exists.
.EXAMPLE
    Get-Microsoft365Teams -Name "NewTeam" -CreateIfMissing
    Retrieves the Microsoft 365 team named "NewTeam" if it exists, otherwise creates a new team with default settings.
#>
function Get-Microsoft365Teams {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string] $Name,
        [Parameter(Mandatory=$False)]
        [switch] $CreateIfMissing
    )
    
    begin {
        
    }
    
    process {
        # Search Microsoft Teams for team
        $Microsoft365Teams = Get-MgTeam -Filter "displayname eq '$Name'"

        # If not exists, create it
        if (!$Microsoft365Teams -and $CreateIfMissing) {

            # New team settings
            $params = @{
                "template@odata.bind" = "https://graph.microsoft.com/v1.0/teamsTemplates('standard')"
                visibility = "Private"
                displayName = $Name
                description = "Equipo de colaboradores CDLA"
                channels = @(
                    @{
                        displayName = "Noticias 📰"
                        isFavoriteByDefault = $true
                        description = "Ponte al dia con las noticias de la empresa"
                        tabs = @(
                            @{
                                "teamsApp@odata.bind" = "https://graph.microsoft.com/v1.0/appCatalogs/teamsApps('com.microsoft.teamspace.tab.web')"
                                displayName = "Intranet"
                                configuration = @{
                                    contentUrl = "https://clinicadelasamericasbo.sharepoint.com/sites/intranet"
                                }
                            }
                        )
                    }

                )
                memberSettings = @{
                    allowCreateUpdateChannels = $false
                    allowDeleteChannels = $false
                    allowAddRemoveApps = $false
                    allowCreateUpdateRemoveTabs = $false
                    allowCreateUpdateRemoveConnectors = $false
                }
                guestSettings = @{
                    allowCreateUpdateChannels = $false
                    allowDeleteChannels = $false
                }
                funSettings = @{
                    allowGiphy = $true
                    giphyContentRating = "Moderate"
                    allowStickersAndMemes = $true
                    allowCustomMemes = $true
                }
                messagingSettings = @{
                    allowUserEditMessages = $true
                    allowUserDeleteMessages = $true
                    allowOwnerDeleteMessages = $true
                    allowTeamMentions = $true
                    allowChannelMentions = $true
                }
            }

            # Create new team
            New-MgTeam -BodyParameter $params

            # Search for new created team
            $Microsoft365Teams = Get-MgTeam -Filter "displayname eq '$Name'"

        }
    }
    
    end {
        return $Microsoft365Teams
    }
}