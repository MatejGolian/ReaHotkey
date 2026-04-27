#Requires AutoHotkey v2.0

#NoTrayIcon
#SingleInstance Force
#Warn All
DetectHiddenWindows True
SetTitleMatchMode 2

#Include ../Lib/FileDownload.ahk

AppName := "ReaHotkey"
ExtractionTempDir := "ReaHotkey\ReaHotkey"
MainTempDir := "ReaHotkey"
ParentAhkDir := GetParentAhkDir()
ParentAhkName := "ReaHotkey.ahk"
UpdaterTitle := "ReaHotkey Update"
X64Exe := "ReaHotkey_x64.exe"
X86Exe := "ReaHotkey_x86.exe"

CloseUpdater(TargetPID) {
    If Not TargetPID = WinGetPID("ahk_id " . A_ScriptHWND)
    If ProcessExist(TargetPID) {
        ProcessClose TargetPID
        ProcessWaitClose TargetPID
    }
}

GetArg(Name) {
    TaskList := ["Download", "DownloadFailed", "DownloadCleanup", "Extract", "ExtractionFailed", "ExtractionCleanup", "Update", "UpdateFailed", "UpdateCleanup", "UpdateComplete"]
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

GetParentAhkDir() {
    If A_IsCompiled = 0
    Return Substr(A_ScriptDir, 1, -9)
    Return A_ScriptDir
}

GetParentPID() {
    Global ParentAhkDir, ParentAhkName
    PrevTitleSetting := A_TitleMatchMode
    SetTitleMatchMode 3
    If A_IsCompiled = 0
    ParentID := WinExist(ParentAhkDir . "\" . ParentAhkName . " - AutoHotkey v" . A_AhkVersion)
    Else
    ParentID := WinExist(A_ScriptFullPath)
    SetTitleMatchMode PrevTitleSetting
    If ParentID
    Return WinGetPID("ahk_id " . ParentID)
    Return 0
}

ShowStatusDialog(Status, RunOnCancel := False, DisableCancel := False) {
    Global UpdaterTitle
    DialogGUI := GUI(, UpdaterTitle)
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
        ConfirmationDialog := MsgBox("Are you sure you want to cancel?", UpdaterTitle, 4)
        If ConfirmationDialog == "Yes" {
            If RunOnCancel
            Run RunOnCancel
            ExitApp
        }
    }
}

PerformCleanup(CleanupOption := "All") {
    Global ExtractionTempDir, MainTempDir
    If FileExist(A_Temp . "\" . MainTempDir) And InStr(FileExist(A_Temp . "\" . MainTempDir), "D") {
        If CleanupOption = "All" {
            DirDelete A_Temp . "\" . MainTempDir, True
        }
        Else If CleanupOption = "Extracted" {
            If FileExist(A_Temp . "\" . ExtractionTempDir) And InStr(FileExist(A_Temp . "\" . ExtractionTempDir), "D")
            DirDelete A_Temp . "\" . ExtractionTempDir, True
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
    
    UpdateDownload := FileDownload(URL, DestinationFile, UpdaterTitle)
    
    If UpdateDownload.Available {
        
        UpdateDownload.Start(PrepareRunCMD("Extract `"" . DestinationFile . "`" UpdaterPID " . CurrentPID), PrepareRunCMD("DownloadCleanup UpdaterPID " . CurrentPID), PrepareRunCMD("DownloadFailed UpdaterPID " . CurrentPID))
        
        If Not UpdateDownload.Complete {
            
            Run PrepareRunCMD("DownloadFailed UpdaterPID " . CurrentPID)
            ExitApp
            
        }
        
        ExitApp
        
    }
    Else {
        
        Run PrepareRunCMD("DownloadFailed UpdaterPID " . CurrentPID)
        ExitApp
        
    }
    
}
Else If TaskSwitch = "DownloadFailed" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\" . MainTempDir) And InStr(FileExist(A_Temp . "\" . MainTempDir), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    MsgBox "Download failed.", UpdaterTitle
    
    ExitApp
    
}
Else If TaskSwitch = "DownloadCleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\" . MainTempDir) And InStr(FileExist(A_Temp . "\" . MainTempDir), "D") {
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
    Try {
        DirCopy FileToExtract, A_Temp . "\" . MainTempDir, 1
    }
    Catch {
        StatusDialog.Destroy()
        Run PrepareRunCMD("ExtractionFailed UpdaterPID " . CurrentPID)
        Exit
    }
    StatusDialog.Destroy()
    
    StatusDialog := ShowStatusDialog("Preparing to update files...")
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_Temp . "\" . ExtractionTempDir . "\" . X64Exe
    Else
    ExeToRun := A_Temp . "\" . ExtractionTempDir . "\" . X86Exe
    
    If A_IsCompiled = 0 {
        If WinExist(ParentAhkDir . "\" . ParentAhkName . " ahk_class AutoHotkey") {
            WinKill ParentAhkDir . "\" . ParentAhkName . " ahk_class AutoHotkey"
            WinWaitClose ParentAhkDir . "\" . ParentAhkName . " ahk_class AutoHotkey"
        }
    }
    Else {
        If ParentPID And ProcessExist(ParentPID) {
            WinKill "ahk_pid " . ParentPID
            ProcessWaitClose ParentPID
        }
    }
    
    StatusDialog.Destroy()
    Run ExeToRun . " /script *UPDATE `"" . A_ScriptDir . "`" UpdaterPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "ExtractionFailed" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\" . MainTempDir) And InStr(FileExist(A_Temp . "\" . MainTempDir), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("Extracted")
        StatusDialog.Destroy()
    }
    
    MsgBox "Extraction failed.", UpdaterTitle
    
    ExitApp
    
}
Else If TaskSwitch = "ExtractionCleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\" . MainTempDir) And InStr(FileExist(A_Temp . "\" . MainTempDir), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("Extracted")
        StatusDialog.Destroy()
    }
    
    ExitApp
    
}
Else If TaskSwitch = "Update" {
    
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
    Try {
        DirCopy A_ScriptDir, Destination, 1
    }
    Catch {
        StatusDialog.Destroy()
        Run PrepareRunCMD("UpdateFailed UpdaterPID " . CurrentPID)
        Exit
    }
    StatusDialog.Destroy()
    
    StatusDialog := ShowStatusDialog("Preparing to clean up files...")
    
    If A_PtrSize * 8 = 64
    ExeToRun := Destination . "\" . X64Exe
    Else
    ExeToRun := Destination . "\" . X86Exe
    
    StatusDialog.Destroy()
    Run ExeToRun . " /script *UPDATE UpdateCleanup UpdaterPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "UpdateFailed" {
    
    CloseUpdater(UpdaterPID)
    MsgBox "Update failed.", UpdaterTitle
    
    ExitApp
    
}
Else If TaskSwitch = "UpdateCleanup" {
    
    CloseUpdater(UpdaterPID)
    
    If FileExist(A_Temp . "\" . MainTempDir) And InStr(FileExist(A_Temp . "\" . MainTempDir), "D") {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    StatusDialog := ShowStatusDialog("Preparing to complete update...")
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_ScriptDir . "\" . X64Exe
    Else
    ExeToRun := A_ScriptDir . "\" . X86Exe
    
    StatusDialog.Destroy()
    Run ExeToRun . " /script *UPDATE UpdateComplete UpdaterPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "UpdateComplete" {
    
    CloseUpdater(UpdaterPID)
    
    MsgBox "Update complete.", UpdaterTitle
    
    StatusDialog := ShowStatusDialog("Launching " . AppName . "...")
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_ScriptDir . "\" . X64Exe
    Else
    ExeToRun := A_ScriptDir . "\" . X86Exe
    
    StatusDialog.Destroy()
    Run ExeToRun
    ExitApp
    
}
Else {
    
    CMDArgs := ""
    For CMDArg In A_Args
    CMDArgs .= CMDArg . " "
    
    CMDToRun := PrepareRunCMD("Update " . CMDArgs)
    Run CMDToRun
    ExitApp
    
}
