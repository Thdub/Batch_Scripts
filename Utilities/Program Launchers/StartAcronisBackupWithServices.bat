@echo off

cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~dp0"" && ""%~dpnx0""", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" 1>nul 2>nul && exit )

	sc config AcronisAgent start= AUTO >NUL 2>&1
	sc config AcrSch2Svc start= AUTO >NUL 2>&1
	sc config ARSM start= AUTO >NUL 2>&1
	sc config MMS start= AUTO >NUL 2>&1
	sc config LanmanWorkstation start= AUTO >NUL 2>&1
	sc config "Acronis VSS Provider" start= DEMAND >NUL 2>&1
	
	
	sc start AcronisAgent >NUL 2>&1
	sc start AcrSch2Svc >NUL 2>&1
	sc start ARSM >NUL 2>&1
	sc start MMS >NUL 2>&1
	sc start LanmanWorkstation >NUL 2>&1

	cd /d "C:\Program Files (x86)\Acronis\BackupAndRecoveryConsole"
	start ManagementConsole.exe >NUL 2>&1

:Loop
	tasklist | find /i "ManagementConsole.exe" > nul && (
		goto :loop
	) || (
		sc stop AcronisAgent >NUL 2>&1
		sc stop AcrSch2Svc >NUL 2>&1
		sc stop ARSM >NUL 2>&1
		sc stop MMS >NUL 2>&1
		sc stop LanmanWorkstation >NUL 2>&1
		timeout /t 1 /nobreak >NUL 2>&1
		sc config AcronisAgent start= DISABLED >NUL 2>&1
		sc config AcrSch2Svc start= DISABLED >NUL 2>&1
		sc config ARSM start= DISABLED >NUL 2>&1
		sc config MMS start= DISABLED >NUL 2>&1
		sc config LanmanWorkstation start= DISABLED >NUL 2>&1
		sc config "Acronis VSS Provider" start= DISABLED >NUL 2>&1
		timeout /t 3 /nobreak >NUL 2>&1
		sc stop AcrSch2Svc >NUL 2>&1
exit /b & cmd /k
		)
exit /b & cmd /k
