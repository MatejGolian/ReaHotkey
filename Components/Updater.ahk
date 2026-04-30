#Requires AutoHotkey v2.0

#NoTrayIcon
#SingleInstance Force
#Warn All
DetectHiddenWindows True
SetTitleMatchMode 2

AppName := "ReaHotkey"
ExtractedTempDir := "ReaHotkey\ReaHotkey"
ExtractionTempDir := "ReaHotkey"
MainTempDir := "ReaHotkey"
ParentAhkName := "ReaHotkey.ahk"
ThisFileSubdir := "Components"
UpdaterTitle := "ReaHotkey Update"
X64Exe := "ReaHotkey_x64.exe"
X86Exe := "ReaHotkey_x86.exe"

#Include <FileDownload>

CloseUpdater(TargetPID) {
    If Not TargetPID = WinGetPID("ahk_id " . A_ScriptHWND)
    If ProcessExist(TargetPID) {
        ProcessClose TargetPID
        ProcessWaitClose TargetPID
    }
}

GetParam(Name) {
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
    Global ThisFileSubdir
    If A_IsCompiled = 0
    If Not ThisFileSubdir = ""
    Return Substr(A_ScriptDir, 1, - (StrLen(ThisFileSubdir) + 1))
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
    Global ExtractedTempDir, MainTempDir
    If DirExist(A_Temp . "\" . MainTempDir) {
        If CleanupOption = "All" {
            DirDelete A_Temp . "\" . MainTempDir, True
        }
        Else If CleanupOption = "Extracted" {
            If DirExist(A_Temp . "\" . ExtractedTempDir)
            DirDelete A_Temp . "\" . ExtractedTempDir, True
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

CurrentPID := WinGetPID("ahk_id " . A_ScriptHWND)
ParentAhkDir := GetParentAhkDir()
ParentPID := GetParentPID()
PreviousPID := GetParam("PreviousPID")
TaskSwitch := ""

If A_Args.Length > 0
TaskSwitch := A_Args[1]

If TaskSwitch = "Download" {
    
    If A_Args.Length < 3 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    URL := A_Args[2]
    DestinationFile := A_Args[3]
    
    UpdateDownload := FileDownload(URL, DestinationFile, UpdaterTitle)
    
    If UpdateDownload.Available {
        
        UpdateDownload.Start(PrepareRunCMD("Extract `"" . DestinationFile . "`" PreviousPID " . CurrentPID), PrepareRunCMD("DownloadCleanup PreviousPID " . CurrentPID), PrepareRunCMD("DownloadFailed PreviousPID " . CurrentPID))
        
        If Not UpdateDownload.Complete {
            
            Run PrepareRunCMD("DownloadFailed PreviousPID " . CurrentPID)
            ExitApp
            
        }
        
        ExitApp
        
    }
    Else {
        
        Run PrepareRunCMD("DownloadFailed PreviousPID " . CurrentPID)
        ExitApp
        
    }
    
}
Else If TaskSwitch = "DownloadFailed" {
    
    CloseUpdater(PreviousPID)
    
    If DirExist(A_Temp . "\" . MainTempDir) {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    MsgBox "Download failed.", UpdaterTitle
    ExitApp
    
}
Else If TaskSwitch = "DownloadCleanup" {
    
    CloseUpdater(PreviousPID)
    
    If DirExist(A_Temp . "\" . MainTempDir) {
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
    
    CloseUpdater(PreviousPID)
    FileToExtract := A_Args[2]
    
    StatusDialog := ShowStatusDialog("Extracting files...", PrepareRunCMD("ExtractionCleanup PreviousPID " . CurrentPID))
    Try {
        DirCopy FileToExtract, A_Temp . "\" . ExtractionTempDir, 1
    }
    Catch {
        StatusDialog.Destroy()
        Run PrepareRunCMD("ExtractionFailed PreviousPID " . CurrentPID)
        Exit
    }
    StatusDialog.Destroy()
    
    StatusDialog := ShowStatusDialog("Preparing to update files...")
    
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
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_Temp . "\" . ExtractedTempDir . "\" . X64Exe
    Else
    ExeToRun := A_Temp . "\" . ExtractedTempDir . "\" . X86Exe
    
    StatusDialog.Destroy()
    
    If A_IsCompiled = 0
    Run ExeToRun . " /script *UPDATE Update `"" . ParentAhkDir . "`" PreviousPID " . CurrentPID
    Else
    Run ExeToRun . " /script *UPDATE Update `"" . A_ScriptDir . "`" PreviousPID " . CurrentPID
    
    ExitApp
    
}
Else If TaskSwitch = "ExtractionFailed" {
    
    CloseUpdater(PreviousPID)
    
    If DirExist(A_Temp . "\" . MainTempDir) {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("Extracted")
        StatusDialog.Destroy()
    }
    
    MsgBox "Extraction failed.", UpdaterTitle
    ExitApp
    
}
Else If TaskSwitch = "ExtractionCleanup" {
    
    CloseUpdater(PreviousPID)
    
    If DirExist(A_Temp . "\" . MainTempDir) {
        StatusDialog := ShowStatusDialog("Cleaning up files...")
        PerformCleanup("Extracted")
        StatusDialog.Destroy()
    }
    
    ExitApp
    
}
Else If TaskSwitch = "Update" {
    
    If A_Args.Length < 2 {
        MsgBox "Not enough parameters.", "Error"
        ExitApp
    }
    
    CloseUpdater(PreviousPID)
    Destination := A_Args[2]
    
    If SubStr(Destination, -1) = "/" Or SubStr(Destination, -1) = "\"
    Destination := SubStr(Destination, 1, -1)
    
    If Not Destination {
        MsgBox "No directory specified.", "Error"
        ExitApp
    }
    Else If Not DirExist(Destination) {
        MsgBox "`"" . Destination . "`" is not a valid directory.", "Error"
        ExitApp
    }
    Else If Destination = A_ScriptDir {
        MsgBox "The destination directory can not be the same as the source directory.", "Error"
        ExitApp
    }
    
    If A_PtrSize * 8 = 64
    ExeToRunOnCancel := Destination . "\" . X64Exe
    Else
    ExeToRunOnCancel := Destination . "\" . X86Exe
    
    StatusDialog := ShowStatusDialog("Updating files...", ExeToRunOnCancel)
    Try {
        DirCopy A_ScriptDir, Destination, 1
    }
    Catch {
        StatusDialog.Destroy()
        Run PrepareRunCMD("UpdateFailed `"" . Destination . "`" PreviousPID " . CurrentPID)
        Exit
    }
    StatusDialog.Destroy()
    
    StatusDialog := ShowStatusDialog("Preparing to clean up files...", ExeToRunOnCancel)
    
    If A_PtrSize * 8 = 64
    ExeToRun := Destination . "\" . X64Exe
    Else
    ExeToRun := Destination . "\" . X86Exe
    
    StatusDialog.Destroy()
    Run ExeToRun . " /script *UPDATE UpdateCleanup PreviousPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "UpdateFailed" {
    
    If A_Args.Length < 2 {
        ExitApp
    }
    
    CloseUpdater(PreviousPID)
    Destination := A_Args[2]
    
    If SubStr(Destination, -1) = "/" Or SubStr(Destination, -1) = "\"
    Destination := SubStr(Destination, 1, -1)
    
    If Not Destination {
        MsgBox "No directory specified.", "Error"
        ExitApp
    }
    Else If Not DirExist(Destination) {
        MsgBox "`"" . Destination . "`" is not a valid directory.", "Error"
        ExitApp
    }
    Else If Destination = A_ScriptDir {
        MsgBox "The destination directory can not be the same as the source directory.", "Error"
        ExitApp
    }
    
    MsgBox "Update failed.", UpdaterTitle
    
    If A_PtrSize * 8 = 64
    ExeToRun := Destination . "\" . X64Exe
    Else
    ExeToRun := Destination . "\" . X86Exe
    
    Run ExeToRun
    ExitApp
    
}
Else If TaskSwitch = "UpdateCleanup" {
    
    CloseUpdater(PreviousPID)
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_ScriptDir . "\" . X64Exe
    Else
    ExeToRun := A_ScriptDir . "\" . X86Exe
    
    If DirExist(A_Temp . "\" . MainTempDir) {
        StatusDialog := ShowStatusDialog("Cleaning up files...", ExeToRun)
        PerformCleanup("All")
        StatusDialog.Destroy()
    }
    
    StatusDialog := ShowStatusDialog("Preparing to complete update...", ExeToRun)
    StatusDialog.Destroy()
    Run ExeToRun . " /script *UPDATE UpdateComplete PreviousPID " . CurrentPID
    ExitApp
    
}
Else If TaskSwitch = "UpdateComplete" {
    
    CloseUpdater(PreviousPID)
    MsgBox "Update complete.", UpdaterTitle
    
    If A_PtrSize * 8 = 64
    ExeToRun := A_ScriptDir . "\" . X64Exe
    Else
    ExeToRun := A_ScriptDir . "\" . X86Exe
    
    StatusDialog := ShowStatusDialog("Launching " . AppName . "...", ExeToRun)
    StatusDialog.Destroy()
    Run ExeToRun
    ExitApp
    
}
Else {
    
    If A_Args.Length > 0 {
        
        DestDirIndex := 1
        CMDArgs := ""
        
        For CMDArg In A_Args
        If DirExist(CMDArg) {
            DestDirIndex := A_Index
            Break
        }
        
        For CMDArg In A_Args
        If A_Index >= DestDirIndex
        CMDArgs .= "`"" . CMDArg . "`" "
        
        CMDToRun := PrepareRunCMD("Update " . CMDArgs)
        Run CMDToRun
        ExitApp
        
    }
    
}
