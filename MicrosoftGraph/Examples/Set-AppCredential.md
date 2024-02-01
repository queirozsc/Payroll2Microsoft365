#See more at https://learn.microsoft.com/en-us/powershell/microsoftgraph/app-only?view=graph-powershell-1.0
function Set-AppCredential
{
    Param(
        [Parameter(Mandatory)]
        [string]$AppName,
        [Parameter(Mandatory)]
        [string]$KeyVaultName,
        [Parameter(Mandatory)]
        [string]$CertificateName
    )

    $Application = Get-MgApplication -Filter "DisplayName eq '$($AppName)'"

    $KeyVaultCertificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertificateName

    $CertCredential = @{
        Type = "AsymmetricX509Cert"
        Usage = "Verify"
        Key = $KeyVaultCertificate.Certificate.RawData
    }

    Update-MgApplication -ApplicationId $Application.Id -KeyCredentials @($CertCredential)

}