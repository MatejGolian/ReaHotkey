#Requires AutoHotkey v2.0

#NoTrayIcon
#SingleInstance Ignore
#Warn All
DetectHiddenWindows True

#Include ../Lib/FileDownload.ahk

Extract(SourceFile, DestinationDir) {
    DirCreate DestinationDir
    ShowStatusDialog("Extracting files...")
    DirCopy SourceFile, DestinationDir, 1
}

ShowStatusDialog(Status, DisableCancel := False) {
    DialogGUI := GUI(, "ReaHotkey Update")
    DialogGUI.AddText("Section W550 vStatus", Status)
    DialogGUI.AddButton("Default Section XS vCancelBtn", "Cancel").OnEvent("Click", Cancel)
    If DisableCancel {
        DialogGUI["CancelBtn"].Opt("+Disabled")
    }
    Else {
        DialogGUI.OnEvent("Close", Cancel)
        DialogGUI.OnEvent("Escape", Cancel)
    }
    DialogGUI.Show()
    Return DialogGUI
    Cancel(*) {
        DialogGUI.Opt("+OwnDialogs")
        ConfirmationDialog := MsgBox("Are you sure you want to cancel?", "ReaHotkey Update", 4)
        If ConfirmationDialog == "Yes"
        ExitApp
    }
}

Parameter := ""

If A_Args.Length > 0
Parameter := A_Args[1]

If Parameter = "Download" {
    
    If A_Args.Length >= 3 {
        
        URL := A_Args[2]
        DestinationFile := A_Args[3]
        
        UpdateDownload := FileDownload(URL, DestinationFile, "ReaHotkey Update")
        
        If A_IsCompiled = 0
        RunOnCancel := A_AhkPath . " /restart " . A_ScriptFullPath . " Cleanup"
        Else
        RunOnCancel := A_ScriptFullPath . " /restart /script *UPDATE Cleanup"
        
        UpdateDownload.Start(RunOnCancel)
        
        ParentPID := ""
        
        For Arg In A_Args
        If Arg = "ParentPID"
        If A_Args.Length >= A_Index + 1 {
            ParentPID := A_Args[A_Index + 1]
            Break
        }
        
        ReaHotkeyAhkDir := Substr(A_ScriptDir, 1, -9)
        
        If Not UpdateDownload.Complete {
            MsgBox "Download failed.", "ReaHotkey Update"
            ExitApp
        }
        Else {
            Extract(UpdateDownload.DestinationFile, A_Temp . "\ReaHotkey")
            If A_PtrSize * 8 = 64
            ExeToRun := A_Temp . "\ReaHotkey\ReaHotkey\ReaHotkey_x64.exe"
            Else
            ExeToRun := A_Temp . "\ReaHotkey\ReaHotkey\ReaHotkey_x86.exe"
            If A_IsCompiled = 0 {
                If WinExist(ReaHotkeyAhkDir . "\ReaHotkey.ahk ahk_class AutoHotkey") {
                    WinClose ReaHotkeyAhkDir . "\ReaHotkey.ahk ahk_class AutoHotkey"
                    WinWaitClose ReaHotkeyAhkDir . "\ReaHotkey.ahk ahk_class AutoHotkey", 3
                }
            }
            Else {
                If ParentPID And ProcessExist(ParentPID) {
                    WinKill "ahk_pid " . ParentPID
                    ProcessWaitClose ParentPID, 3
                }
            }
            Run ExeToRun . " /script *UPDATE `"" . A_ScriptDir . "`""
            ExitApp
        }
        
    }
    
    ExitApp
    
}
Else If Parameter = "Cleanup" {
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        DirDelete A_Temp . "\ReaHotkey", True
        StatusDialog.Destroy()
    }
    
    ExitApp
    
}
Else {
    
    If SubStr(Parameter, -1) = "/" Or SubStr(Parameter, -1) = "\"
    Parameter := SubStr(Parameter, 1, -1)
    
    If Not Parameter {
        MsgBox "Error: No directory specified.", "ReaHotkey Update"
        ExitApp
    }
    Else If Not FileExist(Parameter) Or Not InStr(FileExist(Parameter), "D") {
        MsgBox "Error: `"" . Parameter . "`" is not a valid directory.", "ReaHotkey Update"
        ExitApp
    }
    Else If Parameter = A_ScriptDir {
        MsgBox "Error: The destination directory can not be the same as the source directory.", "ReaHotkey Update"
        ExitApp
    }
    
    StatusDialog := ShowStatusDialog("Updating files...")
    DirCopy A_ScriptDir, Parameter, 1
    StatusDialog.Destroy()
    MsgBox "Update complete.", "ReaHotkey Update"
    
    If A_PtrSize * 8 = 64
    ExeToRun := Parameter . "\ReaHotkey_x64.exe"
    Else
    ExeToRun := Parameter . "\ReaHotkey_x86.exe"
    
    Run ExeToRun
    ExitApp
    
}
