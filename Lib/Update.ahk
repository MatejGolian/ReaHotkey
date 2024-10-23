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
            SoundPlay "*16"
            MsgBox "Error checking for updates.", "Error"
            DialogOpen := False
        }
        DisplayUpdatePrompt() {
            DialogOpen := True
            ShowNotificationBox("New version found!", LatestVersionBody, False)
            DialogOpen := False
        }
        DisplayUpToDateMessage() {
            DialogOpen := True
            ShowNotificationBox("ReaHotkey is up to date!", "ReaHotkey is up to date - the current version is the latest.", True)
            DialogOpen := False
        }
        ProceedToDownload(*) {
            CloseNotificationBox()
            Run LatestVersionUrl
        }
        ShowNotificationBox(Title, Text, DisableProceedToDownload := False) {
            NotificationBox := Gui(, Title)
            NotificationBox.AddEdit("ReadOnly vText", Text)
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
