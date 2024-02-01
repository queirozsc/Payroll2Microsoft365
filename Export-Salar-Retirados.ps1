$Employees = Get-PayrollEmployees -InactivesOnly
$Employees `
    | Select-Object Estado, FechaRetiro, CodigoColaborador, CorreoLaboral, FechaIngreso, CargoPlanillas, PrimerNombre, ApellidoPaterno, ApellidoMaterno  `
    | Sort-Object FechaRetiro -Descending `
    | Export-Csv -Path ".\$(Get-Date -Format yyyyMMdd)_Salar_Retirados.csv"