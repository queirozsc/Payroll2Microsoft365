<#
.SYNOPSIS
    Connects to Microsoft 365 using Microsoft Graph PowerShell module.
.DESCRIPTION
    This function connects to Microsoft 365 using the Microsoft Graph PowerShell module.
    It supports connecting in both delegated mode (when running in debug mode) and with Azure App Registration.
.PARAMETER Scopes
    Specifies a hashtable containing the scopes for the Microsoft Graph connection.
    This parameter is optional and only used when connecting in delegated mode.
.EXAMPLE
    Connect-Microsoft365
    Connects to Microsoft 365 using Azure App Registration for authentication.
.EXAMPLE
    Connect-Microsoft365 -Scopes @{ 'User.Read' = $true }
    Connects to Microsoft 365 in delegated mode with specified scopes for user read access.
#>
function Connect-Microsoft365 {
    [CmdletBinding(SupportsShouldProcess=$True)]
    param (
        [Parameter(Mandatory=$False)]
        [hashtable] $Scopes
    )    
    begin {
        
    }
    
    process {
        # Check if running in debug mode
        if ($env:DEBUG_MODE) {
            # Connect in delegated mode
            Connect-MgGraph `
                -Scopes $Scopes `
                -ForceRefresh
        } else {
            # Connect with Azure App Registration
            # (scopes are assigned to Azure App Registration with no need user interaction)
            Connect-MgGraph `
                -TenantId $env:AZURE_TENANT_ID `
                -ClientId $env:AZURE_CLIENT_ID `
                -CertificateThumbprint $env:AZUREAPP_CERTIFICATE_THUMBPRINT `
                -ForceRefresh
        }
    }
    
    end {
        
    }
}
