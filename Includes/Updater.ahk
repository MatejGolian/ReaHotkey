#Requires AutoHotkey v2.0

#NoTrayIcon
#SingleInstance Force
#Warn All
DetectHiddenWindows True
SetTitleMatchMode 2

#Include ../Lib/FileDownload.ahk

CloseUpdater(TargetPID) {
    If Not TargetPID = WinGetPID("ahk_id " . A_ScriptHWND)
    If ProcessExist(TargetPID) {
        ProcessClose TargetPID
        ProcessWaitClose TargetPID, 3
    }
}

GetArg(Name) {
    TaskList := ["Download", "DownloadFailed", "DownloadCleanup", "Extract", "ExtractionCleanup", "UpdateFiles", "UpdateCleanup", "UpdateComplete"]
    For ArgIndex, Arg In A_Args
    If Arg = Name
    If A_Args.Length >= ArgIndex + 1 {
        For Task In TaskList
        If Task = A_Args[ArgIndex + 1]
        Return ""
        Return A_Args[ArgIndex + 1]
    }
    Return ""
}

GetParentPID() {
    PrevTitleSetting := A_TitleMatchMode
    SetTitleMatchMode 3
    If A_IsCompiled = 0
    ParentID := WinExist(GetReaHotkeyAhkDir() . "ReaHotkey.ahk - AutoHotkey v" . A_AhkVersion)
    Else
    ParentID := WinExist(A_ScriptFullPath)
    SetTitleMatchMode PrevTitleSetting
    If ParentID
    Return WinGetPID("ahk_id " . ParentID)
    Return 0
}

GetReaHotkeyAhkDir() {
    If A_IsCompiled = 0
    Return Substr(A_ScriptDir, 1, -9)
    Return A_ScriptDir
}

ShowStatusDialog(Status, RunOnCancel := False, DisableCancel := False) {
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
        If ConfirmationDialog == "Yes" {
            If RunOnCancel
            Run RunOnCancel
            ExitApp
        }
    }
}

PerformCleanup(CleanupOption := "All") {
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        If CleanupOption = "All" {
            DirDelete A_Temp . "\ReaHotkey", True
        }
        Else If CleanupOption = "Extracted" {
            If FileExist(A_Temp . "\ReaHotkey\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey\ReaHotkey"), "D")
            DirDelete A_Temp . "\ReaHotkey\ReaHotkey", True
        }
    }
}

PrepareRunCMD(ExtraArgs := "") {
    ExtraArgs := Trim(ExtraArgs)
    If A_IsCompiled = 0
    PreparedCMD := A_AhkPath . " /restart " . A_ScriptFullPath . " " . ExtraArgs
    Else
    PreparedCMD := A_ScriptFullPath . " /restart /script *UPDATE " . ExtraArgs
    Return Trim(PreparedCMD)
}

TaskSwitch := ""

If A_Args.Length > 0
TaskSwitch := A_Args[1]

CurrentPID := WinGetPID("ahk_id " . A_ScriptHWND)
ParentPID := GetParentPID()
UpdaterPID := GetArg("UpdaterPID")

If TaskSwitch = "Download" {
    
    If A_Args.Length < 3 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    URL := A_Args[2]
    DestinationFile := A_Args[3]
    UpdateDownload := FileDownload(URL, DestinationFile, "ReaHotkey Update")
    
    UpdateDownload.Start(PrepareRunCMD("Extract `"" . DestinationFile . "`" UpdaterPID " . CurrentPID), PrepareRunCMD("DownloadCleanup UpdaterPID " . CurrentPID))
    
    If Not UpdateDownload.Complete {
        CMDToRun := PrepareRunCMD("DownloadFailed UpdaterPID " . CurrentPID)
        Run CMDToRun
        ExitApp
    }
    
}
Else If TaskSwitch = "DownloadFailed" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    MsgBox "Download failed.", "ReaHotkey Update"
    
    ExitApp
    
}
Else If TaskSwitch = "DownloadCleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    ExitApp
    
}
Else If TaskSwitch = "Extract" {
    
    If A_Args.Length < 2 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    CloseUpdater(UpdaterPID)
    
    FileToExtract := A_Args[2]
    
    StatusDialog := ShowStatusDialog("Extracting files...", PrepareRunCMD("ExtractionCleanup UpdaterPID " . CurrentPID))
    DirCopy FileToExtract, A_Temp . "\ReaHotkey", 1
    StatusDialog.Destroy()
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_Temp . "\ReaHotkey\ReaHotkey\ReaHotkey_x64.exe"
    Else
    ExeToRun := A_Temp . "\ReaHotkey\ReaHotkey\ReaHotkey_x86.exe"
    
    If A_IsCompiled = 0 {
        If WinExist(GetReaHotkeyAhkDir() . "\ReaHotkey.ahk ahk_class AutoHotkey") {
            WinClose GetReaHotkeyAhkDir() . "\ReaHotkey.ahk ahk_class AutoHotkey"
            WinWaitClose GetReaHotkeyAhkDir() . "\ReaHotkey.ahk ahk_class AutoHotkey", 3
        }
    }
    Else {
        If ParentPID And ProcessExist(ParentPID) {
            WinKill "ahk_pid " . ParentPID
            ProcessWaitClose ParentPID, 3
        }
    }
    
    Run ExeToRun . " /script *UPDATE `"" . A_ScriptDir . "`" UpdaterPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "ExtractionCleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("Extracted")
        StatusDialog.Destroy()
    }
    
    ExitApp
    
}
Else If TaskSwitch = "UpdateFiles" {
    
    If A_Args.Length < 2 {
        ExitApp
    }
    
    CloseUpdater(UpdaterPID)
    
    Destination := A_Args[2]
    If SubStr(Destination, -1) = "/" Or SubStr(Destination, -1) = "\"
    Destination := SubStr(Destination, 1, -1)
    
    If Not Destination {
        MsgBox "No directory specified.", "Error"
        ExitApp
    }
    Else If Not FileExist(Destination) Or Not InStr(FileExist(Destination), "D") {
        MsgBox "`"" . Destination . "`" is not a valid directory.", "Error"
        ExitApp
    }
    Else If Destination = A_ScriptDir {
        MsgBox "The destination directory can not be the same as the source directory.", "Error"
        ExitApp
    }
    
    StatusDialog := ShowStatusDialog("Updating files...")
    DirCopy A_ScriptDir, Destination, 1
    StatusDialog.Destroy()
    
    If A_PtrSize * 8 = 64
    ExeToRun := Destination . "\ReaHotkey_x64.exe"
    Else
    ExeToRun := Destination . "\ReaHotkey_x86.exe"
    
    Run ExeToRun . " /script *UPDATE UpdateCleanup UpdaterPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "UpdateCleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_ScriptDir . "\ReaHotkey_x64.exe"
    Else
    ExeToRun := A_ScriptDir . "\ReaHotkey_x86.exe"
    
    Run ExeToRun . " /script *UPDATE UpdateComplete UpdaterPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "UpdateComplete" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    MsgBox "Update complete.", "ReaHotkey Update"
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_ScriptDir . "\ReaHotkey_x64.exe"
    Else
    ExeToRun := A_ScriptDir . "\ReaHotkey_x86.exe"
    
    Run ExeToRun
    ExitApp
    
}
Else {
    
    CMDArgs := ""
    For CMDArg In A_Args
    CMDArgs .= CMDArg . " "
    
    CMDToRun := PrepareRunCMD("UpdateFiles " . CMDArgs)
    Run CMDToRun
    ExitApp
    
}
