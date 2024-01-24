$user = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Sergio C')" -Top 1
$user | Format-List