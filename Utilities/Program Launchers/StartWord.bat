@echo off
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" 1>nul 2>nul && exit )
sc config  ClickToRunSvc  start= DEMAND >NUL 2>&1
sc start ClickToRunSvc >NUL 2>&1
cd /d "C:\Program Files\Microsoft Office\root\Office16\"
start WINWORD.EXE >NUL 2>&1
sc config  ClickToRunSvc start= DISABLED >NUL 2>&1
exit
