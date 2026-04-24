#Requires AutoHotkey v2.0

Class FileDownload {
    
    Available := False
    Complete := False
    CurrentSize := 0
    DestinationFile := ""
    DialogGUI := Object()
    DialogTitle := "File Download"
    PercentComplete := 0
    RunOnCancel := False
    Size := 0
    URL := ""
    
    __New(URL, DestinationFile, DialogTitle := False) {
        This.URL := URL
        This.DestinationFile := DestinationFile
        If DialogTitle
        This.DialogTitle := DialogTitle
        This.Size := This.GetSize()
    }
    
    Cancel(*) {
        This.OwnDialog()
        ConfirmationDialog := MsgBox("Are you sure you want to cancel?", This.DialogTitle, 4)
        If ConfirmationDialog == "Yes" {
            If This.RunOnCancel
            Run This.RunOnCancel
            ExitApp
        }
    }
    
    CreateDialog() {
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
    }
    
    DestroyDialog() {
        If This.DialogGUI Is GUI {
            This.DialogGUI.Destroy()
            This.DialogGUI := Object()
        }
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
            This.Available := True
        }
        Catch {
            This.Size := 0
            This.Available := False
        }
        Return This.Size
    }
    
    OwnDialog() {
        If This.DialogGUI Is GUI {
            This.DialogGUI.Opt("+OwnDialogs")
        }
    }
    
    ShowDialog() {
        If Not This.DialogGUI Is GUI {
            This.CreateDialog()
        }
        If This.DialogGUI Is GUI {
            This.DialogGUI.Show()
        }
    }
    
    Start(RunOnCancel := False) {
        This.RunOnCancel := RunOnCancel
        If Not This.URL {
            MsgBox "No URL specified.", This.DialogTitle
            ExitApp
        }
        If Not This.DestinationFile {
            MsgBox "No destination file specified.", This.DialogTitle
            ExitApp
        }
        This.Complete := False
        This.CurrentSize := 0
        This.PercentComplete := 0
        If This.Available {
            This.ShowDialog()
            SetTimer ObjBindMethod(This, "UpdateStatus"), 200
        }
        SplitPath This.DestinationFile,, &DestinationDir
        DirCreate DestinationDir
        Download This.URL, This.DestinationFile
        If This.Complete {
            SetTimer ObjBindMethod(This, "UpdateStatus"), 0
            This.DestroyDialog()
        }
        This.CurrentSize := This.GetCurrentSize()
        If This.CurrentSize = This.Size {
            This.Complete := True
            This.PercentComplete := 100
            This.DestroyDialog()
        }
    }
    
    UpdateStatus() {
    If This.Complete
    Return
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
