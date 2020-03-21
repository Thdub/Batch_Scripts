@echo off

C:\Windows\system32\whoami.exe /USER | find /i "S-1-5-18" 1>nul && ( goto :OK ) || ( NSudoLC -U:T -P:E -Wait -UseCurrentConsole "%~dpnx0" && exit /b )
:OK
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -ot reg -actn setprot -op "dacl:np" -actn clear -clr "dacl" -actn rstchldrn -rst "dacl" >nul 2>&1
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" -ot reg -actn setprot -op "dacl:np" -actn clear -clr "dacl" -actn rstchldrn -rst "dacl" >nul 2>&1
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -ot reg -actn setprot -op "dacl:np" -actn clear -clr "dacl" -actn rstchldrn -rst "dacl" >nul 2>&1
netsh advfirewall set allprofiles state on >nul 2>&1
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -ot reg -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl" -actn ace -ace "n:SYSTEM;p:full" -ace "n:NT SERVICE\mpssvc;p:read" >nul 2>&1
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" -ot reg -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl" -actn ace -ace "n:SYSTEM;p:full" -ace "n:NT SERVICE\mpssvc;p:read" >nul 2>&1
SetACL -on "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -ot reg -actn setprot -op "dacl:p_nc" -actn clear -clr "dacl" -actn ace -ace "n:SYSTEM;p:full" -ace "n:NT SERVICE\mpssvc;p:read" >nul 2>&1
exit /b
