#Requires AutoHotkey v2.0

Class Update {

Static check(NotifyOnNoUpdate := True) {
Static DialogOpen := False, DialogWinID := ""
If Not DialogOpen {
If NotifyOnNoUpdate
AccessibilityOverlay.Speak("Checking for updates...")
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
CurrentVersionIndex := 0
For Key, Value In JsonData
If Value["tag_name"] = CurrentVersion {
CurrentVersionIndex := Key
Break
}
LatestVersion := "0.0.0"
LatestVersionIndex := 1
If JsonData.Length >= LatestVersionIndex {
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
NotificationBox.AddButton("Section vProceedToDownload", "Proceed to download page").OnEvent("Click", ProceedToDownload)
NotificationBox.AddButton("YP vClose", "Close").OnEvent("Click", CloseNotificationBox)
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
DialogOpen := True
DialogWinID := WinGetID("A")
}
}

}
