#Requires AutoHotkey v2.0

Class Kontakt7 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        Kontakt7.InitConfig()
        
        PluginHeader := AccessibilityOverlay("Kontakt 7")
        PluginHeader.AddStaticText("Kontakt 7")
        PluginHeader.AddCustomButton("FILE menu",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("LIBRARY On/Off",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!L", "Alt+L")
        PluginHeader.AddCustomButton("VIEW menu",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!V", "Alt+V")
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)",,, Kontakt7.ActivatePluginHeaderButton).SetHotkey("!S", "Alt+S")
        PluginHeader.AddCustomButton("Previous instrument", Kontakt7.MoveToPluginInstrumentButton,,, Kontakt7.ActivatePluginInstrumentButton).SetHotkey("^P", "Ctrl+P")
        PluginHeader.AddCustomButton("Next instrument", Kontakt7.MoveToPluginInstrumentButton,,, Kontakt7.ActivatePluginInstrumentButton).SetHotkey("^N", "Ctrl+N")
        PluginHeader.AddCustomButton("Previous multi", Kontakt7.MoveToPluginMultiButton,,, Kontakt7.ActivatePluginMultiButton).SetHotkey("^+P", "Ctrl+Shift+P")
        PluginHeader.AddCustomButton("Next multi", Kontakt7.MoveToPluginMultiButton,,, Kontakt7.ActivatePluginMultiButton).SetHotkey("^+N", "Ctrl+Shift+N")
        PluginHeader.AddCustomButton("Snapshot menu", Kontakt7.MoveToPluginSnapshotButton,,, Kontakt7.ActivatePluginSnapshotButton).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", Kontakt7.MoveToPluginSnapshotButton,,, Kontakt7.ActivatePluginSnapshotButton).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", Kontakt7.MoveToPluginSnapshotButton,,, Kontakt7.ActivatePluginSnapshotButton).SetHotkey("!N", "Alt+N")
        Kontakt7.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt 7")
        StandaloneHeader.AddCustomButton("FILE menu",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",,, Kontakt7.ActivateStandaloneHeaderButton).SetHotkey("!S", "Alt+S")
        Kontakt7.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 7", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(Kontakt7, "InitPlugin"), True, False, False, ObjBindMethod(Kontakt7, "CheckPlugin"))
        
        For PluginOverlay In Kontakt7.PluginOverlays
        Plugin.RegisterOverlay("Kontakt 7", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Kontakt 7", PluginHeader)
        
        Plugin.SetTimer("Kontakt 7", ObjBindMethod(Kontakt7, "CheckPluginConfig"), -1)
        Plugin.SetTimer("Kontakt 7", ObjBindMethod(Kontakt7, "CheckPluginMenu"), 200)
        
        Plugin.Register("Kontakt 7 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(Kontakt7, "CheckPluginContentMissing"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 7 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 7", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe", False, False)
        Standalone.SetTimer("Kontakt 7", ObjBindMethod(Kontakt7, "CheckStandaloneConfig"), -1)
        Standalone.SetTimer("Kontakt 7", ObjBindMethod(Kontakt7, "CheckStandaloneMenu"), 200)
        Standalone.RegisterOverlay("Kontakt 7", StandaloneHeader)
        
        Standalone.Register("Kontakt 7 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe", False, False)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 7 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static CheckMenu(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAPaths := ["2,14", "2,15", "2,16", "2,17", "15,1,14", "15,1,15", "15,1,16", "15,1,17"]
        Else
        UIAPaths := ["1,14", "1,15", "1,16", "1,17"]
        Found := False
        Try
        For UIAPath In UIAPaths {
            UIAElement := GetUIAElement(UIAPath)
            If UIAElement Is Object And UIAElement.Type = 50009 {
                Found := True
                Break
            }
        }
        If Found = False
        %Type%.SetNoHotkeys("Kontakt 7", False)
        Else
        %Type%.SetNoHotkeys("Kontakt 7", True)
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 7"
        Return True
        UIAElement := GetUIAElement(2)
        Try
        If Not UIAElement = False And UIAElement.Name = "Kontakt 7" And UIAElement.ClassName = "ni::qt::QuickWindow"
        Return True
        UIAElement := GetUIAElement("15,1")
        Try
        If Not UIAElement = False And UIAElement.Name = "Kontakt 7" And UIAElement.ClassName = "ni::qt::QuickWindow"
        Return True
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 7", True, True)
        If ReaHotkey.Config.Get("CloseK7Browser") = 1
        Kontakt7.ClosePluginBrowser()
        If ReaHotkey.Config.Get("DetectLibsInK7") = 1
        Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginContentMissing(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 7 Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing" {
            UIAElement := GetUIAElement("1,1")
            Try
            If Not UIAElement = False And UIAElement.Name = "Kontakt 7" And UIAElement.ClassName = "ni::qt::QuickWindow"
            Return True
        }
        Return False
    }
    
    Static CheckPluginMenu(*) {
        Kontakt7.CheckMenu("Plugin")
    }
    
    Static CheckStandaloneConfig() {
        If ReaHotkey.Config.Get("CloseK7Browser") = 1
        Kontakt7.CloseStandaloneBrowser()
    }
    
    Static CheckStandaloneMenu(*) {
        Kontakt7.CheckMenu("Standalone")
    }
    
    Static ClosePluginBrowser() {
        UIAElement := GetUIAElement("2,14,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("2,16,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("15,1,14,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("15,1,16,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static CloseStandaloneBrowser() {
        UIAElement := GetUIAElement("1,14,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
        UIAElement := GetUIAElement("1,16,3")
        If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
            UIAElement.Click()
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseK7Browser", 1, "Automatically close library browser in Kontakt 7", "Kontakt / Komplete Kontrol")
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInK7", 1, "Automatically detect libraries in Kontakt 7 plug-in")
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := Kontakt7.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Kontakt 7", PluginInstance.Overlay)
    }
    
    Class  ActivatePluginHeaderButton {
        Static Call(HeaderButton) {
            Critical
            UIAElement := False
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement := GetUIAElement(StartingElement . ",2")
                Case "LIBRARY On/Off":
                UIAElement := GetUIAElement(StartingElement . ",3")
                Case "VIEW menu":
                UIAElement := GetUIAElement(StartingElement . ",4")
                Case "SHOP (Opens in default web browser)":
                UIAElement := GetUIAElement(StartingElement . ",5")
                If UIAElement = False Or Not UIAElement.Name = "SHOP"
                UIAElement := GetUIAElement(StartingElement . ",7")
            }
            If Not UIAElement = False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Kontakt7.CheckPluginMenu()
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Kontakt7.CheckPluginMenu()
                Case "SHOP (Opens in default web browser)":
                UIAElement.Click("Left")
            }
            Else
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Class ActivatePluginInstrumentButton {
        Static Call(InstrumentButton) {
            Critical
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            UIAElement := GetUIAElement(StartingElement . ",5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                Kontakt7.MoveToPluginInstrumentButton("Previous instrument")
                If CheckColor() {
                    Kontakt7.MoveToPluginInstrumentButton(InstrumentButton)
                    Click
                    Return
                }
            }
            AccessibilityOverlay.Speak("Instrument switching unavailable. Make sure that an instrument is loaded and that you're in rack view.")
            CheckColor() {
                MouseGetPos &mouseXPosition, &mouseYPosition
                Sleep 10
                FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
                If FoundColor = "0x545355" Or FoundColor = "0x656465"
                Return True
                Return False
            }
        }
    }
    
    Class ActivatePluginMultiButton {
        Static Call(MultiButton) {
            Critical
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            UIAElement := GetUIAElement(StartingElement . ",5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                Kontakt7.MoveToPluginMultiButton("Previous multi")
                If CheckColor() {
                    Kontakt7.MoveToPluginMultiButton(MultiButton)
                    Click
                    Return
                }
            }
            AccessibilityOverlay.Speak("Multi switching unavailable. Make sure that a multi is loaded and that you're in rack view.")
            CheckColor() {
                MouseGetPos &mouseXPosition, &mouseYPosition
                Sleep 10
                FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
                If FoundColor = "0x323232"
                Return True
                Return False
            }
        }
    }
    
    Class ActivatePluginSnapshotButton {
        Static Call(SnapshotButton) {
            Critical
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            UIAElement := GetUIAElement(StartingElement . ",5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                Kontakt7.MoveToPluginSnapshotButton("Previous snapshot")
                If CheckColor()
                If InStr(SnapshotButton.Label, "Snapshot", True) {
                    Kontakt7.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Kontakt7.CheckPluginMenu()
                    Return
                }
                Else {
                    Kontakt7.MoveToPluginSnapshotButton(SnapshotButton)
                    Click
                    Return
                }
            }
            AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that an instrument is loaded and that you're in rack view.")
            CheckColor() {
                MouseGetPos &mouseXPosition, &mouseYPosition
                Sleep 10
                FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
                If FoundColor = "0x424142" Or FoundColor = "0x545454"
                Return True
                Return False
            }
        }
    }
    
    Class  ActivateStandaloneHeaderButton {
        Static Call(HeaderButton) {
            Critical
            UIAElement := False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement := GetUIAElement("1,2")
                Case "LIBRARY On/Off":
                UIAElement := GetUIAElement("1,3")
                Case "VIEW menu":
                UIAElement := GetUIAElement("1,4")
                Case "SHOP (Opens in default web browser)":
                UIAElement := GetUIAElement("1,5")
                If UIAElement = False Or Not UIAElement.Name = "SHOP"
                UIAElement := GetUIAElement("1,7")
            }
            If Not UIAElement = False
            Switch HeaderButton.Label {
                Case "FILE menu":
                UIAElement.Click("Left")
                Kontakt7.CheckStandaloneMenu()
                Case "LIBRARY On/Off":
                UIAElement.Click("Left")
                Case "VIEW menu":
                UIAElement.Click("Left")
                Kontakt7.CheckStandaloneMenu()
                Case "SHOP (Opens in default web browser)":
                UIAElement.Click("Left")
            }
            Else
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Class MoveToPluginInstrumentButton {
        Static Call(InstrumentButton) {
            Label := InstrumentButton
            If InstrumentButton Is Object
            Label := InstrumentButton.Label
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            UIAElement := GetUIAElement(StartingElement . ",5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                If Label = "Previous instrument"
                MouseMove ControlX + ControlWidth - 352, ControlY + 87
                Else
                MouseMove ControlX + ControlWidth - 332, ControlY + 87
            }
        }
    }
    
    Class MoveToPluginMultiButton {
        Static Call(MultiButton) {
            Label := MultiButton
            If MultiButton Is Object
            Label := MultiButton.Label
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            UIAElement := GetUIAElement(StartingElement . ",5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                If Label = "Previous multi"
                MouseMove ControlX + 704, ControlY + 53
                Else
                MouseMove ControlX + 722, ControlY + 53
            }
        }
    }
    
    Class MoveToPluginSnapshotButton {
        Static Call(SnapshotButton) {
            If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True)
            SnapshotButton.Label := "Snapshot menu"
            Label := SnapshotButton
            If SnapshotButton Is Object
            Label := SnapshotButton.Label
            If ReaHotkey.PluginNative
            StartingElement := "15,1"
            Else
            StartingElement := 2
            UIAElement := GetUIAElement(StartingElement . ",5")
            If Not UIAElement = False And UIAElement.Name = "SHOP" {
                Try
                ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
                Catch
                Return
                If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) {
                    OCRResult := AccessibilityOverlay.Ocr(ControlX + ControlWidth - 588, ControlY + 109, ControlX + ControlWidth - 588 + 200, ControlY + 129)
                    If Not OCRResult = ""
                    SnapshotButton.Label := "Snapshot " . OcrResult
                }
                If InStr(Label, "Snapshot", True)
                MouseMove ControlX + ControlWidth - 588, ControlY + 118
                Else If InStr(Label, "Previous snapshot", True)
                MouseMove ControlX + ControlWidth - 405, ControlY + 118
                Else
                MouseMove ControlX + ControlWidth - 389, ControlY + 118
            }
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
