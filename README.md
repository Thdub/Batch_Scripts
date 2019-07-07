# Batch Scripts
# Maintenance
    - ClearEventViewerLogs: Clear event viewer logs.
    - RemovePowershellDuplicateLines : Removes duplicate commands from your Powershell console host history.
    - ResetNotificationAreaIconsCache : Resets notification area cache.

# Privacy
    - Telemetry script 2019

# Utilities
    - Remove_duplicate_and_blank_lines : Remove duplicate lines, blank lines or lines containing only white space from any text-based file.
        Usage : just drag and drop your file on to this script.
        PRESERVES initial line ordering.
        Keeps last duplicated occurence. 
        Note: Unlike UNIQ which only works on sorted files/list, because it can only remove adjacent duplicate lines (+ you have to use SORT in conjunction if your lines are not initially ordered, which means losing initial line ordering), the tool will preserve your line ordering (or disorder): handy for batch or big .reg files...
        Supports files with ASCII, UTF-8 and UNICODE character encoding.
        Credits due to dbenham for his great JRepl.bat utility. 
    
    - RemoveDuplicateLines : Remove duplicate lines from any text-based file, while preserving blank lines.
        Usage : just drag and drop your file on to this script.
        PRESERVES initial line ordering.
        Keeps last duplicated occurence. 
        Note: Unlike UNIQ which only works on sorted files/list, because it can only remove adjacent duplicate lines (+ you have to use SORT in conjunction if your lines are not initially ordered, which means losing initial line ordering), the tool will preserve your line ordering (or disorder): handy for batch or big .reg files...
        Supports files with ASCII, UTF-8 and UNICODE character encoding.
        Credits due to dbenham for his great JRepl.bat utility. 
    
    - Restore_Start_Menu_Icons : Do you sometimes have blank icons in your Start Menu? Or new Icons assets to display in your start screen? Here's a simple script that will update the icon(s) for you.
    
    - WinDefenderToggle : Toggle Windows Defender On or Off
    
    Program launchers
        - RegWorkshopX64_TI : Launches Registry workshop as Trusted Installer (requires NSudo)
        - StartAcronisBackupWithServices : Start Acronis Backup with its required services and disable them again after closing.        
        - StartAcronisTrueImageWithServices : Start Acronis True Image with its required services.        
        - StartServerManagerWithServices : Start Server Manager with its required services.        
        - StartWord : Start Microsoft Word with its (useless) required service and disable right away.
    
    ScreenSnip
        - ScreenSnipActiveWindow : Takes a screenshot of your active/selected window only, like explorer, notepad, or        firefox etc. after 2 seconds delay (which gives you time to open a .txt even), and save it on your desktop with date and time.         
        - ScreenSnipEnhanced : Opens Windows Screen Snip and saves your .png screenshot with date and time directly on your desktop. You don't need anymore to press save as, or copy/paste clipboard to another application, yeah!!        
        - ScreenSnipFullScreen : Takes a full screen screenshot and save it on your desktop with date and time. 
          Note : Needs Nircmd. 
          Replace "C:\Program Files\System Tools\System Utilities\NirCmd\nircmdc.exe" with your own Nircmd path.
    
    Send to Context Menu : Send selected file(s) and/or folder(s) using "Send to" context menu.
        - SendtoFolder : Display a prompt to create/name location and move selected file(s) and/or folder(s) there.        
        - SendtoFolderName : Move selected file(s)/and or folder(s) to a folder named as selection.        
        - SendtoNewFolder : Move selected file(s)/and or folder(s) to New folder and rename New folder incrementally if the folder already exists: New folder (2) New folder (3) etc. (as windows does).       
        - Add_to_Context_Menu : Creates shortcuts to the scripts in "Send to" context menu.
    
    Toggle Firewall : Toggle Windows firewall, while being in whitelist/secure mode (for example when using WFC).
        - ToggleFirewall : On/Off toggle  
        - ToggleFirewallOff : Off toggle       
        - ToggleFirewallOn : On toggle
          Note : Needs NSudo and SetACL
  
  
- Download Nircmd : https://www.nirsoft.net/utils/nircmd-x64.zip
- Donwload NSudo : https://github.com/M2Team/NSudo/releases/download/6.2/NSudo_6.2.1812.31_All_Binary.zip
- Download SetACL : https://helgeklein.com/download/#
