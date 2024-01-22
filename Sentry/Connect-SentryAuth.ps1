$SENTRY_URI = "https://sentry.io/api/0/organizations/$($env:SENTRY_ORGANIZATION_SLUG)/teams/?detailed=0"
$SENTRY_URI = "https://sentry.io/api/0/projects/"
Write-Host "URI " $SENTRY_URI

$SENTRY_AUTHORIZATION = "Bearer " + $env:SENTRY_TOKEN
#$SENTRY_AUTHORIZATION = "DSN " + $env:SENTRY_DSN
Write-Host "Authorization" $SENTRY_AUTHORIZATION

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", $SENTRY_AUTHORIZATION)
$response = Invoke-RestMethod $SENTRY_URI -Method 'GET' -Headers $headers
$response