# Skrypt kompilujący gospo.pas w Windows oraz w WSL

Write-Host "Kompilacja lokalna Free Pascal (Windows)..." -ForegroundColor Cyan
fpc gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja w Windows została koncertowo zepsuta. Przerywam dalsze kroki." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`nKompilacja Free Pascal wewnątrz WSL (Linux)..." -ForegroundColor Cyan
wsl fpc gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja w WSL się wyłożyła!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`nOba środowiska skompilowały plik pomyślnie!" -ForegroundColor Green
