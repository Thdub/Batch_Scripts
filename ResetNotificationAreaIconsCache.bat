@echo off

cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" 1>nul 2>nul && exit )

set regPath=HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify
set regKey1=IconStreams
set regKey2=PastIconsStream

echo.
echo The Explorer process must be temporarily killed before deleting your notification area icons cache. 
echo.
echo Please SAVE ALL OPEN WORK before continuing.
echo.
pause

echo.
taskkill /IM explorer.exe /F
echo.
FOR /F "tokens=*" %%a in ('Reg Query "%regpath%" /v %regkey1% ^| find /i "%regkey1%"') do goto IconStreams
echo Registry key "IconStreams" already deleted.
echo.

:verify-PastIconsStream
FOR /F "tokens=*" %%a in ('Reg Query "%regpath%" /v %regkey2% ^| find /i "%regkey2%"') do goto PastIconsStream
echo Registry key "PastIconsStream" already deleted.
echo.
goto restart

:IconStreams
reg delete "%regpath%" /f /v "%regkey1%"
goto verify-PastIconsStream

:PastIconsStream
reg delete "%regpath%" /f /v "%regkey2%"

:restart
echo.
echo.
echo You will need to restart the PC to finish resetting your notification area icons.
echo.
CHOICE /C:YN /M "Do you want to restart the PC now?"
IF ERRORLEVEL 2 goto no
IF ERRORLEVEL 1 goto yes

:no
echo.
echo.
echo Restarting explorer.... 
echo.
echo Please remember to restart the PC later to finish resetting your notification area icons.
echo.
start explorer.exe
pause
exit /B

:yes
shutdown /r /f /t 00