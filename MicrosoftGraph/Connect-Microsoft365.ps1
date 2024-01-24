$scopes = @(
    "User.ReadWrite.All"
    "Directory.ReadWrite.All"
)
Connect-MgGraph -Scopes $scopes
Get-MgContext | Select -ExpandProperty Scopes