<# : Shortcut Creator
:: Code Snippet by Thomas Dubreuil
:: https://github.com/Thdub
@echo off
setlocal
set "PScommand=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass"

:Select_Destination
<nul set /p "DummyName=Choose destination file : "
set "Selector=1"
set "Start_Folder=1"
set "Initial_Dir=::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
set "Selector_Title=Select your file"
for /f "delims=" %%a in ('%PScommand% -c "iex (${%~f0} | out-string)"') do ( set "Destination=%%a" )
if "%Destination%"=="" ( cls & exit /b )
for /f "delims=" %%a in ("%Destination%") do ( echo %%a& set "Work_Dir=%%~dpa" & set "Shorcut_Name=%%~na" & set "Icon_Location=%%~dpnxa" & set "Destination_Extension=%%~xa")
set "Work_Dir=%Work_Dir:~0,-1%"
set /p "Description=Enter a description (optional): "
<nul set /p DummyName=Is it a Start Menu shorcut? [Y/N]
choice /C:YN >nul 2>&1
if errorlevel 2 ( echo No& set "Start_Folder=1" & goto :Select_Shortcut_Folder )
if errorlevel 1 ( echo Yes& set "Start_Folder=2" & goto :Select_Shortcut_Folder )

:Select_Shortcut_Folder
<nul set /p "DummyName=Choose where to create shortcut : "
set "Selector=2"
set "Selector_Title=Browse for location, or enter a folder path in the message box below, then click Select Folder."
for /f "delims=" %%a in ('%PScommand% -c "iex (${%~f0} | out-string)"') do ( set "Shortcut_Folder=%%a" )
echo %Shortcut_Folder%
if "%Shortcut_Folder%"=="" ( goto :Select_Shortcut_Folder )
set "admin=not available for this type of file"
if /i "%Destination_Extension%"==".exe" ( goto :Admin_Question )
if /i "%Destination_Extension%"==".bat" ( goto :Admin_Question )
if /i "%Destination_Extension%"==".ps1" ( goto :Admin_Question )
goto :Create_Shortcut

:Admin_Question
<nul set /p DummyName=Create administrator shorcut? [Y/N]
choice /C:YN >nul 2>&1
if errorlevel 2 ( echo No& set "admin=No" & goto :Create_Shortcut )
if errorlevel 1 ( echo Yes& set "admin=Yes" & goto :Create_Shortcut )

:Create_Shortcut
echo:
echo Destination file : %destination%
echo Shorcut Location : %Shortcut_Folder%
echo Shorcut name     : %Shorcut_Name%.lnk
echo Shortcut Path    : %Shortcut_Folder%\%Shorcut_Name%.lnk
echo Start in         : %Work_Dir%
echo Comment          : %Description%
echo Icon Location    : %Icon_Location%
echo Administrator    : %admin%
echo:
<nul set /p dummyName=Press any key to proceed...%show_cursor%
pause >nul 2>&1
if "%admin%"=="No" ( %PScommand% -c "$s=(New-Object -comObject WScript.Shell).CreateShortcut('%Shortcut_Folder%\%Shorcut_Name%.lnk');$s.TargetPath = '%Destination%';$s.WorkingDirectory='%Work_Dir%';$s.Description='%Description%';$s.IconLocation = '%Icon_Location%';$s.Save()" )
if "%admin%"=="Yes" ( %PScommand% -c "$s=(New-Object -comObject WScript.Shell).CreateShortcut('%Shortcut_Folder%\%Shorcut_Name%.lnk');$s.TargetPath = '%Destination%';$s.WorkingDirectory='%Work_Dir%';$s.Description='%Description%';$s.IconLocation = '%Icon_Location%';$s.Save();$Destination = '%Shortcut_Folder%\%Shorcut_Name%.lnk';$bytes = [System.IO.File]::ReadAllBytes($Destination);$bytes[0x15] = $bytes[0x15] -bor 0x20;[System.IO.File]::WriteAllBytes($Destination, $bytes)" )
echo Done.
<nul set /p dummyName=Press any key to exit...%show_cursor%
pause >nul 2>&1
exit /b

: end Batch portion / begin PowerShell hybrid chimera #>
Function BuildDialog {
    $sourcecode = @"
using System;
using System.Windows.Forms;
using System.Reflection;
namespace FolderSelect
{
    public class FolderSelectDialog
    {
        System.Windows.Forms.OpenFileDialog ofd = null;
        public FolderSelectDialog()
        {
            ofd = new System.Windows.Forms.OpenFileDialog();
            ofd.Filter = "Folders|\n";
            ofd.AddExtension = true;
            ofd.CheckFileExists = false;
            ofd.DereferenceLinks = true;
            ofd.Multiselect = false;
        }
        public string InitialDirectory
        {
            get { return ofd.InitialDirectory; }
            set { ofd.InitialDirectory = value == null || value.Length == 0 ? Environment.CurrentDirectory : value; }
        }
        public string Title
        {
            get { return ofd.Title; }
            set { ofd.Title = value == null ? "Select a folder" : value; }
        }
        public string FileName
        {
            get { return ofd.FileName; }
        }
        public bool ShowDialog()
        {
            return ShowDialog(IntPtr.Zero);
        }
        public bool ShowDialog(IntPtr hWndOwner)
        {
            bool flag = false;
            if (Environment.OSVersion.Version.Major >= 6)
            {
                var r = new Reflector("System.Windows.Forms");
                uint num = 0;
                Type typeIFileDialog = r.GetType("FileDialogNative.IFileDialog");
                object dialog = r.Call(ofd, "CreateVistaDialog");
                r.Call(ofd, "OnBeforeVistaDialog", dialog);
                uint options = (uint)r.CallAs(typeof(System.Windows.Forms.FileDialog), ofd, "GetOptions");
                options |= (uint)r.GetEnum("FileDialogNative.FOS", "FOS_PICKFOLDERS");
                r.CallAs(typeIFileDialog, dialog, "SetOptions", options);
                object pfde = r.New("FileDialog.VistaDialogEvents", ofd);
                object[] parameters = new object[] { pfde, num };
                r.CallAs2(typeIFileDialog, dialog, "Advise", parameters);
                num = (uint)parameters[1];
                try
                {
                    int num2 = (int)r.CallAs(typeIFileDialog, dialog, "Show", hWndOwner);
                    flag = 0 == num2;
                }
                finally
                {
                    r.CallAs(typeIFileDialog, dialog, "Unadvise", num);
                    GC.KeepAlive(pfde);
                }
            }
            else
            {
                var fbd = new FolderBrowserDialog();
                fbd.Description = this.Title;
                fbd.SelectedPath = this.InitialDirectory;
                fbd.ShowNewFolderButton = true;
                if (fbd.ShowDialog(new WindowWrapper(hWndOwner)) != DialogResult.OK) return false;
                ofd.FileName = fbd.SelectedPath;
                flag = true;
            }
            return flag;
        }
    }
    public class WindowWrapper : System.Windows.Forms.IWin32Window
    {
        public WindowWrapper(IntPtr handle)
        {
            _hwnd = handle;
        }
        public IntPtr Handle
        {
            get { return _hwnd; }
        }

        private IntPtr _hwnd;
    }
    public class Reflector
    {
        string m_ns;
        Assembly m_asmb;
        public Reflector(string ns)
            : this(ns, ns)
        { }
        public Reflector(string an, string ns)
        {
            m_ns = ns;
            m_asmb = null;
            foreach (AssemblyName aN in Assembly.GetExecutingAssembly().GetReferencedAssemblies())
            {
                if (aN.FullName.StartsWith(an))
                {
                    m_asmb = Assembly.Load(aN);
                    break;
                }
            }
        }
        public Type GetType(string typeName)
        {
            Type type = null;
            string[] names = typeName.Split('.');
            if (names.Length > 0)
                type = m_asmb.GetType(m_ns + "." + names[0]);

            for (int i = 1; i < names.Length; ++i) {
                type = type.GetNestedType(names[i], BindingFlags.NonPublic);
            }
            return type;
        }
        public object New(string name, params object[] parameters)
        {
            Type type = GetType(name);
            ConstructorInfo[] ctorInfos = type.GetConstructors();
            foreach (ConstructorInfo ci in ctorInfos) {
                try {
                    return ci.Invoke(parameters);
                } catch { }
            }
            return null;
        }
        public object Call(object obj, string func, params object[] parameters)
        {
            return Call2(obj, func, parameters);
        }
        public object Call2(object obj, string func, object[] parameters)
        {
            return CallAs2(obj.GetType(), obj, func, parameters);
        }
        public object CallAs(Type type, object obj, string func, params object[] parameters)
        {
            return CallAs2(type, obj, func, parameters);
        }
        public object CallAs2(Type type, object obj, string func, object[] parameters) {
            MethodInfo methInfo = type.GetMethod(func, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
            return methInfo.Invoke(obj, parameters);
        }
        public object Get(object obj, string prop)
        {
            return GetAs(obj.GetType(), obj, prop);
        }
        public object GetAs(Type type, object obj, string prop) {
            PropertyInfo propInfo = type.GetProperty(prop, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
            return propInfo.GetValue(obj, null);
        }
        public object GetEnum(string typeName, string name) {
            Type type = GetType(typeName);
            FieldInfo fieldInfo = type.GetField(name);
            return fieldInfo.GetValue(null);
        }
    }
}
"@
    $assemblies = ('System.Windows.Forms', 'System.Reflection')
    Add-Type -TypeDefinition $sourceCode -ReferencedAssemblies $assemblies -ErrorAction STOP
}

if ($env:Selector -eq "1") {
	Add-Type -AssemblyName System.Windows.Forms
	$f = new-object Windows.Forms.OpenFileDialog
	$f.InitialDirectory = "C:\Users\$env:username\Desktop"
	$f.Filter = "All Files (*.*)|*.*";
	$f.Title = "$env:Selector_Title";
	$f.ShowHelp = $true
	$f.Multiselect = $false
	$f.ShowDialog() | Out-Null
	$f.FileName
}
if ($env:Selector -eq "2") {
	cd c: #THIS IS THE CRITICAL LINE
	BuildDialog
	$fsd = New-Object FolderSelect.FolderSelectDialog
	$fsd.Title = "$env:Selector_Title"
	If ($env:Start_Folder -eq "1") {$fsd.InitialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"}
	If ($env:Start_Folder -eq "2") {$fsd.InitialDirectory = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"}
	$fsd.ShowDialog() | Out-Null
	$fsd.FileName
}
