@echo off

cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" 1>nul 2>nul && exit )

for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

echo.
echo Event Logs have been cleared! 
goto theEnd

:do_clear
echo clearing %1
wevtutil.exe cl %1
goto :eof

:theEnd
TIMEOUT /T 2 /nobreak >NUL 2>&1
exit