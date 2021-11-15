@echo off
setlocal DisableDelayedExpansion
C:\Windows\System32\reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || goto :No_Admin
title "Set Selective Suspend"
set "windir=C:\Windows" & set "ProgramFiles=C:\Program Files"
set "PScommand=%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass"
set "colors=blue=[94m,green=[92m,red=[31m,yellow=[93m,white=[97m
set "%colors:,=" & set "%"
set "hide_cursor=[?25l"
set "show_cursor=[?25h"
set "yes=[?25l[92mYes[97m"
set "no=[?25l[31mNo[97m"
set "done=[?25l[92mDone.[97m"

echo 1. %hide_cursor%%white%Disable selective suspend& echo:
echo 2. Restore selective suspend& echo:
<nul set /p DummyName=Select your option, or 0 to exit: %show_cursor%
choice /c 120 >nul 2>&1
if errorlevel 3 ( echo %hide_cursor%0& cls & exit /b )
if errorlevel 2 ( echo %hide_cursor%2& cls & call :Selective_Suspend_Restore )
if errorlevel 1 ( echo %hide_cursor%1& cls & call :Selective_Suspend )
<nul set /p DummyName=%white%
goto :Exiting

:Selective_Suspend
echo %hide_cursor%Disabling selective suspend on devices :

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "DeviceSelectiveSuspended" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "DeviceSelectiveSuspended" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x0" ( reg add "!RegistryKey!" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "1" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "EnableSelectiveSuspend" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "EnableSelectiveSuspend" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x1" ( reg add "!RegistryKey!" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "IdleInWorkingState" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "IdleInWorkingState" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x1" ( reg add "!RegistryKey!" /v "IdleInWorkingState" /t REG_DWORD /d "0" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendOn" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "SelectiveSuspendOn" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x1" ( reg add "!RegistryKey!" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendEnabled" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "SelectiveSuspendEnabled" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x1" ( reg add "!RegistryKey!" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM" /s /v "SelectiveSuspendEnabled" /t REG_BINARY 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "SelectiveSuspendEnabled" /t REG_BINARY 2^>nul') do (
			if "%%b"=="01" ( reg add "!RegistryKey!" /v "SelectiveSuspendEnabled" /t REG_BINARY /d "00" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

<nul set /p DummyName=%white%[2C-Bluetooth Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$BTDevice=Get-PnpDevice -Class Bluetooth -InstanceId USB*;$BTDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class Bluetooth -InstanceId USB* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Hid devices Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$HIDDevice=Get-PnpDevice -Class HIDClass -InstanceId USB*;$HIDDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class HIDClass -InstanceId USB* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Intel^(R^) Management Engine Interface Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$PCIDevice=Get-PnpDevice -Class SYSTEM -InstanceId *DEV_A360*;$PCIDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class SYSTEM -InstanceId *DEV_A360* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Mass Storage device^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$USBDevice1=Get-PnpDevice -FriendlyName *Mass*Storage* -Class USB;$USBDevice1 | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -FriendlyName *Mass*Storage* -Class USB | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Network adapter^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$NetDevice=Get-PnpDevice -Class Net -InstanceId PCI*;$NetDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class Net -InstanceId PCI* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-USB Host Controller^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$USBDevice2=Get-PnpDevice -FriendlyName *Host*Controller* -Class USB;$USBDevice2 | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -FriendlyName *Host*Controller* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-USB Hub^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$false;$USBDevice3=Get-PnpDevice -FriendlyName *USB*Hub* -Class USB;$HubDevice3 | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -FriendlyName *Hub* -Class USB | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
goto :eof

:Selective_Suspend_Restore
echo %hide_cursor%Restoring selective suspend on devices :
setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM" /s /v "DeviceSelectiveSuspended" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "DeviceSelectiveSuspended" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x0" ( reg add "!RegistryKey!" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "1" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "EnableSelectiveSuspend" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "EnableSelectiveSuspend" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x0" ( reg add "!RegistryKey!" /v "EnableSelectiveSuspend" /t REG_DWORD /d "1" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "IdleInWorkingState" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "IdleInWorkingState" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x0" ( reg add "!RegistryKey!" /v "IdleInWorkingState" /t REG_DWORD /d "1" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendOn" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "SelectiveSuspendOn" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x0" ( reg add "!RegistryKey!" /v "SelectiveSuspendOn" /t REG_DWORD /d "1" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /v "SelectiveSuspendEnabled" /t REG_DWORD 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "SelectiveSuspendEnabled" /t REG_DWORD 2^>nul') do (
			if "%%b"=="0x0" ( reg add "!RegistryKey!" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "1" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

setlocal EnableDelayedExpansion
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM" /s /v "SelectiveSuspendEnabled" /t REG_BINARY 2^>nul') do (
	set "RegistryKey=%%i"
	if "!Registrykey:~0,5!"=="HKEY_" (
		for /f "tokens=2*" %%a in ('reg query "!Registrykey!" /s /v "SelectiveSuspendEnabled" /t REG_BINARY 2^>nul') do (
			if "%%b"=="00" ( reg add "!RegistryKey!" /v "SelectiveSuspendEnabled" /t REG_BINARY /d "01" /f >nul 2>&1 )
)))
setlocal DisableDelayedExpansion

<nul set /p DummyName=%white%[2C-Bluetooth Selective Suspend:%show_cursor%
%PScommand% -c "&{$Enable=$true;$BTDevice=Get-PnpDevice -Class Bluetooth -InstanceId USB*;$BTDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class Bluetooth -InstanceId USB* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Hid devices Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$true;$HIDDevice=Get-PnpDevice -Class HIDClass -InstanceId USB*;$HIDDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class HIDClass -InstanceId USB* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Intel^(R^) Management Engine Interface Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$true;$PCIDevice=Get-PnpDevice -Class SYSTEM -InstanceId *DEV_A360*;$PCIDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class SYSTEM -InstanceId *DEV_A360* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Mass Storage device^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$true;$USBDevice1=Get-PnpDevice -FriendlyName *Mass*Storage* -Class USB;$USBDevice1 | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -FriendlyName *Mass*Storage* -Class USB | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-Network adapter^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$true;$NetDevice=Get-PnpDevice -Class Net -InstanceId PCI*;$NetDevice | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -Class Net -InstanceId PCI* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
<nul set /p DummyName=%white%[2C-USB Host Controller^(s^) Selective Suspend...%show_cursor%
%PScommand% -c "&{$Enable=$true;$USBDevice2=Get-PnpDevice -FriendlyName *Host*Controller* -Class USB;$USBDevice2 | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -FriendlyName *Host*Controller* | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
<nul set /p DummyName=%white%[2C-USB Hub^(s^) Selective Suspend...%show_cursor%
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
%PScommand% -c "&{$Enable=$true;$USBDevice3=Get-PnpDevice -FriendlyName *USB*Hub* -Class USB;$HubDevice3 | ForEach-Object -Process {$WQL='SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;Set-CimInstance -Namespace root\wmi -Query $WQL -Property @{Enable = $Enable} -PassThru};Get-PnpDevice -FriendlyName *Hub* -Class USB | ForEach-Object -Process {$Test='InstanceName LIKE ' + [char]34 + [char]37 + $([Regex]::Escape($_.PNPDeviceID)) + [char]37 + [char]34;If ((Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -Filter $Test).Enable -eq $Enable) {Exit 0} else {Exit 1}}}" >nul 2>&1
if "%errorlevel%"=="1" echo %hide_cursor%%done% %yellow%Missing settings were not applied.%white%
if "%errorlevel%"=="0" echo %hide_cursor%%green%Success
echo %white%]0;%Shell_Title% %Mode_Title%%white%[1A
goto :eof

:No_Admin
echo %white%You must run this script as administrator.
goto :Exiting

:Exiting
<nul set /p DummyName=Press any key to exit...%show_cursor%
pause >nul
exit /b