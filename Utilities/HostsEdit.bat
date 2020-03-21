@echo off
NSudoLC.exe -U:T -P:E "notepad.exe" "C:\\Windows\\System32\\Drivers\\etc\\hosts" >NUL 2>&1
exit /b
