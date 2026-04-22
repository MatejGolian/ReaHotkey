#Requires AutoHotkey v2.0

Class Update {
    
    Static JsonUrl := "https://api.github.com/repos/MatejGolian/ReaHotkey/releases"
    Static PerformUpdate := True
    
    Static check(NotifyOnNoUpdate := True) {
        Static DialogOpen := False, DialogWinID := ""
        If Not DialogOpen {
            If NotifyOnNoUpdate
            AccessibilityOverlay.Speak("Checking for updates...")
            NotificationBox := Object()
            Try {
                WHR := ComObject("WinHttp.WinHttpRequest.5.1")
                WHR.Open("GET", This.JsonUrl, True)
                WHR.Send()
                WHR.WaitForResponse()
                JsonData := WHR.ResponseText
                JsonData := Jxon_Load(&JsonData)
                CurrentVersion := ""
                If IsSet(GetVersion) And GetVersion Is Func
                CurrentVersion := StrSplit(GetVersion(), "-")
                If CurrentVersion Is Array
                CurrentVersion := CurrentVersion[1]
                CurrentVersionIndex := 0
                For Key, Value In JsonData
                If Value["tag_name"] = CurrentVersion {
                    CurrentVersionIndex := Key
                    Break
                }
                LatestVersion := "0.0.0"
                LatestVersionIndex := 1
                If JsonData.Length >= LatestVersionIndex {
                    LatestAssetName := JsonData[LatestVersionIndex]["assets"][LatestVersionIndex]["name"]
                    LatestAssetUrl := JsonData[LatestVersionIndex]["assets"][LatestVersionIndex]["browser_download_url"]
                    LatestVersionBody := JsonData[LatestVersionIndex]["body"]
                    LatestVersion := JsonData[LatestVersionIndex]["tag_name"]
                    LatestVersionUrl := JsonData[LatestVersionIndex]["html_url"]
                }
                If Not CurrentVersionIndex
                CurrentVersionIndex := LatestVersionIndex
            }
            Catch {
                DisplayErrorMessage()
                Return False
            }
            If NotifyOnNoUpdate And CurrentVersionIndex = LatestVersionIndex {
                DisplayUpToDateMessage()
                Return False
            }
            Else If CurrentVersionIndex > LatestVersionIndex {
                DisplayUpdatePrompt()
                Return True
            }
            Else {
                If NotifyOnNoUpdate {
                    DisplayUpToDateMessage()
                    Return False
                }
            }
        }
        Else {
            WinActivate(DialogWinID)
        }
        CloseNotificationBox(*) {
            NotificationBox.Destroy()
            DialogOpen := False
            DialogWinID := ""
        }
        DisplayErrorMessage() {
            ShowNotificationBox("Error checking for new version!", "There was an error checking for the latest version`nis an internet connection present?!", False, True)
        }
        DisplayUpdatePrompt() {
            ShowNotificationBox("New version found!", "ReaHotkey " . LatestVersion . " is available, with the following updates:`n" . LatestVersionBody, True, False)
        }
        DisplayUpToDateMessage() {
            ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", False, True)
        }
        PerformUpdate(*) {
            CloseNotificationBox()
            If WinExist("ahk_pid " . This.Download.PID) {
                WinActivate("ahk_pid " . This.Download.PID)
            }
            Else {
                This.DeleteTempDir()
                CurrentPID := DllCall("GetCurrentProcessId")
                If A_IsCompiled = 0
                Run A_AhkPath . " Update.ahk Download " . LatestAssetUrl . " `"" . A_Temp . "\ReaHotkey\" . LatestAssetName . "`" PID " . CurrentPID,,, &OutputPID
                Else
                Run A_ScriptFullPath . " /script *UPDATE Download " . LatestAssetUrl . " `"" . A_Temp . "\ReaHotkey\" . LatestAssetName . "`" PID " . CurrentPID,,, &OutputPID
                This.Download.PID := OutputPID
            }
        }
        ProceedToDownload(*) {
            CloseNotificationBox()
            Run LatestVersionUrl
        }
        ProcessNotificationText(Text) {
            Text := Trim(Text)
            Lines := StrSplit(Text, "`n")
            If Lines Is Array And Lines.Length > 0 {
                Text := ""
                For Line In Lines {
                    Line := Trim(Line)
                    Line := RegExReplace(Line, "\s{2,}", " ")
                    Line := RegExReplace(Line, "^#+.*", "")
                    Line := RegExReplace(Line, "^-", "  +")
                    Line := RTrim(Line)
                    If Not Line = ""
                    Text .= Line . "`n"
                }
                Text := RegExReplace(Text, "\n+$", "")
            }
            Return Text
        }
        ShowNotificationBox(Title, Text, ProcessText := False, DisableUpdateButton := False) {
            If ProcessText
            Text := ProcessNotificationText(Text)
            NotificationBox := Gui(, Title)
            NotificationBox.AddEdit("ReadOnly vText -WantReturn", Text)
            If This.PerformUpdate
            NotificationBox.AddButton("Section vPerformUpdate", "Update").OnEvent("Click", PerFormUpdate)
            Else
            NotificationBox.AddButton("Section vProceedToDownload", "Proceed to download page").OnEvent("Click", ProceedToDownload)
            NotificationBox.AddButton("YP vClose", "Close").OnEvent("Click", CloseNotificationBox)
            NotificationBox.OnEvent("Close", CloseNotificationBox)
            NotificationBox.OnEvent("Escape", CloseNotificationBox)
            If DisableUpdateButton {
                If This.PerformUpdate {
                    NotificationBox["PerformUpdate"].Opt("+Disabled")
                }
                Else {
                    NotificationBox["ProceedToDownload"].Opt("+Disabled")
                }
                NotificationBox["Close"].Opt("+Default")
            }
            Else {
                If This.PerformUpdate {
                    NotificationBox["PerformUpdate"].Opt("-Disabled")
                    NotificationBox["PerformUpdate"].Opt("+Default")
                }
                Else {
                    NotificationBox["ProceedToDownload"].Opt("-Disabled")
                    NotificationBox["ProceedToDownload"].Opt("+Default")
                }
            }
            NotificationBox.Show()
            DialogOpen := True
            DialogWinID := WinGetID("A")
        }
    }
    
    Static Cleanup() {
        If ProcessExist(This.Download.PID) {
            ProcessClose This.Download.PID
            This.DeleteTempDir()
        }
    }
    
    Static DeleteTempDir() {
        If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D")
        DirDelete A_Temp . "\ReaHotkey", True
    }
    
    Static DisplayStatusDialog(Status) {
        DialogGUI := GUI(, "ReaHotkey Update")
        DialogGUI.OnEvent("Close", Cancel)
        DialogGUI.OnEvent("Escape", Cancel)
        DialogGUI.AddText("Section W550 vStatus", Status)
        DialogGUI.AddButton("Default Section XS", "Cancel").OnEvent("Click", Cancel)
        DialogGUI.Show()
        Return DialogGUI
        Cancel(*) {
            If DialogGUI Is GUI
            DialogGUI.Hide()
            ConfirmationDialog := MsgBox("Are you sure you want to cancel?", "ReaHotkey Update", 4)
            If ConfirmationDialog == "Yes" {
                ExitApp
            }
            If DialogGUI Is GUI
            DialogGUI.Show()
        }
    }
    
    Static Extract(SourceFile, DestinationDir) {
        DirCreate DestinationDir
        This.DisplayStatusDialog("Extracting files...")
        DirCopy SourceFile, DestinationDir, 1
    }
    
    Class Download {
        
        Available := False
        Complete := False
        CurrentSize := 0
        DestinationFile := ""
        DialogGUI := Object()
        DialogTitle := "File Download"
        FileToDelete := ""
        Operation := False
        PercentComplete := 0
        Size := 0
        URL := ""
        Static PID := ""
        
        __New(DialogTitle := False) {
            If DialogTitle
            This.DialogTitle := DialogTitle
            For Arg In A_Args {
                Arg := StrReplace(Arg, '"')
                If Arg = "Download" {
                    This.Operation := "Download"
                    If A_Args.Length >= A_Index + 1
                    This.URL := A_Args[A_Index + 1]
                    If A_Args.Length >= A_Index + 2
                    This.DestinationFile := A_Args[A_Index + 2]
                    If A_Args.Length < A_Index + 2
                    This.Available := False
                    Else
                    This.Available := True
                    Break
                }
            }
            For Arg In A_Args {
                Arg := StrReplace(Arg, '"')
                If Arg = "Delete" {
                    This.Operation := "Delete"
                    This.Available := True
                    If A_Index = A_Args.Length
                    This.FileToDelete := This.DestinationFile
                    Else
                    This.FileToDelete := A_Args[A_Index + 1]
                    Break
                }
            }
            If This.Available And This.Operation = "Download"
            This.Size := This.GetSize()
        }
        
        Cancel(*) {
            If This.DialogGUI Is GUI
            This.DialogGUI.Hide()
            ConfirmationDialog := MsgBox("Are you sure you want to cancel?", This.DialogTitle, 4)
            If ConfirmationDialog == "Yes" {
                If A_IsCompiled = 0
                Run A_AhkPath . " /restart Update.ahk Delete " . This.DestinationFile
                Else
                Run A_ScriptFullPath . " /restart /script *UPDATE Delete " . This.DestinationFile
                ExitApp
            }
            If This.DialogGUI Is GUI
            This.DialogGUI.Show()
        }
        
        DestroyDialog() {
            If This.DialogGUI Is GUI {
                This.DialogGUI.Destroy()
                This.DialogGUI := Object()
            }
        }
        
        DisplayDialog() {
            This.DialogGUI := GUI(, This.DialogTitle)
            This.DialogGUI.OnEvent("Close", ObjBindMethod(This, "Cancel"))
            This.DialogGUI.OnEvent("Escape", ObjBindMethod(This, "Cancel"))
            This.DialogGUI.AddText("Section W550", "Downloading")
            This.DialogGUI.AddProgress("Section vDownloadProgress")
            This.DialogGUI.AddText("Section W100", "Downloaded")
            This.DialogGUI.AddText("W450 YS vDownloadRatio", "0 B of " . This.FormatSize(This.Size))
            This.DialogGUI.AddText("Section W100", "Speed")
            This.DialogGUI.AddText("W450 YS vDownloadSpeed", "0 B/s")
            This.DialogGUI.AddText("Section W100", "Time remaining")
            This.DialogGUI.AddText("W450 YS vTimeRemaining", "∞")
            This.DialogGUI.AddButton("Default Section XS", "Cancel").OnEvent("Click", ObjBindMethod(This, "Cancel"))
            This.DialogGUI.Show()
        }
        
        FormatSize(Size, DecimalPlaces := 2) {
            Units := ["B", "KB", "MB", "GB", "TB"]
            Index := 1
            While Size >= 1024 {
                Index++
                Size /= 1024
                If Index = 5
                Break
            }
            If Index = 2
            Size := Round(Size)
            Else
            If Index > 2 {
                Size := Round(Size, DecimalPlaces)
                If DecimalPlaces > 0
                While Substr(Size, -1) = "0"
                Size := SubStr(Size, 1, StrLen(Size) -1)
                If Substr(Size, -1) = "."
                Size .= "0"
            }
            Return Size . " " . Units[Index]
        }
        
        FormatTime(Seconds) {
            Time := 19990101
            Time := DateAdd(Time, Seconds, "Seconds")
            Hrs := Seconds // 3600
            Mins := FormatTime(Time, "m")
            Secs := FormatTime(Time, "s")
            Return Trim((Hrs = 0 ? "" : Hrs . " h ") . (Mins = 0 ? "" : Mins . " m ") . (Hrs = 0 And Mins = 0 ? Secs . " s" : (Secs = 0 ? "" : Secs . " s")))
        }
        
        GetCurrentSize() {
            PreviousSize := This.CurrentSize
            Try
            This.CurrentSize := FileGetSize(This.DestinationFile)
            Catch
            This.CurrentSize := PreviousSize
            Return This.CurrentSize
        }
        
        GetSize() {
            WHR := ComObject("WinHttp.WinHttpRequest.5.1")
            WHR.Open("HEAD", This.URL, True)
            WHR.Send()
            WHR.WaitForResponse()
            Try {
                This.Size := WHR.GetResponseHeader("Content-Length")
            }
            Catch {
                This.Available := False
                This.Size := 0
            }
            Return This.Size
        }
        
        Start(ExitOnCompletion := True) {
            If This.Operation = "Delete" {
                If FileExist(This.FileToDelete) And Not InStr(FileExist(This.FileToDelete), "D") {
                    Sleep 2000
                    FileDelete This.FileToDelete
                }
            }
            If This.Operation = "Download" {
                If Not This.URL {
                    MsgBox "No URL specified.", This.DialogTitle
                    ExitApp
                }
                If Not This.DestinationFile {
                    MsgBox "No destination file specified.", This.DialogTitle
                    ExitApp
                }
                This.CurrentSize := 0
                This.PercentComplete := 0
                If This.Available {
                    This.DisplayDialog()
                    SetTimer ObjBindMethod(This, "UpdateStatus"), 200
                }
                SplitPath This.DestinationFile,, &DestinationDir
                DirCreate DestinationDir
                Download This.URL, This.DestinationFile
                If This.Available {
                    SetTimer ObjBindMethod(This, "UpdateStatus"), 0
                    This.DestroyDialog()
                }
                This.CurrentSize := This.GetCurrentSize()
                If This.CurrentSize = This.Size {
                    This.Complete := True
                    This.PercentComplete := 100
                }
            }
            If ExitOnCompletion
            ExitApp
        }
        
        UpdateStatus() {
            Static CurrentSizeTick := 0, DownloadSpeed := 0, FormattedSize := This.FormatSize(This.Size), FormattedTimeRemaining := "∞", PreviousSize := This.CurrentSize, PreviousSizeTick := 0
            TickCount := A_TickCount
            CurrentSizeTick := TickCount
            If PreviousSizeTick = 0
            PreviousSizeTick := TickCount
            This.CurrentSize := This.GetCurrentSize()
            FormattedCurrentSize := This.FormatSize(This.CurrentSize)
            If CurrentSizeTick = PreviousSizeTick {
                DownloadSpeed := This.CurrentSize
                FormatTimeRemaining()
            }
            Else
            If CurrentSizeTick >= PreviousSizeTick + 1000 {
                DownloadSpeed := (This.CurrentSize - PreviousSize) / Round((CurrentSizeTick - PreviousSizeTick) / 1000)
                PreviousSize := This.CurrentSize
                PreviousSizeTick := CurrentSizeTick
                FormatTimeRemaining()
            }
            This.PercentComplete := Round(This.CurrentSize / This.Size * 100)
            FormattedSpeed := This.FormatSize(DownloadSpeed) . "/s"
            If This.DialogGUI Is GUI {
                This.DialogGUI["DownloadProgress"].Value := This.PercentComplete
                This.DialogGUI["DownloadRatio"].Value := FormattedCurrentSize . " of " . FormattedSize
                This.DialogGUI["DownloadSpeed"].Value := FormattedSpeed
                This.DialogGUI["TimeRemaining"].Value := FormattedTimeRemaining
            }
            FormatTimeRemaining() {
                If DownloadSpeed = 0
                FormattedTimeRemaining := "∞"
                Else
                FormattedTimeRemaining := This.FormatTime(Round(((This.Size - This.CurrentSize) * 8) / (DownloadSpeed * 8)))
            }
        }
        
    }
    
}
