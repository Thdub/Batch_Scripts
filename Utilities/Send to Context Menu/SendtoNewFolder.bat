@echo off

cd /d "%~dp1"
set "NF=New folder"
set "Dest=%~dp1%NF%"

if not exist "%Dest%" goto :MoveTask
:: incremental folder naming
	setlocal enableDelayedExpansion
	set "baseName=New folder ("
	set "n=1"
	for /f "delims=" %%F in (
	  '2^>nul dir /b /ad "%baseName%*)"^|findstr /xri /c:"%baseName%[0-9]*)"'
	) do (
	  set "name=%%F"
	  set "name=!name:*%baseName%=!"
	  set "name=!name:)=!"
	  echo !name!
	  if !name! gtr !n! set "n=!name!"
	)
	set /a n+=1
	set "NF=%baseName%%n%"
	set "Dest=%~dp1%NF%)"

:MoveTask
	mkdir "%Dest%" >NUL 2>&1
	for %%A in (%*) do (
		move %%A  "%Dest%"
		) >NUL 2>&1
exit /b