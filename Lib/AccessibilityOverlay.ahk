#Requires AutoHotkey v2.0

Class AccessibilityControl {
    
    ControlID := 0
    ControlType := "Control"
    ControlTypeLabel := ""
    SuperordinateControlID := 0
    
    __New() {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    GetMasterControl() {
        CurrentControl := This
        Loop AccessibilityOverlay.TotalNumberOfControls {
            If CurrentControl.SuperordinateControlID = 0
            Return CurrentControl
            CurrentControl := CurrentControl.GetSuperordinateControl()
        }
        Return 0
    }
    
    GetSuperordinateControl() {
        Return AccessibilityOverlay.GetControl(This.SuperordinateControlID)
    }
    
}

Class AccessibilityOverlay Extends AccessibilityControl {
    
    ChildControls := Array()
    ControlType := "Overlay"
    ControlTypeLabel := "overlay"
    CurrentControlID := 0
    DefaultLabel := ""
    FocusableControlIDs := Array()
    Label := ""
    PreviousControlID := 0
    Static AllControls := Array()
    Static CurrentControlID := 0
    Static JAWS := False
    Static LastMessage := ""
    Static PreviousControlID := 0
    Static SAPI := False
    Static TotalNumberOfControls := 0
    
    __New(Label := "") {
        Super.__New()
        This.Label := Label
    }
    
    __Call(Value, Properties) {
        If SubStr(Value, 1, 3) == "Add" And IsSet(%SubStr(Value, 4)%){
            Control := %SubStr(Value, 4)%.Call(Properties*)
            Return This.AddControl(Control)
        }
        Return False
    }
    
    ActivateControl(ControlID) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(ControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(ControlID)
                This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
                If CurrentControl.HasMethod("Activate")
                CurrentControl.Activate()
                This.SetCurrentControlID(ControlID)
            }
        }
    }
    
    ActivateCurrentControl() {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
                This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
                If CurrentControl.HasMethod("Activate")
                CurrentControl.Activate()
                This.SetCurrentControlID(CurrentControl.ControlID)
            }
        }
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
        Clone := AccessibilityControl()
        Clone.Base := This.Base
        Clone.ChildControls := Array()
        Clone.CurrentControlID := 0
        For PropertyName, PropertyValue In This.OwnProps()
        If Not PropertyName = "ChildControls" And Not PropertyName = "ControlID" And Not PropertyName = "CurrentControlID" And Not PropertyName = "SuperordinateControlID"
        Clone.%PropertyName% := PropertyValue
        For CurrentControl In This.ChildControls
        Switch(CurrentControl.__Class) {
            Case "AccessibilityOverlay":
            Clone.AddControl(CurrentControl.Clone())
            Case "TabControl":
            ClonedControl := TabControl()
            For CurrentTab In CurrentControl.Tabs
            ClonedControl.AddTabs(CurrentTab.Clone())
            For PropertyName, PropertyValue In CurrentControl.OwnProps()
            If Not ClonedControl.HasProp(PropertyName)
            ClonedControl.%PropertyName% := PropertyValue
            Else
            If Not PropertyName = "ControlID"And Not PropertyName = "CurrentTab" And Not PropertyName = "SuperordinateControlID" And Not PropertyName = "Tabs"
            If Not ClonedControl.%PropertyName% = PropertyValue
            ClonedControl.%PropertyName% := PropertyValue
            Clone.AddControl(ClonedControl)
            Default:
            ClonedControl := AccessibilityControl()
            ClonedControl.Base := CurrentControl.Base
            For PropertyName, PropertyValue In CurrentControl.OwnProps()
            If Not PropertyName = "ControlID" And Not PropertyName = "SuperordinateControlID"
            ClonedControl.%PropertyName% := PropertyValue
            Clone.AddControl(ClonedControl)
        }
        Return Clone
    }
    
    DecreaseSlider() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl Is GraphicalSlider
                CurrentControl.Decrease()
            }
        }
    }
    
    FindFocusableControlID(ControlID) {
        FocusableControlIDs := This.GetFocusableControlIDs()
        If FocusableControlIDs.Length > 0
        For Index, Value In FocusableControlIDs
        If Value = ControlID
        Return Index
        Return 0
    }
    
    Focus(Speak := True) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0
            This.CurrentControlID := This.FocusableControlIDs[1]
            CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
            This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
            If CurrentControl.HasMethod("Focus")
            CurrentControl.Focus(Speak)
            This.SetCurrentControlID(This.CurrentControlID)
        }
    }
    
    FocusControl(ControlID) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(ControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(ControlID)
                This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
                If CurrentControl.HasMethod("Focus")
                CurrentControl.Focus()
                This.SetCurrentControlID(ControlID)
            }
        }
    }
    
    FocusCurrentControl() {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
                This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
                If CurrentControl.HasMethod("Focus")
                CurrentControl.Focus()
                This.SetCurrentControlID(CurrentControl.controlID)
            }
        }
    }
    
    FocusNextControl() {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 Or Found = This.FocusableControlIDs.Length
            This.CurrentControlID := This.FocusableControlIDs[1]
            Else
            This.CurrentControlID := This.FocusableControlIDs[Found + 1]
            CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
            This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
            If CurrentControl.HasMethod("Focus")
            CurrentControl.Focus()
            This.SetCurrentControlID(This.CurrentControlID)
        }
    }
    
    FocusPreviousControl() {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found <= 1
            This.CurrentControlID := This.FocusableControlIDs[This.FocusableControlIDs.Length]
            Else
            This.CurrentControlID := This.FocusableControlIDs[Found - 1]
            CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
            This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
            If CurrentControl.HasMethod("Focus")
            CurrentControl.Focus()
            This.SetCurrentControlID(This.CurrentControlID)
        }
    }
    
    FocusNextTab() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl Is TabControl {
                    This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
                    CurrentControl.FocusNextTab()
                    This.SetCurrentControlID(CurrentControl.ControlID)
                }
            }
        }
    }
    
    FocusPreviousTab() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl Is TabControl {
                    This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
                    CurrentControl.FocusPreviousTab()
                    This.SetCurrentControlID(CurrentControl.controlID)
                }
            }
        }
    }
    
    GetAllControls() {
        AllControls := Array()
        If This.ChildControls.Length > 0
        For CurrentControl In This.ChildControls {
            Switch(CurrentControl.__Class) {
                Case "AccessibilityOverlay":
                AllControls.Push(CurrentControl)
                If CurrentControl.ChildControls.Length > 0 {
                    For ChildControl In CurrentControl.GetAllControls()
                    AllControls.Push(ChildControl)
                }
                Case "TabControl":
                AllControls.Push(CurrentControl)
                If CurrentControl.Tabs.Length > 0 {
                    For CurrentTab In CurrentControl.Tabs {
                        AllControls.Push(CurrentTab)
                        If CurrentTab.ChildControls.Length > 0 {
                            For CurrentTabControl In CurrentTab.GetAllControls()
                            AllControls.Push(CurrentTabControl)
                        }
                    }
                }
                Default:
                AllControls.Push(CurrentControl)
            }
        }
        Return AllControls
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
    
    GetCurrentControlType() {
        CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
        If CurrentControl Is Object
        Return CurrentControl.ControlType
        Return ""
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
    
    GetFocusableControls() {
        FocusableControls := Array()
        This.FocusableControlIDs := This.GetFocusableControlIDs()
        For FocusableControlID In This.FocusableControlIDs
        FocusableControls.Push(AccessibilityOverlay.GetControl(FocusableControlID))
        Return FocusableControls
    }
    
    GetHotkeys() {
        OverlayHotkeys := Array()
        TempList := Map()
        For OverlayControl In This.GetAllControls()
        If OverlayControl.HasOwnProp("HotkeyCommand") And Not OverlayControl.HotkeyCommand = ""
        TempList.Set(OverlayControl.HotkeyCommand, OverlayControl.HotkeyCommand)
        For OverlayHotkey In TempList
        OverlayHotkeys.Push(OverlayHotkey)
        Return OverlayHotkeys
    }
    
    GetPreviousControl() {
        Return AccessibilityOverlay.GetControl(This.PreviousControlID)
    }
    
    GetReachableControls() {
        ReachableControls := Array()
        For Value In This.GetFocusableControls()
        If Value Is TabControl {
            For TabObject In Value.Tabs
            ReachableControls.Push(TabObject)
        }
        Else {
            ReachableControls.Push(Value)
        }
        Return ReachableControls
    }
    
    IncreaseSlider() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl Is GraphicalSlider
                CurrentControl.Increase()
            }
        }
    }
    
    RemoveControl() {
        If This.ChildControls.Length > 0 {
            OldList := This.GetFocusableControlIDs()
            This.ChildControls.Pop()
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            NewList := This.FocusableControlIDs
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 Or Not OldList[Found] = NewList[Found]
            If NewList.Length = 0 {
                This.CurrentControlID := 0
            }
            Else If NewList.Length = 1 {
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
        }
    }
    
    RemoveControlAt(Index) {
        If Index > 0 And Index <= This.ChildControls.Length {
            OldList := This.GetFocusableControlIDs()
            This.ChildControls.RemoveAt(Index)
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            NewList := This.FocusableControlIDs
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 Or Not OldList[Found] = NewList[Found]
            If NewList.Length = 0 {
                This.CurrentControlID := 0
            }
            Else If NewList.Length = 1 {
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
        }
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
    
    SelectNextOption() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl.ControlType = "ComboBox"
                CurrentControl.SelectNextOption()
            }
        }
    }
    
    SelectPreviousOption() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl.ControlType = "ComboBox"
                CurrentControl.SelectPreviousOption()
            }
        }
    }
    
    SetControlID(Type, ControlID) {
        If Type = "Current" Or Type = "Previous"
        If This.ChildControls.Length > 0 {
            AccessibilityOverlay.%Type%ControlID := ControlID
            This.%Type%ControlID := ControlID
            For CurrentControl In This.ChildControls {
                Switch(CurrentControl.__Class) {
                    Case "AccessibilityOverlay":
                    If CurrentControl.ChildControls.Length > 0 {
                        Found := CurrentControl.FindFocusableControlID(ControlID)
                        If Found > 0
                        CurrentControl.SetControlID(Type, ControlID)
                        Else
                        CurrentControl.%Type%ControlID := 0
                    }
                    Else {
                        CurrentControl.%Type%ControlID := 0
                    }
                    Case "TabControl":
                    If CurrentControl.Tabs.Length > 0 {
                        CurrentTab := CurrentControl.Tabs[CurrentControl.CurrentTab]
                        If CurrentTab.ChildControls.Length > 0 {
                            Found := CurrentTab.FindFocusableControlID(ControlID)
                            If Found > 0
                            CurrentTab.SetControlID(Type, ControlID)
                            Else
                            CurrentTab.%Type%ControlID := 0
                        }
                        Else {
                            CurrentTab.%Type%ControlID := 0
                        }
                    }
                }
            }
        }
        Else {
            This.%Type%ControlID := 0
        }
    }
    
    SetCurrentControlID(ControlID) {
        This.SetControlID("Current", controlID)
    }
    
    SetPreviousControlID(ControlID) {
        This.SetControlID("Previous", controlID)
    }
    
    TriggerHotkey(HotkeyCommand) {
        For ReachableControl In This.GetReachableControls()
        If ReachableControl.HasOwnProp("HotkeyCommand") And ReachableControl.HotkeyCommand = HotkeyCommand {
            ControlToTrigger := ReachableControl
            HotkeyFunctions := ReachableControl.HotkeyFunctions
            HotkeyTarget := ReachableControl
            If ReachableControl.ControlType = "Tab" {
                ControlToTrigger := ReachableControl.GetSuperordinateControl()
                TabNumber := 1
                For TabIndex, TabObject In ControlToTrigger.Tabs
                If TabObject = ReachableControl {
                    TabNumber := TabIndex
                    Break
                }
                ControlToTrigger.CurrentTab := TabNumber
            }
            This.SetPreviousControlID(AccessibilityOverlay.CurrentControlID)
            If ControlToTrigger.HasMethod("Activate")
            This.ActivateControl(ControlToTrigger.ControlID)
            Else
            This.FocusControl(ControlToTrigger.ControlID)
            For HotkeyFunction In HotkeyFunctions
            HotkeyFunction.Call(HotkeyTarget)
            This.SetCurrentControlID(ControlToTrigger.ControlID)
            Break
        }
    }
    
    Static __New() {
        Try
        JAWS := ComObject("FreedomSci.JawsApi")
        Catch
        JAWS := False
        AccessibilityOverlay.JAWS := JAWS
        Try
        SAPI := ComObject("SAPI.SpVoice")
        Catch
        SAPI := False
        AccessibilityOverlay.SAPI := SAPI
    }
    
    Static GetAllControls() {
        Return AccessibilityOverlay.AllControls
    }
    
    Static GetControl(ControlID) {
        If ControlID > 0 And AccessibilityOverlay.AllControls.Length > 0 And AccessibilityOverlay.AllControls.Length >= ControlID
        Return AccessibilityOverlay.AllControls[ControlID]
        Return 0
    }
    
    Static OCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1) {
        If IsSet(OCR) {
            AvailableLanguages := OCR.GetAvailableLanguages()
            FirstAvailableLanguage := False
            PreferredLanguage := False
            Loop Parse, AvailableLanguages, "`n" {
                If A_Index = 1 And Not A_LoopField = ""
                FirstAvailableLanguage := A_LoopField
                If A_LoopField = OCRLanguage And Not OCRLanguage = "" {
                    PreferredLanguage := OCRLanguage
                    Break
                }
            }
            If PreferredLanguage = False And Not FirstAvailableLanguage = False {
                OCRResult := OCR.FromWindow("A", FirstAvailableLanguage, OCRScale)
                OCRResult := OCRResult.Crop(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate)
                Return OCRResult.Text
            }
            Else If PreferredLanguage = OCRLanguage{
                OCRResult := OCR.FromWindow("A", PreferredLanguage, OCRScale)
                OCRResult := OCRResult.Crop(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate)
                Return OCRResult.Text
            }
            Else {
                Return ""
            }
        }
        Return ""
    }
    
    Static Speak(Message) {
        If Not Message = "" {
            AccessibilityOverlay.LastMessage := Message
            If (Not AccessibilityOverlay.JAWS = False And ProcessExist("jfw.exe")) Or (FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And Not DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")) {
                If Not AccessibilityOverlay.JAWS = False And ProcessExist("jfw.exe") {
                    AccessibilityOverlay.JAWS.SayString(Message)
                }
                If FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And Not DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
                    DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
                    DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "Wstr", Message)
                }
            }
            Else {
                If Not AccessibilityOverlay.SAPI = False {
                    AccessibilityOverlay.SAPI.Speak("", 0x1|0x2)
                    AccessibilityOverlay.SAPI.Speak(Message, 0x1)
                }
            }
        }
    }
    
    Static StopSpeech() {
        If (Not AccessibilityOverlay.JAWS = False Or Not ProcessExist("jfw.exe")) And (Not FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") Or DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning"))
        If Not AccessibilityOverlay.SAPI = False
        AccessibilityOverlay.SAPI.Speak("", 0x1|0x2)
    }
    
}

Class FocusableControl Extends AccessibilityControl {
    
    ControlType := "Focusable"
    DefaultLabel := ""
    DefaultValue := ""
    Focused := 1
    HotkeyCommand := ""
    HotkeyFunctions := Array()
    HotkeyLabel := ""
    Label := ""
    PostExecFocusFunctions := Array()
    PreExecFocusFunctions := Array()
    State := 1
    States := Map()
    Value := ""
    
    __New(Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New()
        This.Label := Label
        If Not PreExecFocusFunctions = "" {
            If Not PreExecFocusFunctions Is Array
            PreExecFocusFunctions := Array(PreExecFocusFunctions)
            For FocusFunction In PreExecFocusFunctions
            If FocusFunction Is Object And FocusFunction.HasMethod("Call")
            This.PreExecFocusFunctions.Push(FocusFunction)
        }
        If Not PostExecFocusFunctions = "" {
            If Not PostExecFocusFunctions Is Array
            PostExecFocusFunctions := Array(PostExecFocusFunctions)
            For FocusFunction In PostExecFocusFunctions
            If FocusFunction Is Object And FocusFunction.HasMethod("Call")
            This.PostExecFocusFunctions.Push(FocusFunction)
        }
    }
    
    CheckFocus() {
        Return True
    }
    
    CheckState() {
        Return True
    }
    
    Focus(Speak := True) {
        If Not This.ControlID = AccessibilityOverlay.CurrentControlID
        For FocusFunction In This.PreExecFocusFunctions
        FocusFunction.Call(This)
        This.CheckFocus()
        If This.HasFocus() {
            If This.HasMethod("ExecuteOnFocusPreSpeech")
            This.ExecuteOnFocusPreSpeech()
            This.CheckState()
            This.SpeakOnFocus(Speak)
            If This.HasMethod("ExecuteOnFocusPostSpeech")
            This.ExecuteOnFocusPostSpeech()
            For FocusFunction In This.PostExecFocusFunctions
            FocusFunction.Call(This)
        }
    }
    
    GetState() {
        Return This.State
    }
    
    GetValue() {
        Return This.Value
    }
    
    HasFocus() {
        Return This.Focused
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.GetValue())
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunctions := "") {
        This.HotkeyCommand := HotkeyCommand
        This.HotkeyLabel := HotkeyLabel
        If Not HotkeyFunctions = "" {
            If Not HotkeyFunctions Is Array
            HotkeyFunctions := Array(HotkeyFunctions)
            For HotkeyFunction In HotkeyFunctions
            If HotkeyFunction Is Object And HotkeyFunction.HasMethod("Call")
            This.HotkeyFunctions.Push(HotkeyFunction)
        }
    }
    
    SetValue(Value) {
        This.Value := Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class ActivatableControl Extends FocusableControl {
    
    ControlType := "Activatable"
    PostExecActivationFunctions := Array()
    PreExecActivationFunctions := Array()
    
    __New(Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        If Not PreExecActivationFunctions = "" {
            If Not PreExecActivationFunctions Is Array
            PreExecActivationFunctions := Array(PreExecActivationFunctions)
            For ActivationFunction In PreExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PreExecActivationFunctions.Push(ActivationFunction)
        }
        If Not PostExecActivationFunctions = "" {
            If Not PostExecActivationFunctions Is Array
            PostExecActivationFunctions := Array(PostExecActivationFunctions)
            For ActivationFunction In PostExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PostExecActivationFunctions.Push(ActivationFunction)
        }
    }
    
    Activate(Speak := True) {
        If Not This.ControlID = AccessibilityOverlay.CurrentControlID
        This.Focus(False)
        This.CheckFocus()
        If This.HasFocus() {
            For ActivationFunction In This.PreExecActivationFunctions
            ActivationFunction.Call(This)
            This.CheckFocus()
            If This.HasFocus() {
                If This.HasMethod("ExecuteOnActivationPreSpeech")
                This.ExecuteOnActivationPreSpeech()
                This.CheckState()
                This.SpeakOnActivation(Speak)
                If This.HasMethod("ExecuteOnActivationPostSpeech")
                This.ExecuteOnActivationPostSpeech()
                For ActivationFunction In This.PostExecActivationFunctions
                ActivationFunction.Call(This)
            }
        }
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString
        Else
        If This.States.Count > 1
        Message := StateString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class FocusableCustom Extends FocusableControl {
    
    SpeakOnFocus(*) {
    }
    
}

Class ActivatableCustom Extends ActivatableControl {
    
    SpeakOnActivation(*) {
    }
    
    SpeakOnFocus(*) {
    }
    
}

Class FocusableGraphic Extends FocusableControl {
    
    FoundXCoordinate := False
    FoundYCoordinate := False
    States := Map(0, "", 1, "")
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", StateParam := "State", ErrorState := 0, Groups := Map()) {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        If Not StateParam = "State" {
            This.DeleteProp("State")
            This.%StateParam% := 1
        }
        If Groups Is Map
        For GroupName, GroupImages In Groups {
            If SubStr(GroupName, 1, 1) Is Number
            GroupName := ""
            This.%GroupName%Images := Array()
            This.Found%GroupName%Image := False
            If Not GroupImages Is Array
            GroupImages := Array(GroupImages)
            For GroupImage In GroupImages
            If GroupImage And Not GroupImage Is Object
            This.%GroupName%Images.Push(GroupImage)
        }
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    CheckFocus(StateParam := "State", ErrorState := 0, Groups := Map()) {
        If Not This.CheckState(StateParam, ErrorState, Groups) {
            This.Focused := 0
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.States[ErrorState])
            Return False
        }
        This.Focused := 1
        Return True
    }
    
    CheckState(StateParam := "state", ErrorState := 0, Groups := Map()) {
        FoundXCoordinate := False
        FoundYCoordinate := False
        If Groups.Count = 0
        Groups := Map(1, 1)
        For GroupName, ReturnState In Groups {
            If SubStr(GroupName, 1, 1) Is Number
            GroupName := ""
            Try
            For Image In This.%GroupName%Images
            If Not Image = "" And FileExist(Image) And Not InStr(FileExist(Image), "D") And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, Image) {
                This.Found%GroupName%Image := Image
                This.FoundXCoordinate := FoundXCoordinate
                This.FoundYCoordinate := FoundYCoordinate
                This.%StateParam% := ReturnState
                Return True
            }
            Catch
            SetFalse()
        }
        SetFalse()
        Return False
        SetFalse() {
            If Not IsSet(GroupName)
            GroupName := ""
            This.Found%GroupName%Image := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.%StateParam% := ErrorState
        }
    }
    
}

Class ActivatableGraphic Extends FocusableGraphic {
    
    ControlType := "Activatable"
    PostExecActivationFunctions := Array()
    PreExecActivationFunctions := Array()
    States := Map(-1, "", 0, "", 1, "")
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", StateParam := "State", ErrorState := 0, Groups := Map()) {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, StateParam, ErrorState, Groups)
        If Not PreExecActivationFunctions = "" {
            If Not PreExecActivationFunctions Is Array
            PreExecActivationFunctions := Array(PreExecActivationFunctions)
            For ActivationFunction In PreExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PreExecActivationFunctions.Push(ActivationFunction)
        }
        If Not PostExecActivationFunctions = "" {
            If Not PostExecActivationFunctions Is Array
            PostExecActivationFunctions := Array(PostExecActivationFunctions)
            For ActivationFunction In PostExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PostExecActivationFunctions.Push(ActivationFunction)
        }
    }
    
    Activate(Speak := True) {
        If Not This.ControlID = AccessibilityOverlay.CurrentControlID
        This.Focus(False)
        This.CheckFocus()
        If This.HasFocus() {
            For ActivationFunction In This.PreExecActivationFunctions
            ActivationFunction.Call(This)
            This.CheckFocus()
            If This.HasFocus() {
                If This.HasMethod("ExecuteOnActivationPreSpeech")
                This.ExecuteOnActivationPreSpeech()
                This.CheckState()
                This.SpeakOnActivation(Speak)
                If This.HasMethod("ExecuteOnActivationPostSpeech")
                This.ExecuteOnActivationPostSpeech()
                For ActivationFunction In This.PostExecActivationFunctions
                ActivationFunction.Call(This)
            }
        }
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString
        Else
        If This.States.Count > 1
        Message := StateString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class FocusableNative Extends FocusableControl {
    
    NativeControlID := ""
    States := Map(-1, "Can not focus control", 0, "not found", 1, "")
    
    __New(NativeControlID, Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        This.NativeControlID := NativeControlID
    }
    
    CheckFocus() {
        Try
        Found := ControlGetHwnd(This.NativeControlID, "A")
        Catch
        Found := False
        If Not Found {
            This.Focused := 0
            AccessibilityOverlay.Speak(This.States[0])
        }
        Else {
            Try {
                This.Focused := 1
                ControlFocus Found, "A"
            }
            Catch {
                This.Focused := 0
                This.State := -1
                AccessibilityOverlay.Speak(This.States[-1])
            }
            If This.Focused
            Return True
        }
        Return False
    }
    
    CheckState() {
        If This.Focused = 0
        Return False
        Try
        Found := ControlGetHwnd(This.NativeControlID, "A")
        Catch
        Found := False
        If Found {
            This.State := 1
            Return True
        }
        Else {
            This.State := 0
            Return False
        }
    }
    
}

Class ActivatableNative Extends FocusableNative {
    
    ControlType := "Activatable"
    PostExecActivationFunctions := Array()
    PreExecActivationFunctions := Array()
    
    __New(NativeControlID, Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(NativeControlID, Label, PreExecFocusFunctions, PostExecFocusFunctions)
        If Not PreExecActivationFunctions = "" {
            If Not PreExecActivationFunctions Is Array
            PreExecActivationFunctions := Array(PreExecActivationFunctions)
            For ActivationFunction In PreExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PreExecActivationFunctions.Push(ActivationFunction)
        }
        If Not PostExecActivationFunctions = "" {
            If Not PostExecActivationFunctions Is Array
            PostExecActivationFunctions := Array(PostExecActivationFunctions)
            For ActivationFunction In PostExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PostExecActivationFunctions.Push(ActivationFunction)
        }
    }
    
    Activate(Speak := True) {
        If Not This.ControlID = AccessibilityOverlay.CurrentControlID
        This.Focus(False)
        This.CheckFocus()
        If This.HasFocus() {
            For ActivationFunction In This.PreExecActivationFunctions
            ActivationFunction.Call(This)
            This.CheckFocus()
            If This.HasFocus() {
                If This.HasMethod("ExecuteOnActivationPreSpeech")
                This.ExecuteOnActivationPreSpeech()
                This.CheckState()
                This.SpeakOnActivation(Speak)
                If This.HasMethod("ExecuteOnActivationPostSpeech")
                This.ExecuteOnActivationPostSpeech()
                For ActivationFunction In This.PostExecActivationFunctions
                ActivationFunction.Call(This)
            }
        }
    }
    
    ExecuteOnActivationPreSpeech() {
        Try {
            Found := ControlGetHwnd(This.NativeControlID, "A")
            ControlClick Found, "A", "Left"
        }
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString
        Else
        If This.States.Count > 1
        Message := StateString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class FocusableUIA Extends FocusableControl {
    
    States := Map("0", "not found", "1", "")
    UIAPath := ""
    
    __New(UIAPath, Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        This.UIAPath := UIAPath
    }
    
    CheckFocus() {
        Try
        Found := This.GetControl()
        Catch
        Found := False
        If Not Found {
            This.Focused := 0
            AccessibilityOverlay.Speak(This.States[0])
        }
        Else {
            This.Focused := 1
            Return True
        }
        Return False
    }
    
    CheckState() {
        Try
        Found := This.GetElement()
        Catch
        Found := False
        If Found {
            This.State := 1
            Return True
        }
        Else {
            This.State := 0
            Return False
        }
    }
    
    ExecuteOnFocusPreSpeech() {
        Try {
            element := This.GetElement()
            element.SetFocus()
        }
    }
    
    GetElement() {
        If Not IsSet(UIA)
        Return False
        Try {
            element := UIA.ElementFromHandle("ahk_id " . WinGetID("A"))
            element := element.ElementFromPath(This.UIAPath)
        }
        Catch {
            Return False
        }
        Return Element
    }
    
}

Class ActivatableUIA Extends FocusableUIA {
    
    ControlType := "Activatable"
    PostExecActivationFunctions := Array()
    PreExecActivationFunctions := Array()
    
    __New(UIAPath, Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(UIAPath, Label, PreExecFocusFunctions, PostExecFocusFunctions)
        If Not PreExecActivationFunctions = "" {
            If Not PreExecActivationFunctions Is Array
            PreExecActivationFunctions := Array(PreExecActivationFunctions)
            For ActivationFunction In PreExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PreExecActivationFunctions.Push(ActivationFunction)
        }
        If Not PostExecActivationFunctions = "" {
            If Not PostExecActivationFunctions Is Array
            PostExecActivationFunctions := Array(PostExecActivationFunctions)
            For ActivationFunction In PostExecActivationFunctions
            If ActivationFunction Is Object And ActivationFunction.HasMethod("Call")
            This.PostExecActivationFunctions.Push(ActivationFunction)
        }
    }
    
    Activate(Speak := True) {
        If Not This.ControlID = AccessibilityOverlay.CurrentControlID
        This.Focus(False)
        This.CheckFocus()
        If This.HasFocus() {
            For ActivationFunction In This.PreExecActivationFunctions
            ActivationFunction.Call(This)
            This.CheckFocus()
            If This.HasFocus() {
                If This.HasMethod("ExecuteOnActivationPreSpeech")
                This.ExecuteOnActivationPreSpeech()
                This.CheckState()
                This.SpeakOnActivation(Speak)
                If This.HasMethod("ExecuteOnActivationPostSpeech")
                This.ExecuteOnActivationPostSpeech()
                For ActivationFunction In This.PostExecActivationFunctions
                ActivationFunction.Call(This)
            }
        }
    }
    
    ExecuteOnActivationPreSpeech() {
        Try {
            element := This.GetElement()
            element.Click("Left")
        }
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString
        Else
        If This.States.Count > 1
        Message := StateString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class Button Extends ActivatableControl {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    DefaultLabel := "unlabelled"
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
    }
    
}

Class ToggleButton Extends Button {
    
    States := Map(-1, "unknown state", 0, "off", 1, "on")
    
}

Class Checkbox Extends ActivatableControl {
    
    Checked := 1
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    DefaultLabel := "unlabelled"
    States := Map(-1, "unknown state", 0, "not checked", 1, "checked")
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        This.DeleteProp("State")
    }
    
    GetState() {
        Return This.Checked
    }
    
}

Class ComboBox Extends FocusableControl {
    
    ChangeFunctions := Array()
    ControlType := "ComboBox"
    ControlTypeLabel := "combo box"
    CurrentOption := 1
    Options := Array()
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", ChangeFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        If Not ChangeFunctions = "" {
            If Not ChangeFunctions Is Array
            ChangeFunctions := Array(ChangeFunctions)
            For ChangeFunction In ChangeFunctions
            If ChangeFunction Is Object And ChangeFunction.HasMethod("Call")
            This.ChangeFunctions.Push(ChangeFunction)
        }
    }
    
    GetValue() {
        If This.CurrentOption > 0 And This.CurrentOption <= This.Options.Length
        This.Value := This.Options[This.CurrentOption]
        Return This.Value
    }
    
    SelectNextOption() {
        CurrentOption := This.CurrentOption
        If This.Options.Length > 0
        If This.CurrentOption < This.Options.Length {
            This.CurrentOption++
            This.Value := This.Options[This.CurrentOption]
        }
        If Not CurrentOption = This.CurrentOption {
            For ChangeFunction In This.ChangeFunctions
            ChangeFunction.Call(This)
            This.ReportValue()
        }
    }
    
    SelectOption(Option) {
        CurrentOption := This.CurrentOption
        If Not Option Is Integer Or Option < 1 Or Option > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := Option
        If This.Options.Has(Option)
        This.Value := This.Options[Option]
        If Not CurrentOption = This.CurrentOption {
            For ChangeFunction In This.ChangeFunctions
            ChangeFunction.Call(This)
            This.ReportValue()
        }
    }
    
    SelectPreviousOption() {
        CurrentOption := This.CurrentOption
        If This.Options.Length > 0
        If This.CurrentOption > 1 {
            This.CurrentOption--
            This.Value := This.Options[This.CurrentOption]
        }
        If Not CurrentOption = This.CurrentOption {
            For ChangeFunction In This.ChangeFunctions
            ChangeFunction.Call(This)
            This.ReportValue()
        }
    }
    
    SetOptions(Options, DefaultOption := 1) {
        If Not Options Is Array
        Options := Array(Options)
        For Option In Options
        If Option And Not Option Is Object
        This.Options.Push(Option)
        If Not DefaultOption Is Integer Or DefaultOption < 1 Or DefaultOption > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := DefaultOption
    }
    
}

Class Edit Extends FocusableControl {
    
    ControlType := "Edit"
    ControlTypeLabel := "edit"
    DefaultLabel := "unlabelled"
    DefaultValue := "blank"
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
    }
    
}

Class Tab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    DefaultLabel := "Unlabelled"
    Focused := 1
    HotkeyCommand := ""
    HotkeyFunctions := Array()
    HotkeyLabel := ""
    PostExecFocusFunctions := Array()
    PreExecFocusFunctions := Array()
    State := 1
    States := Map(0, "not found", 1, "selected")
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label)
        If Not PreExecFocusFunctions = "" {
            If Not PreExecFocusFunctions Is Array
            PreExecFocusFunctions := Array(PreExecFocusFunctions)
            For FocusFunction In PreExecFocusFunctions
            If FocusFunction Is Object And FocusFunction.HasMethod("Call")
            This.PreExecFocusFunctions.Push(FocusFunction)
        }
        If Not PostExecFocusFunctions = "" {
            If Not PostExecFocusFunctions Is Array
            PostExecFocusFunctions := Array(PostExecFocusFunctions)
            For FocusFunction In PostExecFocusFunctions
            If FocusFunction Is Object And FocusFunction.HasMethod("Call")
            This.PostExecFocusFunctions.Push(FocusFunction)
        }
    }
    
    CheckFocus() {
        Return This.Focused
    }
    
    CheckState() {
        Return True
    }
    
    Focus(Speak := True) {
        If Not This.ControlID = AccessibilityOverlay.CurrentControlID
        For FocusFunction In This.PreExecFocusFunctions
        FocusFunction.Call(This)
        This.CheckFocus()
        If This.HasFocus() {
            If This.HasMethod("ExecuteOnFocusPreSpeech")
            This.ExecuteOnFocusPreSpeech()
            This.CheckState()
            This.SpeakOnFocus(Speak)
            If This.HasMethod("ExecuteOnFocusPostSpeech")
            This.ExecuteOnFocusPostSpeech()
            For FocusFunction In This.PostExecFocusFunctions
            FocusFunction.Call(This)
        }
    }
    
    GetState() {
        Return This.State
    }
    
    HasFocus() {
        Return True
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunctions := "") {
        This.HotkeyCommand := HotkeyCommand
        This.HotkeyLabel := HotkeyLabel
        If Not HotkeyFunctions = "" {
            If Not HotkeyFunctions Is Array
            HotkeyFunctions := Array(HotkeyFunctions)
            For HotkeyFunction In HotkeyFunctions
            If HotkeyFunction Is Object And HotkeyFunction.HasMethod("Call")
            This.HotkeyFunctions.Push(HotkeyFunction)
        }
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        Message := LabelString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
        AccessibilityOverlay.LastMessage := Message
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class TabControl Extends FocusableControl {
    
    ControlType := "TabControl"
    ControlTypeLabel := "tab control"
    CurrentTab := 1
    PreviousTab := 0
    Tabs := Array()
    
    __New(Label := "", Tabs*) {
        Super.__New(Label)
        If Tabs.Length > 0
        For TabObject In Tabs
        This.AddTabs(TabObject)
    }
    
    AddTabs(Tabs*) {
        If Tabs.Length > 0
        For TabObject In Tabs {
            TabObject.SuperordinateControlID := This.ControlID
            This.Tabs.Push(TabObject)
        }
    }
    
    Focus(Speak := True) {
        Super.Focus(Speak)
        This.PreviousTab := This.CurrentTab
    }
    
    FocusNextTab(Speak := True) {
        If This.CurrentTab < This.Tabs.Length
        TabNumber := This.CurrentTab + 1
        Else
        TabNumber := 1
        This.CurrentTab := TabNumber
        This.Focus(Speak)
    }
    
    FocusPreviousTab(Speak := True) {
        If This.CurrentTab <= 1
        TabNumber := This.Tabs.Length
        Else
        TabNumber := This.CurrentTab - 1
        This.CurrentTab := TabNumber
        This.Focus(Speak)
    }
    
    GetCurrentTab() {
        Return This.Tabs.Get(This.CurrentTab, 0)
    }
    
    GetTab(TabNumber) {
        Return This.Tabs.Get(TabNumber, 0)
    }
    
    GetValue() {
        Value := ""
        CurrentTab := This.GetCurrentTab()
        If CurrentTab Is Object And CurrentTab.ControlType = "Tab" {
            CurrentTab.Focus(False)
            Value := AccessibilityOverlay.LastMessage
        }
        This.Value := Value
        Return This.Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        If This.controlID = AccessibilityOverlay.PreviousControlID
        If This.CurrentTab = This.PreviousTab And This.Tabs.Length > 1
        ValueString := ""
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.controlID = AccessibilityOverlay.PreviousControlID
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        Else
        Message := ValueString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class CustomButton Extends Button {
}

Class CustomToggleButton Extends ToggleButton {
    
    CheckStateFunction := ""
    
    __New(Label, CheckStateFunction := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        If CheckStateFunction Is Object And CheckStateFunction.HasMethod("Call")
        This.CheckStateFunction := CheckStateFunction
    }
    
    CheckState() {
        If This.CheckStateFunction Is Object And This.CheckStateFunction.HasMethod("Call")
        Return This.CheckStateFunction.Call(This)
    }
    
}

Class CustomCheckbox Extends Checkbox {
    
    CheckStateFunction := ""
    
    __New(Label, CheckStateFunction := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        If CheckStateFunction Is Object And CheckStateFunction.HasMethod("Call")
        This.CheckStateFunction := CheckStateFunction
    }
    
    CheckState() {
        If This.CheckStateFunction Is Object And This.CheckStateFunction.HasMethod("Call")
        This.Checked := This.CheckStateFunction.Call(This)
        Return True
    }
    
}

Class CustomComboBox Extends ComboBox {
}

Class CustomEdit Extends Edit {
}

Class CustomTab Extends Tab {
}

Class GraphicalButton Extends  ActivatableGraphic {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    DefaultLabel := "unlabelled"
    States := Map(0, "not found", 1, "")
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, Images, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, "State", 0, Map(1, Images))
    }
    
    CheckFocus(*) {
        Return Super.CheckFocus("State", 0, Map(1, 1))
    }
    
    CheckState(*) {
        Return Super.CheckState("State", 0, Map(1, 1))
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.FoundXCoordinate, This.FoundYCoordinate
        Sleep 200
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.FoundXCoordinate, This.FoundYCoordinate
    }
    
}

Class GraphicalToggleButton Extends  ActivatableGraphic {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    DefaultLabel := "unlabelled"
    States := Map(-1, "not found", 0, "off", 1, "on")
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImages, OffImages := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, "State", -1, Map("On", OnImages, "Off", OffImages))
    }
    
    CheckFocus(*) {
        Return Super.CheckFocus("State", -1, Map("On", 1, "Off", 0))
    }
    
    CheckState(*) {
        Return Super.CheckState("State", -1, Map("On", 1, "Off", 0))
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.FoundXCoordinate, This.FoundYCoordinate
        Sleep 200
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.FoundXCoordinate, This.FoundYCoordinate
    }
    
}

Class GraphicalCheckbox Extends ActivatableGraphic {
    
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    DefaultLabel := "unlabelled"
    States := Map(-1, "not found", 0, "Not checked", 1, "checked")
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, CheckedImages, UncheckedImages, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, "Checked", -1, Map("Checked", CheckedImages, "Unchecked", UncheckedImages))
    }
    
    CheckFocus(*) {
        Return Super.CheckFocus("Checked", -1, Map("Checked", 1, "Unchecked", 0))
    }
    
    CheckState(*) {
        Return Super.CheckState("Checked", -1, Map("Checked", 1, "Unchecked", 0))
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.FoundXCoordinate, This.FoundYCoordinate
        Sleep 200
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.FoundXCoordinate, This.FoundYCoordinate
    }
    
    GetState() {
        Return This.Checked
    }
    
}

Class GraphicalSlider Extends FocusableGraphic {
    
    ControlType := "Slider"
    ControlTypeLabel := "slider"
    DefaultLabel := "unlabelled"
    End := 0
    Size := 0
    Start := 0
    States := Map(0, "Not Found", 1, "")
    Type := False
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, Images, Start := "", End := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, "State", 0, Map(1, Images))
        This.Label := Label
        If Start = "" {
            If This.Type = "Horizontal"
            Start := X1Coordinate
            Else If This.Type = "Vertical"
            Start := Y1Coordinate
            Else
            Start := 0
        }
        This.Start := Start
        If End = "" {
            If This.Type = "Horizontal"
            End := X2Coordinate
            Else If This.Type = "Vertical"
            End := Y2Coordinate
            Else
            End := 0
        }
        This.End := End
        This.Size := End - Start
    }
    
    Decrease() {
        This.Move(-1)
    }
    
    GetPosition() {
        If This.Type = "Horizontal" {
            If This.FoundXCoordinate <= This.Start
            Return "0 %"
            Else If This.FoundXCoordinate >= This.End
            Return "100 %"
            Else
            Return Round((This.FoundXCoordinate - This.Start) / (This.Size / 100), 0) . " %"
        }
        Else If This.Type = "Vertical" {
            If This.FoundYCoordinate <= This.Y1Coordinate
            Return "100 %"
            Else If This.FoundYCoordinate >= This.Y2Coordinate
            Return "0 %"
            Else
            Return Round((This.End - This.FoundYCoordinate) / (This.Size / 100), 0) . " %"
        }
        Else {
            Return ""
        }
    }
    
    GetValue() {
        This.Value := This.GetPosition()
        Return This.Value
    }
    
    Increase() {
        This.Move(+1)
    }
    
    Move(Value) {
        If This.Type = "Horizontal" Or This.Type = "Vertical" {
            TargetXCoordinate := 0
            TargetYCoordinate := 0
            If This.Type = "Horizontal"
            Coordinate := "X"
            Else
            Coordinate := "Y"
            This.CheckState()
            If This.State = 1 {
                FoundCoordinate := This.Found%Coordinate%Coordinate
                OnePercent := Ceil(This.Size / 100)
                If OnePercent < 1
                OnePercent := 1
                If Value = -1 {
                    Target%Coordinate%Coordinate := This.Found%Coordinate%Coordinate - OnePercent
                }
                Else {
                    Target%Coordinate%Coordinate := This.Found%Coordinate%Coordinate + OnePercent
                }
                If Not Target%Coordinate%Coordinate = This.Found%Coordinate%Coordinate
                While This.Found%Coordinate%Coordinate = FoundCoordinate
                Drag()
            }
            If This.State = 1
            AccessibilityOverlay.Speak(This.GetPosition())
        }
        Drag() {
            If Coordinate = "X"
            MouseClickDrag "Left", This.FoundXCoordinate, This.FoundYCoordinate, TargetXCoordinate, This.FoundYCoordinate, 0
            Else
            MouseClickDrag "Left", This.FoundXCoordinate, This.FoundYCoordinate, This.FoundYCoordinate, TargetYCoordinate, 0
            Sleep 100
            This.CheckState()
        }
    }
    
}

Class GraphicalHorizontalSlider Extends GraphicalSlider {
    
    Type := "Horizontal"
    
}

Class GraphicalVerticalSlider Extends GraphicalSlider {
    
    Type := "Vertical"
    
}

Class GraphicalTab Extends Tab {
    
    FoundImage := False
    FoundXCoordinate := False
    FoundYCoordinate := False
    Images := Array()
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, Images, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label)
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
        If Not Images = "" {
            If Not Images Is Array
            Images := Array(Images)
            For Image In Images
            If Image And Not Image Is Object
            This.Images.Push(Image)
        }
    }
    
    CheckFocus() {
        If Not This.CheckState() {
            This.Focused := 0
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.States[0])
            Return False
        }
        This.Focused := 1
        Return True
    }
    
    CheckState() {
        FoundXCoordinate := False
        FoundYCoordinate := False
        Try
        For Image In This.Images
        If Not Image = "" And FileExist(Image) And Not InStr(FileExist(Image), "D") And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, Image) {
            This.FoundImage := Image
            This.FoundXCoordinate := FoundXCoordinate
            This.FoundYCoordinate := FoundYCoordinate
            This.State := 1
            Return True
        }
        Catch
        SetFalse()
        SetFalse()
        Return False
        SetFalse() {
            This.FoundImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := 0
        }
    }
    
    ExecuteOnFocusPreSpeech() {
        Click This.FoundXCoordinate, This.FoundYCoordinate
    }
    
}

Class HotspotButton Extends Button {
    
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.XCoordinate, This.YCoordinate
    }
    
}

Class HotspotToggleButton Extends ToggleButton {
    
    OffColors := Array()
    OnColors := Array()
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, OnColors, OffColors, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        If Not OnColors = "" {
            If Not OnColors Is Array
            OnColors := Array(OnColors)
            For OnColor In OnColors
            If Not OnColor Is Object
            This.OnColors.Push(OnColor)
        }
        If Not OffColors = "" {
            If Not OffColors Is Array
            OffColors := Array(OffColors)
            For OffColor In OffColors
            If Not OffColor Is Object
            This.OffColors.Push(OffColor)
        }
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    CheckState() {
        Sleep 100
        CurrentColor := PixelGetColor(This.XCoordinate, This.YCoordinate)
        For OnColor In This.OnColors
        If CurrentColor = OnColor {
            This.State := 1
            Return True
        }
        For OffColor In This.OffColors
        If CurrentColor = OffColor {
            This.State := 0
            Return False
        }
        This.State := -1
        Return False
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.XCoordinate, This.YCoordinate
    }
    
}

Class HotspotCheckbox Extends Checkbox {
    
    CheckedColors := Array()
    UncheckedColors := Array()
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, CheckedColors, UncheckedColors, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        If Not CheckedColors = "" {
            If Not CheckedColors Is Array
            CheckedColors := Array(CheckedColors)
            For CheckedColor In CheckedColors
            If Not CheckedColor Is Object
            This.CheckedColors.Push(CheckedColor)
        }
        If Not UncheckedColors = "" {
            If Not UncheckedColors Is Array
            UncheckedColors := Array(UncheckedColors)
            For UncheckedColor In UncheckedColors
            If Not UncheckedColor Is Object
            This.UncheckedColors.Push(UncheckedColor)
        }
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    CheckState() {
        Sleep 100
        CurrentColor := PixelGetColor(This.XCoordinate, This.YCoordinate)
        For CheckedColor In This.CheckedColors
        If CurrentColor = CheckedColor {
            This.Checked := 1
            Return True
        }
        For UncheckedColor In This.UncheckedColors
        If CurrentColor = UncheckedColor {
            This.Checked := 0
            Return False
        }
        This.Checked := -1
        Return False
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.XCoordinate, This.YCoordinate
    }
    
}

Class HotspotComboBox Extends ComboBox {
    
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", ChangeFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, ChangeFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
}

Class HotspotEdit Extends Edit {
    
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
}

Class HotspotTab Extends Tab {
    
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
}

Class OCRButton Extends Button {
    
    DefaultLabel := ""
    OCRLanguage := ""
    OCRScale := 1
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions)
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    ExecuteOnActivationPreSpeech() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        MouseMove XCoordinate, YCoordinate
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        This.Label := LabelString
        If LabelString = ""
        LabelString := This.DefaultLabel
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.controlID = AccessibilityOverlay.PreviousControlID
        Message := LabelString . " " . This.ControlTypeLabel . " " . StateString
        Else
        If This.States.Count > 1
        Message := StateString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If LabelString = ""
        LabelString := This.DefaultLabel
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCRComboBox Extends ComboBox {
    
    OCRLanguage := ""
    OCRScale := 1
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "", ChangeFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, ChangeFunctions)
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
    }
    
    GetValue() {
        This.Value := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        Return This.Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCREdit Extends Edit {
    
    OCRLanguage := ""
    OCRScale := 1
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions)
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
    }
    
    GetValue() {
        This.Value := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        Return This.Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.GetValue()
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCRTab Extends Tab {
    
    DefaultLabel := ""
    OCRLanguage := ""
    OCRScale := 1
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions)
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        This.Label := LabelString
        If LabelString = ""
        LabelString := This.DefaultLabel
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCRText Extends FocusableControl {
    
    ControlType := "Text"
    OCRLanguage := ""
    OCRScale := 1
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions)
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        ValueString := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        This.Value := ValueString
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class StaticText Extends FocusableControl {
    
    ControlType := "Text"
    
    __New(Value := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions := "")
        This.Value := Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        ValueString := This.Value
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.GetMasterControl() Is AccessibilityOverlay And This.GetMasterControl().GetFocusableControlIDs().Length = 1)
        Message := ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}
