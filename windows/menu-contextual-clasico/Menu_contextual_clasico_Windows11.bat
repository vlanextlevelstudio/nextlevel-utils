@echo off
setlocal
title Menu contextual clasico - Windows 11

:MENU
cls
echo ============================================
echo   MENU CONTEXTUAL CLASICO - WINDOWS 11
echo ============================================
echo.
echo 1. Activar menu contextual clasico
echo 2. Restaurar menu contextual moderno de Windows 11
echo 3. Salir
echo.
set /p opcion=Selecciona una opcion [1-3]: 

if "%opcion%"=="1" goto ACTIVAR
if "%opcion%"=="2" goto RESTAURAR
if "%opcion%"=="3" goto FIN

echo.
echo Opcion no valida.
pause
goto MENU

:ACTIVAR
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >nul 2>&1

if errorlevel 1 (
    powershell.exe -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('No se pudo aplicar el cambio en el Registro.','Error',[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null"
    goto FIN
)

powershell.exe -NoProfile -Command ^
"Add-Type -AssemblyName System.Windows.Forms; ^
$r=[System.Windows.Forms.MessageBox]::Show('El menu contextual clasico ha sido activado correctamente.`n`nPara aplicar el cambio es necesario reiniciar el Explorador de Windows, ya que es el proceso que gestiona el escritorio, la barra de tareas y los menus contextuales.`n`nNo se reiniciara el PC. Solo se cerrara y volvera a abrir el Explorador de Windows.`n`nQuieres reiniciarlo ahora?','Cambio aplicado',[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information); ^
if($r -eq [System.Windows.Forms.DialogResult]::Yes){exit 0}else{exit 1}"

if errorlevel 1 goto FIN
goto REINICIAR_EXPLORADOR

:RESTAURAR
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1

powershell.exe -NoProfile -Command ^
"Add-Type -AssemblyName System.Windows.Forms; ^
$r=[System.Windows.Forms.MessageBox]::Show('Se ha restaurado el menu contextual moderno de Windows 11.`n`nPara aplicar el cambio es necesario reiniciar el Explorador de Windows, ya que es el proceso que gestiona el escritorio, la barra de tareas y los menus contextuales.`n`nNo se reiniciara el PC. Solo se cerrara y volvera a abrir el Explorador de Windows.`n`nQuieres reiniciarlo ahora?','Cambio aplicado',[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information); ^
if($r -eq [System.Windows.Forms.DialogResult]::Yes){exit 0}else{exit 1}"

if errorlevel 1 goto FIN
goto REINICIAR_EXPLORADOR

:REINICIAR_EXPLORADOR
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul
start explorer.exe
goto FIN

:FIN
endlocal
exit /b 0
