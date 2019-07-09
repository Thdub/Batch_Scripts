@echo off

%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>NUL 2>NUL || goto :NOADMIN

:: Disable "allow the computer to turn off this device to save power" for HID Devices under PowerManagement tab in Device Manager
    <nul set /p dummyName=[97mDisabling "Allow the computer to turn off this device to save power" for HID Devices under Power Management tab in Device Manager:
    setlocal EnableExtensions DisableDelayedExpansion
    set "DetectionCount=0"
    for /f "delims=" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendOn" /t REG_DWORD') do call :ProcessLine "%%i"
    if not %DetectionCount% == 0 endlocal & ( goto :SelectiveSuspend_part2)

:ProcessLine
    set "RegistryLine=%~1"
    if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :eof
    reg add "%RegistryKey%" /v "SelectiveSuspendOn" /t REG_DWORD /d 0 /f >NUL 2>&1
    set /A DetectionCount+=1
    goto :eof

:SelectiveSuspend_part2
    setlocal EnableExtensions DisableDelayedExpansion
    set "Detection2_Count=0"
    for /f "delims=" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB" /s /v "EnableSelectiveSuspend" /t REG_DWORD') do call :ProcessLine2 "%%i"
    if not %Detection2_Count% == 0 endlocal & ( goto :SelectiveSuspend_part3)

:ProcessLine2
    set "RegistryLine=%~1"
    if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :eof
    reg add "%RegistryKey%" /v "EnableSelectiveSuspend" /t REG_DWORD /d 0 /f >NUL 2>&1
    set /A Detection2_Count+=1
    goto :eof

:SelectiveSuspend_part3
    setlocal EnableExtensions DisableDelayedExpansion
    set "Detection3_Count=0"
    for /f "delims=" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendEnabled" /t REG_DWORD') do call :ProcessLine3 "%%i"
    if not %Detection3_Count% == 0 endlocal & ( goto :SelectiveSuspend_part4)

:ProcessLine3
    set "RegistryLine=%~1"
    if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :eof
    reg add "%RegistryKey%" /v "SelectiveSuspendEnabled" /t REG_DWORD /d 0 /f >NUL 2>&1
    set /A Detection3_Count+=1
    goto :eof

:SelectiveSuspend_part4
    setlocal EnableExtensions DisableDelayedExpansion
    set "Detection4_Count=0"
    for /f "delims=" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendEnabled" /t REG_BINARY') do call :ProcessLine4 "%%i"
    if not %Detection4_Count% == 0 endlocal & ( goto :SelectiveSuspend_part5)

:ProcessLine4
    set "RegistryLine=%~1"
    if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :eof
    reg add "%RegistryKey%" /v "SelectiveSuspendEnabled" /t REG_BINARY /d "00" /f >NUL 2>&1
    set /A Detection4_Count+=1
    goto :eof

:SelectiveSuspend_part5
    setlocal EnableExtensions DisableDelayedExpansion
    set "Detection5_Count=0"
    for /f "delims=" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB" /s /v "DeviceSelectiveSuspended" /t REG_DWORD') do call :ProcessLine5 "%%i"
    if not %Detection5_Count% == 0 (
		endlocal
		<nul set /p dummyName=[92m Done.[97m
		timeout /t 3 /nobreak >NUL 2>&1
		exit /b
	)

:ProcessLine5
    set "RegistryLine=%~1"
    if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :eof
    reg add "%RegistryKey%" /v "DeviceSelectiveSuspended" /t REG_DWORD /d 0 /f >NUL 2>&1
    set /A Detection5_Count+=1
    goto :eof

::============================================================================================================
:NOADMIN
::============================================================================================================
    echo You must have administrator rights to run this script.
    <nul set /p dummyName=Press any key to exit...
    pause >nul
    goto :eof
