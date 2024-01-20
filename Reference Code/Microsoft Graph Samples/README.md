# Miscelaneous code
## Pre-requisites
Install the NuGet provider:
```
Install-PackageProvider -Name NuGet -Force
```

Set the execution policy (Windows):
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Install into the current user scope:
```
Install-Module Microsoft.Graph -Scope CurrentUser
```

## Microsoft Graph
Find available commands:
```
Get-Command -Module Microsoft.Graph*
Get-Command -Module Microsoft.Graph* *User*
Get-Command -Module Microsoft.Graph* *Team*
Get-Command -Module Microsoft.Graph -Verb Get
Get-Command -Module Microsoft.Graph -Noun Photo
Get-Command -Module Microsoft.Graph.Authentication
```
Getting help for a command:
```
Get-Help Get-MgUser
Get-Help Get-MgUser -Category Cmdlet
Get-Help Get-MgUser -Category Function
Get-Help Get-MgUser -Detailed
Get-Help Get-MgUser -Full
Get-Help Get-MgUser -ShowWindow
```
### Connecting to Microsoft 365
There are two ways to connect to Microsoft 365:

* **Direct Command:** the user have to consent to authorize defined connection scopes to the session.
```
Import-Module Microsoft.Graph
$scopes = @(
    "Chat.ReadWrite.All"
    "Directory.Read.All"
    "Group.Read.All"
)
Connect-MgGraph -Scopes $scopes
Get-MgContext
```
* **Azure App Registration:** connections scopes are assigned to the Azure App Registration with no need user interaction.
```
Connect-MgGraph `
    -ClientId YOUR_CLIENT_ID `
    -TenantId YOUR_TENANT_ID `
    -CertificateThumbprint CERTIFICATE_THUMBPRINT
```

### Users
Searching users:
```
#Example 1
Connect-MgGraph -Scopes 'User.Read.All'
Get-MgUser -All | Format-List  ID, DisplayName, Mail, UserPrincipalName

#Example 2
Get-MgUser -UserId 'e4e2b110-8d4f-434f-a990-7cd63e23aed6' | `
Format-List  ID, DisplayName, Mail, UserPrincipalName

#Example 3
Get-MgUser -Count userCount -ConsistencyLevel eventual

#Example 4
Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'a')" -Top 1

#Example 5
Get-MgUser -ConsistencyLevel eventual -Count userCount -Search '"DisplayName:Sala"'

#Example 6
Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Sala')" -OrderBy UserPrincipalName
```