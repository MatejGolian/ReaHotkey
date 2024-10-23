#Requires AutoHotkey v2.0

Class Update {
    
    Static check(NotifyOnNoUpdate := True) {
        JsonUrl := "https://api.github.com/repos/MatejGolian/ReaHotkey/releases"
        NotificationBox := Object()
        Try {
            WHR := ComObject("WinHttp.WinHttpRequest.5.1")
            WHR.Open("GET", JsonUrl, True)
            WHR.Send()
            WHR.WaitForResponse()
            JsonData := WHR.ResponseText
            JsonData := Jxon_Load(&JsonData)
            CurrentVersion := StrSplit(GetVersion(), "-")
            If CurrentVersion Is Array
            CurrentVersion := CurrentVersion[1]
            VersionInfo := StrSplit(CurrentVersion, ".")
            CurrentMajorVersion := VersionInfo[1]
            CurrentMinorVersion := VersionInfo[2]
            CurrentMaintenanceVersion := VersionInfo[3]
            CurrentVersionNumber := 0
            For Key, Value In JsonData
            If Value["tag_name"] = CurrentVersion {
                CurrentVersionNumber := Key
                Break
            }
            LatestVersion := "0.0.0"
            LatestVersionNumber := 1
            If JsonData.Length >= LatestVersionNumber {
                LatestAssetUrl := JsonData[LatestVersionNumber]["assets"][LatestVersionNumber]["browser_download_url"]
                LatestVersionBody := JsonData[LatestVersionNumber]["body"]
                LatestVersion := JsonData[LatestVersionNumber]["tag_name"]
                LatestVersionUrl := JsonData[LatestVersionNumber]["html_url"]
            }
            VersionInfo := StrSplit(LatestVersion, ".")
            LatestMajorVersion := VersionInfo[1]
            LatestMinorVersion := VersionInfo[2]
            LatestMaintenanceVersion := VersionInfo[3]
        }
        Catch {
            DisplayErrorMessage()
            Return False
        }
        If NotifyOnNoUpdate And CurrentVersion = LatestVersion {
            DisplayUpToDateMessage()
            Return False
        }
        Else If CurrentVersionNumber And CurrentVersionNumber > LatestVersionNumber {
            DisplayUpdatePrompt()
            Return True
        }
        Else If LatestMajorVersion > CurrentMajorVersion {
            DisplayUpdatePrompt()
            Return True
        }
        Else If LatestMajorVersion >= CurrentMajorVersion And LatestMinorVersion > CurrentMinorVersion {
            DisplayUpdatePrompt()
            Return True
        }
        Else If LatestMajorVersion >= CurrentMajorVersion And LatestMinorVersion >= CurrentMinorVersion And LatestMaintenanceVersion > CurrentMaintenanceVersion {
            DisplayUpdatePrompt()
            Return True
        }
        Else {
            If NotifyOnNoUpdate {
                DisplayUpToDateMessage()
                Return False
            }
        }
        CloseNotificationBox(*) {
            NotificationBox.Destroy()
        }
        DisplayErrorMessage() {
            DialogOpen := True
            ShowNotificationBox("Error checking for new version!", "There was an error checking for the latest version`nis an internet connection present?!", False, True)
            DialogOpen := False
        }
        DisplayUpdatePrompt() {
            DialogOpen := True
            ShowNotificationBox("New version found!", "ReaHotkey " . LatestVersion . " is available, with the following updates:`n" . LatestVersionBody, True, False)
            DialogOpen := False
        }
        DisplayUpToDateMessage() {
            DialogOpen := True
            ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", False, True)
            DialogOpen := False
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
        ShowNotificationBox(Title, Text, ProcessText := False, DisableProceedToDownload := False) {
            If ProcessText
            Text := ProcessNotificationText(Text)
            NotificationBox := Gui(, Title)
            NotificationBox.AddEdit("ReadOnly vText -WantReturn", Text)
            NotificationBox.AddButton("Section XS vProceedToDownload", "Proceed to download page").OnEvent("Click", ProceedToDownload)
            NotificationBox.AddButton("YS vClose", "Close").OnEvent("Click", CloseNotificationBox)
            NotificationBox.OnEvent("Close", CloseNotificationBox)
            NotificationBox.OnEvent("Escape", CloseNotificationBox)
            If DisableProceedToDownload {
                NotificationBox["ProceedToDownload"].Opt("+Disabled")
                NotificationBox["Close"].Opt("+Default")
            }
            Else {
                NotificationBox["ProceedToDownload"].Opt("-Disabled")
                NotificationBox["ProceedToDownload"].Opt("+Default")
            }
            NotificationBox.Show()
        }
    }
    
}
