@echo off

echo Enter NirCmd path here:
    set /p "NirCmdFolder="
echo Enter scripts path here:
    set /p "ScriptPath="
echo ADD Send To New Folder Capabilities to explorer Context Menu
    PowerShell -NoProfile -ExecutionPolicy Bypass "$s=(New-Object -COM WScript.Shell).CreateShortcut('%AppData%\Microsoft\Windows\SendTo\New folder (create new folder).lnk');$s.TargetPath='%ScriptPath%\SendtoNewFolder.bat';$s.WorkingDirectory='%AppData%\Microsoft\Windows\SendTo';$s.WindowStyle=7;$s.Description='Move selection to a new folder';$s.IconLocation='%SystemRoot%\System32\SHELL32.dll,4';$s.Save()" >NUL 2>&1
    PowerShell -NoProfile -ExecutionPolicy Bypass "$s=(New-Object -COM WScript.Shell).CreateShortcut('%AppData%\Microsoft\Windows\SendTo\New folder (named as selection).lnk');$s.TargetPath='%ScriptPath%\SendtoFolderName.bat';$s.WorkingDirectory='%AppData%\Microsoft\Windows\SendTo';$s.WindowStyle=7;$s.Description='Move selection to a new folder, named as first item selected.';$s.IconLocation='%SystemRoot%\System32\SHELL32.dll,4';$s.Save()" >NUL 2>&1
    PowerShell -NoProfile -ExecutionPolicy Bypass "$s=(New-Object -COM WScript.Shell).CreateShortcut('%AppData%\Microsoft\Windows\SendTo\New folder (type name).lnk');$s.TargetPath='%ScriptPath%\SendtoFolder.bat';$s.WorkingDirectory='%AppData%\Microsoft\Windows\SendTo';$s.Description='Prompt for a folder name and move selection to that folder';$s.IconLocation='%SystemRoot%\System32\SHELL32.dll,4';$s.Save()" >NUL 2>&1
    reg add "HKCR\CLSID\{7BA4C740-9E81-11CF-99D3-00AA004AE837}" /v "flags" /t REG_DWORD /d "2" /f >NUL 2>&1

exit /b
