@echo off

:: Launch NSudo
	%windir%\system32\whoami.exe /USER | find /i "S-1-5-18" 1>nul && ( goto :START ) || ( NSudoLC.exe -U:T -P:E -UseCurrentConsole "%~dpnx0"&& exit /b )

:START
	setlocal enabledelayedexpansion
	cd /d "%TEMP%"
	mode 90,5
	schTasks /query /TN "CreateExplorerShellUnelevatedTask" >nul 2>&1 && schTasks /Delete /TN "CreateExplorerShellUnelevatedTask" /f >nul 2>&1
	SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -ot reg -actn setprot -op "dacl:np" -actn clear -clr "dacl" -actn rstchldrn -rst "dacl" >nul 2>&1
	SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -ot reg -actn setprot -op "dacl:np" -actn clear -clr "dacl" -actn rstchldrn -rst "dacl" >nul 2>&1
	netsh advfirewall set currentprofile state off >nul 2>&1
	<nul set /p dummyName=Checking for signature updates, wait a few seconds.
	cd %ProgramFiles%\Windows Defender
	MpCmdRun.exe -removedefinitions -dynamicsignatures >nul 2>&1
	for /f "tokens=*" %%G in ('MpCmdRun.exe -SignatureUpdate') do ( set "update_result=%%G" )
	echo:
	echo %update_result%
	goto :ACTIVATE


:ACTIVATE
	<nul set /p dummyName=Enabling Windows Firewall Secure Profile...
	netsh advfirewall set currentprofile state on >nul 2>&1
	SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -ot reg -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl" -actn ace -ace "n:SYSTEM;p:full" -ace "n:NT SERVICE\mpssvc;p:read" >nul 2>&1
	SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -ot reg -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl" -actn ace -ace "n:SYSTEM;p:full" -ace "n:NT SERVICE\mpssvc;p:read" >nul 2>&1
	timeout /t 2 /nobreak >nul 2>&1
	echo Done.
	cd /d "%TEMP%" & del "Get_UpdateClient_Event.xml" "Get_Event19.txt" "Get_Event4.txt" /s /q >nul 2>&1
	setlocal EnableDelayedExpansion
	for /f %%a in ('copy /Z "%~f0" nul') do set "CR=%%a"
	for /l %%n in (4 -1 1) do (
		<nul set /p "=[?25lClosing in %%n seconds...[2X!CR!"
		ping -n 2 localhost > nul
	)
	exit /b
