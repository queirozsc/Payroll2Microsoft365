$SALAR_URI = 'https://clinicaamericas.salar10.net/api/Colaboradores/Consultar'
Write-Host "URI " $SALAR_URI

$SALAR_AUTHORIZATION = "Bearer " + $env:SALAR_TOKEN
#Write-Host "Authorization" $SALAR_AUTHORIZATION

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", $SALAR_AUTHORIZATION)
$headers.Add("Cookie", "SALAR.CLINAME.SESION=1brhcycza3df2ymjmdblip4z")
$postParam = @{
    "IdEmpresa" = $env:SALAR_ID_EMPRESA
    "Cuenta" = $env:SALAR_CUENTA
    "Contrasena" = $env:SALAR_CONTRASENA
    #"Estado" = 2 # Status of worker (1 = Active / 2 = Inactive)
    #"FechaIngresoInicio" = "2024-01-01" # Start date, in format yyyy-mm-dd
    #"FechaIngresoFin" = "2024-01-31" # End date, in format yyyy-mm-dd

}
$body = ConvertTo-Json $postParam
#Write-Host "Body " $body

$worker = Invoke-RestMethod $SALAR_URI -Method 'POST' -Headers $headers -Body $body
$worker `
    | Select-Object -ExpandProperty Resultado `
    | Where-Object { $_.PrimerNombre -eq "YERSIN" }
$worker | Format-List
