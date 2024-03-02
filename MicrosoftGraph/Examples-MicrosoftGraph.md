# Miscelaneous code
## Pre-requisites
#Install the NuGet provider:
Install-PackageProvider -Name NuGet -Force

#Set the execution policy (Windows):
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

#Install into the current user scope:
Install-Module Microsoft.Graph -Scope CurrentUser

## Microsoft Graph
#Find available commands:
Get-Command -Module Microsoft.Graph*
Get-Command -Module Microsoft.Graph* *User*
Get-Command -Module Microsoft.Graph* *Team*
Get-Command -Module Microsoft.Graph -Verb Get
Get-Command -Module Microsoft.Graph -Noun Photo
Get-Command -Module Microsoft.Graph.Authentication

#Getting help for a command:
Get-Help Get-MgUser
Get-Help Get-MgUser -Category Cmdlet
Get-Help Get-MgUser -Category Function
Get-Help Get-MgUser -Detailed
Get-Help Get-MgUser -Full
Get-Help Get-MgUser -ShowWindow

### Connecting to Microsoft 365
#There are two ways to connect to Microsoft 365:
# **Direct Command:** the user have to consent to authorize defined connection scopes to the session.
Import-Module Microsoft.Graph
$scopes = @(
    "Directory.Read.All"
    "Group.Read.All"
    "User.Invite.All"
)
Connect-MgGraph -Scopes $scopes
Get-MgContext
Get-MgContext | Select -ExpandProperty Scopes
Disconnect-MgGraph

# **Azure App Registration:** connections scopes are assigned to the Azure App Registration with no need user interaction.
Connect-MgGraph `
    -ClientId YOUR_CLIENT_ID `
    -TenantId YOUR_TENANT_ID `
    -CertificateThumbprint CERTIFICATE_THUMBPRINT `
    -ForceRefresh

### Users
#Searching users:
#Example 1
Connect-MgGraph -Scopes 'User.Read.All'
Get-MgUser -All | Format-List  ID, DisplayName, Mail, UserPrincipalName

#Example 2
Get-MgUser -UserId 'e4e2b110-8d4f-434f-a990-7cd63e23aed6' | `
Format-List  ID, DisplayName, Mail, UserPrincipalName

#Example 3
Get-MgUser -Count userCount -ConsistencyLevel eventual

#Example 4
Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Sergio C')" -Top 1

#Example 5
Get-MgUser -ConsistencyLevel eventual -Count userCount -Search '"DisplayName:Sala"'

#Example 6
Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Sala')" -OrderBy UserPrincipalName

#Creating a new user:
$Password = @{ Password = "CDLA@$(Get-Date -Format yyyy)" }
$Password

New-MgUser `
    -DisplayName 'FULL NAME CREATED BY POWERSHELL' `
    -PasswordProfile $Password `
    -MailNickname 'name.surname' `
    -UserPrincipalName 'name.surname@clinicadelasamericas.com.bo' `
    -AccountEnabled

#Updating a user:
$user = Get-MgUser -UserId 8871f11a-8e8d-4a95-bb0d-5cb333b22814
$user
Update-MgUser `
    -UserId $user.Id
    -DisplayName 'FULL NAME (AUTOMATICALLY CREATED BY POWERSHELL)' `
    -Birthday "1978-03-27T00:00:00Z"
$user | Format-List

#Updating massive properties from a user:
$user = Get-MgUser -UserId 72d67b84-d85c-4f95-b9b4-613f33eeeb31
$user
$properties = @{
    AboutMe = "BACHILLER EN CIENCIAS DE LA COMPUTACION"
    Birthday = "1978-03-27T00:00:00Z"
    EmployeeHireDate = "2021-01-01T00:00:00Z"    
}
$properties
Update-MgUser `
    -UserId $user.Id `
    -BodyParameter $properties
$user | Format-List

#Inactivating a user:
Update-MgUser `
    -UserId 8871f11a-8e8d-4a95-bb0d-5cb333b22814 `
    -AccountEnable:$false 

### Finding permissions
Find-MgGraphPermission user -PermissionType Delegated
Find-MgGraphPermission teams -PermissionType Delegated
Find-MgGraphPermission sites -PermissionType Delegated
Find-MgGraphPermission ediscovery -PermissionType Delegated
Find-MgGraphPermission compliance -PermissionType Delegated
Find-MgGraphPermission service -PermissionType Delegated

### Groups
#Setting permissions:
Disconnect-MgGraph
$scopes = @(
    "User.ReadWrite.All"
    "Group.ReadWrite.All"
    "GroupMember.ReadWrite.All"
    "Directory.ReadWrite.All"
    "TeamSettings.ReadWrite.All"
)
Connect-MgGraph -Scopes $scopes
Get-MgContext | Select -ExpandProperty Scopes
Get-MgGroup

#Listing existing groups (Unified = Microsoft 365 group, {} = Security group):
# Read more at https://learn.microsoft.com/en-us/answers/questions/732613/azure-ad-what-is-difference-between-security-group
Get-MgGroup | Format-List ID, DisplayName, Description, GroupTypes
Get-MgGroup -ConsistencyLevel eventual -Filter "startsWith(DisplayName, 'Somos CDLA')"

#Creating a new group:
New-MgGroup `
    -DisplayName 'FULL GROUP (AUTOMATICALLY CREATED BY POWERSHELL)' `
    -MailNickname 'PwshGroup' `
    -MailEnabled:$false `
    -SecurityEnabled

#Updating a group:
$group = Get-MgGroup -GroupId 0ef59490-98d1-47fa-a02e-b1b62e6db833
$group
$properties = @{
    "Description" = "Updated group description"
    "DisplayName" = "New Group Display (Automatically updated by Powershell)"
}
$properties
Update-MgGroup `
    -GroupId $group.Id `
    -BodyParameter $properties

    #### Group members
#Listing members from a group:
Get-MgGroupMember -GroupId 0ef59490-98d1-47fa-a02e-b1b62e6db833

#Adding members to a group:
$user = Get-MgUser -UserId 8871f11a-8e8d-4a95-bb0d-5cb333b22814
$user
$group = Get-MgGroup -GroupId 0ef59490-98d1-47fa-a02e-b1b62e6db833
$group
New-MgGroupMember `
    -GroupId $group.Id `
    -DirectoryObjectId $user.Id

### Sharepoint sites
Disconnect-MgGraph
$scopes = @(
    "Sites.FullControl.All"
)
Connect-MgGraph -Scopes $scopes
Get-MgContext | Select -ExpandProperty Scopes
Get-MgSite -SiteId root

### Teams
Disconnect-MgGraph
$scopes = @(
    "Team.Create"
)
Connect-MgGraph -Scopes $scopes
Get-MgContext | Select -ExpandProperty Scopes
Get-MgSite -SiteId root

### Certificates
#### Creating
```
$cert = New-SelfSignedCertificate `
    -Subject "CN={GraphCertificate}" `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyExportPolicy Exportable `
    -KeySpec Signature `
    -KeyLength 4096 `
    -KeyAlgorithm RSA `
    -HashAlgorithm SHA256

#To view your newly created certificate:
#Run on Windows comamnd
& "certmgr.msc"

#Then navigate to Personal \ Certificates folder

#### Exporting
#To export with the private key, into a PKCS12 file format (.PFX): 
$Password = ConvertTo-SecureString -String 'pwd@1234' -Force -AsPlainText
$cert | Export-PfxCertificate -FilePath .\GraphCertificate.pfx -Password $Password

#To view the properties for your newly certificate, on a terminal window: 
& "certutil -dump GraphCertificate.pfx"

#To export without the private key, into a X.509 file format (.CER): 
Export-Certificate -Cert $cert -FilePath .\GraphCertificate.cer

#To view the properties for your newly certificate, on a terminal window: 
& "certutil -dump GraphCertificate.cer"
