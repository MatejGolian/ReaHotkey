#Requires AutoHotkey v2.0

Class AccessibilityOverlay {
    
    ControlID := 0
    ControlType := "Overlay"
    ControlTypeLabel := "overlay"
    Label := ""
    FocusableControlIDs := Array()
    ChildControls := Array()
    CurrentControlID := 0
    SuperordinateControlID := 0
    UnlabelledString := ""
    Static AllControls := Array()
    Static TotalNumberOfControls := 0
    Static JAWS := AccessibilityOverlay.SetupJAWS()
    Static SAPI := AccessibilityOverlay.SetupSAPI()
    Static Translations := AccessibilityOverlay.SetupTranslations()
    
    __New(Label := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    ActivateControl(ControlID) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(ControlID)
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
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
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
        This.FocusableControlIDs := This.GetFocusableControlIDs()
        Return This.ChildControls[This.ChildControls.Length]
    }
    
    AddControlAt(Index, Control) {
        If Index <= 0 Or Index > This.ChildControls.Length
        Index := This.ChildControls.Length + 1
        Control.SuperordinateControlID := This.ControlID
        This.ChildControls.InsertAt(Index, Control)
        This.FocusableControlIDs := This.GetFocusableControlIDs()
        Return This.ChildControls[Index]
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
        For CurrentControl In This.ChildControls {
            Switch(CurrentControl.__Class) {
                Case "AccessibilityOverlay":
                If CurrentControl.ChildControls.Length == 0
                Clone.AddAccessibilityOverlay(CurrentControl.Label)
                Else
                Clone.AddControl(CurrentControl.Clone())
                Case "CustomButton":
                Clone.AddCustomButton(CurrentControl.Label, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
                Case "CustomControl":
                Clone.AddCustomControl(CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
                Case "CustomEdit":
                Clone.AddCustomEdit(CurrentControl.Label, CurrentControl.OnFocusFunction)
                Case "GraphicButton":
                Clone.AddGraphicButton(CurrentControl.Label, CurrentControl.RegionX1Coordinate, CurrentControl.RegionY1Coordinate, CurrentControl.RegionX2Coordinate, CurrentControl.RegionY2Coordinate, CurrentControl.OnImage, CurrentControl.OffImage, CurrentControl.OnHoverImage, CurrentControl.OffHoverImage, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
                Case "GraphicCheckbox":
                Clone.AddGraphicCheckbox(CurrentControl.Label, CurrentControl.RegionX1Coordinate, CurrentControl.RegionY1Coordinate, CurrentControl.RegionX2Coordinate, CurrentControl.RegionY2Coordinate, CurrentControl.CheckedImage, CurrentControl.UncheckedImage, CurrentControl.CheckedHoverImage, CurrentControl.UncheckedHoverImage, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
                Case "HotspotButton":
                Clone.AddHotspotButton(CurrentControl.Label, CurrentControl.XCoordinate, CurrentControl.YCoordinate, CurrentControl.OnFocusFunction, CurrentControl.OnActivateFunction)
                Case "HotspotEdit":
                Clone.AddHotspotEdit(CurrentControl.Label, CurrentControl.XCoordinate, CurrentControl.YCoordinate, CurrentControl.OnFocusFunction)
                Case "SpeechOutput":
                Clone.AddSpeechOutput(CurrentControl.Message)
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
            LastAddedChild := Clone.ChildControls[Clone.ChildControls.Length]
            For PropertyName, PropertyValue In CurrentControl.OwnProps()
            If !HasProp(LastAddedChild, PropertyName)
            LastAddedChild.%PropertyName% := PropertyValue
        }
        For PropertyName, PropertyValue In This.OwnProps()
        If !HasProp(Clone, PropertyName)
        Clone.%PropertyName% := PropertyValue
        Return Clone
    }
    
    FindFocusableControlID(ControlID) {
        FocusableControlIDs := This.GetFocusableControlIDs()
        If FocusableControlIDs.Length > 0
        For Index, Value In FocusableControlIDs
        If Value == ControlID
        Return Index
        Return 0
    }
    
    FocusControl(ControlID) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(ControlID)
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
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
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
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found == 0 Or Found == This.FocusableControlIDs.Length
            This.CurrentControlID := This.FocusableControlIDs[1]
            Else
            This.CurrentControlID := This.FocusableControlIDs[Found + 1]
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
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found <= 1
            This.CurrentControlID := This.FocusableControlIDs[This.FocusableControlIDs.Length]
            Else
            This.CurrentControlID := This.FocusableControlIDs[Found - 1]
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
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
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
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
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
    
    GetChildControl(Index) {
        Return This.ChildControls.Get(Index, 0)
    }
    
    GetCurrentControl() {
        Return AccessibilityOverlay.GetControl(This.CurrentControlID)
    }
    
    GetCurrentControlID() {
        Return This.CurrentControlID
    }
    
    GetFocusableControlIDs() {
        FocusableControlIDs := Array()
        If This.ChildControls.Length > 0
        For CurrentControl In This.ChildControls {
            Switch(CurrentControl.__Class) {
                Case "AccessibilityOverlay":
                If CurrentControl.ChildControls.Length > 0 {
                    CurrentControl.FocusableControlIDs := CurrentControl.GetFocusableControlIDs()
                    For CurrentControlID In CurrentControl.FocusableControlIDs
                    FocusableControlIDs.Push(CurrentControlID)
                }
                Case "TabControl":
                FocusableControlIDs.Push(CurrentControl.ControlID)
                If CurrentControl.Tabs.Length > 0 {
                    CurrentTab := CurrentControl.Tabs[CurrentControl.CurrentTab]
                    If CurrentTab.ChildControls.Length > 0 {
                        CurrentTab.FocusableControlIDs := CurrentTab.GetFocusableControlIDs()
                        For CurrentTabControlID In CurrentTab.FocusableControlIDs
                        FocusableControlIDs.Push(CurrentTabControlID)
                    }
                }
                Default:
                FocusableControlIDs.Push(CurrentControl.ControlID)
            }
        }
        Return FocusableControlIDs
    }
    
    RemoveControl() {
        If This.ChildControls.Length > 0 {
            OldList := This.GetFocusableControlIDs()
            This.ChildControls.Pop()
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            NewList := This.FocusableControlIDs
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found == 0 Or OldList[Found] != NewList[Found]
            If NewList.Length == 0 {
                This.CurrentControlID := 0
            }
            Else If NewList.Length == 1 {
                This.CurrentControlID := NewList[1]
            }
            Else {
                I := NewList.Length
                Loop NewList.Length {
                    If OldList[I] == NewList[I] {
                        This.CurrentControlID := NewList[I]
                        Break
                    }
                    I--
                }
            }
            This.SetCurrentControlID(This.CurrentControlID)
            Return 1
        }
        Return 0
    }
    
    RemoveControlAt(Index) {
        If Index > 0 And Index <= This.ChildControls.Length {
            OldList := This.GetFocusableControlIDs()
            This.ChildControls.RemoveAt(Index)
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            NewList := This.FocusableControlIDs
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found == 0 Or OldList[Found] != NewList[Found]
            If NewList.Length == 0 {
                This.CurrentControlID := 0
            }
            Else If NewList.Length == 1 {
                This.CurrentControlID := NewList[1]
            }
            Else {
                I := NewList.Length
                Loop NewList.Length {
                    If OldList[I] == NewList[I] {
                        This.CurrentControlID := NewList[I]
                        Break
                    }
                    I--
                }
            }
            This.SetCurrentControlID(This.CurrentControlID)
            Return 1
        }
        Return 0
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
                        Found := CurrentControl.FindFocusableControlID(ControlID)
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
                            Found := CurrentTab.FindFocusableControlID(ControlID)
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
    
    Static SetupJAWS() {
        Try
        JAWS := ComObject("FreedomSci.JawsApi")
        Catch
        JAWS := False
        Return JAWS
    }
    
    Static SetupSAPI() {
        Try
        SAPI := ComObject("SAPI.SpVoice")
        Catch
        SAPI := False
        Return SAPI
    }
    
    Static SetupTranslations() {
        English := Map(
        "AccessibilityOverlay", Map(
        "ControlTypeLabel", "overlay",
        "UnlabelledString", ""),
        "CustomButton", Map(
        "ControlTypeLabel", "button",
        "UnlabelledString", "unlabelled"),
        "CustomEdit", Map(
        "ControlTypeLabel", "edit",
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
        "GraphicCheckbox", Map(
        "ControlTypeLabel", "checkbox",
        "NotFoundString", "not found",
        "CheckedString", "checked",
        "UncheckedString", "unchecked",
        "UnlabelledString", "unlabelled"),
        "GraphicTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "HotspotButton", Map(
        "ControlTypeLabel", "button",
        "UnlabelledString", "unlabelled"),
        "HotspotEdit", Map(
        "ControlTypeLabel", "edit",
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
        "CustomEdit", Map(
        "ControlTypeLabel", "editačné",
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
        "GraphicCheckbox", Map(
        "ControlTypeLabel", "začiarkavacie políčko",
        "NotFoundString", "nenájdené",
        "CheckedString", "začiarknuté",
        "UncheckedString", "nezačiarknuté",
        "UnlabelledString", "bez názvu"),
        "GraphicTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "HotspotButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "UnlabelledString", "bez názvu"),
        "HotspotEdit", Map(
        "ControlTypeLabel", "editačné",
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
        "CustomEdit", Map(
        "ControlTypeLabel", "redigera",
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
        "GraphicCheckbox", Map(
        "ControlTypeLabel", "kryssruta",
        "NotFoundString", "hittades ej",
        "CheckedString", "kryssad",
        "UncheckedString", "inte kryssad",
        "UnlabelledString", "namnlös"),
        "GraphicTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "HotspotButton", Map(
        "ControlTypeLabel", "knapp",
        "UnlabelledString", "namnlös"),
        "HotspotEdit", Map(
        "ControlTypeLabel", "redigera",
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
        If (AccessibilityOverlay.JAWS != False And ProcessExist("jfw.exe")) Or (FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And !DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")) {
            If AccessibilityOverlay.JAWS != False And ProcessExist("jfw.exe") {
                AccessibilityOverlay.JAWS.SayString(Message)
            }
            If FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And !DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
                DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
                DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "Wstr", Message)
            }
        }
        Else {
            If AccessibilityOverlay.SAPI != False {
                AccessibilityOverlay.SAPI.Speak("", 0x1|0x2)
                AccessibilityOverlay.SAPI.Speak(Message, 0x1)
            }
        }
    }
    
    Static StopSpeech() {
        If (AccessibilityOverlay.JAWS != False Or !ProcessExist("jfw.exe")) And (!FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") Or DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning"))
        If AccessibilityOverlay.SAPI != False
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
    
    AddCustomEdit(Label, OnFocusFunction := "") {
        Control := CustomEdit(Label, OnFocusFunction)
        Return This.AddControl(Control)
    }
    
    AddGraphicButton(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OnImage, OffImage := "", OnHoverImage := "", OffHoverImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        Control := GraphicButton(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, OnImage, OffImage, OnHoverImage, OffHoverImage, OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddGraphicCheckbox(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, CheckedImage, UncheckedImage, CheckedHoverImage := "", UncheckedHoverImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        Control := GraphicCheckbox(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, CheckedImage, UncheckedImage, CheckedHoverImage, UncheckedHoverImage, OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddHotspotButton(Label, XCoordinate, YCoordinate, OnFocusFunction := "", OnActivateFunction := "") {
        Control := HotspotButton(Label, XCoordinate, YCoordinate, OnFocusFunction, OnActivateFunction)
        Return This.AddControl(Control)
    }
    
    AddHotspotEdit(Label, XCoordinate, YCoordinate, OnFocusFunction := "") {
        Control := HotspotEdit(Label, XCoordinate, YCoordinate, OnFocusFunction)
        Return This.AddControl(Control)
    }
    
    AddSpeechOutput(Message := "") {
        Control := SpeechOutput(Message)
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
        %This.OnActivateFunction.Name%(This)
        Return 1
    }
    
    Focus(CurrentControlID := 0) {
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
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
        %This.OnActivateFunction.Name%(This)
        Return 1
    }
    
    Focus(*) {
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        Return 1
    }
    
}

Class CustomEdit {
    
    ControlID := 0
    ControlType := "Edit"
    ControlTypeLabel := "edit"
    OnFocusFunction := ""
    Label := ""
    SuperordinateControlID := 0
    Value := ""
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.OnFocusFunction := OnFocusFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Focus(CurrentControlID := 0) {
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Value)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Value)
        }
        Return 1
    }
    
    GetValue() {
        Return This.Value
    }
    
    SetValue(Value) {
        This.Value := Value
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
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        If This.ControlID != ControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
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
                %This.OnActivateFunction.Name%(This)
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
                %This.OnActivateFunction.Name%(This)
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
                %This.OnActivateFunction.Name%(This)
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
                %This.OnActivateFunction.Name%(This)
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.OnActivateFunction != ""
                %This.OnActivateFunction.Name%(This)
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
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
        }
        Else If This.IsToggle == 1 And This.ToggleState == 1 {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
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

Class GraphicCheckbox {
    
    ControlID := 0
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    Label := ""
    SuperordinateControlID := 0
    CheckedImage := ""
    UncheckedImage := ""
    CheckedHoverImage := ""
    UncheckedHoverImage := ""
    RegionX1Coordinate := 0
    RegionY1Coordinate := 0
    RegionX2Coordinate := 0
    RegionY2Coordinate := 0
    OnFocusFunction := ""
    OnActivateFunction := ""
    FoundXCoordinate := 0
    FoundYCoordinate := 0
    ToggleState := 0
    NotFoundString := "not found"
    CheckedString := "checked"
    UncheckedString := "unchecked"
    UnlabelledString := "unlabelled"
    
    __New(Label, RegionX1Coordinate, RegionY1Coordinate, RegionX2Coordinate, RegionY2Coordinate, CheckedImage, UncheckedImage, CheckedHoverImage := "", UncheckedHoverImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Label := Label
        This.RegionX1Coordinate := RegionX1Coordinate
        This.RegionY1Coordinate := RegionY1Coordinate
        This.RegionX2Coordinate := RegionX2Coordinate
        This.RegionY2Coordinate := RegionY2Coordinate
        If CheckedImage == "" Or !FileExist(CheckedImage)
        CheckedImage := ""
        If UncheckedImage == "" Or !FileExist(UncheckedImage)
        UncheckedImage := ""
        If CheckedHoverImage == "" Or !FileExist(CheckedHoverImage)
        CheckedHoverImage := ""
        If UncheckedHoverImage == "" Or !FileExist(UncheckedHoverImage)
        UncheckedHoverImage := ""
        This.CheckedImage := CheckedImage
        This.UncheckedImage := UncheckedImage
        This.CheckedHoverImage := CheckedHoverImage
        This.UncheckedHoverImage := UncheckedHoverImage
        This.OnFocusFunction := OnFocusFunction
        This.OnActivateFunction := OnActivateFunction
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Activate(CurrentControlID := 0) {
        If This.ToggleState == 0 {
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
                %This.OnActivateFunction.Name%(This)
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 0
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.UncheckedString)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.UncheckedString)
                }
                If This.OnActivateFunction != ""
                %This.OnActivateFunction.Name%(This)
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 0
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.UncheckedString)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.UncheckedString)
                }
                If This.OnActivateFunction != ""
                %This.OnActivateFunction.Name%(This)
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
                %This.OnActivateFunction.Name%(This)
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
        If This.CheckedImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.CheckedImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        If This.CheckedHoverImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.CheckedHoverImage) == 1 {
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
        If This.UncheckedImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.UncheckedImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        If This.UncheckedHoverImage != "" And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.RegionX1Coordinate, This.RegionY1Coordinate, This.RegionX2Coordinate, This.RegionY2Coordinate, This.UncheckedHoverImage) == 1 {
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            Return 1
        }
        This.FoundXCoordinate := 0
        This.FoundYCoordinate := 0
        Return 0
    }
    
    Focus(CurrentControlID := 0) {
        If This.ToggleState == 0 {
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                MouseMove This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != CurrentControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
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
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
        }
        Else If This.IsToggle == 1 And This.ToggleState == 1 {
            If This.CheckIfActive() == 1 {
                This.ToggleState := 1
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
            If This.CheckIfInactive() == 1 {
                This.ToggleState := 0
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
                Return 1
            }
        }
        Else {
            If This.CheckIfActive() == 1 {
                If This.OnFocusFunction != ""
                %This.OnFocusFunction.Name%(This)
                Click This.FoundXCoordinate, This.FoundYCoordinate
                If This.ControlID != ControlID {
                    If This.Label == ""
                    AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
                }
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
        %This.OnActivateFunction.Name%(This)
        Return 1
    }
    
    Focus(CurrentControlID := 0) {
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        MouseMove This.XCoordinate, This.YCoordinate
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        Return 1
    }
    
}

Class HotspotEdit {
    
    ControlID := 0
    ControlType := "Edit"
    ControlTypeLabel := "edit"
    OnFocusFunction := ""
    Label := ""
    SuperordinateControlID := 0
    Value := ""
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
    
    Focus(CurrentControlID := 0) {
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        Click This.XCoordinate, This.YCoordinate
        If This.ControlID != CurrentControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Value)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Value)
        }
        Return 1
    }
    
    GetValue() {
        Return This.Value
    }
    
    SetValue(Value) {
        This.Value := Value
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
        If This.OnFocusFunction != ""
        %This.OnFocusFunction.Name%(This)
        Click This.XCoordinate, This.YCoordinate
        If This.ControlID != ControlID {
            If This.Label == ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
        Return 1
    }
    
}

Class SpeechOutput {
    
    ControlID := 0
    ControlType := "SpeechOutput"
    ControlTypeLabel := "speech output"
    Message := ""
    SuperordinateControlID := 0
    
    __New(Message := "") {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        This.Message := Message
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    Focus(*) {
        AccessibilityOverlay.Speak(This.Message)
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
    
    Reset() {
        This.CurrentTab := 1
        For Tab In This.Tabs
        Tab.Reset()
    }
    
}
