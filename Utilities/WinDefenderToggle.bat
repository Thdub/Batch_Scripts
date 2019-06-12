@echo off

cd /d "%~dp0/1"
sc query WinDefend | find "STATE" | find "RUNNING" && goto :stop

:start
NSudoG.exe -U:T -ShowWindowMode:Hide sc start WinDefend & exit /b

:stop
NSudoG.exe -U:T -ShowWindowMode:Hide sc stop WinDefend & exit /b
