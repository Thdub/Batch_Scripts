@echo off

"C:\Program Files\System Tools\System Utilities\NirCmd\nircmdc.exe" clipboard clear
timeout /t 2 /nobreak >NUL 2>&1
"C:\Program Files\System Tools\System Utilities\NirCmd\nircmdc.exe" sendkeypress alt+printscreen
:SaveImage_loop
for /f "tokens=1, 2, 3, 4 delims=-/. " %%a in ("%DATE%") do set "ClipName=%%a-%%b-%%c"
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do set "ClipName=%ClipName%_%%ah%%bm%%cs"
"C:\Program Files\System Tools\System Utilities\NirCmd\nircmdc.exe" clipboard saveimage "%USERPROFILE%\Desktop\%ClipName%.png"
if exist "%USERPROFILE%\Desktop\%ClipName%.png" exit /b
goto :SaveImage_loop