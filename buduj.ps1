# Skrypt kompilujący gospo.pas w Windows oraz w WSL
# Uwaga: ten skrypt jest dla mnie, więc nie oczekuje się od Ciebie,
# że to zrozumiesz, ani że to pójdzie u Ciebie. Jeżeli jednak
# tak koniecznie chcesz, żeby to poszlo u Ciebie, pozmieniaj
# ścieżki do kompilatorów skrośnych i wsio pójdzie.



#Write-Host "Kompilacja lokalna Free Pascal (Windows)..." -ForegroundColor Cyan
#fpc gospo.pas

#if ($LASTEXITCODE -ne 0) {
#    Write-Host "Kompilacja w Windows została koncertowo zepsuta. Przerywam dalsze kroki." -ForegroundColor Red
 #   exit $LASTEXITCODE
#}

#Write-Host "`nKompilacja Free Pascal pod Linuksa" -ForegroundColor Cyan
#c:\FPC\deluxe\fpc\bin\x86_64-win64\ppcross64.exe -Tlinux gospo

#if ($LASTEXITCODE -ne 0) {
#    Write-Host "Kompilacja w Linuksie sie wylozyla!" -ForegroundColor Red
#    exit $LASTEXITCODE
#}
#
#Write-Host "`nKompilacja Free Pascal na dosa" -ForegroundColor Cyan
#c:\FPC\deluxe\fpc\bin\x86_64-win64\ppcross386.exe -Tgo32v2 -Pi386 gospo -o dos.exe
#
#if ($LASTEXITCODE -ne 0) {
#    Write-Host "Kompilacja w WSL się wylozyla!" -ForegroundColor Red
#    exit $LASTEXITCODE
###Write-Host "`nWsio   poszlo asjompilowaly plik pomyslnie!" -ForegroundColor Green

# Skrypt kompilujący gospo.pas w Windows oraz w WSL

Write-Host "Kompilacja lokalna Free Pascal (Windows)..." -ForegroundColor Cyan
fpc gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja w Windows została koncertowo zepsuta. Przerywam dalsze kroki." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`nKompilacja Free Pascal pod Linuksa..." -ForegroundColor Cyan
# Dodano literkę 'x' -> ppcrossx64.exe oraz dodano rozszerzenie .pas
c:\FPC\deluxe\fpc\bin\x86_64-win64\ppcrossx64.exe -Tlinux gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja w Linuksie sie wylozyla!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`nKompilacja Free Pascal na DOSa32..." -ForegroundColor Cyan

# Ścieżka do jednostek RTL dla targetu go32v2 (dostosuj ścieżkę, jeśli fpcupdeluxe zainstalował je piętro niżej):
$DOS_UNITS = "c:\FPC\deluxe\fpc\units\i386-go32v2\rtl"

c:\FPC\deluxe\fpc\bin\x86_64-win64\ppcross386.exe -Tgo32v2 -Ch1024 -Pi386 -Fu"$DOS_UNITS" -odos32.exe gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja na DOSa 32 się wyłożyła!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`nKompilacja Free Pascal na DOSa 16..." -ForegroundColor Cyan

# Prawidłowa ścieżka do 16-bitowych bibliotek RTL:
$DOS16_UNITS = "c:\FPC\deluxe\fpc\units\i8086-msdos\rtl"

# Usunięto flagę -P8086:
c:\FPC\deluxe\fpc\bin\x86_64-win64\ppcross8086.exe -Tmsdos -Fu"$DOS16_UNITS" -odos16.exe gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja na DOSa 16 się wyłożyła!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`nKompilacja Free Pascal na Amigę (m68k)..." -ForegroundColor Cyan

# Ścieżka do jednostek RTL dla targetu AmigaOS (m68k):
$AMIGA_UNITS = "c:\FPC\deluxe\fpc\units\m68k-amiga\rtl"

c:\FPC\deluxe\fpc\bin\x86_64-win64\ppcross68k.exe -Tamiga -Pm68k -Fu"$AMIGA_UNITS" -oamiga_gospo gospo.pas

if ($LASTEXITCODE -ne 0) {
    Write-Host "Kompilacja na Amigę się wyłożyła!" -ForegroundColor Red
    exit $LASTEXITCODE
}


<#
    Tworzenie katalogu docelowego - parametr -Force gwarantuje, że PowerShell
    nie wyłoży się, jeśli katalog 'bin' już istnieje w D:\prog\rolasyst\
#>
New-Item -ItemType Directory -Path "bin" -Force | Out-Null

<# Kopiowanie gotowych plików wykonywalnych do bin\ #>
Copy-Item *.exe, amiga_gospo, gospo, dos16, dos32 -Destination "bin\" -Force

<# Sprzątanie ze ścieżki głównej po skopiowaniu #>
Remove-Item *.exe, amiga_gospo, dos16, dos32, gospo -ErrorAction SilentlyContinue
Remove-Item *.o, *.a, *.ppu -ErrorAction SilentlyContinue

Write-Host "`nWsio poszło, wszystkie pliki zostały pomyślnie skompilowane!" -ForegroundColor Green