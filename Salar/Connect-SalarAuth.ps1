#Authenticate to get the session token
$SALAR_URI = 'https://clinicaamericas.salar10.net/api/Autenticacion/Autenticar'
Write-Host -Foreground Cyan "Connecting to " $SALAR_URI

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$postParam = @{
    "IdEmpresa" = $env:SALAR_ID_EMPRESA
    "Cuenta" = $env:SALAR_CUENTA
    "Contrasena" = $env:SALAR_CONTRASENA
}
$body = ConvertTo-Json $postParam
#Write-Host "Body " $body

$response = Invoke-RestMethod $SALAR_URI -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json
if ($response.Exito) {
    $env:SALAR_TOKEN = $response.Token
    Write-Host -Foreground Green "Successfuly connected! Token " $env:SALAR_TOKEN
} else {
    Write-Host -Foreground Red "Error! " $response.Mensajes[0]
}
