@echo off

%windir%\system32\whoami.exe /USER | find /i "S-1-5-18" 1>nul && (
goto :OK
) || (
NSudoG -U:T -P:E -ShowWindowMode:Hide "%~dpnx0"&exit /b >NUL 2>&1
)

:OK
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -ot reg -actn setprot -op "dacl:np" -actn clear -clr "dacl" -actn rstchldrn -rst "dacl" >NUL 2>&1
netsh advfirewall set  currentprofile state off >NUL 2>&1
exit