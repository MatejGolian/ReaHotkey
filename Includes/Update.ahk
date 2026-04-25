#Requires AutoHotkey v2.0

#NoTrayIcon
#SingleInstance Ignore
#Warn All
DetectHiddenWindows True

#Include ../Lib/FileDownload.ahk

CloseUpdater(UpdaterPID) {
    If ProcessExist(UpdaterPID) {
        ProcessClose UpdaterPID
        ProcessWaitClose UpdaterPID, 3
    }
}

GetArg(Name) {
    For Arg In A_Args
    If Arg = Name
    If A_Args.Length >= A_Index + 1
    Return A_Args[A_Index + 1]
    Return ""
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
        If ConfirmationDialog == "Yes" {
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
    RunCMD := A_AhkPath . " /restart " . A_ScriptFullPath . " " . ExtraArgs
    Else
    RunCMD := A_ScriptFullPath . " /restart /script *UPDATE " . ExtraArgs
    Return Trim(RunCMD)
}

ModeSwitch := ""

If A_Args.Length > 0
ModeSwitch := A_Args[1]

CurrentPID := WinGetPID("ahk_id " . A_ScriptHWND)
ParentPID := GetArg("ParentPID")
UpdaterPID := GetArg("UpdaterPID")

If ModeSwitch = "Download" {
    
    If A_Args.Length < 3 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    URL := A_Args[2]
    DestinationFile := A_Args[3]
    
    UpdateDownload := FileDownload(URL, DestinationFile, "ReaHotkey Update")
    
    RunOnCompletion := PrepareRunCMD("Extract " . DestinationFile . " ParentPID " . CurrentPID)
    RunOnCancel := PrepareRunCMD("Cleanup ParentPID " . CurrentPID)
    
    UpdateDownload.Start(RunOnCompletion, RunOnCancel)
    
    ReaHotkeyAhkDir := Substr(A_ScriptDir, 1, -9)
    
    If Not UpdateDownload.Complete {
        MsgBox "Download failed.", "ReaHotkey Update"
        ExitApp
    }
    
}
Else If ModeSwitch = "Extract" {
    
    If A_Args.Length < 2 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    FileToExtract := A_Args[2]
    
    StatusDialog := ShowStatusDialog("Extracting files...")
    DirCopy FileToExtract, A_Temp . "\ReaHotkey", 1
    StatusDialog.Destroy()
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
    Run ExeToRun . " /script *UPDATE `"" . A_ScriptDir . "`" ParentPID " . CurrentPID
    ExitApp
    
}
Else If ModeSwitch = "Cleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    ExitApp
    
}
Else {
    
    If A_Args.Length < 2 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    Destination := A_Args[2]
    
    If SubStr(Destination, -1) = "/" Or SubStr(Destination, -1) = "\"
    Destination := SubStr(Destination, 1, -1)
    
    If Not Destination {
        MsgBox "Error: No directory specified.", "ReaHotkey Update"
        ExitApp
    }
    Else If Not FileExist(Destination) Or Not InStr(FileExist(Destination), "D") {
        MsgBox "Error: `"" . Destination . "`" is not a valid directory.", "ReaHotkey Update"
        ExitApp
    }
    Else If Destination = A_ScriptDir {
        MsgBox "Error: The destination directory can not be the same as the source directory.", "ReaHotkey Update"
        ExitApp
    }
    
    CloseUpdater(UpdaterPID)
    
    StatusDialog := ShowStatusDialog("Updating files...")
    DirCopy A_ScriptDir, Destination, 1
    StatusDialog.Destroy()
    
    MsgBox "Update complete.", "ReaHotkey Update"
    
    If A_PtrSize * 8 = 64
    ExeToRun := Destination . "\ReaHotkey_x64.exe"
    Else
    ExeToRun := Destination . "\ReaHotkey_x86.exe"
    
    Run ExeToRun
    ExitApp
    
}
