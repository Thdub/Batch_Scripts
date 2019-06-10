@echo off
%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || goto :NOADMIN

echo Processing telemetry blocking tweaks...
echo   -Registry
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /f /v "IncludeRecommendedUpdates" /t REG_DWORD /d 0 >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v "AllowOSUpgrade" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /v "HaveUploadedForTarget" /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\AIT" /v "AITEnable" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v "DontRetryOnError" /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v "IsCensusDisabled" /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v "TaskEnableRun" /t REG_DWORD /d 1 /f >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags" /v "UpgradeEligible" /f >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /f >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v "CEIPEnable" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v "SqmLoggerRunning" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v "CEIPEnable" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v "SqmLoggerRunning" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "DisableOptinExperience" /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "SqmLoggerRunning" /t REG_DWORD /d 0 /f >NUL 2>&1
	sc.exe config DiagTrack start= disabled >NUL 2>&1
	sc.exe stop DiagTrack >NUL 2>&1
	reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f >NUL 2>&1
	reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\Diagtrack-Listener" /f >NUL 2>&1
	reg delete "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\SQMLogger" /f >NUL 2>&1
	reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >NUL 2>&1
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DiagTrackAuthorization" /t REG_DWORD /d 0 /f >NUL 2>&1
	takeown /f %ProgramData%\Microsoft\Diagnosis /A /r /d y >NUL 2>&1
	icacls %ProgramData%\Microsoft\Diagnosis /grant:r *S-1-5-32-544:F /T /C >NUL 2>&1
	del /f /q %ProgramData%\Microsoft\Diagnosis\*.rbs >NUL 2>&1
	del /f /s /q %ProgramData%\Microsoft\Diagnosis\ETLLogs\* >NUL 2>&1
echo   -Tasks 
	schtasks /query /TN "CreateExplorerShellUnelevatedTask" 2>NUL && schtasks /Delete /F /TN "CreateExplorerShellUnelevatedTask" >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyRefresh" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >NUL 2>&1
echo   -Office Tasks
	schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\Office Automatic Updates" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\Office Automatic Updates 2.0" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\Office ClickToRun Service Monitor" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\Office Feature Updates" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\Office Feature Updates Logon" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetry\AgentLogOn2016" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetry\OfficeTelemetryAgentLogOn2016" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetry\AgentFallBack2016" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable >NUL 2>&1
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn2016" /Disable >NUL 2>&1
	schtasks /Delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >NUL 2>&1
	schtasks /Delete /F /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" >NUL 2>&1
	schtasks /Delete /F /TN "\Microsoft\Windows\Application Experience\AitAgent" >NUL 2>&1
	schtasks /Delete /F /TN "\Microsoft\Windows\PerfTrack\BackgroundConfigSurveyor" >NUL 2>&1
echo   -Office Registry
	reg add HKCU\Software\Microsoft\Office\Common\ClientTelemetry /v DisableTelemetry /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common /v sendcustomerdata /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common\Feedback /v enabled /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common\Feedback /v includescreenshot /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Outlook\Options\Mail /v EnableLogging /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Word\Options /v EnableLogging /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common /v qmenable /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common /v updatereliabilitydata /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common\General /v shownfirstrunoptin /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common\General /v skydrivesigninoption /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Common\ptwatson /v ptwoptin /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\Firstrun /v disablemovie /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM /v Enablelogging /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM /v EnableUpload /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM /v EnableFileObfuscation /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v accesssolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v olksolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v onenotesolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v pptsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v projectsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v publishersolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v visiosolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v wdsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedapplications /v xlsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v agave /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v appaddins /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v comaddins /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v documentfiles /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKCU\Software\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v templatefiles /t REG_DWORD /d 1 /f >NUL 2>&1
echo   -Office Policies
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common /v qmenable /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common /v updatereliabilitydata /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General /v shownfirstrunoptin /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\General /v skydrivesigninoption /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Common\ptwatson /v ptwoptin /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\Firstrun /v disablemovie /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM /v Enablelogging /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM /v EnableUpload /t REG_DWORD /d 0 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM /v EnableFileObfuscation /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v accesssolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v olksolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v onenotesolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v pptsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v projectsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v publishersolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v visiosolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v wdsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedapplications /v xlsolution /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v agave /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v appaddins /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v comaddins /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v documentfiles /t REG_DWORD /d 1 /f >NUL 2>&1
	reg add HKLM\SOFTWARE\Policies\Microsoft\Office\16.0\OSM\preventedsolutiontypes /v templatefiles /t REG_DWORD /d 1 /f >NUL 2>&1
echo Done.
TIMEOUT /T 5 >NUL 2>&1
exit /b

:NOADMIN
	echo You must have administrator rights to run this script.
	<nul set /p dummyName=Press any key to exit...
	pause >nul
	goto :eof
