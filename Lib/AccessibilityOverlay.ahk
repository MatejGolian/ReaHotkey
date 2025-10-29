﻿#Requires AutoHotkey v2.0

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
    
    __Get(Name, Params) {
        Try
        Return This.Get%Name%()
        Catch As ErrorMessage
        Throw ErrorMessage
    }
    
    GetMasterControl() {
        CurrentControl := This
        Loop AccessibilityOverlay.TotalNumberOfControls {
            If CurrentControl.SuperordinateControlID = 0
            Return CurrentControl
            CurrentControl := CurrentControl.SuperordinateControl
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
    
    ActivateChildNumber(ChildNumber) {
        If This.ChildControls.Length > 0
        If ChildNumber > 0 And This.ChildControls.Length >= ChildNumber {
            ControlID := This.ChildControls[ChildNumber].ControlID
            Return This.ActivateControlID(ControlID)
        }
    }
    
    ActivateControlID(ControlID) {
        If This.ChildControls.Length > 0 {
            If ControlID = This.CurrentControlID {
                Return This.ActivateCurrentControl()
            }
            Else {
                Found := This.FindFocusableControlID(ControlID)
                If Found > 0 {
                    TargetControl := AccessibilityOverlay.GetControl(ControlID)
                    This.SetPreviousControlID(This.CurrentControlID)
                    This.SetCurrentControlID(ControlID)
                    If TargetControl.HasMethod("Activate")
                    TargetControl.Activate()
                    Return TargetControl
                }
            }
        }
    }
    
    ActivateControlNumber(ControlNumber) {
        If This.ChildControls.Length > 0 {
            This.GetFocusableControlIDs()
            If ControlNumber > 0 And This.FocusableControlIDs.Length >= ControlNumber {
                ControlID := This.FocusableControlIDs[ControlNumber]
                If ControlID = This.CurrentControlID {
                    Return This.ActivateCurrentControl()
                }
                Else {
                    TargetControl := AccessibilityOverlay.GetControl(ControlID)
                    This.SetPreviousControlID(This.CurrentControlID)
                    This.SetCurrentControlID(TargetControl.ControlID)
                    If TargetControl.HasMethod("Activate")
                    TargetControl.Activate()
                    Return TargetControl
                }
            }
        }
    }
    
    ActivateCurrentControl() {
        If This.ChildControls.Length > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
                If CurrentControl.ControlType = "Checkbox" Or CurrentControl.ControlType = "ToggleButton" {
                    TruePrev := AccessibilityOverlay.PreviousControlID
                    AccessibilityOverlay.PreviousControlID := CurrentControl.ControlID
                    Speak := True
                }
                Else {
                    Speak := False
                }
                If CurrentControl.HasMethod("Activate")
                CurrentControl.Activate(Speak)
                If CurrentControl.ControlType = "Checkbox" Or CurrentControl.ControlType = "ToggleButton" {
                    AccessibilityOverlay.PreviousControlID := TruePrev
                }
                Return CurrentControl
            }
        }
    }
    
    AddControl(Control) {
        Control.SuperordinateControlID := This.ControlID
        This.ChildControls.Push(Control)
        This.GetFocusableControlIDs()
        If Control.HasOwnProp("HotkeyCommand") And Not Control.HotkeyCommand = ""
        This.RegisterHotkey(Control.HotkeyCommand)
        Return This.ChildControls[This.ChildControls.Length]
    }
    
    AddControlAt(Index, Control) {
        If Index <= 0 Or Index > This.ChildControls.Length
        Index := This.ChildControls.Length + 1
        Control.SuperordinateControlID := This.ControlID
        This.ChildControls.InsertAt(Index, Control)
        This.GetFocusableControlIDs()
        If Control.HasOwnProp("HotkeyCommand") And Not Control.HotkeyCommand = ""
        This.RegisterHotkey(Control.HotkeyCommand)
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
            If CurrentControl Is AccessibilityOverlay {
                Clone.AddControl(CurrentControl.Clone())
            }
            Else {
                ClonedControl := AccessibilityControl()
                ClonedControl.Base := CurrentControl.Base
                For PropertyName, PropertyValue In CurrentControl.OwnProps()
                If Not PropertyName = "ControlID" And Not PropertyName = "SuperordinateControlID"
                ClonedControl.%PropertyName% := PropertyValue
                Clone.AddControl(ClonedControl)
            }
        }
        Return Clone
    }
    
    DecreaseSlider() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
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
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 And This.FocusableControlIDs.Length > 0
            ControlID := This.FocusableControlIDs[1]
            Else
            ControlID := This.CurrentControlID
            If ControlID {
                TargetControl := AccessibilityOverlay.GetControl(ControlID)
                If Not ControlID = This.CurrentControlID
                This.SetPreviousControlID(This.CurrentControlID)
                If TargetControl.HasMethod("Focus") {
                    If Speak And TargetControl.ControlType = "TabControl" {
                        TruePrev := AccessibilityOverlay.PreviousControlID
                        AccessibilityOverlay.PreviousControlID := 0
                    }
                    TargetControl.Focus(Speak)
                    If Speak And TargetControl.ControlType = "TabControl" {
                        AccessibilityOverlay.PreviousControlID := TruePrev
                    }
                }
                This.SetCurrentControlID(ControlID)
                Return TargetControl
            }
        }
    }
    
    FocusChildNumber(ChildNumber) {
        If This.ChildControls.Length > 0
        If ChildNumber > 0 And This.ChildControls.Length >= ChildNumber {
            ControlID := This.ChildControls[ChildNumber].ControlID
            Return This.FocusControlID(ControlID)
        }
    }
    
    FocusControlID(ControlID) {
        If This.ChildControls.Length > 0 {
            Found := This.FindFocusableControlID(ControlID)
            If Found > 0 {
                TargetControl := AccessibilityOverlay.GetControl(ControlID)
                If Not ControlID = This.CurrentControlID
                This.SetPreviousControlID(This.CurrentControlID)
                If TargetControl.HasMethod("Focus")
                TargetControl.Focus()
                This.SetCurrentControlID(ControlID)
                Return TargetControl
            }
        }
    }
    
    FocusControlNumber(ControlNumber) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs :=This.GetFocusableControlIDs()
            If ControlNumber > 0 And This.FocusableControlIDs.Length >= ControlNumber {
                ControlID := This.FocusableControlIDs[ControlNumber]
                TargetControl := AccessibilityOverlay.GetControl(ControlID)
                If Not ControlID = This.CurrentControlID
                This.SetPreviousControlID(This.CurrentControlID)
                If TargetControl.HasMethod("Focus")
                TargetControl.Focus()
                This.SetCurrentControlID(TargetControl.ControlID)
                Return TargetControl
            }
        }
    }
    
    FocusCurrentControl() {
        If This.ChildControls.Length > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
                If CurrentControl.HasMethod("Focus")
                CurrentControl.Focus()
                Return CurrentControl
            }
        }
    }
    
    FocusNextControl() {
        If This.ChildControls.Length > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If This.FocusableControlIDs.Length = 0
            ControlID := 0
            Else If Found = 0 Or Found = This.FocusableControlIDs.Length
            ControlID := This.FocusableControlIDs[1]
            Else
            ControlID := This.FocusableControlIDs[Found + 1]
            TargetControl := AccessibilityOverlay.GetControl(ControlID)
            If Not ControlID = This.CurrentControlID
            This.SetPreviousControlID(This.CurrentControlID)
            If TargetControl Is Object And TargetControl.HasMethod("Focus")
            TargetControl.Focus()
            This.SetCurrentControlID(TargetControl.ControlID)
            Return TargetControl
        }
    }
    
    FocusPreviousControl() {
        If This.ChildControls.Length > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If This.FocusableControlIDs.Length = 0
            ControlID := 0
            Else If Found <= 1
            ControlID := This.FocusableControlIDs[This.FocusableControlIDs.Length]
            Else
            ControlID := This.FocusableControlIDs[Found - 1]
            TargetControl := AccessibilityOverlay.GetControl(ControlID)
            If Not ControlID = This.CurrentControlID
            This.SetPreviousControlID(This.CurrentControlID)
            If TargetControl Is Object And TargetControl.HasMethod("Focus")
            TargetControl.Focus()
            This.SetCurrentControlID(TargetControl.ControlID)
            Return TargetControl
        }
    }
    
    FocusNextTab() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl Is TabControl {
                    This.SetPreviousControlID(This.CurrentControlID)
                    CurrentControl.FocusNextTab()
                    This.SetCurrentControlID(CurrentControl.ControlID)
                    Return CurrentControl.GetCurrentTab()
                }
            }
        }
    }
    
    FocusPreviousTab() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl Is TabControl {
                    This.SetPreviousControlID(This.CurrentControlID)
                    CurrentControl.FocusPreviousTab()
                    This.SetCurrentControlID(CurrentControl.ControlID)
                    Return CurrentControl.GetCurrentTab()
                }
            }
        }
    }
    
    GetAllControls() {
        AllControls := Array()
        If This.ChildControls.Length > 0
        For CurrentControl In This.ChildControls {
            Switch(CurrentControl.__Class) {
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
                If CurrentControl Is AccessibilityOverlay {
                    AllControls.Push(CurrentControl)
                    If CurrentControl.ChildControls.Length > 0 {
                        For ChildControl In CurrentControl.GetAllControls()
                        AllControls.Push(ChildControl)
                    }
                }
                Else {
                    AllControls.Push(CurrentControl)
                }
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
    
    GetCurrentControlNumber() {
        If This.ChildControls.Length > 0
        Return This.FindFocusableControlID(This.CurrentControlID)
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
                If CurrentControl Is AccessibilityOverlay {
                    If CurrentControl.ChildControls.Length > 0 {
                        CurrentControl.FocusableControlIDs := CurrentControl.GetFocusableControlIDs()
                        For CurrentControlID In CurrentControl.FocusableControlIDs
                        FocusableControlIDs.Push(CurrentControlID)
                    }
                }
                Else {
                    FocusableControlIDs.Push(CurrentControl.ControlID)
                }
            }
        }
        This.FocusableControlIDs := FocusableControlIDs
        Return This.FocusableControlIDs
    }
    
    GetFocusableControls() {
        FocusableControls := Array()
        This.GetFocusableControlIDs()
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
        Return AccessibilityOverlay.GetControl(AccessibilityOverlay.PreviousControlID)
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
            NewList := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 Or Not OldList[Found] = NewList[Found]
            If NewList.Length = 0 {
                This.SetCurrentControlID(0)
            }
            Else If NewList.Length = 1 {
                This.SetCurrentControlID(NewList[1])
            }
            Else {
                I := NewList.Length
                Loop NewList.Length {
                    If OldList[I] == NewList[I] {
                        This.SetCurrentControlID(NewList[I])
                        Break
                    }
                    I--
                }
            }
        }
    }
    
    RemoveControlAt(Index) {
        If Index > 0 And Index <= This.ChildControls.Length {
            OldList := This.GetFocusableControlIDs()
            This.ChildControls.RemoveAt(Index)
            NewList := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 Or Not OldList[Found] = NewList[Found]
            If NewList.Length = 0 {
                This.SetCurrentControlID(0)
            }
            Else If NewList.Length = 1 {
                This.SetCurrentControlID(NewList[1])
            }
            Else {
                I := NewList.Length
                Loop NewList.Length {
                    If OldList[I] == NewList[I] {
                        This.SetCurrentControlID(NewList[I])
                        Break
                    }
                    I--
                }
            }
        }
    }
    
    Reset() {
        This.SetCurrentControlID(0)
        If This.ChildControls.Length > 0 {
            For CurrentControl In This.ChildControls
            Switch(CurrentControl.__Class) {
                Case "TabControl":
                If CurrentControl.Tabs.Length > 0 {
                    CurrentControl.CurrentTab := 1
                    For CurrentTab In CurrentControl.Tabs
                    If CurrentTab.ChildControls.Length > 0 {
                        CurrentTab.Reset()
                    }
                }
            }
            Default:
            If CurrentControl Is AccessibilityOverlay {
                If CurrentControl.ChildControls.Length > 0 {
                    CurrentControl.Reset()
                }
            }
        }
    }
    
    SelectNextOption() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl.ControlType = "ComboBox" {
                    CurrentControl.SelectNextOption()
                    Return CurrentControl.GetValue()
                }
            }
        }
    }
    
    SelectPreviousOption() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl.ControlType = "ComboBox" {
                    CurrentControl.SelectPreviousOption()
                    Return CurrentControl.GetValue()
                }
            }
        }
    }
    
    SetCurrentControlID(ControlID) {
        This.CurrentControlID := ControlID
        AccessibilityOverlay.CurrentControlID := ControlID
    }
    
    SetPreviousControlID(ControlID) {
        This.PreviousControlID := ControlID
        AccessibilityOverlay.PreviousControlID := ControlID
    }
    
    TriggerHotkey(HotkeyCommand) {
        For ReachableControl In This.GetReachableControls()
        If ReachableControl.HasOwnProp("HotkeyCommand") And ReachableControl.HotkeyCommand = HotkeyCommand {
            ControlToTrigger := ReachableControl
            HotkeyFunctions := ReachableControl.HotkeyFunctions
            HotkeyTarget := ReachableControl
            If ReachableControl.ControlType = "Tab" {
                ControlToTrigger := ReachableControl.SuperordinateControl
                TabNumber := 1
                For TabIndex, TabObject In ControlToTrigger.Tabs
                If TabObject = ReachableControl {
                    TabNumber := TabIndex
                    Break
                }
                ControlToTrigger.CurrentTab := TabNumber
            }
            If ControlToTrigger.HasMethod("Activate")
            This.ActivateControlID(ControlToTrigger.ControlID)
            Else
            This.FocusControlID(ControlToTrigger.ControlID)
            For HotkeyFunction In HotkeyFunctions
            HotkeyFunction.Call(HotkeyTarget)
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
    
    Static GetImgSize(Img) {
        BaseDir := A_WorkingDir
        If Not SubStr(BaseDir, 0, 1) = "\"
        BaseDir .= "\"
        Img := StrReplace(Img, "/", "\")
        If SubStr(Img, 2, 1) = ":" Or SubStr(Img, 2, 1) = "\"
        SplitPath Img, &FileName, &Dir
        Else
        SplitPath BaseDir . Img, &FileName, &Dir
        (Dir = "" && Dir := BaseDir)
        ObjShell := ComObject("Shell.Application")
        ObjFolder := objShell.NameSpace(Dir), ObjFolderItem := ObjFolder.ParseName(FileName)
        Scale := StrSplit(RegExReplace(ObjFolder.GetDetailsOf(ObjFolderItem, 31), ".(.+).", "$1"), " x ")
        Try
        ReturnObject := {W: Scale[1], H: Scale[2]}
        Catch
        ReturnObject := {W: 0, H: 0}
        Return ReturnObject
    }
    
    Static OCR(OCRType, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "") {
        If OCRType = "Tesseract" Or OCRType = "TesseractLegacy"
        Return AccessibilityOverlay.TesseractOCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, 3)
        Else If OCRType = "TesseractBest"
        Return AccessibilityOverlay.TesseractOCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, 1)
        Else If OCRType = "TesseractFast"
        Return AccessibilityOverlay.TesseractOCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, 2)
        Else
        Return AccessibilityOverlay.UWPOCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale)
    }
    
    Static Speak(Message) {
        Message := Trim(Message)
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
    
    Static TesseractOCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "", OCRType := "") {
        If IsSet(Tesseract) {
            Try {
                If A_CoordModeMouse := "Client"
                WinGetClientPos &WinX, &WinY,,, "A"
                Else
                WinGetPos &WinX, &WinY,,, "A"
            }
            Catch {
                WinX := 0
                WinY := 0
            }
            X1Coordinate := WinX + X1Coordinate
            Y1Coordinate := WinY + Y1Coordinate
            X2Coordinate := WinX + X2Coordinate
            Y2Coordinate := WinY + Y2Coordinate
            RectWidth := X2Coordinate - X1Coordinate
            RectHeight := Y2Coordinate - Y1Coordinate
            Return Trim(Tesseract.FromRect(X1Coordinate, Y1Coordinate, RectWidth, RectHeight, OCRLanguage, OCRScale, OCRType))
        }
        Return ""
    }
    
    Static UWPOCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "") {
        If IsSet(OCR) {
            If A_CoordModeMouse := "Client"
            ClientOnly := 1
            Else
            ClientOnly := 0
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
                If Not OCRScale
                OCRScale := 1
                OCRResult := OCR.FromWindow("A", FirstAvailableLanguage, OCRScale, ClientOnly)
                OCRResult := OCRResult.Crop(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate)
                Return Trim(OCRResult.Text)
            }
            Else If PreferredLanguage = OCRLanguage{
                OCRResult := OCR.FromWindow("A", PreferredLanguage, OCRScale, ClientOnly)
                OCRResult := OCRResult.Crop(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate)
                Return Trim(OCRResult.Text)
            }
            Else {
                Return ""
            }
        }
        Return ""
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
    
    __New(Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
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
        If Not HotkeyCommand = ""
        This.SetHotkey(HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
            This.GetValue()
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
        Value := This.Value
        This.Value := Value
        Return This.Value
    }
    
    HasFocus() {
        Return This.Focused
    }
    
    ReportValue() {
        If Not This.Value = ""
        AccessibilityOverlay.Speak(This.Value)
        Else
        AccessibilityOverlay.Speak(This.DefaultValue)
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
        If This.MasterControl Is AccessibilityOverlay
        This.MasterControl.RegisterHotkey(HotkeyCommand)
        Else
        If This.HasMethod("RegisterHotkey")
        This.RegisterHotkey(HotkeyCommand)
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
        ValueString := This.Value
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class ActivatableControl Extends FocusableControl {
    
    ControlType := "Activatable"
    PostExecActivationFunctions := Array()
    PreExecActivationFunctions := Array()
    
    __New(Label := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
        ValueString := This.Value
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
    
    ControlType := "Custom"
    
    SpeakOnFocus(*) {
    }
    
}

Class ActivatableCustom Extends ActivatableControl {
    
    ControlType := "Custom"
    
    SpeakOnActivation(*) {
    }
    
    SpeakOnFocus(*) {
    }
    
}

Class FocusableGraphic Extends FocusableControl {
    
    FoundImage := False
    FoundXCoordinate := False
    FoundYCoordinate := False
    States := Map(0, "", 1, "")
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", StateParam := "State", ErrorState := 0, Groups := Map(), HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        If Not StateParam = "State" {
            This.DeleteProp("State")
            This.%StateParam% := 1
        }
        If Groups Is Map
        For GroupName, GroupImages In Groups {
            If SubStr(GroupName, 1, 1) Is Number
            GroupName := ""
            This.%GroupName%Images := Array()
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
        FoundImage := False
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
                This.FoundImage := Image
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
            This.FoundImage := False
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
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", StateParam := "State", ErrorState := 0, Groups := Map(), HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, StateParam, ErrorState, Groups, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
        ValueString := This.Value
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
    
    ControlTypeLabel := ""
    NativeControlID := ""
    States := Map(-1, "Can not focus control", 0, "not found", 1, "")
    
    __New(Label, ControlTypeLabel, NativeControlID, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.ControlTypeLabel := ControlTypeLabel
        This.NativeControlID := NativeControlID
    }
    
    CheckFocus() {
        Try
        Found := ControlGetHwnd(This.NativeControlID, "A")
        Catch
        Found := False
        If Not Found {
            This.Focused := 0
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.States[0])
        }
        Else {
            Try {
                This.Focused := 1
                ControlFocus Found, "A"
            }
            Catch {
                This.Focused := 0
                This.State := -1
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.States[-1])
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
    
    __New(Label, ControlTypeLabel, NativeControlID, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, ControlTypeLabel, NativeControlID, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
            ControlClick Found,, "Left"
        }
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.Value
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
    
    ControlTypeLabel := ""
    element := False
    SearchCriteria := ""
    States := Map("0", "not found", "1", "")
    Window := False
    
    __New(Label, ControlTypeLabel, SearchCriteria, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.ControlTypeLabel := ControlTypeLabel
        This.SearchCriteria := SearchCriteria
    }
    
    CheckFocus() {
        Try
        Found := This.FindElement()
        Catch
        Found := False
        If Not Found {
            This.Focused := 0
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.States[0])
        }
        Else {
            This.Focused := 1
            Return True
        }
        Return False
    }
    
    CheckState() {
        Try
        Found := This.FindElement()
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
            element := This.FindElement()
            element.SetFocus()
        }
    }
    
    FindElement() {
        Window := This.GetWindow()
        If Not Window
        Return False
        Try
        Element := Window.FindElement(This.SearchCriteria)
        Catch
        Return False
        This.element := element
        Return Element
    }
    
    GetWindow() {
        If Not IsSet(UIA)
        Return False
        CacheRequest := UIA.CreateCacheRequest(["Type", "LocalizedType", "AutomationId", "Name", "Value", "ClassName", "AcceleratorKey", "WindowCanMaximize"], ["Window"], "Subtree")
        Try
        Window := UIA.ElementFromHandle("ahk_id " . WinGetID("A"), CacheRequest)
        Catch
        Return False
        This.Window := Window
        Return Window
    }
    
}

Class ActivatableUIA Extends FocusableUIA {
    
    ControlType := "Activatable"
    PostExecActivationFunctions := Array()
    PreExecActivationFunctions := Array()
    
    __New(Label, ControlTypeLabel, SearchCriteria, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, ControlTypeLabel, SearchCriteria, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
            element := This.FindElement()
            element.Click("Left")
        }
    }
    
    SpeakOnActivation(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.Value
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
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
    }
    
}

Class ToggleButton Extends Button {
    
    ControlType := "ToggleButton"
    States := Map(-1, "unknown state", 0, "off", 1, "on")
    
}

Class Checkbox Extends ActivatableControl {
    
    Checked := 1
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    DefaultLabel := "unlabelled"
    States := Map(-1, "unknown state", 0, "not checked", 1, "checked")
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", ChangeFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
        For ChangeFunction In This.ChangeFunctions
        ChangeFunction.Call(This)
        This.ReportValue()
    }
    
    SelectOption(Option) {
        CurrentOption := This.CurrentOption
        If Not Option Is Integer Or Option < 1 Or Option > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := Option
        If This.Options.Has(Option)
        This.Value := This.Options[Option]
        For ChangeFunction In This.ChangeFunctions
        ChangeFunction.Call(This)
        This.ReportValue()
    }
    
    SelectPreviousOption() {
        CurrentOption := This.CurrentOption
        If This.Options.Length > 0
        If This.CurrentOption > 1 {
            This.CurrentOption--
            This.Value := This.Options[This.CurrentOption]
        }
        For ChangeFunction In This.ChangeFunctions
        ChangeFunction.Call(This)
        This.ReportValue()
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
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
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
        If Not HotkeyCommand = ""
        This.SetHotkey(HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
        If This.MasterControl Is AccessibilityOverlay
        This.MasterControl.RegisterHotkey(HotkeyCommand)
        Else
        This.RegisterHotkey(HotkeyCommand)
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
    
    GetNextTab() {
        If This.CurrentTab < This.Tabs.Length
        TabNumber := This.CurrentTab + 1
        Else
        TabNumber := 1
        Return This.Tabs.Get(TabNumber, 0)
    }
    
    GetPreviousTab() {
        If This.CurrentTab <= 1
        TabNumber := This.Tabs.Length
        Else
        TabNumber := This.CurrentTab - 1
        Return This.Tabs.Get(TabNumber, 0)
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
        ValueString := This.Value
        If ValueString = ""
        ValueString := This.DefaultValue
        If This.ControlID = AccessibilityOverlay.PreviousControlID
        If This.CurrentTab = This.PreviousTab And This.Tabs.Length > 1
        ValueString := ""
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID
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
    
    __New(Label, CheckStateFunction := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, CheckStateFunction := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, Images, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, "State", 0, Map(1, Images), HotkeyCommand, HotkeyLabel, HotkeyFunctions)
    }
    
    CheckFocus(*) {
        Return Super.CheckFocus("State", 0, Map(1, 1))
    }
    
    CheckState(*) {
        Return Super.CheckState("State", 0, Map(1, 1))
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
        Sleep 200
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
    }
    
}

Class GraphicalToggleButton Extends  ActivatableGraphic {
    
    ControlType := "ToggleButton"
    ControlTypeLabel := "button"
    DefaultLabel := "unlabelled"
    States := Map(-1, "not found", 0, "off", 1, "on")
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImages, OffImages := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, "State", -1, Map("On", OnImages, "Off", OffImages), HotkeyCommand, HotkeyLabel, HotkeyFunctions)
    }
    
    CheckFocus(*) {
        Return Super.CheckFocus("State", -1, Map("On", 1, "Off", 0))
    }
    
    CheckState(*) {
        Return Super.CheckState("State", -1, Map("On", 1, "Off", 0))
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
        Sleep 200
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
    }
    
}

Class GraphicalCheckbox Extends ActivatableGraphic {
    
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    DefaultLabel := "unlabelled"
    States := Map(-1, "not found", 0, "not checked", 1, "checked")
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, CheckedImages, UncheckedImages, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, "Checked", -1, Map("Checked", CheckedImages, "Unchecked", UncheckedImages), HotkeyCommand, HotkeyLabel, HotkeyFunctions)
    }
    
    CheckFocus(*) {
        Return Super.CheckFocus("Checked", -1, Map("Checked", 1, "Unchecked", 0))
    }
    
    CheckState(*) {
        Return Super.CheckState("Checked", -1, Map("Checked", 1, "Unchecked", 0))
    }
    
    ExecuteOnActivationPreSpeech() {
        Click This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
        Sleep 200
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
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
    States := Map(0, "not found", 1, "")
    Type := False
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, Images, Start := "", End := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, PreExecFocusFunctions, PostExecFocusFunctions, "State", 0, Map(1, Images), HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    CenterMouse() {
        MouseMove This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
    }
    
    Decrease() {
        This.Move(-1)
    }
    
    ExecuteOnFocusPreSpeech() {
        This.CenterMouse()
    }
    
    GetPosition() {
        If This.Type = "Horizontal" {
            If This.FoundXCoordinate <= This.Start {
                Return 0
            }
            Else If This.FoundXCoordinate >= This.End {
                Return 100
            }
            Else {
                Position := Round((This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2) - This.Start) / (This.Size / 100), 0)
                If Position > 100
                Position := 100
                Return Position
            }
        }
        Else If This.Type = "Vertical" {
            If This.FoundYCoordinate <= This.Y1Coordinate {
                Return 100
            }
            Else If This.FoundYCoordinate >= This.Y2Coordinate {
                Return 0
            }
            Else {
                Position := Round((This.End - This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)) / (This.Size / 100), 0)
                If Position > 100
                Position := 100
                Return Position
            }
        }
        Else {
            Return ""
        }
    }
    
    GetValue() {
        Position := This.GetPosition()
        If Not Position = ""
        This.Value := This.GetPosition() . " %"
        Else
        This.Value := ""
        Return This.Value
    }
    
    Increase() {
        This.Move(+1)
    }
    
    Move(Value) {
        Critical
        If This.Type = "Horizontal" Or This.Type = "Vertical" {
            TargetCoordinate := 0
            If This.Type = "Horizontal"
            Coordinate := "X"
            Else
            Coordinate := "Y"
            This.CheckState()
            If This.State = 1 {
                StartCoordinate := This.Found%Coordinate%Coordinate
                StartPosition := This.GetPosition()
                CurrentPosition := StartPosition
                If Coordinate = "X"
                StartCoordinate := StartCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2)
                Else
                StartCoordinate := StartCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
                OnePercent := Ceil(This.Size / 100)
                If OnePercent < 1
                OnePercent := 1
                If Value = -1
                TargetCoordinate := StartCoordinate - OnePercent
                Else
                TargetCoordinate := StartCoordinate + OnePercent
                If Not TargetCoordinate = StartCoordinate
                While CurrentPosition = StartPosition {
                    Drag()
                    CurrentPosition := This.GetPosition()
                    If CurrentPosition = 0 And TargetCoordinate < StartCoordinate
                    Break
                    If CurrentPosition = 100 And TargetCoordinate > StartCoordinate
                    Break
                    If CurrentPosition = ""
                    Break
                    If  TargetCoordinate < StartCoordinate
                    TargetCoordinate := TargetCoordinate - 1
                    Else If  TargetCoordinate > StartCoordinate
                    TargetCoordinate := TargetCoordinate + 1
                    Else
                    Break
                }
            }
            If This.State = 1 {
                This.CenterMouse()
                AccessibilityOverlay.Speak(This.GetValue())
            }
        }
        Drag() {
            If Coordinate = "X"
            MouseClickDrag "Left", This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2), TargetCoordinate, This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2), 0
            Else
            MouseClickDrag "Left", This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2), TargetCoordinate, 0
            Sleep 25
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
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, Images, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
        Click This.FoundXCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).W / 2), This.FoundYCoordinate + Floor(AccessibilityOverlay.GetImgSize(This.FoundImage).H / 2)
    }
    
}

Class HotspotButton Extends Button {
    
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    ExecuteOnActivationPostSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.XCoordinate, This.YCoordinate
    }
    
}

Class HotspotToggleButton Extends ToggleButton {
    
    ControlType := "ToggleButton"
    OffColors := Array()
    OnColors := Array()
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, OnColors, OffColors, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, XCoordinate, YCoordinate, CheckedColors, UncheckedColors, PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", ChangeFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, ChangeFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    SelectNextOption() {
        Click This.XCoordinate, This.YCoordinate
        Super.SelectNextOption()
    }
    
    SelectPreviousOption() {
        Click This.XCoordinate, This.YCoordinate
        Super.SelectPreviousOption()
    }
    
}

Class HotspotEdit Extends Edit {
    
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
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
    
    __New(Label, XCoordinate, YCoordinate, PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
}

Class OCRButton Extends Button {
    
    DefaultLabel := ""
    LabelPrefix := ""
    OCRLanguage := ""
    OCRScale := ""
    OCRType := "UWP"
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(LabelPrefix, DefaultLabel, OCRType, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", PreExecActivationFunctions := "", PostExecActivationFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions, PreExecActivationFunctions, PostExecActivationFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.DefaultLabel := DefaultLabel
        This.LabelPrefix := LabelPrefix
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.OCRType := (OCRType = "Tesseract" Or OCRType = "TesseractBest" Or OCRType = "TesseractFast" Or OCRType = "TesseractLegacy" Or OCRType = "UWP" ? OCRType : This.OCRType)
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    ExecuteOnActivationPostSpeech() {
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
        This.Label := AccessibilityOverlay.OCR(This.OCRType, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If This.Label = ""
        This.Label := This.DefaultLabel
        Else
        This.Label := This.LabelPrefix . " " . This.Label
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID
        Message := This.Label . " " . This.ControlTypeLabel . " " . StateString
        Else
        If This.States.Count > 1
        Message := StateString
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        This.Label := AccessibilityOverlay.OCR(This.OCRType, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If This.Label = ""
        This.Label := This.DefaultLabel
        Else
        This.Label := This.LabelPrefix . " " . This.Label
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCRComboBox Extends ComboBox {
    
    OCRLanguage := ""
    OCRScale := ""
    OCRType := "UWP"
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, DefaultValue, OCRType, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", ChangeFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, ChangeFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.DefaultValue := DefaultValue
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.OCRType := (OCRType = "Tesseract" Or OCRType = "TesseractBest" Or OCRType = "TesseractFast" Or OCRType = "TesseractLegacy" Or OCRType = "UWP" ? OCRType : This.OCRType)
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
    }
    
    GetValue() {
        This.Value := AccessibilityOverlay.OCR(This.OCRType, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        Return This.Value
    }
    
    SelectNextOption() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
        If This.ChangeFunctions.Length = 0
        If This.HasMethod("GetValue")
        This.GetValue()
        For ChangeFunction In This.ChangeFunctions {
            If This.HasMethod("GetValue")
            This.GetValue()
            ChangeFunction.Call(This)
        }
        This.ReportValue()
    }
    
    SelectPreviousOption() {
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
        If This.ChangeFunctions.Length = 0
        If This.HasMethod("GetValue")
        This.GetValue()
        For ChangeFunction In This.ChangeFunctions {
            If This.HasMethod("GetValue")
            This.GetValue()
            ChangeFunction.Call(This)
        }
        This.ReportValue()
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.Value
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCREdit Extends Edit {
    
    OCRLanguage := ""
    OCRScale := ""
    OCRType := "UWP"
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(Label, OCRType, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New(Label, PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.OCRType := (OCRType = "Tesseract" Or OCRType = "TesseractBest" Or OCRType = "TesseractFast" Or OCRType = "TesseractLegacy" Or OCRType = "UWP" ? OCRType : This.OCRType)
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
        This.Value := AccessibilityOverlay.OCR(This.OCRType, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        Return This.Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        LabelString := This.Label
        If LabelString = ""
        LabelString := This.DefaultLabel
        ValueString := This.Value
        If ValueString = ""
        ValueString := This.DefaultValue
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCRTab Extends Tab {
    
    DefaultLabel := ""
    OCRLanguage := ""
    OCRScale := ""
    OCRType := "UWP"
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(DefaultLabel, OCRType, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.DefaultLabel := DefaultLabel
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.OCRType := (OCRType = "Tesseract" Or OCRType = "TesseractBest" Or OCRType = "TesseractFast" Or OCRType = "TesseractLegacy" Or OCRType = "UWP" ? OCRType : This.OCRType)
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
        LabelString := AccessibilityOverlay.OCR(This.OCRLanguage, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        This.Label := LabelString
        If LabelString = ""
        LabelString := This.DefaultLabel
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := LabelString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class OCRText Extends FocusableControl {
    
    ControlType := "Text"
    DefaultValue := ""
    OCRLanguage := ""
    OCRScale := ""
    OCRType := "UWP"
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(DefaultValue, OCRType, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.DefaultValue := DefaultValue
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        This.OCRType := (OCRType = "Tesseract" Or OCRType = "TesseractBest" Or OCRType = "TesseractFast" Or OCRType = "TesseractLegacy" Or OCRType = "UWP" ? OCRType : This.OCRType)
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
        ValueString := AccessibilityOverlay.OCR(This.OCRType, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If ValueString = ""
        ValueString := This.DefaultValue
        This.Value := ValueString
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}

Class StaticText Extends FocusableControl {
    
    ControlType := "Text"
    
    __New(Value := "", PreExecFocusFunctions := "", PostExecFocusFunctions := "", HotkeyCommand := "", HotkeyLabel := "", HotkeyFunctions := "") {
        Super.__New("", PreExecFocusFunctions, PostExecFocusFunctions, HotkeyCommand, HotkeyLabel, HotkeyFunctions)
        This.Value := Value
    }
    
    SpeakOnFocus(Speak := True) {
        Message := ""
        CheckResult := This.GetState()
        StateString := ""
        If This.States.Has(CheckResult)
        StateString := This.States[CheckResult]
        ValueString := This.Value
        If Not This.ControlID = AccessibilityOverlay.PreviousControlID Or (This.MasterControl Is AccessibilityOverlay And This.MasterControl.GetFocusableControlIDs().Length = 1)
        Message := ValueString . " " . StateString . " " . This.HotkeyLabel
        If Speak
        AccessibilityOverlay.Speak(Message)
    }
    
}
