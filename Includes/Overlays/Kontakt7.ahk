#Requires AutoHotkey v2.0

Class Kontakt7 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        This.InitConfig()
        
        PluginHeader := PluginOverlay("Kontakt 7")
        PluginHeader.AddStaticText("Kontakt 7")
        PluginHeader.AddCustomButton("FILE menu", ObjBindMethod(This, "FocusPluginHeaderButton"),, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("LIBRARY On/Off", ObjBindMethod(This, "FocusPluginHeaderButton"),, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!L", "Alt+L")
        PluginHeader.AddCustomButton("VIEW menu", ObjBindMethod(This, "FocusPluginHeaderButton"),, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!V", "Alt+V")
        PluginHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(This, "FocusPluginHeaderButton"),, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!S", "Alt+S")
        PluginHeader.AddCustomButton("Previous instrument", ObjBindMethod(This, "MoveToPluginInstrumentButton"),,, ObjBindMethod(This, "ActivatePluginInstrumentButton")).SetHotkey("^P", "Ctrl+P")
        PluginHeader.AddCustomButton("Next instrument", ObjBindMethod(This, "MoveToPluginInstrumentButton"),,, ObjBindMethod(This, "ActivatePluginInstrumentButton")).SetHotkey("^N", "Ctrl+N")
        PluginHeader.AddCustomButton("Previous multi", ObjBindMethod(This, "MoveToPluginMultiButton"),,, ObjBindMethod(This, "ActivatePluginMultiButton")).SetHotkey("^+P", "Ctrl+Shift+P")
        PluginHeader.AddCustomButton("Next multi", ObjBindMethod(This, "MoveToPluginMultiButton"),,, ObjBindMethod(This, "ActivatePluginMultiButton")).SetHotkey("^+N", "Ctrl+Shift+N")
        PluginHeader.AddCustomButton("Snapshot menu", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!N", "Alt+N")
        PluginHeader.AddCustomButton("Choose library",,, ObjBindMethod(ChoosePluginOverlay,,,, "O")).SetHotkey("!C", "Alt+C")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := StandaloneOverlay("Kontakt 7")
        StandaloneHeader.AddCustomButton("FILE menu", ObjBindMethod(This, "FocusStandaloneHeaderButton"),, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomButton("LIBRARY On/Off", ObjBindMethod(This, "FocusStandaloneHeaderButton"),, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!L", "Alt+L")
        StandaloneHeader.AddCustomButton("VIEW menu", ObjBindMethod(This, "FocusStandaloneHeaderButton"),, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!V", "Alt+V")
        StandaloneHeader.AddCustomButton("SHOP (Opens in default web browser)", ObjBindMethod(This, "FocusStandaloneHeaderButton"),, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!S", "Alt+S")
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 7", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitPlugin"), False, 1, False, ObjBindMethod(This, "CheckPlugin"))
        
        For K7PluginOverlay In This.PluginOverlays {
            K7PluginOverlay.ChildControls[1] := This.PluginHeader.Clone()
            Plugin.RegisterOverlay("Kontakt 7", K7PluginOverlay)
        }
        
        Plugin.SetTimer("Kontakt 7", This.CheckPluginConfig, -1)
        Plugin.SetTimer("Kontakt 7", This.CheckPluginMenu, 250)
        
        Plugin.Register("Kontakt 7 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, 1, True, ObjBindMethod(This, "CheckPluginContentMissing"))
        
        PluginContentMissingOverlay := PluginOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 7 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 7", "Kontakt 7 ahk_class NINormalWindow* ahk_exe Kontakt 7.exe", False, False, 1)
        Standalone.SetTimer("Kontakt 7", This.CheckStandaloneConfig, -1)
        Standalone.SetTimer("Kontakt 7", This.CheckStandaloneMenu, 250)
        Standalone.RegisterOverlay("Kontakt 7", StandaloneHeader)
        
        Standalone.Register("Kontakt 7 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 7.exe", False, False, 1)
        
        StandaloneContentMissingOverlay := StandaloneOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 7 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static ActivateHeaderButton(Type, HeaderButton) {
        This.FocusOrActivateHeaderButton("Activate", Type, HeaderButton)
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
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Found := False
        Try
        UIAElement := UIAElement.FindElement({Type: "Menu"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50009
        Found := True
        If Not Found
        %Type%.SetHotkeyMode("Kontakt 7", 1)
        Else
        %Type%.SetHotkeyMode("Kontakt 7", 0)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Kontakt 7"
        Return True
        UIAElement := This.GetPluginUIAElement()
        If UIAElement
        Return True
        Return False
    }
    
    Static CheckPluginContentMissing(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Kontakt 7 Content Missing Dialog"
        Return True
        If WinExist(ReaHotkey.PluginWinCriteria) And WinActive(ReaHotkey.PluginWinCriteria) And WinGetTitle("A") = "content Missing" {
            UIAElement := This.GetPluginUIAElement()
            If UIAElement
            Return True
        }
        Return False
    }
    
    Static CloseBrowser(Type) {
        Thread "NoTimers"
        UIAElement := This.GetBrowser(Type)
        If UIAElement Is UIA.IUIAutomationElement {
            Try
            UIAElement.WalkTree(-1).Click("Left")
            AccessibilityOverlay.AddToSpeechQueue("Library Browser closed.")
        }
    }
    
    Static ClosePluginBrowser() {
        This.CloseBrowser("Plugin")
    }
    
    Static ClosePluginUpdateDialog() {
        This.CloseUpdateDialog("Plugin")
    }
    
    Static CloseStandaloneBrowser() {
        This.CloseBrowser("Standalone")
    }
    
    Static CloseStandaloneUpdateDialog() {
        This.CloseUpdateDialog("Standalone")
    }
    
    Static CloseUpdateDialog(Type) {
        Thread "NoTimers"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({ClassName: "UpdateDialog", MatchMode: "Substring"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50033 {
            Try
            UIAElement.WalkTree(1).Click("Left")
            AccessibilityOverlay.AddToSpeechQueue("Update dialog closed.")
        }
    }
    
    Static FocusHeaderButton(Type, HeaderButton) {
        This.FocusOrActivateHeaderButton("Focus", Type, HeaderButton)
    }
    
    Static FocusOrActivateHeaderButton(Action, Type, HeaderButton) {
        Critical
        If Not Action = "Focus" And Not Action = "Activate"
        Action := "Focus"
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Try
        If UIAElement
        Switch HeaderButton.Label {
            Case "FILE menu":
            UIAElement := UIAElement.FindElement({Type: "Button", Name: "FILE"})
            Case "LIBRARY On/Off":
            UIAElement := UIAElement.FindElement({Type: "Button", Name: "LIBRARY"})
            Case "VIEW menu":
            UIAElement := UIAElement.FindElement({Type: "Button", Name: "VIEW"})
            Case "SHOP (Opens in default web browser)":
            UIAElement := UIAElement.FindElement({Type: "Button", Name: "SHOP"})
        }
        Catch
        UIAElement := False
        If UIAElement {
            Switch HeaderButton.Label {
                Case "FILE menu":
                If Action = "Focus"
                UIAElement.SetFocus()
                Else
                UIAElement.Click("Left")
                If Action = "Activate"
                This.Check%Type%Menu()
                Case "VIEW menu":
                If Action = "Focus"
                UIAElement.SetFocus()
                Else
                UIAElement.Click("Left")
                If Action = "Activate"
                This.Check%Type%Menu()
                Default:
                If Action = "Focus"
                UIAElement.SetFocus()
                Else
                UIAElement.Click("Left")
            }
            Return
        }
        If Type = "Plugin" And Action = "Activate"
        MouseFunction := "ClickPluginCoordinates"
        Else If Type = "Plugin" And Action = "Focus"
        MouseFunction := "MoveToPluginCoordinates"
        Else If Type = "Standalone" And Action = "Activate"
        MouseFunction := "Click"
        Else
        MouseFunction := "MouseMove"
        Switch HeaderButton.Label {
            Case "FILE menu":
            %MouseFunction%(175, 19)
            If Action = "Activate"
            This.Check%Type%Menu()
            Case "VIEW menu":
            %MouseFunction%(288, 19)
            If Action = "Activate"
            This.Check%Type%Menu()
            Case "LIBRARY On/Off":
            %MouseFunction%(231, 19)
            Case "SHOP (Opens in default web browser)":
            If This.Get%Type%Browser()
            %MouseFunction%(815, 19)
            Else
            %MouseFunction%(440, 19)
            Default:
            AccessibilityOverlay.Speak(HeaderButton.Label . " button not found")
        }
    }
    
    Static FocusPluginHeaderButton(HeaderButton) {
        This.FocusHeaderButton("Plugin", HeaderButton)
    }
    
    Static FocusStandaloneHeaderButton(HeaderButton) {
        This.FocusHeaderButton("Standalone", HeaderButton)
    }
    
    Static GetBrowser(Type) {
        If Type = "Plugin"
        UIAElement := This.GetPluginUIAElement()
        Else
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({ClassName: "TagCloudAccordionWithBrands", MatchMode: "Substring"})
        Catch
        UIAElement := False
        If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50033
        Return UIAElement
        Return False
    }
    
    Static GetPluginUIAElement() {
        Critical
        Static Criteria := [{ClassName: "ni::qt::QuickWindow"}, {ClassName: "QWindowIcon", MatchMode: "Substring"}]
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        Try
        If CheckElement(UIAElement)
        Return UIAElement
        Loop Criteria.Length {
            Try
            UIAElements := UIAElement.FindElements(Criteria[A_Index])
            Catch
            UIAElements := Array()
            Try
            For UIAElement In UIAElements
            If CheckElement(UIAElement)
            Return UIAElement
        }
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Kontakt 7"
            If UIAElement.Type = 50032 Or UIAElement.Type = 50033
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
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Try
        UIAElement := UIAElement.FindElement({Type: "Button", Name: "SHOP"})
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
        PluginInstance.Overlay.AddPluginOverlay()
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
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 7", True, True, "C", 2)
            LastMessage := AccessibilityOverlay.LastMessage
            %ParentClass%.ClosePluginUpdateDialog()
            If ReaHotkey.Config.Get("CloseK7Browser") = 1
            %ParentClass%.ClosePluginBrowser()
            AccessibilityOverlay.AddToSpeechQueue(LastMessage)
            AccessibilityOverlay.ClearLastMessage()
            AccessibilityOverlay.Speak()
            If ReaHotkey.Config.Get("DetectLibsInK7") = 1
            Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 500)
            Else
            Plugin.SetTimer("Kontakt 7", PluginAutoChangeFunction, 0)
        }
    }
    
    Class CheckPluginMenu {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria)
            %ParentClass%.CheckMenu("Plugin")
        }
    }
    
    Class CheckStandaloneConfig {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            LastMessage := AccessibilityOverlay.LastMessage
            %ParentClass%.CloseStandaloneUpdateDialog()
            If ReaHotkey.Config.Get("CloseK7Browser") = 1
            %ParentClass%.CloseStandaloneBrowser()
            AccessibilityOverlay.AddToSpeechQueue(LastMessage)
            AccessibilityOverlay.ClearLastMessage()
            AccessibilityOverlay.Speak()
        }
    }
    
    Class CheckStandaloneMenu {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            %ParentClass%.CheckMenu("Standalone")
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoLibraryProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/Audiobro.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
