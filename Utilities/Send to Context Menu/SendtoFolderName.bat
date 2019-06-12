@echo off

set "Dest=%~dpn1"
	cd /d "%~dp1"
	if exist "%Dest%" goto :eof
	mkdir "%Dest%" >NUL 2>&1
	for %%A in (%*) do (
		move %%A  "%Dest%"
		) >NUL 2>&1
exit /b