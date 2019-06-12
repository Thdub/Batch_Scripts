@echo off
%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>NUL 2>NUL || goto :NOADMIN

:: Change code page to european (required in case you have any character accentuation)
	chcp 1252 >NUL 2>&1
:: Set Folder
	set "StartMenuFolder=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
	echo In which Start Menu folder do you have blank or new icons to update?
	set /p "Folder=%StartMenuFolder%\"
:: Set PSScript Name and Path
	set "scriptname=%TEMP%\DebugIcons.ps1"
	if exist %scriptname% del %scriptname% /s /q >NUL 2>&1
	set "Folder2update=%StartMenuFolder%\%Folder%"
	cd /d "%Folder2update%"
:: Create Script
	for /r %%a in ("*.lnk") do (
	@echo ^(ls "%%a" ^).lastwritetime = get-date>>%scriptname%
	)
:: Process
	PowerShell -ExecutionPolicy Bypass -File "%scriptname%"
	echo Selected start menu icons have been updated.
	del %scriptname% /s /q >NUL 2>&1
	TIMEOUT /T 3 >NUL 2>&1
	exit /b

:NOADMIN
	echo You must have administrator rights to run this script.
	<nul set /p dummyName=Press any key to exit...
	pause >nul
	goto :eof
