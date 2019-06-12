@echo off

cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" 1>nul 2>nul && exit )

	sc config  AcrSch2Svc  start= AUTO >NUL 2>&1
	sc config  LanmanWorkstation start= DEMAND >NUL 2>&1
	
	sc start AcrSch2Svc >NUL 2>&1
	sc start LanmanWorkstation >NUL 2>&1
	
	cd /d "%PROGRAMFILES(x86)%\Acronis\TrueImageHome"
	start TrueImageLauncher.exe >NUL 2>&1
	
	sc config  AcrSch2Svc  start= DISABLED >NUL 2>&1
	sc config  LanmanWorkstation start= DISABLED >NUL 2>&1

	exit/b