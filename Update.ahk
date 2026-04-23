#Requires AutoHotkey v2.0

#NoTrayIcon
#SingleInstance Ignore
#Warn All
#Warn LocalSameAsGlobal, Off
DetectHiddenWindows True

#Include <AccessibilityOverlay>
#Include <JXON>
#Include <UIA>
#Include <Update>

Parameter := ""

If A_Args.Length > 0
Parameter := A_Args[1]

If Parameter = "Download" Or Parameter = "Delete" {
    
    UpdateDownload := Update.Download("ReaHotkey Update")
    UpdateDownload.Start(False)
    
    If UpdateDownload.Operation = "Delete" {
        Update.Cleanup()
        ExitApp
    }
    
    MainPID := ""
    
    For Arg In A_Args
    If Arg = "ParentPID"
    If A_Args.Length >= A_Index + 1 {
        MainPID := A_Args[A_Index + 1]
        Break
    }
    
    If Not UpdateDownload.Complete {
        MsgBox "Failed to download update.", "ReaHotkey"
        ExitApp
    }
    Else {
        Update.Extract(UpdateDownload.DestinationFile, A_Temp . "\ReaHotkey")
        If A_PtrSize * 8 = 64
        ExeToRun := A_Temp . "\ReaHotkey\ReaHotkey\ReaHotkey_x64.exe"
        Else
        ExeToRun := A_Temp . "\ReaHotkey\ReaHotkey\ReaHotkey_x86.exe"
        If A_IsCompiled = 0 {
            WinClose A_ScriptDir . "\ReaHotkey.ahk ahk_class AutoHotkey"
        }
        Else {
            If MainPID And ProcessExist(MainPID)
            ProcessClose MainPID
        }
        Run ExeToRun . " /script *UPDATE `"" . A_ScriptDir . "`""
        ExitApp
    }
    
}
Else {
    
    If Not Parameter {
        MsgBox "No directory specified.", "Error"
        ExitApp
    }
    Else If Not FileExist(Parameter) Or Not InStr(FileExist(Parameter), "D") {
        MsgBox "`"" . Parameter . "`" is not a valid directory.", "Error"
        ExitApp
    }
    
    StatusDialog := Update.DisplayStatusDialog("Updating files...")
    DirCopy A_ScriptDir, Parameter, 1
    StatusDialog.Destroy()
    MsgBox "Update complete.`nPress OK to launch the updated script.", "ReaHotkey"
    
    If A_PtrSize * 8 = 64
    ExeToRun := Parameter . "\ReaHotkey_x64.exe"
    Else
    ExeToRun := Parameter . "\ReaHotkey_x86.exe"
    
    Run ExeToRun
    ExitApp
    
}
