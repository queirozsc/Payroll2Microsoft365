$ADUsers = Get-ADUser -Filter "Enabled -eq '$true' -and (PostalCode -notlike '*')"
$ADUsers `
    | Select-Object Enabled, SamAccountName, Name, UserPrincipalName `
    | Sort-Object SamAccountName `
    | Export-Csv -Path ".\$(Get-Date -Format yyyyMMdd)_AD_Without_PostalCode.csv"
