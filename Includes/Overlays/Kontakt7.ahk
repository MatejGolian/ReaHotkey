#Requires AutoHotkey v2.0

Class Kontakt7 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        This.InitConfig()
        
        PluginHeader := AccessibilityOverlay("Kontakt 7")
        PluginHeader.AddStaticText("Kontakt 7")
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
        PluginHeader.AddCustomButton("Choose library",,, ObjBindMethod(ChoosePluginOverlay,,,, PluginHeader.FocusableControlIDs.Length + 1)).SetHotkey("!C", "Alt+C")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := AccessibilityOverlay("Kontakt 7")
        StandaloneHeader.AddCustomButton("FILE menu",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)",,, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!S", "Alt+S")
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 7", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitPlugin"), False, False, False, ObjBindMethod(This, "CheckPlugin"))
        
        For PluginOverlay In This.PluginOverlays {
            PluginOverlay.ChildControls[1] := This.PluginHeader.Clone()
            Plugin.RegisterOverlay("Kontakt 7", PluginOverlay)
        }
        
        Plugin.SetTimer("Kontakt 7", This.CheckPluginConfig, -1)
        Plugin.SetTimer("Kontakt 7", This.CheckPluginMenu, 200)
        
        Plugin.Register("Kontakt 7 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, False, True, ObjBindMethod(This, "CheckPluginContentMissing"))
        
        PluginContentMissingOverlay := AccessibilityOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 7 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 7", "Kontakt ahk_class NINormalWindow* ahk_exe Kontakt 7.exe", False, False)
        Standalone.SetTimer("Kontakt 7", This.CheckStandaloneConfig, -1)
        Standalone.SetTimer("Kontakt 7", This.CheckStandaloneMenu, 200)
        Standalone.RegisterOverlay("Kontakt 7", StandaloneHeader)
        
        Standalone.Register("Kontakt 7 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe", False, False)
        
        StandaloneContentMissingOverlay := AccessibilityOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 7 Content Missing Dialog", StandaloneContentMissingOverlay)
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
        If This.GetPluginView() = "rack" {
            Try
            ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
            Catch
            Return
            This.MoveToPluginInstrumentButton(InstrumentButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Instrument switching unavailable. Make sure that an instrument is loaded and that you're in rack view.")
    }
    
    Static ActivatePluginMultiButton(MultiButton) {
        Critical
        If This.GetPluginView() = "rack" {
            Try
            ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
            Catch
            Return
            This.MoveToPluginMultiButton(MultiButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Multi switching unavailable. Make sure that a multi is loaded and that you're in rack view.")
    }
    
    Static ActivatePluginSnapshotButton(SnapshotButton) {
        Critical
        If This.GetPluginView() = "rack" {
            Try
            ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
            Catch
            Return
            This.MoveToPluginSnapshotButton(SnapshotButton)
            If InStr(SnapshotButton.Label, "Snapshot", True) {
                Click
                This.CheckPluginMenu()
                Return
            }
            Else {
                Click
                Return
            }
        }
        AccessibilityOverlay.Speak("Snapshot switching unavailable. Make sure that an instrument is loaded and that you're in rack view.")
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
        %Type%.SetNoHotkeys("Kontakt 7", False)
        Else
        %Type%.SetNoHotkeys("Kontakt 7", True)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = GetCurrentControlClass()
        If PluginInstance.Name = "Kontakt 7"
        Return True
        UIAElement := This.GetPluginUIAElement()
        If UIAElement
        Return True
        Return False
    }
    
    Static CheckPluginContentMissing(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = GetCurrentControlClass()
        If PluginInstance.Name = "Kontakt 7 Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing" {
            UIAElement := This.GetPluginUIAElement()
            If UIAElement
            Return True
        }
        Return False
    }
    
    Static closeBrowser(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({ClassName:"TagCloudAccordionWithBrands", matchmode:"Substring"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50033 {
            Try
            UIAElement.WalkTree(-1).Click("Left")
            AccessibilityOverlay.Speak("Library Browser closed.")
            Sleep 1000
        }
    }
    
    Static ClosePluginBrowser() {
        This.closeBrowser("Plugin")
    }
    
    Static ClosePluginUpdateDialog() {
        This.CloseUpdateDialog("Plugin")
    }
    
    Static CloseStandaloneBrowser() {
        This.closeBrowser("Standalone")
    }
    
    Static CloseStandaloneUpdateDialog() {
        This.CloseUpdateDialog("Standalone")
    }
    
    Static CloseUpdateDialog(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({ClassName:"UpdateDialog", matchmode:"Substring"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50033 {
            Try
            UIAElement.WalkTree(1).Click("Left")
            AccessibilityOverlay.Speak("Update dialog closed.")
            Sleep 1000
        }
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
        UIAElement := UIAElement.FindElement({ClassName:"ni::qt::QuickWindow"})
        Catch
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Kontakt 7" And UIAElement.Type = 50032
            Return True
            Return False
        }
    }
    
    Static GetPluginView() {
        Return This.GetView("Plugin")
    }
    
    Static GetStandaloneView() {
        Return This.GetView("Standalone")
    }
    
    Static GetView(Type) {
        Critical
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({Type:"Button", Name:"SHOP"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50000 {
            Try
            UIAElement := UIAElement.WalkTree(-1)
            Catch
            UIAElement := False
            If Not UIAElement Is UIA.IUIAutomationElement Or Not UIAElement.Type = 50000
            Return False
            If UIAElement.Name = "VIEW"
            Return "Rack"
            Else
            Return "Single"
        }
        Return False
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseK7Browser", 1, "Automatically close library browser in Kontakt 7", "Kontakt / Komplete Kontrol")
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInK7", 1, "Automatically detect libraries in Kontakt 7 plug-in")
    }
    
    Static InitPlugin(PluginInstance) {
        If PluginInstance.Overlay.ChildControls.Length = 0
        PluginInstance.Overlay.AddAccessibilityOverlay()
        PluginInstance.Overlay.ChildControls[1] := This.PluginHeader.Clone()
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
        Plugin.RegisterOverlayHotkeys("Kontakt 7", PluginInstance.Overlay)
    }
    
    Static MoveToPluginInstrumentButton(InstrumentButton) {
        Critical
        Label := InstrumentButton
        If InstrumentButton Is Object
        Label := InstrumentButton.Label
        If This.GetPluginView() = "rack" {
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
    
    Static MoveToPluginMultiButton(MultiButton) {
        Critical
        Label := MultiButton
        If MultiButton Is Object
        Label := MultiButton.Label
        If This.GetPluginView() = "rack" {
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
    
    Static MoveToPluginSnapshotButton(SnapshotButton) {
        Critical
        If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True)
        SnapshotButton.Label := "Snapshot menu"
        Label := SnapshotButton
        If SnapshotButton Is Object
        Label := SnapshotButton.Label
        If This.GetPluginView() = "rack" {
            Try
            ControlGetPos &ControlX, &ControlY, &ControlWidth, &ControlHeight, ReaHotkey.GetPluginControl(), "A"
            Catch
            Return
            If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) {
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
    }
    
    Class CheckPluginConfig {
        Static Call() {
            Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 7", True, True, Kontakt7.PluginHeader.FocusableControlIDs.Length + 1)
            Kontakt7.ClosePluginUpdateDialog()
            Sleep 1000
            If ReaHotkey.Config.Get("CloseK7Browser") = 1
            Kontakt7.ClosePluginBrowser()
            If ReaHotkey.Config.Get("DetectLibsInK7") = 1
            Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 500)
            Else
            Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 0)
        }
    }
    
    Class CheckPluginMenu {
        Static Call() {
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria)
            Kontakt7.CheckMenu("Plugin")
        }
    }
    
    Class CheckStandaloneConfig {
        Static Call() {
            Kontakt7.CloseStandaloneUpdateDialog()
            Sleep 1000
            If ReaHotkey.Config.Get("CloseK7Browser") = 1
            Kontakt7.CloseStandaloneBrowser()
        }
    }
    
    Class CheckStandaloneMenu {
        Static Call() {
            Kontakt7.CheckMenu("Standalone")
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
