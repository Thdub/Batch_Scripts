@if (@CodeSection == @Batch) @then


@echo off
setlocal
set "Clean=OFF"
set "Index=0"
set "IndexedFolder="
set "tmpfolder=%TEMP%\Indexing_Options_%random%.tmp"
set "lock=%tmpfolder%\wait%random%.lock"
set "scriptname=%tmpfolder%\SearchScopeTask.ps1"
set "Shell_Title=]0;Indexing Options"
	
	mkdir "%tmpfolder%" >NUL 2>&1
	echo [97m%Shell_Title%[97m
	cls
	cd /d "%~dp0"

:SmallMenu
	echo 1. Set custom locations& echo:
	echo 2. Add Windows start menus only& echo:
	echo 3. Remove all locations from indexing options& echo:
	echo 4. Default indexing options settings& echo: & echo:
	choice /c 12340 /n /m "Select your option, or 0 to exit: "
	if errorlevel 5 ( set "Clean=ON" & goto :Clean)
	if errorlevel 4 ( set "Style=default" & cls & goto :ScopeTask)
	if errorlevel 3 ( set "Style=reset" & cls & goto :ScopeTask)
	if errorlevel 2 ( set "Style=startmenus" & cls & goto :ScopeTask)
	if errorlevel 1 ( set "Style=custom" & goto :PathSelection)
	goto :eof

:PathSelection
	setlocal EnableDelayedExpansion
	for /F "delims=" %%a in ('CScript //nologo //E:JScript "%~F0" "Select the folder or type the path you want to index, then click OK."') do (
		if %Index%==0 ( cls & set "IndexedFolder=%%a") else ( set "Index2_%Index%=%%a")
	)
	if "%IndexedFolder%" == "" ( cls & goto :SmallMenu)
	if %Index%==0 ( echo You selected "%IndexedFolder%") else ( echo You selected "!Index2_%Index%!")
	<nul set /p dummyName=Do you want to add another path to indexed locations? [Y/N]
	choice /C:YN /M "" >NUL 2>&1
	if errorlevel 2 ( echo No& goto :PathResult)
	set /a "Index+=1"
	echo Yes
	goto :PathSelection

:PathResult
	echo:
	if %Index%==0 (
		echo Indexed location is "%IndexedFolder%"
		goto :SetCount
	)
	echo Indexed locations are
	echo "%IndexedFolder%"
:SetCount
	set /a "Count=%Index%"

:ResultLoop
	if "%Count%" == "0" ( echo: & goto :ScopeTask)
	set "Index2=!Index2_%Count%!"
	echo "%Index2%"
	set /a "Count-=1"
	goto :ResultLoop

:ScopeTask
:: Get SID
	<nul set /p dummyName=Setting Indexing Options...
	for /f "tokens=1,2 delims==" %%s IN ('wmic path win32_useraccount where name^='%username%' get sid /value ^| find /i "SID"') do set "SID=%%t"
:: Make PS Script
	@echo Add-Type -path "%~dp0Microsoft.Search.Interop.dll">>%scriptname%
	@echo $sm = New-Object Microsoft.Search.Interop.CSearchManagerClass>>%scriptname%
	@echo $catalog = $sm.GetCatalog^("SystemIndex"^)>>%scriptname%
	@echo $crawlman = $catalog.GetCrawlScopeManager^(^)>>%scriptname%
	:: Reset rules
	@echo $crawlman.RevertToDefaultScopes^(^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	:: Remove default rules
	if "%Style%" == "default" ( goto :MakeDefault)
	@echo $crawlman.RemoveDefaultScopeRule^("file:///C:\Users\*"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.RemoveDefaultScopeRule^("file:///C:\ProgramData\Microsoft\Windows\Start Menu\*"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.RemoveDefaultScopeRule^("file:///C:\Users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.RemoveDefaultScopeRule^("file:///C:\Users\*\AppData\Local\Temp\*"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.RemoveDefaultScopeRule^("file:///C:\Users\*\AppData\*"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.RemoveDefaultScopeRule^("iehistory://{%SID%}"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	if "%Style%" == "default" ( goto :MakeDefault)
	if "%Style%" == "reset" ( goto :Finish_Ps)
	if "%Style%" == "startmenus" ( goto :AddStartMenus)
	if "%Style%" == "custom" ( goto :SetCustomPaths)
	
	:MakeDefault
	@echo $crawlman.AddUserScopeRule^("file:///C:\Users\*",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.AddUserScopeRule^("file:///C:\ProgramData\Microsoft\Windows\Start Menu\*",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.AddUserScopeRule^("iehistory://{%SID%}",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%	
	goto :Reindex
	
	:AddStartMenus
	:: Add start menu locations
	@echo $crawlman.AddUserScopeRule^("file:///%ProgramData%\Microsoft\Windows\Start Menu\Programs\*",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	@echo $crawlman.AddUserScopeRule^("file:///%AppData%\Microsoft\Windows\Start Menu\Programs\*",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	goto :Finish_Ps
	
	:SetCustomPaths
	:: Add custom path
	@echo $crawlman.AddUserScopeRule^("file:///%IndexedFolder%\*",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	
	:MorePathsLoop
	:: Loop until there is no more paths to add
	if %Index%==0 ( goto :Finish_Ps)
	set "Index2=!Index2_%Index%!"
	@echo $crawlman.AddUserScopeRule^("file:///%Index2%\*",$true,$false,$null^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	set /a "Index-=1"
	goto :MorePathsLoop
	
	:Finish_Ps
	:: Remove automatically added favorites
	@echo $crawlman.RemoveDefaultScopeRule^("file:///%UserProfile%\Favorites\*"^)>>%scriptname%
	@echo $crawlman.SaveAll^(^)>>%scriptname%
	:Reindex
	@echo $Catalog.Reindex^(^)>>%scriptname%
	:: Delete lock file
	@echo Remove-Item "%lock%">>%scriptname%

:: Execute Task
	:: Create lock file
	@echo Locked>"%lock%"
	:: Launch script
	PowerShell -NoProfile -ExecutionPolicy Bypass -c "& {Start-Process Powershell -ArgumentList '-ExecutionPolicy Unrestricted -File "%scriptname%" -force' -Verb RunAs -WindowStyle hidden}" >NUL 2>&1
	:: loop until lock file is deleted	
	:Wait
	if exist "%lock%" goto :Wait

:Clean
	if "%Clean%" == "ON" ( cls & echo [?25lNo indexing location has been set.) else ( echo [?25l[92mDone.)
:: loop to ensure that temp files and folders are not anymore in use and can be deleted.
	:CleanCheck1	
	if not exist "%scriptname%" ( goto :CleanCheck2) else (
		del "%scriptname%" /f /s /q >NUL 2>&1
		goto :CleanCheck1
	)
	:CleanCheck2
	if not exist "%tmpfolder%" ( goto :End_Pause) else ( 
		rmdir "%tmpfolder%" /s /q >NUL 2>&1
		goto :CleanCheck2
	)
	:End_Pause
	timeout /t 2 /nobreak >NUL 2>&1
goto :eof


@end


var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, WScript.Arguments(0), 0x00000050,17);
WScript.Stdout.WriteLine(folder ? folder.self.path : "");