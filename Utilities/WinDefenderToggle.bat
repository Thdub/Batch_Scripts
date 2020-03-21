@echo off

C:\Windows\system32\whoami.exe /USER | find /i "S-1-5-18" 1>nul && (
	goto :OK
) || (
	NSudoLC -U:T -P:E -Wait -UseCurrentConsole "%~dpnx0" && exit /b
)
:OK
set "PScommand=%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass"
for /f "tokens=3 delims=: " %%i in ('sc query WinDefend ^| findstr /i "STATE"') do ( set "WinDefend=%%i" )
if /i "%WinDefend%"=="RUNNING" ( goto :stop )
if /i "%WinDefend%"=="STOPPED" ( goto :start )

:start
sc start WinDefend >nul 2>&1
:query_Service
for /f "tokens=3 delims=: " %%i in ('sc query WinDefend ^| findstr /i "STATE"') do ( set "WinDefend2=%%i" )
if /i "%WinDefend2%"=="RUNNING" ( %PScommand% -c "Set-MpPreference -DisableRealtimeMonitoring $false" )	else ( goto :query_Service )
exit /b

:stop
%PScommand% -c "Set-MpPreference -DisableRealtimeMonitoring $true"
sc stop WinDefend >nul 2>&1
exit /b
