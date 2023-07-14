#Requires AutoHotkey v2.0

Class AccessibilityOverlay {
    
    ControlID := 0
    ControlType := "Overlay"
    ControlTypeLabel := "overlay"
    Label := ""
    AllFocusableControls := Array()
    ChildControls := Array()
    CurrentControlID := 0
    SuperordinateControlID := 0
    UnlabelledString := ""
    Static AllControls := Array()
    Static TotalNumberOfControls := 0
    Static SAPI := ComObject("SAPI.SpVoice")
    Static Translations := AccessibilityOverlay.SetupTranslations()
    
    __New(Label := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    ActivateControl(ControlID) {
        If This.ChildControls.Length > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(ControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(ControlID)
                If HasMethod(CurrentControl, "Focus") And ControlID != This.CurrentControlID {
                    CurrentControl.Focus()
                    This.SetCurrentControlID(ControlID)
                }
                If HasMethod(CurrentControl, "Activate") {
                    CurrentControl.Activate(ControlID)
                    This.SetCurrentControlID(ControlID)
                    Return 1
                }
            }
        }
        Return 0
    }
    
    ActivateCurrentControl() {
        If This.ChildControls.Length > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
                If HasMethod(CurrentControl, "Activate")
                CurrentControl.Activate(CurrentControl.ControlID)
                Return 1
            }
        }
        Return 0
    }
    
    AddControl(Control) {
        Control.SuperordinateControlID := This.ControlID
        This.ChildControls.Push(Control)
        Return This.ChildControls[This.ChildControls.Length]
    }
    
    Clone() {
        Switch(This.__Class) {
            Case "AccessibilityOverlay":
            Clone := AccessibilityOverlay(This.Label)
            Case "CustomTab":
            Clone := CustomTab(This.Label, This.OnFocusFunction)
            Case "GraphicTab":
            Clone := GraphicTab(This.Label, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OnImage, This.OffImage, This.OnHoverImage, This.OffHoverImage, This.OnFocusFunction)
            Case "HotspotTab":
            Clone := HotspotTab(This.Label, This.XCoordinate, This.YCoordinate, This.OnFocusFunction)
        }
        If This.ChildControls.Length > 0
        For CurrentControl In This.ChildControls
        Switch(CurrentControl.__Class) {
            Case "AccessibilityOverlay":
            If CurrentControl.ChildControls.Length == 0
            Clone.AddAccessibilityOverlay(CurrentControl.Label)
            Else
            Clone.AddControl(CurrentControl.Clone())
            Case "CustomButton":
            Clone.AddCustomButton(CurrentControl.Label, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
            Case "CustomControl":
            Clone.AddCustomControl(CurrentControl.Label, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
            Case "GraphicButton":
            Clone.AddGraphicButton(CurrentControl.Label, CurrentControl.RegionX1Coordinate, CurrentControl.RegionY1Coordinate, CurrentControl.RegionX2Coordinate, CurrentControl.RegionY2Coordinate, CurrentControl.OnImage, CurrentControl.OffImage, CurrentControl.OnHoverImage, CurrentControl.OffHoverImage, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
            Case "HotspotButton":
            Clone.AddHotspotButton(CurrentControl.Label, CurrentControl.XCoordinate, CurrentControl.YCoordinate, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
            Case "TabControl":
            If CurrentControl.Tabs.Length == 0 {
                Clone.AddTabControl(CurrentControl.Label)
            }
            Else {
                ClonedTabControl := Clone.AddTabControl(CurrentControl.Label)
                For CurrentTab In CurrentControl.Tabs
                ClonedTabControl.AddTabs(CurrentTab.Clone())
            }
        }
        Return Clone
    }
    
    FindFocusableControl(ControlID) {
        AllFocusableControls := This.GetAllFocusableControls()
        If AllFocusableControls.Length > 0
        For Index, Value In AllFocusableControls
        If Value == ControlID
        Return Index
        Return 0
    }
    
    FocusControl(ControlID) {
        If This.ChildControls.Length > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(ControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(ControlID)
                If HasMethod(CurrentControl, "Focus")
                If ControlID != This.CurrentControlID {
                    CurrentControl.Focus()
                    This.SetCurrentControlID(ControlID)
                }
                Else {
                    CurrentControl.Focus(ControlID)
                }
                Return 1
            }
        }
        Return 0
    }
    
    FocusCurrentControl() {
        If This.ChildControls.Length > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
                If HasMethod(CurrentControl, "Focus")
                CurrentControl.Focus()
                Return 1
            }
        }
        Return 0
    }
    
    FocusNextControl() {
        If This.ChildControls.Length > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(This.CurrentControlID)
            If Found == 0 Or Found == This.AllFocusableControls.Length
            This.CurrentControlID := This.AllFocusableControls[1]
            Else
            This.CurrentControlID := This.AllFocusableControls[Found + 1]
            This.SetCurrentControlID(This.CurrentControlID)
            CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
            If HasMethod(CurrentControl, "Focus") {
                CurrentControl.Focus()
                Return 1
            }
        }
        Return 0
    }
    
    FocusPreviousControl() {
        If This.ChildControls.Length > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(This.CurrentControlID)
            If Found <= 1
            This.CurrentControlID := This.AllFocusableControls[This.AllFocusableControls.Length]
            Else
            This.CurrentControlID := This.AllFocusableControls[Found - 1]
            This.SetCurrentControlID(This.CurrentControlID)
            CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
            If HasMethod(CurrentControl, "Focus") {
                CurrentControl.Focus()
                Return 1
            }
        }
        Return 0
    }
    
    FocusNextTab() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.AllFocusableControls[Found])
                If CurrentControl Is TabControl {
                    If CurrentControl.CurrentTab < CurrentControl.Tabs.Length
                    Tab := CurrentControl.CurrentTab + 1
                    Else
                    Tab := 1
                    CurrentControl.CurrentTab := Tab
                    CurrentControl.Focus(CurrentControl.ControlID)
                    Return 1
                }
            }
        }
        Return 0
    }
    
    FocusPreviousTab() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.AllFocusableControls := This.GetAllFocusableControls()
            Found := This.FindFocusableControl(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.AllFocusableControls[Found])
                If CurrentControl Is TabControl {
                    If CurrentControl.CurrentTab <= 1
                    Tab := CurrentControl.Tabs.Length
                    Else
                    Tab := CurrentControl.CurrentTab - 1
                    CurrentControl.CurrentTab := Tab
                    CurrentControl.Focus(CurrentControl.ControlID)
                    Return 1
                }
            }
        }
        Return 0
    }
    
    GetAllFocusableControls() {
        AllFocusableControls := Array()
        If This.ChildControls.Length > 0
        For CurrentControl In This.ChildControls {
            Switch(CurrentControl.__Class) {
                Case "AccessibilityOverlay":
                If CurrentControl.ChildControls.Length > 0 {
                    CurrentControl.AllFocusableControls := CurrentControl.GetAllFocusableControls()
                    For CurrentControlID In CurrentControl.AllFocusableControls
                    AllFocusableControls.Push(CurrentControlID)
                }
                Case "TabControl":
                AllFocusableControls.Push(CurrentControl.ControlID)
                If CurrentControl.Tabs.Length > 0 {
                    CurrentTab := CurrentControl.Tabs[CurrentControl.CurrentTab]
                    If CurrentTab.ChildControls.Length > 0 {
                        CurrentTab.AllFocusableControls := CurrentTab.GetAllFocusableControls()
                        For CurrentTabControlID In CurrentTab.AllFocusableControls
                        AllFocusableControls.Push(CurrentTabControlID)
                    }
                }
                Default:
                AllFocusableControls.Push(CurrentControl.ControlID)
            }
        }
        Return AllFocusableControls
    }
    
    GetCurrentControl() {
        Return AccessibilityOverlay.GetControl(This.CurrentControlID)
    }
    
    GetCurrentControlID() {
        Return This.CurrentControlID
    }
    
    Reset() {
        This.CurrentControlID := 0
        If This.ChildControls.Length > 0 {
            For CurrentControl In This.ChildControls
            Switch(CurrentControl.__Class) {
                Case "AccessibilityOverlay":
                If CurrentControl.ChildControls.Length > 0 {
                    CurrentControl.CurrentControlID := 0
                    CurrentControl.Reset()
                }
                Case "TabControl":
                If CurrentControl.Tabs.Length > 0 {
                    CurrentControl.CurrentTab := 1
                    For CurrentTab In CurrentControl.Tabs
                    If CurrentTab.ChildControls.Length > 0 {
                        CurrentTab.CurrentControlID := 0
                        CurrentTab.Reset()
                    }
                }
            }
        }
    }
    
    SetCurrentControlID(ControlID) {
        If This.ChildControls.Length > 0 {
            This.CurrentControlID := ControlID
            For CurrentControl In This.ChildControls {
                Switch(CurrentControl.__Class) {
                    Case "AccessibilityOverlay":
                    If CurrentControl.ChildControls.Length > 0 {
                        Found := CurrentControl.FindFocusableControl(ControlID)
                        If Found > 0
                        CurrentControl.SetCurrentControlID(ControlID)
                        Else
                        CurrentControl.CurrentControlID := 0
                    }
                    Else {
                        CurrentControl.CurrentControlID := 0
                    }
                    Case "TabControl":
                    If CurrentControl.Tabs.Length > 0 {
                        CurrentTab := CurrentControl.Tabs[CurrentControl.CurrentTab]
                        If CurrentTab.ChildControls.Length > 0 {
                            Found := CurrentTab.FindFocusableControl(ControlID)
                            If Found > 0
                            CurrentTab.SetCurrentControlID(ControlID)
                            Else
                            CurrentTab.CurrentControlID := 0
                        }
                        Else {
                            CurrentTab.CurrentControlID := 0
                        }
                    }
                }
            }
        }
        Else {
            This.CurrentControlID := 0
        }
    }
    
    Translate(Translation := "") {
        If Translation != "" {
            If !(Translation Is Map)
            Translation := AccessibilityOverlay.Translations[Translation]
            If Translation Is Map {
                If Translation[This.__Class] Is Map
                For Key, Value In Translation[This.__Class]
                This.%Key% := Value
                If This.ChildControls.Length > 0
                For CurrentControl In This.ChildControls {
                    If Translation[CurrentControl.__Class] Is Map
                    For Key, Value In Translation[CurrentControl.__Class]
                    CurrentControl.%Key% := Value
                    Switch(CurrentControl.__Class) {
                        Case "AccessibilityOverlay":
                        If CurrentControl.ChildControls.Length > 0 {
                            CurrentControl.Translate(Translation)
                        }
                        Case "TabControl":
                        If CurrentControl.Tabs.Length > 0
                        For CurrentTab In CurrentControl.Tabs {
                            If Translation[CurrentTab.__Class] Is Map
                            For Key, Value In Translation[CurrentTab.__Class]
                            CurrentTab.%Key% := Value
                            If CurrentTab.ChildControls.Length > 0
                            CurrentTab.Translate(Translation)
                        }
                    }
                }
            }
        }
    }
    
    Static GetAllControls() {
        Return AccessibilityOverlay.AllControls
    }
    
    Static GetControl(ControlID) {
        If ControlID > 0 And AccessibilityOverlay.AllControls.Length > 0 And AccessibilityOverlay.AllControls.Length >= ControlID
        Return AccessibilityOverlay.AllControls[ControlID]
        Return 0
    }
    
    Static SetupTranslations() {
        English := Map(
        "AccessibilityOverlay", Map(
        "ControlTypeLabel", "overlay",
        "UnlabelledString", ""),
        "CustomButton", Map(
        "ControlTypeLabel", "button",
        "UnlabelledString", "unlabelled"),
        "CustomTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "GraphicButton", Map(
        "ControlTypeLabel", "button",
        "NotFoundString", "not found",
        "OffString", "off",
        "OnString", "on",
        "UnlabelledString", "unlabelled"),
        "GraphicTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "HotspotButton", Map(
        "ControlTypeLabel", "button",
        "UnlabelledString", "unlabelled"),
        "HotspotTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "TabControl", Map(
        "ControlTypeLabel", "tab control",
        "SelectedString", "selected",
        "NotFoundString", "not found",
        "UnlabelledString", ""))
        English.Default := ""
        Slovak := Map(
        "AccessibilityOverlay", Map(
        "ControlTypeLabel", "pokrývka",
        "UnlabelledString", ""),
        "CustomButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "UnlabelledString", "bez názvu"),
        "CustomTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "GraphicButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "NotFoundString", "nenájdené",
        "OffString", "vypnuté",
        "OnString", "zapnuté",
        "UnlabelledString", "bez názvu"),
        "GraphicTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "HotspotButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "UnlabelledString", "bez názvu"),
        "HotspotTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "TabControl", Map(
        "ControlTypeLabel", "zoznam záložiek",
        "SelectedString", "vybraté",
        "NotFoundString", "nenájdené",
        "UnlabelledString", ""))
        Slovak.Default := ""
        Swedish := Map(
        "AccessibilityOverlay", Map(
        "ControlTypeLabel", "täcke",
        "UnlabelledString", ""),
        "CustomButton", Map(
        "ControlTypeLabel", "knapp",
        "UnlabelledString", "namnlös"),
        "CustomTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "GraphicButton", Map(
        "ControlTypeLabel", "knapp",
        "NotFoundString", "hittades ej",
        "OffString", "av",
        "OnString", "på",
        "UnlabelledString", "namnlös"),
        "GraphicTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "HotspotButton", Map(
        "ControlTypeLabel", "knapp",
        "UnlabelledString", "namnlös"),
        "HotspotTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "TabControl", Map(
        "ControlTypeLabel", "flikar",
        "SelectedString", "markerad",
        "NotFoundString", "hittades ej",
        "UnlabelledString", ""))
        Swedish.Default := ""
        Translations := Map()
        Translations["English"] := English
        Translations["Slovak"] := Slovak
        Translations["Swedish"] := Swedish
        Translations.Default := ""
        Return Translations
    }
    
    Static Speak(Message) {
        If FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And !DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "Wstr", Message)
        }
        Else {
            AccessibilityOverlay.SAPI.Speak("", 0x1|0x2)
            AccessibilityOverlay.SAPI.Speak(Message, 0x1)
        }
    }
    
    Static StopSpeech() {
        If !FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") Or DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")
        AccessibilityOverlay.SAPI.Speak("", 0x1|0x2)
    }
    
    AddAccessibilityOverlay(Label := "") {
        Control := AccessibilityOverlay(Label)
        Return This.AddControl(Control)
    }
    
    AddCustomButton(Label, OnFocusFunction := "", OnActivateFunction := "") {
        Control := CustomButton(Label, OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddCustomControl(OnFocusFunction := "", OnActivateFunction := "") {
        Control := CustomControl(OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddGraphicButton(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OnImage, OffImage := "", OnHoverImage := "", OffHoverImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        Control := GraphicButton(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OnImage, OffImage, OnHoverImage, OffHoverImage, OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddHotspotButton(Label, XCoordinate, YCoordinate, OnFocusFunction := "", OnActivateFunction := "") {
        Control := HotspotButton(Label, XCoordinate, YCoordinate, OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddTabControl(Label := "", Tabs*) {
        Control := TabControl(Label)
        If Tabs.Length > 0
        For Tab In Tabs
        Control.AddTabs(Tab)
        Return This.AddControl(Control)
    }
    
}

Class CustomButton {
    
    ControlID := 0
    ControlType := "Button"
    ControlTypeLabel := "button"
    OnFocusFunction := ""
    OnActivateFunction := ""
    Label := ""
    SuperordinateControlID := 0
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "", OnActivateFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.OnFocusFunction := OnFocusFunction
        This.OnAcTivateFunction := OnActivateFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Activate(CurrentControlID := 0) {
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        If This.OnActivateFunction != ""
        %this.OnActivateFunction%(This)
        Return 1
    }
    
    Focus(CurrentControlID := 0) {
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        If This.OnFocusFunction != ""
        %this.OnFocusFunction%(This)
        Return 1
    }
    
}

Class CustomControl {
    
    ControlID := 0
    ControlType := "Custom"
    ControlTypeLabel := "custom"
    OnFocusFunction := ""
    OnActivateFunction := ""
    SuperordinateControlID := 0
    
    __New(OnFocusFunction := "", OnActivateFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.OnFocusFunction := OnFocusFunction
        This.OnAcTivateFunction := OnActivateFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Activate(*) {
        If This.OnActivateFunction != ""
        %this.OnActivateFunction%(This)
        Return 1
    }
    
    Focus(*) {
        If This.OnFocusFunction != ""
        %this.OnFocusFunction%(This)
        Return 1
    }
    
}

Class CustomTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    OnFocusFunction := ""
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.OnFocusFunction := OnFocusFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Focus(ControlID := 0) {
        If This.ControlID != ControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        If This.OnFocusFunction != ""
        %this.OnFocusFunction%(This)
        Return 1
    }
    
}

Class GraphicButton {
    
    ControlID := 0
    ControlType := "Button"
    ControlTypeLabel := "button"
    Label := ""
    SuperordinateControlID := 0
    OnImage := ""
    OffImage := ""
    OnHoverImage := ""
    OffHoverImage := ""
    RegionX1Coordinate := 0
    RegionY1Coordinate := 0
    RegionX2Coordinate := 0
    RegionY2Coordinate := 0
    OnFocusFunction := ""
    OnActivateFunction := ""
    FoundXCoordinate := 0
    FoundYCoordinate := 0
    IsToggle := 0
    ToggleState := 0
    NotFoundString := "not found"
    OffString := "off"
    OnString := "on"
    UnlabelledString := "unlabelled"
    
    __New(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OnImage, OffImage := "", OnHoverImage := "", OffHoverImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.RegionX1Coordinate := RegionX1Coordinate
        This.RegionY1Coordinate := RegionY1Coordinate
        This.RegionX2Coordinate := RegionX2Coordinate
        This.RegionY2Coordinate := RegionY2Coordinate
        If OnImage == "" Or !FileExist(OnImage)
        OnImage := ""
        If OffImage == "" Or !FileExist(OffImage)
        OffImage := ""
        If OnHoverImage == "" Or !FileExist(OnHoverImage)
        OnHoverImage := ""
        If OffHoverImage == "" Or !FileExist(OffHoverImage)
        OffHoverImage := ""
        If OnImage != "" And OffImage != "" And OnImage != OffImage
        This.IsToggle := 1
        This.OnImage := OnImage
        This.OffImage := OffImage
        This.OnHoverImage := OnHoverImage
        This.OffHoverImage := OffHoverImage
        This.OnFocusFunction := OnFocusFunction
        This.OnActivateFunction := OnActivateFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Activate(CurrentControlID := 0) {
        If This.IsToggle == 1 And This.ToggleState == 0 {
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 1
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.OnString)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.OnString)
                }
                If This.OnActivateFunction != ""
                %this.OnActivateFunction%(This)
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 0
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.OffString)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.OffString)
                }
                If This.OnActivateFunction != ""
                %this.OnActivateFunction%(This)
                Return 1
            }
        }
        Else If This.IsToggle == 1 And This.ToggleState == 1 {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 0
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.OffString)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.OffString)
                }
                If This.OnActivateFunction != ""
                %this.OnActivateFunction%(This)
                Return 1
            }
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 1
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.OnString)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.OnString)
                }
                If This.OnActivateFunction != ""
                %this.OnActivateFunction%(This)
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.OnActivateFunction != ""
                %this.OnActivateFunction%(This)
                Return 1
            }
        }
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString)
        }
        Return 0
    }
    
    CheckIfActive() {
        FoundXCoordinate := 0
        FoundYCoordinate := 0
        If This.OnImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OnImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        If This.OnHoverImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OnHoverImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        This.FoundXCoordinate := 0
        This.FoundYCoordinate := 0
        Return 0
    }
    
    CheckIfInactive() {
        FoundXCoordinate := 0
        FoundYCoordinate := 0
        If This.OffImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OffImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        If This.OffHoverImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OffHoverImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        This.FoundXCoordinate := 0
        This.FoundYCoordinate := 0
        Return 0
    }
    
    Focus(CurrentControlID := 0) {
        If This.IsToggle == 1 And This.ToggleState == 0 {
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
        }
        Else If This.IsToggle == 1 And This.ToggleState == 1 {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
        }
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString)
        }
        Return 0
    }
    
}

Class GraphicTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    OnImage := ""
    OffImage := ""
    OnHoverImage := ""
    OffHoverImage := ""
    RegionX1Coordinate := 0
    RegionY1Coordinate := 0
    RegionX2Coordinate := 0
    RegionY2Coordinate := 0
    OnFocusFunction := ""
    FoundXCoordinate := 0
    FoundYCoordinate := 0
    IsToggle := 0
    ToggleState := 0
    UnlabelledString := "unlabelled"
    
    __New(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OnImage, OffImage := "", OnHoverImage := "", OffHoverImage := "", OnFocusFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.RegionX1Coordinate := RegionX1Coordinate
        This.RegionY1Coordinate := RegionY1Coordinate
        This.RegionX2Coordinate := RegionX2Coordinate
        This.RegionY2Coordinate := RegionY2Coordinate
        If OnImage == "" Or !FileExist(OnImage)
        OnImage := ""
        If OffImage == "" Or !FileExist(OffImage)
        OffImage := ""
        If OnHoverImage == "" Or !FileExist(OnHoverImage)
        OnHoverImage := ""
        If OffHoverImage == "" Or !FileExist(OffHoverImage)
        OffHoverImage := ""
        If OnImage != "" And OffImage != "" And OnImage != OffImage
        This.IsToggle := 1
        This.OnImage := OnImage
        This.OffImage := OffImage
        This.OnHoverImage := OnHoverImage
        This.OffHoverImage := OffHoverImage
        This.OnFocusFunction := OnFocusFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    CheckIfActive() {
        FoundXCoordinate := 0
        FoundYCoordinate := 0
        If This.OnImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OnImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        If This.OnHoverImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OnHoverImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        This.FoundXCoordinate := 0
        This.FoundYCoordinate := 0
        Return 0
    }
    
    CheckIfInactive() {
        FoundXCoordinate := 0
        FoundYCoordinate := 0
        If This.OffImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OffImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        If This.OffHoverImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.OffHoverImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        This.FoundXCoordinate := 0
        This.FoundYCoordinate := 0
        Return 0
    }
    
    Focus(ControlID := 0) {
        If This.IsToggle == 1 And This.ToggleState == 0 {
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
        }
        Else If This.IsToggle == 1 And This.ToggleState == 1 {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                If This.OnFocusFunction != ""
                %this.OnFocusFunction%(This)
                Return 1
            }
        }
        Return 0
    }
    
}

Class HotspotButton {
    
    ControlID := 0
    ControlType := "Button"
    ControlTypeLabel := "button"
    OnFocusFunction := ""
    OnActivateFunction := ""
    Label := ""
    SuperordinateControlID := 0
    XCoordinate := 0
    YCoordinate := 0
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnFocusFunction := "", OnActivateFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
        This.OnFocusFunction := OnFocusFunction
        This.OnAcTivateFunction := OnActivateFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Activate(CurrentControlID := 0) {
        Click This.XCoordinate, This.YCoordinate
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        If This.OnActivateFunction != ""
        %this.OnActivateFunction%(This)
        Return 1
    }
    
    Focus(CurrentControlID := 0) {
        MouseMove This.XCoordinate, This.YCoordinate
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        If This.OnFocusFunction != ""
        %this.OnFocusFunction%(This)
        Return 1
    }
    
}

Class HotspotTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    OnFocusFunction := ""
    XCoordinate := 0
    YCoordinate := 0
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnFocusFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
        This.OnFocusFunction := OnFocusFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Focus(ControlID := 0) {
        Click This.XCoordinate, This.YCoordinate
        If This.ControlID != ControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        If This.OnFocusFunction != ""
        %this.OnFocusFunction%(This)
        Return 1
    }
    
}

Class TabControl {
    
    ControlID := 0
    ControlType := "TabControl"
    ControlTypeLabel := "tab control"
    Label := ""
    SuperordinateControlID := 0
    CurrentTab := 1
    Tabs := Array()
    SelectedString := "selected"
    NotFoundString := "not found"
    UnlabelledString := ""
    
    __New(Label := "", Tabs*) {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        If Tabs.Length > 0
        For Tab In Tabs
        This.AddTabs(Tab)
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    AddTabs(Tabs*) {
        If Tabs.Length > 0
        For Tab In Tabs {
            Tab.SuperordinateControlID := This.ControlID
            This.Tabs.Push(Tab)
        }
    }
    
    Focus(CurrentControlID := 0) {
        If This.Tabs.Length > 0 {
            If This.Tabs[This.CurrentTab].Focus(This.Tabs[This.CurrentTab].ControlID) == 1 {
                If This.ControlID == CurrentControlID {
                    If This.Tabs[This.CurrentTab].Label == ""
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString)
                    Else
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString)
                }
                Else {
                    If This.Label == "" {
                        If This.Tabs[This.CurrentTab].Label == ""
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString)
                        Else
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString)
                    }
                    Else {
                        If This.Tabs[This.CurrentTab].Label == ""
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString)
                        Else
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString)
                    }
                }
            }
            Else {
                If This.ControlID == CurrentControlID {
                    If This.Tabs[This.CurrentTab].Label == ""
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString)
                    Else
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString)
                }
                Else {
                    If This.Label == "" {
                        If This.Tabs[This.CurrentTab].Label == ""
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString)
                        Else
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString)
                    }
                    Else {
                        If This.Tabs[This.CurrentTab].Label == ""
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString)
                        Else
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString)
                    }
                }
            }
        }
        Else {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        Return 1
    }
    
    GetCurrentTab() {
        Return This.Tabs.Get(This.CurrentTab, 0)
    }
    
    GetTab(TabNumber) {
        Return This.Tabs.Get(TabNumber, 0)
    }
    
}
