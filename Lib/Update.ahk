#Requires AutoHotkey v2.0

Class Update {
    
    Static JsonUrl := "https://api.github.com/repos/MatejGolian/ReaHotkey/releases"
    Static PerformUpdate := True
    Static UpdaterPID := ""
    
    Static check(ForceUpdate := False, NotifyOnNoUpdate := True) {
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
                ShowErrorMessage()
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
            If WinExist("ahk_pid " . This.UpdaterPID) {
                WinActivate("ahk_pid " . This.UpdaterPID)
            }
            Else {
                This.DeleteTempDir()
                PrevDetectionSetting := A_DetectHiddenWindows
                DetectHiddenWindows True
                CurrentPID := WinGetPID("ahk_id " . A_ScriptHWND)
                DetectHiddenWindows PrevDetectionSetting
                If A_IsCompiled = 0
                Run A_AhkPath . " Includes/Update.ahk Download " . LatestAssetUrl . " `"" . A_Temp . "\ReaHotkey\" . LatestAssetName . "`" ParentPID " . CurrentPID,,, &OutputPID
                Else
                Run A_ScriptFullPath . " /script *UPDATE Download " . LatestAssetUrl . " `"" . A_Temp . "\ReaHotkey\" . LatestAssetName . "`" ParentPID " . CurrentPID,,, &OutputPID
                This.UpdaterPID := OutputPID
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
        ShowErrorMessage() {
            ShowNotificationBox("Error checking for new version!", "There was an error checking for the latest version`nis an internet connection present?!", False, True)
        }
        ShowNotificationBox(Title, Text, ProcessText := False, DisableActionButton := False) {
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
            If DisableActionButton {
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
        ShowUpdatePrompt() {
            ShowNotificationBox("New version found!", "ReaHotkey " . LatestVersion . " is available, with the following updates:`n" . LatestVersionBody, True, False)
        }
        ShowUpToDateMessage() {
            ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", False, True)
        }
    }
    
    Static DeleteTempDir() {
        If FileExist(A_Temp . "\ReaHotkey") And InStr(FileExist(A_Temp . "\ReaHotkey"), "D")
        DirDelete A_Temp . "\ReaHotkey", True
    }
    
    Static IsRunning() {
        If ProcessExist(This.UpdaterPID) {
            MsgBox "An update is currently in progress.`nPlease cancel it first or wait for it to finish.", "Quit ReaHotkey"
            Return True
        }
        Return False
    }
    
}
