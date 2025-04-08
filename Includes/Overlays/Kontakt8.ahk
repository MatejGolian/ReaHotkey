﻿#Requires AutoHotkey v2.0

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
        PluginHeader.AddCustomButton("Choose library",,, ObjBindMethod(ChoosePluginOverlay,,,, "O")).SetHotkey("!C", "Alt+C")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt 8")
        StandaloneHeader.AddCustomButton("FILE menu",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!S", "Alt+S")
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 8", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitPlugin"), False, 1, False, ObjBindMethod(This, "CheckPlugin"))
        
        For PluginOverlay In This.PluginOverlays {
            PluginOverlay.ChildControls[1] := This.PluginHeader.Clone()
            Plugin.RegisterOverlay("Kontakt 8", PluginOverlay)
        }
        
        Plugin.SetTimer("Kontakt 8", This.CheckPluginConfig, -1)
        Plugin.SetTimer("Kontakt 8", This.CheckPluginMenu, 250)
        
        Plugin.Register("Kontakt 8 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, 1, True, ObjBindMethod(This, "CheckPluginContentMissing"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 8 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 8", "Kontakt 8 ahk_class NINormalWindow* ahk_exe Kontakt 8.exe", False, False, 1)
        Standalone.SetTimer("Kontakt 8", This.CheckStandaloneConfig, -1)
        Standalone.SetTimer("Kontakt 8", This.CheckStandaloneMenu, 250)
        Standalone.RegisterOverlay("Kontakt 8", StandaloneHeader)
        
        Standalone.Register("Kontakt 8 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 8.exe", False, False, 1)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 8 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static ActivateHeaderButton(Type, HeaderButton) {
        Critical
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Try
        If UIAElement
        Switch HeaderButton.Label {
            Case "FILE menu":
            UIAElement := UIAElement.FindElement({Type:"Button", Name:"FILE"})
            Case "LIBRARY On/Off":
            UIAElement := UIAElement.FindElement({Type:"Button", Name:"LIBRARY"})
            Case "VIEW menu":
            UIAElement := UIAElement.FindElement({Type:"Button", Name:"VIEW"})
            Case "SHOP (Opens in default web browser)":
            UIAElement := UIAElement.FindElement({Type:"Button", Name:"SHOP"})
        }
        Catch
        UIAElement := False
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
    
    Static ActivatePluginHeaderButton(HeaderButton) {
        This.ActivateHeaderButton("Plugin", HeaderButton)
    }
    
    Static ActivatePluginInstrumentButton(InstrumentButton) {
        Critical
        If This.CheckPluginClassicViewColor("instrument") {
            This.MoveToPluginInstrumentButton(InstrumentButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Instrument switching unavailable. Make sure that an instrument is loaded and that you're in classic view.")
    }
    
    Static ActivatePluginMultiButton(MultiButton) {
        Critical
        If This.CheckPluginClassicViewColor("multi") {
            This.MoveToPluginMultiButton(MultiButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Multi switching unavailable. Make sure that a multi is loaded and that you're in classic view.")
    }
    
    Static ActivatePluginSnapshotButton(SnapshotButton) {
        Critical
        If This.CheckPluginClassicViewColor("Snapshot") {
            This.MoveToPluginSnapshotButton(SnapshotButton)
            If InStr(SnapshotButton.Label, "Snapshot", True) {
                Click
                This.CheckPluginMenu()
                Return
            }
            Else {
                This.MoveToPluginSnapshotButton(SnapshotButton)
                Click
                Return
            }
        }
        AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that an instrument is loaded and that you're in classic view.")
    }
    
    Static ActivateStandaloneHeaderButton(HeaderButton) {
        This.ActivateHeaderButton("Standalone", HeaderButton)
    }
    
    Static CheckMenu(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Found := False
        Try
        UIAElement := UIAElement.FindElement({Type:"Menu"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50009
        Found := True
        If Not Found
        %Type%.SetHotkeyMode("Kontakt 8", 1)
        Else
        %Type%.SetHotkeyMode("Kontakt 8", 3)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Kontakt 8"
        Return True
        If ReaHotkey.AbletonPlugin Or ReaHotkey.ReaperPluginNative {
            UIAElement := This.GetPluginUIAElement()
            If UIAElement
            Return True
        }
        Return False
    }
    
    Static CheckPluginClassicViewColor(Mode) {
        InstrumentColors := ["0x545355", "0x656465"]
        MultiColors := ["0x323232"]
        SnapshotColors := ["0x424142", "0x545454"]
        Switch Mode {
            Case "Instrument":
            This.MoveToPluginInstrumentButton("Previous instrument")
            Case "Multi":
            This.MoveToPluginMultiButton("Previous multi")
            Case "Snapshot":
            This.MoveToPluginSnapshotButton("Previous snapshot")
        }
        Return CheckColor(%Mode%Colors)
        CheckColor(ModeColors) {
            MouseGetPos &mouseXPosition, &mouseYPosition
            Sleep 10
            FoundColor := PixelGetColor(MouseXPosition, MouseYPosition, "Slow")
            For ModeColor In ModeColors
            If FoundColor = ModeColor
            Return True
            Return False
        }
    }
    
    Static CheckPluginContentMissing(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Kontakt 8 Content Missing Dialog"
        Return True
        If ReaHotkey.AbletonPlugin Or ReaHotkey.ReaperPluginNative
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing" {
            UIAElement := This.GetPluginUIAElement()
            If UIAElement
            Return True
        }
        Return False
    }
    
    Static CloseBrowser(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({ClassName:"FileTypeSelector", matchmode:"Substring"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50018 {
            Try
            UIAElement.WalkTree(-1).Click("Left")
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static ClosePluginBrowser() {
        This.CloseBrowser("Plugin")
    }
    
    Static CloseStandaloneBrowser() {
        This.CloseBrowser("Standalone")
    }
    
    Static GetPluginUIAElement() {
        Critical
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Try
        UIAElements := UIAElement.FindElements({ClassName:"ni::qt::QuickWindow"})
        Catch
        Return False
        For UIAElement In UIAElements
        If CheckElement(UIAElement)
        Return UIAElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Kontakt 8" And UIAElement.Type = 50032
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
        Critical
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
        Critical
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
        Critical
        If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True)
        SnapshotButton.Label := "Snapshot menu"
        Label := SnapshotButton
        If SnapshotButton Is Object
        Label := SnapshotButton.Label
        Try
        ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
        Catch
        Return
        If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) And This.CheckPluginClassicViewColor("Snapshot") {
            OCRResult := AccessibilityOverlay.Ocr("TesseractBest", ControlX + ControlWidth - 588, ControlY + 109, ControlX + ControlWidth - 588 + 200, ControlY + 129)
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
    
    Class CheckPluginConfig {
        Static Call() {
            Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 8", True, True, "C", 2)
            If ReaHotkey.Config.Get("CloseK8Browser") = 1
            Kontakt8.ClosePluginBrowser()
            If ReaHotkey.Config.Get("DetectLibsInK8") = 1
            Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 500)
            Else
            Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 0)
        }
    }
    
    Class CheckPluginMenu {
        Static Call(*) {
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria)
            Kontakt8.CheckMenu("Plugin")
        }
    }
    
    Class CheckStandaloneConfig {
        Static Call() {
            If ReaHotkey.Config.Get("CloseK8Browser") = 1
            Kontakt8.CloseStandaloneBrowser()
        }
    }
    
    Class CheckStandaloneMenu {
        Static Call(*) {
            Kontakt8.CheckMenu("Standalone")
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoLibraryProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
