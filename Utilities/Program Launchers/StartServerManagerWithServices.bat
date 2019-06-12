@echo off

cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" 1>nul 2>nul && exit )

sc config  WinRM  start= AUTO >NUL 2>&1
sc config  LanmanServer start= DEMAND >NUL 2>&1
sc config  LanmanWorkstation start= DEMAND >NUL 2>&1

sc start WinRM >NUL 2>&1
sc start LanmanServer >NUL 2>&1
sc start LanmanWorkstation >NUL 2>&1

cd /d "%windir%\system32"
start ServerManager.exe >NUL 2>&1

sc config  WinRM  start= DISABLED >NUL 2>&1
sc config  LanmanServer start= DISABLED >NUL 2>&1
sc config  LanmanWorkstation start= DISABLED >NUL 2>&1
exit