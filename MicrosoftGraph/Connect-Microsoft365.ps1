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
