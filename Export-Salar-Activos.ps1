$Employees = Get-PayrollEmployees -ActivesOnly
$Employees `
    | Select-Object Estado, FechaIngreso, FechaNacimiento, CodigoColaborador, NumeroDocumento, CodigoAsistencia, NombreCompleto, CargoPlanillas, ProfesionOficio, Division, CentroCosto, NombreSuperior, Ciudad, DireccionPersonal   `
    | Sort-Object FechaIngreso -Descending `
    | Export-Csv -Path ".\$(Get-Date -Format yyyyMMdd)_Salar_Activos.csv"
