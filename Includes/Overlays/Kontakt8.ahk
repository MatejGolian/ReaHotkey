#Requires AutoHotkey v2.0

Class Kontakt8 {
    
    Static PluginHeader := Object()
    Static StandaloneHeader := Object()
    Static PluginOverlays := Array()
    Static StandaloneOverlays := Array()
    
    Static __New() {
        This.InitConfig()
        
        PluginHeader := PluginOverlay("Kontakt 8")
        PluginHeader.AddStaticText("Kontakt 8")
        PluginHeader.AddCustomButton("Kontakt File Menu", ObjBindMethod(This, "FocusPluginHeaderButton"),, ObjBindMethod(This, "ActivatePluginHeaderButton")).SetHotkey("!F", "Alt+F")
        PluginHeader.AddCustomButton("Load",,,, This.InvokePluginMenuItem("Kontakt File Menu", "Load...")).SetHotkey("^L", "Ctrl+L")
        PluginHeader.AddCustomButton("Save as",,,, ProducePluginMenu(["Instrument #1", "Instrument #2", "Instrument #3", "Instrument #4", "Instrument #5", "Instrument #6", "Instrument #7", "Instrument #8", "Instrument #9", "Instrument #10", "Instrument #11", "Instrument #12", "Instrument #13", "Instrument #14", "Instrument #15", "Instrument #16"], ObjBindMethod(This, "HandlePluginSaveAsMenu"))).SetHotkey("^S", "Ctrl+S")
        PluginHeader.AddCustomButton("Reset multi",,,, This.InvokePluginMenuItem("Kontakt File Menu", "Reset multi")).SetHotkey("^R", "Ctrl+R")
        PluginHeader.AddCustomPassThrough("Plugin", "Tab", "+Tab", WrapPluginUIAPassThroughStart.Bind(, This.GetPluginUIAElement, 1), WrapPluginUIAPassThroughEnd.Bind(, This.GetPluginUIAElement, 0), ObjBindMethod(This, "HandlePassThrough"),, ObjBindMethod(This, "CheckFocusableElements"))
        PluginHeader.AddCustomButton("Previous instrument", ObjBindMethod(This, "MoveToPluginInstrumentButton"),,, ObjBindMethod(This, "ActivatePluginInstrumentButton")).SetHotkey("^P", "Ctrl+P")
        PluginHeader.AddCustomButton("Next instrument", ObjBindMethod(This, "MoveToPluginInstrumentButton"),,, ObjBindMethod(This, "ActivatePluginInstrumentButton")).SetHotkey("^N", "Ctrl+N")
        PluginHeader.AddCustomButton("Previous multi", ObjBindMethod(This, "MoveToPluginMultiButton"),,, ObjBindMethod(This, "ActivatePluginMultiButton")).SetHotkey("^+P", "Ctrl+Shift+P")
        PluginHeader.AddCustomButton("Next multi", ObjBindMethod(This, "MoveToPluginMultiButton"),,, ObjBindMethod(This, "ActivatePluginMultiButton")).SetHotkey("^+N", "Ctrl+Shift+N")
        PluginHeader.AddCustomButton("Snapshot menu", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!M", "Alt+M")
        PluginHeader.AddCustomButton("Previous snapshot", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!P", "Alt+P")
        PluginHeader.AddCustomButton("Next snapshot", ObjBindMethod(This, "MoveToPluginSnapshotButton"),,, ObjBindMethod(This, "ActivatePluginSnapshotButton")).SetHotkey("!N", "Alt+N")
        PluginHeader.AddCustomButton("Choose library",,, ObjBindMethod(ChoosePluginOverlay,,,, "O")).SetHotkey("!C", "Alt+C")
        This.PluginHeader := PluginHeader
        
        StandaloneHeader := StandaloneOverlay("Kontakt 8")
        StandaloneHeader.AddCustomButton("Kontakt File Menu", ObjBindMethod(This, "FocusStandaloneHeaderButton"),, ObjBindMethod(This, "ActivateStandaloneHeaderButton")).SetHotkey("!F", "Alt+F")
        StandaloneHeader.AddCustomPassThrough("Standalone", "Tab", "+Tab", WrapStandaloneUIAPassThroughStart.Bind(, AccessibilityOverlay.Helpers.GetUIAWindow, 1), WrapStandaloneUIAPassThroughEnd.Bind(, AccessibilityOverlay.Helpers.GetUIAWindow, 0), ObjBindMethod(This, "HandlePassThrough"),, ObjBindMethod(This, "CheckFocusableElements"))
        This.StandaloneHeader := StandaloneHeader
        
        Plugin.Register("Kontakt 8", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitPlugin"), False, 1, False, ObjBindMethod(This, "CheckPlugin"))
        
        For K8PluginOverlay In This.PluginOverlays {
            K8PluginOverlay.AddControlAt(1, This.PluginHeader)
            Plugin.RegisterOverlay("Kontakt 8", K8PluginOverlay)
        }
        
        Plugin.SetTimer("Kontakt 8", This.CheckPluginConfig, -1)
        Plugin.SetTimer("Kontakt 8", This.CheckPluginMenu, 250)
        
        Plugin.Register("Kontakt 8 Content Missing Dialog", "^NIChildWindow[0-9A-F]{17}$",, False, 1, True, ObjBindMethod(This, "CheckPluginContentMissing"))
        
        PluginContentMissingOverlay := PluginOverlay("Content Missing")
        PluginContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Plugin.RegisterOverlay("Kontakt 8 Content Missing Dialog", PluginContentMissingOverlay)
        
        Standalone.Register("Kontakt 8", "Kontakt 8 ahk_class NINormalWindow* ahk_exe Kontakt 8.exe", False, False, 1)
        Standalone.SetTimer("Kontakt 8", This.CheckStandaloneConfig, -1)
        Standalone.SetTimer("Kontakt 8", This.CheckStandaloneMenu, 250)
        Standalone.RegisterOverlay("Kontakt 8", StandaloneHeader)
        
        Standalone.Register("Kontakt 8 Content Missing Dialog", "Content Missing ahk_class #32770 ahk_exe Kontakt 8.exe", False, False, 1)
        
        StandaloneContentMissingOverlay := StandaloneOverlay("Content Missing")
        StandaloneContentMissingOverlay.AddHotspotButton("Browse For Folder", 218, 341).SetHotkey("!B", "Alt+B")
        Standalone.RegisterOverlay("Kontakt 8 Content Missing Dialog", StandaloneContentMissingOverlay)
    }
    
    Static ActivateHeaderButton(Type, HeaderButton) {
        This.FocusOrActivateHeaderButton("Activate", Type, HeaderButton)
    }
    
    Static ActivatePluginHeaderButton(HeaderButton) {
        This.ActivateHeaderButton("Plugin", HeaderButton)
    }
    
    Static ActivatePluginInstrumentButton(InstrumentButton) {
        Critical
        If This.CheckPluginClassicView() {
            This.MoveToPluginInstrumentButton(InstrumentButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Instrument switching unavailable. Make sure that an instrument is loaded and that you're in classic view.")
    }
    
    Static ActivatePluginMultiButton(MultiButton) {
        Critical
        If This.CheckPluginClassicView() {
            This.MoveToPluginMultiButton(MultiButton)
            Click
            Return
        }
        AccessibilityOverlay.Speak("Multi switching unavailable. Make sure that a multi is loaded and that you're in classic view.")
    }
    
    Static ActivatePluginSnapshotButton(SnapshotButton) {
        Critical
        If This.CheckPluginClassicView() {
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
    
    Static CheckFocusableElements(OverlayObj) {
        If OverlayObj.Label = "Plugin"
        MainElement := This.GetPluginUIAElement()
        Else
        MainElement := AccessibilityOverlay.Helpers.GetUIAWindow().ElementFromPath(1)
        If Not MainElement Is UIA.IUIAutomationElement {
            ReportError(OverlayObj.Label)
            Return
        }
        Elements := AccessibilityOverlay.Helpers.GetFocusableUIAElements(MainElement)
        If Elements.Length = 0 {
            ReportError(OverlayObj.Label)
            Return
        }
        ReportError(Label) {
            If Label = "Plugin"
            AccessibilityOverlay.Speak("Error: The plug-in does not seem to be loaded correctly.")
            Else
            AccessibilityOverlay.Speak("Error: The program does not seem to be loaded correctly.")
        }
    }
    
    Static CheckMenu(Type, OrigHKMode) {
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
        %Type%.SetHotkeyMode("Kontakt 8", OrigHKMode)
        Else
        %Type%.SetHotkeyMode("Kontakt 8", 0)
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
    
    Static CheckPluginClassicView() {
        MainElement := This.GetPluginUIAElement()
        If Not MainElement Is UIA.IUIAutomationElement
        Return False
        ChildElements := AccessibilityOverlay.Helpers.GetUIAElements(MainElement)
        If ChildElements.Length < 6
        Return False
        ElementToCheck := ChildElements[6]
        If ElementToCheck Is UIA.IUIAutomationElement And ElementToCheck.Name = "Restart: Forces a re-initialization of the audio engine in case of CPU overruns or hanging notes."
        If ElementToCheck.Type = 50000
        Return True
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
        UIAElement := This.GetBrowser(Type)
        If UIAElement Is UIA.IUIAutomationElement {
            Try
            UIAElement.Click("Left")
            LastMessage := AccessibilityOverlay.LastMessage
            AccessibilityOverlay.AddToSpeechQueue("Library Browser closed.")
            AccessibilityOverlay.AddToSpeechQueue(LastMessage)
            AccessibilityOverlay.ClearLastMessage()
            AccessibilityOverlay.Speak()
        }
    }
    
    Static ClosePluginBrowser() {
        This.CloseBrowser("Plugin")
    }
    
    Static CloseStandaloneBrowser() {
        This.CloseBrowser("Standalone")
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
        If UIAElement {
            Try
            UIAElement := UIAElement.FindElement({Type: "Button", Name: HeaderButton.Label})
            Catch
            UIAElement := False
            If UIAElement {
                Switch HeaderButton.Label {
                    Case "Kontakt File Menu":
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
            Case "Kontakt File Menu":
            %MouseFunction%(86, 19)
            If Action = "Activate"
            This.Check%Type%Menu()
            Case "Play View":
            %MouseFunction%(185, 19)
            Case "Library":
            %MouseFunction%(213, 19)
            Case "Shop":
            If This.Get%Type%Browser()
            %MouseFunction%(823, 19)
            Else
            %MouseFunction%(462, 19)
            Case "Restart: Forces a re-initialization of the audio engine in case of CPU overruns or hanging notes.":
            If This.Get%Type%Browser()
            %MouseFunction%(963, 19)
            Else
            %MouseFunction%(602, 19)
            Case "About Kontakt":
            If This.Get%Type%Browser()
            %MouseFunction%(986, 19)
            Else
            %MouseFunction%(625, 19)
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
        UIAElement := UIAElement.FindElement({Name: "Close Browser"})
        Catch
        Return False
        If UIAElement.Type = 50000
        Return UIAElement
        Return False
    }
    
    Static GetPluginBrowser() {
        Return This.GetBrowser("Plugin")
    }
    
    Static GetStandaloneBrowser() {
        Return This.GetBrowser("Standalone")
    }
    
    Static HandlePassThrough(OverlayObj) {
        If OverlayObj.Label = "Plugin" {
            FirstItemFunction := FocusFocusablePluginUIAElement.Bind(, This.GetPluginUIAElement, 1)
            LastItemFunction := FocusFocusablePluginUIAElement.Bind(, This.GetPluginUIAElement, 0)
        }
        Else {
            FirstItemFunction := FocusFocusableStandaloneUIAElement.Bind(, AccessibilityOverlay.Helpers.GetUIAWindow, 1)
            LastItemFunction := FocusFocusableStandaloneUIAElement.Bind(, AccessibilityOverlay.Helpers.GetUIAWindow, 0)
        }
        If OverlayObj.LastDirection = 1 And OverlayObj.CurrentItem = 1 {
            FirstItemFunction.Call(OverlayObj)
            Return False
        }
        Else If OverlayObj.LastDirection = 1 {
            Return True
        }
        Else If OverlayObj.LastDirection = -1 And OverlayObj.CurrentItem = OverlayObj.Size {
            LastItemFunction.Call(OverlayObj)
            Return False
        }
        Else If OverlayObj.LastDirection = -1 {
            Return True
        }
        Else {
            Return False
        }
    }
    
    Static HandlePluginSaveAsMenu(ItemName, ItemNumber, SaveAsMenu) {
        This.HandleSaveAsMenu("Plugin", ItemName, ItemNumber, SaveAsMenu)
    }
    
    Static HandleSaveAsMenu(Type, ItemName, ItemNumber, SaveAsMenu) {
        Critical
        InvokedItem := This.InvokePluginMenuItem("Kontakt File Menu", "Save as", False).Call()
        If InvokedItem {
            If Type = "Plugin"
            MainElement := This.GetPluginUIAElement()
            Else
            MainElement := AccessibilityOverlay.Helpers.GetUIAWindow()
            Try
            Instrument := MainElement.FindElement({Type: "MenuItem", Name: "Instrument #" . ItemNumber . " - ", MatchMode: "StartsWith"})
            Catch
            Instrument := False
            If Instrument Is UIA.IUIAutomationElement {
                Instrument.Click("Left")
            }
            Else {
                AccessibilityOverlay.Helpers.PassThroughHotkey("Left")
            }
        }
        Else {
            AccessibilityOverlay.Speak("No instruments seem to be loaded.")
        }
    }
    
    Static HandleStandaloneSaveAsMenu(ItemName, ItemNumber, SaveAsMenu) {
        This.HandleSaveAsMenu("Standalone", ItemName, ItemNumber, SaveAsMenu)
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "CloseK8Browser", 0, {Label: "Automatically close the library browser in Kontakt 8", Tab: "Kontakt / Komplete Kontrol"})
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "DetectLibsInK8", 1, {Label: "Automatically detect libraries in the Kontakt 8 plug-in"})
    }
    
    Static InitPlugin(PluginInstance) {
        If Not HasProp(PluginInstance.Overlay, "Metadata") {
            PluginInstance.Overlay.Metadata := Map("Product", "None")
            PluginInstance.Overlay.OverlayNumber := 1
        }
    }
    
    Static InvokeMenuItem(Type, MenuName, ItemName, ReportErrors := True) {
        InvocationFunc := Object()
        InvocationFunc.DefineProp("MenuName", {Value: MenuName})
        InvocationFunc.DefineProp("ItemName", {Value: ItemName})
        InvocationFunc.DefineProp("ReportErrors", {Value: ReportErrors})
        InvocationFunc.DefineProp("Type", {Value: Type})
        InvocationFunc.DefineProp("Call", {call: CallInvocationFunc})
        Return InvocationFunc
        CallInvocationFunc(This, OverlayObj := {}) {
            Critical
            If This.Type = "Plugin"
            MainElement := Kontakt8.GetPluginUIAElement()
            Else
            MainElement := AccessibilityOverlay.Helpers.GetUIAWindow()
            If MainElement {
                Try {
                    ButtonElement := MainElement.FindElement({Type: "Button", Name: This.MenuName})
                }
                Catch {
                    If This.ReportErrors
                    ReportMenuNotFound()
                    Return False
                }
                If ButtonElement {
                    ButtonElement.Click("Left")
                    Sleep 250
                    Found := False
                    Try
                    MenuElement := MainElement.FindElement({Type: "Menu"})
                    Catch
                    MenuElement := False
                    If MenuElement Is UIA.IUIAutomationElement And MenuElement.Type = 50009
                    Found := True
                    If Found {
                        Found := False
                        Try
                        ItemElement := MenuElement.FindElement({Type: "MenuItem", Name: This.ItemName})
                        Catch
                        ItemElement := False
                        If ItemElement Is UIA.IUIAutomationElement And ItemElement.Type = 50011
                        Found := True
                        If Found {
                            ItemElement.Click("Left")
                            Return ItemElement
                        }
                        Else {
                            AccessibilityOverlay.Helpers.PassThroughHotkey("Escape")
                            If This.ReportErrors
                            ReportItemNotFound()
                            Return False
                        }
                    }
                }
            }
            If This.ReportErrors
            ReportMenuNotFound()
            Return False
        }
        ReportItemNotFound() {
            AccessibilityOverlay.Speak("Menu item not found")
        }
        ReportMenuNotFound() {
            AccessibilityOverlay.Speak("Menu not found")
        }
    }
    
    Static InvokePluginMenuItem(MenuName, MenuItem, ReportErrors := True) {
        Return This.InvokeMenuItem("Plugin", MenuName, MenuItem, ReportErrors)
    }
    
    Static InvokeStandaloneMenuItem(MenuName, MenuItem, ReportErrors := True) {
        Return This.InvokeMenuItem("Standalone", MenuName, MenuItem, ReportErrors)
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
        If SnapshotButton Is Object And InStr(SnapshotButton.Label, "Snapshot", True) And This.CheckPluginClassicView() {
            OCRResult := AccessibilityOverlay.Helpers.OCR("TesseractBest", ControlX + ControlWidth - 588, ControlY + 109, ControlX + ControlWidth - 588 + 200, ControlY + 129)
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
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Static PluginAutoChangeFunction := ObjBindMethod(AutoChangePluginOverlay,, "Kontakt 8", True, True, "C", 2)
            If ReaHotkey.Config.Get("Config", "CloseK8Browser") = 1
            %ParentClass%.ClosePluginBrowser()
            If ReaHotkey.Config.Get("Config", "DetectLibsInK8") = 1
            Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 500)
            Else
            Plugin.SetTimer("Kontakt 8", PluginAutoChangeFunction, 0)
        }
    }
    
    Class CheckPluginMenu {
        Static Call(*) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Static OrigHKMode := Plugin.GetHotkeyMode("Kontakt 8")
            If ReaHotkey.PluginWinCriteria And WinActive(ReaHotkey.PluginWinCriteria)
            %ParentClass%.CheckMenu("Plugin", OrigHKMode)
        }
    }
    
    Class CheckStandaloneConfig {
        Static Call() {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            If ReaHotkey.Config.Get("Config", "CloseK8Browser") = 1
            %ParentClass%.CloseStandaloneBrowser()
        }
    }
    
    Class CheckStandaloneMenu {
        Static Call(*) {
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            Static OrigHKMode := Standalone.GetHotkeyMode("Kontakt 8")
            %ParentClass%.CheckMenu("Standalone", OrigHKMode)
        }
    }
    
    Class GetPluginUIAElement {
        Static Call() {
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
                If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Kontakt 8"
                If UIAElement.Type = 50032 Or UIAElement.Type = 50033
                Return True
                Return False
            }
        }
    }
    
    #IncludeAgain KontaktKompleteKontrol/NoLibraryProduct.ahk
    #IncludeAgain KontaktKompleteKontrol/Audiobro.ahk
    #IncludeAgain KontaktKompleteKontrol/AudioImperia.ahk
    #IncludeAgain KontaktKompleteKontrol/CinematicStudioSeries.ahk
    #IncludeAgain KontaktKompleteKontrol/ImpactSoundworks.ahk
    #IncludeAgain KontaktKompleteKontrol/Soundiron.ahk
    
}
