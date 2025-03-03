#Requires AutoHotkey v2.0

Class Kontakt8 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        This.InitConfig()
        
        PluginHeader := AccessibilityOverlay("Kontakt 8")
        PluginHeader.AddStaticText("Kontakt 8")
        PluginHeader.AddCustomButton("FILE menu",,, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("LIBRARY On/Off",,, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!L", "Alt+L")
        PluginHeader.AddCustomButton("VIEW menu",,, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!V", "Alt+V")
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)",,, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!S", "Alt+S")
        PluginHeader.AddCustomButton("Previous instrument", ObjBindMethod(This, "MoveToPluginInstrumentButton"),,, ObjBindMethod(This, "ActivatePluginInstrumentButton")).SetHotkey("^P", "Ctrl+P")
        PluginHeader.AddCustomButton("Next instrument", ObjBindMethod(This, "MoveToPluginInstrumentButton"),,, ObjBindMethod(This, "ActivatePluginInstrumentButton")).SetHotkey("^N", "Ctrl+N")
        PluginHeader.AddCustomButton("Previous multi", ObjBindMethod(This, "MoveToPluginMultiButton"),,, ObjBindMethod(This, "ActivatePluginMultiButton")).SetHotkey("^+P", "Ctrl+Shift+P")
        PluginHeader.AddCustomButton("Next multi", ObjBindMethod(This, "MoveToPluginMultiButton"),,, ObjBindMethod(This, "ActivatePluginMultiButton")).SetHotkey("^+N", "Ctrl+Shift+N")
        PluginHeader.AddCustomButton("Snapshot menu", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!N", "Alt+N")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt 8")
        StandaloneHeader.AddCustomButton("FILE menu",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!S", "Alt+S")
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 8", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitPlugin"), True, False, False, ObjBindMethod(This, "CheckPlugin"))
        
        For PluginOverlay In This.PluginOverlays
        Plugin.RegisterOverlay("Kontakt 8", PluginOverlay)
        Plugin.RegisterOverlayHotkeys("Kontakt 8", PluginHeader)
        
        Plugin.SetTimer("Kontakt 8", ObjBindMethod(This, "CheckPluginConfig"), -1)
        Plugin.SetTimer("Kontakt 8", ObjBindMethod(This, "CheckPluginMenu"), 200)
        
        Plugin.Register("Kontakt 8 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(This, "CheckPluginContentMissing"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 8 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 8", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 8.exe", False, False)
        Standalone.SetTimer("Kontakt 8", ObjBindMethod(This, "CheckStandaloneConfig"), -1)
        Standalone.SetTimer("Kontakt 8", ObjBindMethod(This, "CheckStandaloneMenu"), 200)
        Standalone.RegisterOverlay("Kontakt 8", StandaloneHeader)
        
        Standalone.Register("Kontakt 8 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 8.exe", False, False)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 8 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static ActivatePluginHeaderButton(HeaderButton) {
        Critical
        StartingPath := This.GetPluginStartingPath()
        If StartingPath
        Switch HeaderButton.Label {
            Case "FILE menu":
            UIAElement := GetUIAElement(StartingPath . ",2")
            Case "LIBRARY On/Off":
            UIAElement := GetUIAElement(StartingPath . ",3")
            Case "VIEW menu":
            UIAElement := GetUIAElement(StartingPath . ",4")
            Case "SHOP (Opens in default web browser)":
            UIAElement := GetUIAElement(StartingPath . ",5")
        }
        If Not UIAElement = False
        Switch HeaderButton.Label {
            Case "FILE menu":
            UIAElement.Click("Left")
            This.CheckPluginMenu()
            Case "LIBRARY On/Off":
            UIAElement.Click("Left")
            Case "VIEW menu":
            UIAElement.Click("Left")
            This.CheckPluginMenu()
            Case "SHOP (Opens in default web browser)":
            UIAElement.Click("Left")
        }
        Else
        AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
    }
    
    Static ActivatePluginInstrumentButton(InstrumentButton) {
        Critical
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        This.MoveToPluginInstrumentButton("Previous instrument")
        If CheckColor() {
            This.MoveToPluginInstrumentButton(InstrumentButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Instrument switching unavailable. Make sure that an instrument is loaded and that you're in classic view.")
        CheckColor() {
            MouseGetPos &mouseXPosition, &mouseYPosition
            Sleep 10
            FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
            If FoundColor = "0x545355" Or FoundColor = "0x656465"
            Return True
            Return False
        }
    }
    
    Static ActivatePluginMultiButton(MultiButton) {
        Critical
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        This.MoveToPluginMultiButton("Previous multi")
        If CheckColor() {
            This.MoveToPluginMultiButton(MultiButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Multi switching unavailable. Make sure that a multi is loaded and that you're in classic view.")
        CheckColor() {
            MouseGetPos &mouseXPosition, &mouseYPosition
            Sleep 10
            FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
            If FoundColor = "0x323232"
            Return True
            Return False
        }
    }
    
    Static ActivatePluginSnapshotButton(SnapshotButton) {
        Critical
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        This.MoveToPluginSnapshotButton("Previous snapshot")
        If CheckColor()
        If InStr(SnapshotButton.Label, "Snapshot", True) {
            This.MoveToPluginSnapshotButton(SnapshotButton)
            Click
            This.CheckPluginMenu()
            Return
        }
        Else {
            This.MoveToPluginSnapshotButton(SnapshotButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that an instrument is loaded and that you're in classic view.")
        CheckColor() {
            MouseGetPos &mouseXPosition, &mouseYPosition
            Sleep 10
            FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
            If FoundColor = "0x424142" Or FoundColor = "0x545454"
            Return True
            Return False
        }
    }
    
    Static ActivateStandaloneHeaderButton(HeaderButton) {
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
        }
        If Not UIAElement = False
        Switch HeaderButton.Label {
            Case "FILE menu":
            UIAElement.Click("Left")
            This.CheckStandaloneMenu()
            Case "LIBRARY On/Off":
            UIAElement.Click("Left")
            Case "VIEW menu":
            UIAElement.Click("Left")
            This.CheckStandaloneMenu()
            Case "SHOP (Opens in default web browser)":
            UIAElement.Click("Left")
        }
        Else
        AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
    }
    
    Static CheckMenu(Type) {
        Thread "NoTimers"
        StartingPath := This.GetPluginStartingPath()
        UIAPaths := [StartingPath . ",14", StartingPath . ",15", StartingPath . ",16", StartingPath . ",17"]
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
        %Type%.SetNoHotkeys("Kontakt 8", False)
        Else
        %Type%.SetNoHotkeys("Kontakt 8", True)
    }
    
    Static CheckPlugin(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 8"
        Return True
        If ReaHotkey.AbletonPlugin Or ReaHotkey.ReaperPluginNative {
            StartingPath := This.GetPluginStartingPath()
            If StartingPath
            Return True
        }
        Return False
    }
    
    Static CheckPluginConfig() {
        Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 8", True, True)
        If ReaHotkey.Config.Get("CloseK8Browser") = 1
        This.ClosePluginBrowser()
        If ReaHotkey.Config.Get("DetectLibsInK8") = 1
        Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 500)
        Else
        Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 0)
    }
    
    Static CheckPluginContentMissing(*) {
        Thread "NoTimers"
        PluginInstance := Plugin.GetInstance(GetCurrentControlClass())
        If PluginInstance Is Plugin And PluginInstance.Name = "Kontakt 8 Content Missing Dialog"
        Return True
        If ReaHotkey.AbletonPlugin Or ReaHotkey.ReaperPluginNative
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing" {
            StartingPath := This.GetPluginStartingPath()
            If StartingPath
            Return True
        }
        Return False
    }
    
    Static CheckPluginMenu(*) {
        This.CheckMenu("Plugin")
    }
    
    Static CheckStandaloneConfig() {
        If ReaHotkey.Config.Get("CloseK8Browser") = 1
        This.CloseStandaloneBrowser()
    }
    
    Static CheckStandaloneMenu(*) {
        This.CheckMenu("Standalone")
    }
    
    Static ClosePluginBrowser() {
        If ReaHotkey.ReaperPluginNative {
            StartingPath := This.GetPluginStartingPath()
            UIAElement := GetUIAElement(StartingPath . ",14,3")
            If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
                UIAElement.Click()
                AccessibilityOverlay.Speak("Library Browser closed.")
                Sleep 1000
            }
            UIAElement := GetUIAElement(StartingPath . ",16,3")
            If Not UIAElement = False And RegExMatch(UIAElement.ClassName, "^LumenButton_QMLTYPE_[0-9]+$") {
                UIAElement.Click()
                AccessibilityOverlay.Speak("Library Browser closed.")
                Sleep 1000
            }
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
    
    Static GetPluginStartingPath() {
        Static UIAPath := False
        Try
        UIAElement := UIA.ElementFromHandle("ahk_id " . WinGetID("A"))
        Catch
        UIAElement := False
        If UIAElement And UIAPath And CheckPath(UIAElement, UIAPath)
        Return UIAPath
        If UIAElement
        Try
        For Index, ChildElement In UIAElement.Children {
            UIAPaths := [Index, Index . ",1"]
            For UIAPath In UIAPaths
            If CheckPath(UIAElement, UIAPath)
            Return UIAPath
        }
        UIAPath := False
        Return ""
        CheckPath(UIAElement, UIAPath) {
            Try
            TestElement := UIAElement.ElementFromPath(UIAPath)
            Catch
            TestElement := False
            If TestElement And TestElement.Name = "Kontakt 8" And TestElement.ClassName = "ni::qt::QuickWindow"
            Return True
            Return False
        }
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseK8Browser", 1, "Automatically close library browser in Kontakt 8", "Kontakt / Komplete Kontrol")
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInK8", 1, "Automatically detect libraries in Kontakt 8 plug-in")
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := This.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Kontakt 8", PluginInstance.Overlay)
    }
    
    Static MoveToPluginInstrumentButton(InstrumentButton) {
        Label := InstrumentButton
        If InstrumentButton Is Object
        Label := InstrumentButton.Label
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        If Label = "Previous instrument"
        MouseMove ControlX + ControlWidth - 352, ControlY + 87
        Else
        MouseMove ControlX + ControlWidth - 332, ControlY + 87
    }
    
    Static MoveToPluginMultiButton(MultiButton) {
        Label := MultiButton
        If MultiButton Is Object
        Label := MultiButton.Label
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        If Label = "Previous multi"
        MouseMove ControlX + 722, ControlY + 53
        Else
        MouseMove ControlX + 742, ControlY + 53
    }
    
    Static MoveToPluginSnapshotButton(SnapshotButton) {
        If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True)
        SnapshotButton.Label := "Snapshot menu"
        Label := SnapshotButton
        If SnapshotButton Is Object
        Label := SnapshotButton.Label
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) {
            OCRResult := AccessibilityOverlay.Ocr("UWP", ControlX + ControlWidth - 588, ControlY + 109, ControlX + ControlWidth - 588 + 200, ControlY + 129)
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
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    ;#IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
