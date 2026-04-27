#Requires AutoHotkey v2.0

Class Update {
    
    Static AllowReinstall := True
    Static JsonUrl := "https://api.github.com/repos/MatejGolian/ReaHotkey/releases"
    Static PerformUpdate := True
    Static TempDirName := "ReaHotkey"
    
    Static ActivateWindow() {
        RunningUpdate := This.IsRunning()
        If RunningUpdate {
            PrevDetectionSetting := A_DetectHiddenWindows
            DetectHiddenWindows True
            WinActivate("ahk_pid " . WinGetPID("ahk_id " . RunningUpdate))
            DetectHiddenWindows PrevDetectionSetting
        }
    }
    
    Static check(ForceUpdate := False, NotifyOnNoUpdate := True) {
        Static DialogOpen := False, DialogWinID := ""
        If Not DialogOpen {
            If NotifyOnNoUpdate
            AccessibilityOverlay.Speak("Checking for updates...")
            NotificationBox := Object()
            Try {
                DataError := False
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
                If CurrentVersion = ""
                CurrentVersion := "0.0.0"
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
                DataError := True
                ShowCheckingError()
                Return False
            }
            If ForceUpdate {
                ShowUpdatePrompt()
                Return True
            }
            Else If NotifyOnNoUpdate And CurrentVersionIndex = LatestVersionIndex {
                ShowUpToDateMessage()
                Return False
            }
            Else If CurrentVersionIndex > LatestVersionIndex {
                ShowUpdatePrompt()
                Return True
            }
            Else {
                If NotifyOnNoUpdate {
                    ShowUpToDateMessage()
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
        PerformUpdate(*) {
            CloseNotificationBox()
            If This.IsRunning() {
                This.ActivateWindow()
            }
            If DataError {
                MsgBox "An error occurred.`nPlease try again later.", "ReaHotkey"
            }
            Else {
                This.DeleteTempDir()
                If A_IsCompiled = 0
                Run A_AhkPath . " Includes/Updater.ahk Download " . LatestAssetUrl . " `"" . A_Temp . "\" . This.TempDirName . "\" . LatestAssetName . "`""
                Else
                Run A_ScriptFullPath . " /script *UPDATE Download " . LatestAssetUrl . " `"" . A_Temp . "\" . This.TempDirName . "\" . LatestAssetName . "`""
            }
        }
        ProceedToDownloadPage(*) {
            CloseNotificationBox()
            If DataError {
                MsgBox "An error occurred.`nPlease try again later.", "ReaHotkey"
            }
            Else {
                Run LatestVersionUrl
            }
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
        ShowCheckingError() {
            If This.PerformUpdate
            ShowNotificationBox("Error checking for new version!", "There was an error checking for the latest version`nis an internet connection present?!", False, "Update", False, True)
            Else
            ShowNotificationBox("Error checking for new version!", "There was an error checking for the latest version`nis an internet connection present?!", False, "Proceed to download page", False, True)
        }
        ShowNotificationBox(Title, Text, ProcessText := False, ActionButtonLabel := "Update", ActionButtonAction := False, DisableActionButton := False) {
            If ProcessText
            Text := ProcessNotificationText(Text)
            NotificationBox := Gui(, Title)
            NotificationBox.AddEdit("ReadOnly vText -WantReturn", Text)
            If ActionButtonAction
            NotificationBox.AddButton("Section vActionButton", ActionButtonLabel).OnEvent("Click", ActionButtonAction)
            Else
            NotificationBox.AddButton("Section vActionButton", ActionButtonLabel)
            NotificationBox.AddButton("YP vClose", "Close").OnEvent("Click", CloseNotificationBox)
            NotificationBox.OnEvent("Close", CloseNotificationBox)
            NotificationBox.OnEvent("Escape", CloseNotificationBox)
            If DisableActionButton {
                NotificationBox["ActionButton"].Opt("+Disabled")
                NotificationBox["Close"].Opt("+Default")
            }
            Else {
                NotificationBox["ActionButton"].Opt("-Disabled")
                NotificationBox["ActionButton"].Opt("+Default")
            }
            NotificationBox.Show()
            DialogOpen := True
            DialogWinID := WinGetID("A")
        }
        ShowUpdatePrompt() {
            If This.PerformUpdate
            ShowNotificationBox("New version found!", "ReaHotkey " . LatestVersion . " is available, with the following updates:`n" . LatestVersionBody, True, "Update", PerformUpdate, False)
            Else
            ShowNotificationBox("New version found!", "ReaHotkey " . LatestVersion . " is available, with the following updates:`n" . LatestVersionBody, True, "Proceed to download page", ProceedToDownloadPage, False)
        }
        ShowUpToDateMessage() {
            If This.PerformUpdate {
                If This.AllowReinstall
                ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", False, "Reinstall", PerformUpdate, False)
                Else
                ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", False, "Update", False, True)
            }
            Else {
                ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", False, "Proceed to download page", False, True)
            }
        }
    }
    
    Static Close() {
        RunningUpdate := This.IsRunning()
        If RunningUpdate {
            PrevDetectionSetting := A_DetectHiddenWindows
            DetectHiddenWindows True
            ProcessClose(WinGetPID("ahk_id " . RunningUpdate))
            DetectHiddenWindows PrevDetectionSetting
        }
    }
    
    Static DeleteTempDir() {
        If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D")
        DirDelete A_Temp . "\ReaHotkey", True
    }
    
    Static GetHiddenWinTitle() {
        If A_IsCompiled = 0
        Return A_ScriptDir . "\Includes\Updater.ahk - AutoHotkey v" A_AhkVersion
        Return A_ScriptFullPath . " - *UPDATE"
    }
    
    Static IsRunning() {
        PrevDetectionSetting := A_DetectHiddenWindows
        DetectHiddenWindows True
        PrevTitleSetting := A_TitleMatchMode
        SetTitleMatchMode 2
        RunningUpdate := WinExist(This.GetHiddenWinTitle())
        SetTitleMatchMode PrevTitleSetting
        DetectHiddenWindows PrevDetectionSetting
        Return RunningUpdate
    }
    
}
