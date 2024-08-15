#Requires AutoHotkey v2.0

Class AccessibilityControl {
    
    ControlID := 0
    ControlType := "AccessibilityControl"
    SuperordinateControlID := 0
    
    __New() {
        AccessibilityOverlay.TotalNumberOfControls++
        This.ControlID := AccessibilityOverlay.TotalNumberOfControls
        AccessibilityOverlay.AllControls.Push(This)
    }
    
    GetSuperordinateControl() {
        Return AccessibilityOverlay.GetControl(This.SuperordinateControlID)
    }
    
}

Class FocusableCustom Extends AccessibilityControl {
    
    ControlType := "Custom"
    HotkeyCommand := ""
    HotkeyFunction := Array()
    OnFocusFunction := Array()
    
    __New(OnFocusFunction := "") {
        Super.__New()
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class ActivatableCustom Extends AccessibilityControl {
    
    ControlType := "Custom"
    HotkeyCommand := ""
    HotkeyFunction := Array()
    OnActivateFunction := Array()
    OnFocusFunction := Array()
    
    __New(OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New()
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
        If OnActivateFunction != "" {
            If OnActivateFunction Is Array
            This.OnActivateFunction := OnActivateFunction
            Else
            This.OnActivateFunction := Array(OnActivateFunction)
        }
    }
    
    Activate(CurrentControlID := 0) {
        If HasMethod(This, "Focus")
        This.Focus(CurrentControlID)
        For OnActivateFunction In This.OnActivateFunction
        OnActivateFunction.Call(This)
    }
    
    Focus(CurrentControlID := 0) {
        If CurrentControlID != This.ControlID
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class GraphicalControl Extends AccessibilityControl {
    
    ControlType := "Graphic"
    FoundOnImage := False
    FoundXCoordinate := False
    FoundYCoordinate := False
    OnImage := Array()
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    State := 0
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage) {
        Super.__New()
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
        If OnImage = ""
        OnImage := Array()
        If Not OnImage Is Array
        OnImage := Array(OnImage)
        This.OnImage := OnImage
    }
    
    SetState() {
        FoundXCoordinate := False
        FoundYCoordinate := False
        Try {
            For OnImage In This.OnImage
            If OnImage != "" And FileExist(OnImage) And Not InStr(FileExist(OnImage), "D") And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, OnImage) {
                This.FoundOnImage := OnImage
                This.FoundXCoordinate := FoundXCoordinate
                This.FoundYCoordinate := FoundYCoordinate
                This.State := 1
                Return True
            }
            This.FoundOnImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := 0
            Return False
        }
        Catch {
            This.FoundOnImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := 0
            Return False
        }
    }
    
}

Class FocusableGraphic Extends GraphicalControl {
    
    HotkeyCommand := ""
    HotkeyFunction := Array()
    OnFocusFunction := Array()
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OnFocusFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage)
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        This.SetState()
        If This.State = 1 And CurrentControlID != This.ControlID {
            MouseMove This.FoundXCoordinate, This.FoundYCoordinate
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
    SetState() {
        If HasProp(This, "OnFocusFunction")
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
        Super.SetState()
    }
    
}

Class ActivatableGraphic Extends FocusableGraphic {
    
    OnActivateFunction := Array()
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OnFocusFunction)
        If OnActivateFunction != "" {
            If OnActivateFunction Is Array
            This.OnActivateFunction := OnActivateFunction
            Else
            This.OnActivateFunction := Array(OnActivateFunction)
        }
    }
    
    Activate(CurrentControlID := 0) {
        This.SetState()
        If This.State = 1 {
            If HasMethod(This, "Focus")
            This.Focus(CurrentControlID)
            Click This.FoundXCoordinate, This.FoundYCoordinate
            Sleep 250
        }
    }
    
}

Class ToggleableGraphic Extends ActivatableGraphic {
    
    IsToggle := 0
    FoundOffImage := False
    OffImage := Array()
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage := "", OffImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OnFocusFunction, OnActivateFunction)
        If OffImage = ""
        OffImage := Array()
        If Not OffImage Is Array
        OffImage := Array(OffImage)
        This.OffImage := OffImage
        If This.OnImage != Array() And This.OffImage != Array() And This.OnImage != This.OffImage
        This.IsToggle := 1
    }
    
    Activate(CurrentControlID := 0) {
        This.SetState()
        If This.State != -1 {
            If CurrentControlID != This.ControlID
            If HasMethod(This, "Focus")
            This.Focus(CurrentControlID)
            Click This.FoundXCoordinate, This.FoundYCoordinate
            Sleep 250
        }
        This.SetState()
    }
    
    Focus(CurrentControlID := 0) {
        This.SetState()
        If This.State != -1 {
            If CurrentControlID != This.ControlID
            MouseMove This.FoundXCoordinate, This.FoundYCoordinate
        }
    }
    
    SetState() {
        If HasProp(This, "OnFocusFunction")
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
        FoundXCoordinate := False
        FoundYCoordinate := False
        Try {
            For OnImage In This.OnImage
            If OnImage != "" And FileExist(OnImage) And Not InStr(FileExist(OnImage), "D") And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, OnImage) {
                This.FoundOnImage := OnImage
                This.FoundXCoordinate := FoundXCoordinate
                This.FoundYCoordinate := FoundYCoordinate
                This.State := 1
                Return True
            }
            For OffImage In This.OffImage
            If OffImage != "" And FileExist(OffImage) And Not InStr(FileExist(OffImage), "D") And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, OffImage) {
                This.FoundOffImage := OffImage
                This.FoundXCoordinate := FoundXCoordinate
                This.FoundYCoordinate := FoundYCoordinate
                This.State := 0
                Return True
            }
            This.FoundOnImage := False
            This.FoundOffImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := -1
            Return False
        }
        Catch {
            This.FoundOnImage := False
            This.FoundOffImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := -1
            Return False
        }
    }
    
}

Class HotspotControl Extends AccessibilityControl {
    
    ControlType := "Hotspot"
    XCoordinate := 0
    YCoordinate := 0
    
    __New(XCoordinate, YCoordinate) {
        Super.__New()
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
    }
    
}

Class FocusableHotspot Extends HotspotControl {
    
    HotkeyCommand := ""
    HotkeyFunction := Array()
    OnFocusFunction := Array()
    
    __New(XCoordinate, YCoordinate, OnFocusFunction := "") {
        Super.__New(XCoordinate, YCoordinate)
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        If CurrentControlID != This.ControlID {
            For OnFocusFunction In This.OnFocusFunction
            OnFocusFunction.Call(This)
            Click This.XCoordinate, This.YCoordinate
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class ActivatableHotspot Extends HotspotControl {
    
    HotkeyCommand := ""
    HotkeyFunction := Array()
    OnActivateFunction := Array()
    OnFocusFunction := Array()
    
    __New(XCoordinate, YCoordinate, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(XCoordinate, YCoordinate)
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
        If OnActivateFunction != "" {
            If OnActivateFunction Is Array
            This.OnActivateFunction := OnActivateFunction
            Else
            This.OnActivateFunction := Array(OnActivateFunction)
        }
    }
    
    Activate(CurrentControlID := 0) {
        If HasMethod(This, "Focus")
        This.Focus(CurrentControlID)
        For OnActivateFunction In This.OnActivateFunction
        OnActivateFunction.Call(This)
        Click This.XCoordinate, This.YCoordinate
    }
    
    Focus(CurrentControlID := 0) {
        If CurrentControlID != This.ControlID {
            For OnFocusFunction In This.OnFocusFunction
            OnFocusFunction.Call(This)
            MouseMove This.XCoordinate, This.YCoordinate
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class OCRControl Extends AccessibilityControl {
    
    ControlType := "OCR"
    OCRLanguage := ""
    OCRScale := 1
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1) {
        Super.__New()
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
    }
    
}

Class FocusableOCR Extends OCRControl {
    
    HotkeyCommand := ""
    HotkeyFunction := Array()
    OnFocusFunction := Array()
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale)
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        If CurrentControlID != This.ControlID {
            For OnFocusFunction In This.OnFocusFunction
            OnFocusFunction.Call(This)
            XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
            YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
            Click XCoordinate, YCoordinate
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class ActivatableOCR Extends OCRControl {
    
    OnActivateFunction := Array()
    OnFocusFunction := Array()
    HotkeyCommand := ""
    HotkeyFunction := Array()
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale)
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
        If OnActivateFunction != "" {
            If OnActivateFunction Is Array
            This.OnActivateFunction := OnActivateFunction
            Else
            This.OnActivateFunction := Array(OnActivateFunction)
        }
    }
    
    Activate(CurrentControlID := 0) {
        If HasMethod(This, "Focus")
        This.Focus(CurrentControlID)
        For OnActivateFunction In This.OnActivateFunction
        OnActivateFunction.Call(This)
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
    }
    
    Focus(CurrentControlID := 0) {
        If CurrentControlID != This.ControlID {
            For OnFocusFunction In This.OnFocusFunction
            OnFocusFunction.Call(This)
            XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
            YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
            MouseMove XCoordinate, YCoordinate
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class AccessibilityOverlay Extends AccessibilityControl {
    
    ControlType := "Overlay"
    ControlTypeLabel := "overlay"
    Label := ""
    FocusableControlIDs := Array()
    ChildControls := Array()
    CurrentControlID := 0
    UnlabelledString := ""
    Static AllControls := Array()
    Static TotalNumberOfControls := 0
    Static JAWS := AccessibilityOverlay.SetupJAWS()
    Static SAPI := AccessibilityOverlay.SetupSAPI()
    Static Translations := AccessibilityOverlay.SetupTranslations()
    
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
        Clone := AccessibilityControl()
        Clone.Base := This.Base
        Clone.ChildControls := Array()
        Clone.CurrentControlID := 0
        For PropertyName, PropertyValue In This.OwnProps()
        If PropertyName != "ChildControls" And PropertyName != "ControlID" And PropertyName != "CurrentControlID" And PropertyName != "SuperordinateControlID"
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
            If !HasProp(ClonedControl, PropertyName)
            ClonedControl.%PropertyName% := PropertyValue
            Else
            If PropertyName != "ControlID"And PropertyName != "CurrentTab" And PropertyName != "SuperordinateControlID" And PropertyName != "Tabs"
            If ClonedControl.%PropertyName% != PropertyValue
            ClonedControl.%PropertyName% := PropertyValue
            Clone.AddControl(ClonedControl)
            Default:
            ClonedControl := AccessibilityControl()
            ClonedControl.Base := CurrentControl.Base
            For PropertyName, PropertyValue In CurrentControl.OwnProps()
            If PropertyName != "ControlID" And PropertyName != "SuperordinateControlID"
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
                If CurrentControl Is GraphicalSlider {
                    CurrentControl.Decrease()
                    Return 1
                }
            }
        }
        Return 0
    }
    
    FindFocusableControlID(ControlID) {
        FocusableControlIDs := This.GetFocusableControlIDs()
        If FocusableControlIDs.Length > 0
        For Index, Value In FocusableControlIDs
        If Value = ControlID
        Return Index
        Return 0
    }
    
    Focus(ControlID := 0) {
        If This.ChildControls.Length > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0
            This.CurrentControlID := This.FocusableControlIDs[1]
            This.SetCurrentControlID(This.CurrentControlID)
            CurrentControl := AccessibilityOverlay.GetControl(This.CurrentControlID)
            If HasMethod(CurrentControl, "Focus") {
                If This.ControlID != ControlID
                CurrentControl.Focus()
                Else
                CurrentControl.Focus(CurrentControl.ControlID)
                Return 1
            }
        }
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
            If Found = 0 Or Found = This.FocusableControlIDs.Length
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
        If OverlayControl.HasOwnProp("HotkeyCommand") And OverlayControl.HotkeyCommand != ""
        TempList.Set(OverlayControl.HotkeyCommand, OverlayControl.HotkeyCommand)
        For OverlayHotkey In TempList
        OverlayHotkeys.Push(OverlayHotkey)
        Return OverlayHotkeys
    }
    
    GetReachableControls() {
        ReachableControls := Array()
        For Value In This.GetFocusableControls()
        If Value Is TabControl {
            For Tab In Value.Tabs
            ReachableControls.Push(Tab)
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
                If CurrentControl Is GraphicalSlider {
                    CurrentControl.Increase()
                    Return 1
                }
            }
        }
        Return 0
    }
    
    RemoveControl() {
        If This.ChildControls.Length > 0 {
            OldList := This.GetFocusableControlIDs()
            This.ChildControls.Pop()
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            NewList := This.FocusableControlIDs
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found = 0 Or OldList[Found] != NewList[Found]
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
            If Found = 0 Or OldList[Found] != NewList[Found]
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
    
    SelectNextOption() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl.ControlType = "ComboBox" {
                    CurrentOption := CurrentControl.CurrentOption
                    CurrentControl.SelectNextOption()
                    If CurrentOption != CurrentControl.CurrentOption
                    CurrentControl.ReportValue()
                    Return 1
                }
            }
        }
        Return 0
    }
    
    SelectPreviousOption() {
        If This.ChildControls.Length > 0 And This.CurrentControlID > 0 {
            This.FocusableControlIDs := This.GetFocusableControlIDs()
            Found := This.FindFocusableControlID(This.CurrentControlID)
            If Found > 0 {
                CurrentControl := AccessibilityOverlay.GetControl(This.FocusableControlIDs[Found])
                If CurrentControl.ControlType = "ComboBox" {
                    CurrentOption := CurrentControl.CurrentOption
                    CurrentControl.SelectPreviousOption()
                    If CurrentOption != CurrentControl.CurrentOption
                    CurrentControl.ReportValue()
                    Return 1
                }
            }
        }
        Return 0
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
    
    TriggerHotkey(HotkeyCommand) {
        For ReachableControl In This.GetReachableControls()
        If ReachableControl.HasOwnProp("HotkeyCommand") And ReachableControl.HotkeyCommand = HotkeyCommand
        If ReachableControl.ControlType = "Tab" {
            ParentTabControl := ReachableControl.GetSuperordinateControl()
            SiblingTab := ParentTabControl.GetCurrentTab()
            For Index, Value In ParentTabControl.Tabs
            If Value = ReachableControl {
                ParentTabControl.CurrentTab := Index
                If ReachableControl.ControlID != SiblingTab.ControlID {
                    This.FocusControl(ParentTabControl.ControlID)
                }
                Else {
                    If This.GetCurrentControlID() != ParentTabControl.ControlID
                    This.FocusControl(ParentTabControl.ControlID)
                    Else
                    ReachableControl.Focus(ReachableControl.controlID)
                    This.SetCurrentControlID(ParentTabControl.ControlID)
                }
                For HotkeyFunction In ReachableControl.HotkeyFunction
                HotkeyFunction.Call(ReachableControl)
                Break 2
            }
        }
        Else {
            If HasMethod(ReachableControl, "Activate")
            This.ActivateControl(ReachableControl.ControlID)
            Else
            This.FocusControl(ReachableControl.ControlID)
            For HotkeyFunction In ReachableControl.HotkeyFunction
            HotkeyFunction.Call(ReachableControl)
            Break
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
    
    Static OCR(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1) {
        If IsSet(OCR) {
            AvailableLanguages := OCR.GetAvailableLanguages()
            FirstAvailableLanguage := False
            PreferredLanguage := False
            Loop Parse, AvailableLanguages, "`n" {
                If A_Index = 1 And A_LoopField != ""
                FirstAvailableLanguage := A_LoopField
                If A_LoopField = OCRLanguage And OCRLanguage != "" {
                    PreferredLanguage := OCRLanguage
                    Break
                }
            }
            If PreferredLanguage = False And FirstAvailableLanguage != False {
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
        "CustomCheckbox", Map(
        "ControlTypeLabel", "checkbox",
        "CheckedString", "checked",
        "UncheckedString", "not checked",
        "UnknownStateString", "unknown state",
        "UnlabelledString", "unlabelled"),
        "CustomComboBox", Map(
        "ControlTypeLabel", "combo box",
        "UnlabelledString", "unlabelled"),
        "CustomEdit", Map(
        "ControlTypeLabel", "edit",
        "BlankString", "blank",
        "UnlabelledString", "unlabelled"),
        "CustomTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "CustomToggleButton", Map(
        "ControlTypeLabel", "button",
        "OffString", "off",
        "OnString", "on",
        "UnknownStateString", "unknown state",
        "UnlabelledString", "unlabelled"),
        "GraphicalButton", Map(
        "ControlTypeLabel", "button",
        "NotFoundString", "not found",
        "OffString", "off",
        "OnString", "on",
        "UnlabelledString", "unlabelled"),
        "GraphicalCheckbox", Map(
        "ControlTypeLabel", "checkbox",
        "CheckedString", "checked",
        "UncheckedString", "not checked",
        "NotFoundString", "not found",
        "UnlabelledString", "unlabelled"),
        "GraphicalSlider", Map(
        "ControlTypeLabel", "slider",
        "NotFoundString", "not found",
        "UnlabelledString", "unlabelled"),
        "GraphicalHorizontalSlider", Map(
        "ControlTypeLabel", "slider",
        "NotFoundString", "not found",
        "UnlabelledString", "unlabelled"),
        "GraphicalVerticalSlider", Map(
        "ControlTypeLabel", "slider",
        "NotFoundString", "not found",
        "UnlabelledString", "unlabelled"),
        "GraphicalTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "HotspotButton", Map(
        "ControlTypeLabel", "button",
        "UnlabelledString", "unlabelled"),
        "HotspotCheckbox", Map(
        "ControlTypeLabel", "checkbox",
        "CheckedString", "checked",
        "UncheckedString", "not checked",
        "UnknownStateString", "unknown state",
        "UnlabelledString", "unlabelled"),
        "HotspotComboBox", Map(
        "ControlTypeLabel", "combo box",
        "UnlabelledString", "unlabelled"),
        "HotspotEdit", Map(
        "ControlTypeLabel", "edit",
        "BlankString", "blank",
        "UnlabelledString", "unlabelled"),
        "HotspotTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", "unlabelled"),
        "HotspotToggleButton", Map(
        "ControlTypeLabel", "button",
        "OffString", "off",
        "OnString", "on",
        "UnknownStateString", "unknown state",
        "UnlabelledString", "unlabelled"),
        "NativeControl", Map(
        "NotFoundString", "not found"),
        "OCRButton", Map(
        "ControlTypeLabel", "button",
        "UnlabelledString", ""),
        "OCRComboBox", Map(
        "ControlTypeLabel", "combo box",
        "UnlabelledString", "unlabelled"),
        "OCREdit", Map(
        "ControlTypeLabel", "edit",
        "BlankString", "blank",
        "UnlabelledString", "unlabelled"),
        "OCRTab", Map(
        "ControlTypeLabel", "tab",
        "UnlabelledString", ""),
        "TabControl", Map(
        "ControlTypeLabel", "tab control",
        "SelectedString", "selected",
        "NotFoundString", "not found",
        "UnlabelledString", ""),
        "UIAControl", Map(
        "NotFoundString", "not found"))
        English.Default := ""
        Slovak := Map(
        "AccessibilityOverlay", Map(
        "ControlTypeLabel", "prekrytie",
        "UnlabelledString", ""),
        "CustomButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "UnlabelledString", "bez názvu"),
        "CustomCheckbox", Map(
        "ControlTypeLabel", "začiarkavacie políčko",
        "CheckedString", "začiarknuté",
        "UncheckedString", "nezačiarknuté",
        "UnknownStateString", "neznámy stav",
        "UnlabelledString", "bez názvu"),
        "CustomComboBox", Map(
        "ControlTypeLabel", "kombinovaný rámik",
        "UnlabelledString", "bez názvu"),
        "CustomEdit", Map(
        "ControlTypeLabel", "editačné",
        "BlankString", "prázdny",
        "UnlabelledString", "bez názvu"),
        "CustomTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "CustomToggleButton", Map(
        "ControlTypeLabel", "button",
        "OffString", "vypnuté",
        "OnString", "zapnuté",
        "UnknownStateString", "neznámy stav",
        "UnlabelledString", "unlabelled"),
        "GraphicalButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "NotFoundString", "nenájdené",
        "OffString", "vypnuté",
        "OnString", "zapnuté",
        "UnlabelledString", "bez názvu"),
        "GraphicalCheckbox", Map(
        "ControlTypeLabel", "začiarkavacie políčko",
        "CheckedString", "začiarknuté",
        "UncheckedString", "nezačiarknuté",
        "NotFoundString", "nenájdené",
        "UnlabelledString", "bez názvu"),
        "GraphicalSlider", Map(
        "ControlTypeLabel", "posuvník",
        "NotFoundString", "nenájdené",
        "UnlabelledString", "bez názvu"),
        
        "GraphicalHorizontalSlider", Map(
        "ControlTypeLabel", "posuvník",
        "NotFoundString", "nenájdené",
        "UnlabelledString", "bez názvu"),
        "GraphicalVerticalSlider", Map(
        "ControlTypeLabel", "posuvník",
        "NotFoundString", "nenájdené",
        "UnlabelledString", "bez názvu"),
        "GraphicalTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "HotspotButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "UnlabelledString", "bez názvu"),
        "HotspotCheckbox", Map(
        "ControlTypeLabel", "začiarkavacie políčko",
        "CheckedString", "začiarknuté",
        "UncheckedString", "nezačiarknuté",
        "UnknownStateString", "neznámy stav",
        "UnlabelledString", "bez názvu"),
        "HotspotComboBox", Map(
        "ControlTypeLabel", "kombinovaný rámik",
        "UnlabelledString", "bez názvu"),
        "HotspotEdit", Map(
        "ControlTypeLabel", "editačné",
        "BlankString", "prázdny",
        "UnlabelledString", "bez názvu"),
        "HotspotTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", "bez názvu"),
        "HotspotToggleButton", Map(
        "ControlTypeLabel", "button",
        "OffString", "vypnuté",
        "OnString", "zapnuté",
        "UnknownStateString", "neznámy stav",
        "UnlabelledString", "unlabelled"),
        "NativeControl", Map(
        "NotFoundString", "nenájdené"),
        "OCRButton", Map(
        "ControlTypeLabel", "tlačidlo",
        "UnlabelledString", ""),
        "OCRComboBox", Map(
        "ControlTypeLabel", "kombinovaný rámik",
        "UnlabelledString", "bez názvu"),
        "OCREdit", Map(
        "ControlTypeLabel", "editačné",
        "BlankString", "prázdny",
        "UnlabelledString", "bez názvu"),
        "OCRTab", Map(
        "ControlTypeLabel", "záložka",
        "UnlabelledString", ""),
        "TabControl", Map(
        "ControlTypeLabel", "zoznam záložiek",
        "SelectedString", "vybraté",
        "NotFoundString", "nenájdené",
        "UnlabelledString", ""),
        "UIAControl", Map(
        "NotFoundString", "nenájdené"))
        Slovak.Default := ""
        Swedish := Map(
        "AccessibilityOverlay", Map(
        "ControlTypeLabel", "täcke",
        "UnlabelledString", ""),
        "CustomButton", Map(
        "ControlTypeLabel", "knapp",
        "UnlabelledString", "namnlös"),
        "CustomCheckbox", Map(
        "ControlTypeLabel", "kryssruta",
        "CheckedString", "kryssad",
        "UncheckedString", "inte kryssad",
        "UnknownStateString", "okänt läge",
        "UnlabelledString", "namnlös"),
        "CustomComboBox", Map(
        "ControlTypeLabel", "kombinationsruta",
        "UnlabelledString", "namnlös"),
        "CustomEdit", Map(
        "ControlTypeLabel", "redigera",
        "BlankString", "tom",
        "UnlabelledString", "namnlös"),
        "CustomTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "CustomToggleButton", Map(
        "ControlTypeLabel", "button",
        "OffString", "av",
        "OnString", "på",
        "UnknownStateString", "okänt läge",
        "UnlabelledString", "unlabelled"),
        "GraphicalButton", Map(
        "ControlTypeLabel", "knapp",
        "NotFoundString", "hittades ej",
        "OffString", "av",
        "OnString", "på",
        "UnlabelledString", "namnlös"),
        "GraphicalCheckbox", Map(
        "ControlTypeLabel", "kryssruta",
        "CheckedString", "kryssad",
        "UncheckedString", "inte kryssad",
        "NotFoundString", "hittades ej",
        "UnlabelledString", "namnlös"),
        "GraphicalSlider", Map(
        "ControlTypeLabel", "skjutreglage",
        "NotFoundString", "hittades ej",
        "UnlabelledString", "namnlös"),
        
        "GraphicalHorizontalSlider", Map(
        "ControlTypeLabel", "skjutreglage",
        "NotFoundString", "hittades ej",
        "UnlabelledString", "namnlös"),
        "GraphicalVerticalSliderSlider", Map(
        "ControlTypeLabel", "skjutreglage",
        "NotFoundString", "hittades ej",
        "UnlabelledString", "namnlös"),
        "GraphicalTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "HotspotButton", Map(
        "ControlTypeLabel", "knapp",
        "UnlabelledString", "namnlös"),
        "HotspotCheckbox", Map(
        "ControlTypeLabel", "kryssruta",
        "CheckedString", "kryssad",
        "UncheckedString", "inte kryssad",
        "UnknownStateString", "okänt läge",
        "UnlabelledString", "namnlös"),
        "HotspotComboBox", Map(
        "ControlTypeLabel", "kombinationsruta",
        "UnlabelledString", "namnlös"),
        "HotspotEdit", Map(
        "ControlTypeLabel", "redigera",
        "BlankString", "tom",
        "UnlabelledString", "namnlös"),
        "HotspotTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", "namnlös"),
        "HotspotToggleButton", Map(
        "ControlTypeLabel", "button",
        "OffString", "av",
        "OnString", "på",
        "UnknownStateString", "okänt läge",
        "UnlabelledString", "unlabelled"),
        "NativeControl", Map(
        "NotFoundString", "hittades ej"),
        "OCRButton", Map(
        "ControlTypeLabel", "knapp",
        "UnlabelledString", ""),
        "OCRComboBox", Map(
        "ControlTypeLabel", "kombinationsruta",
        "UnlabelledString", "namnlös"),
        "OCREdit", Map(
        "ControlTypeLabel", "redigera",
        "BlankString", "tom",
        "UnlabelledString", "namnlös"),
        "OCRTab", Map(
        "ControlTypeLabel", "flik",
        "UnlabelledString", ""),
        "TabControl", Map(
        "ControlTypeLabel", "flikar",
        "SelectedString", "markerad",
        "NotFoundString", "hittades ej",
        "UnlabelledString", ""),
        "UIAControl", Map(
        "NotFoundString", "hittades ej"))
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
    
}

Class CustomButton Extends ActivatableCustom {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    HotkeyLabel := ""
    Label := ""
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(OnFocusFunction, OnActivateFunction)
        This.Label := Label
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class CustomCheckbox Extends ActivatableCustom {
    
    Checked := 0
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    HotkeyLabel := ""
    Label := ""
    CheckStateFunction := ""
    CheckedString := "checked"
    UncheckedString := "not checked"
    UnknownStateString := "unknown state"
    UnlabelledString := "unlabelled"
    
    __New(Label, CheckStateFunction, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(OnFocusFunction, OnActivateFunction)
        This.Label := Label
        This.CheckStateFunction := CheckStateFunction
    }
    
    CheckState() {
        If This.CheckStateFunction Is Func
        This.Checked := This.CheckStateFunction.Call(This)
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        This.CheckState()
        If This.Checked = 1
        StateString := This.CheckedString
        Else If This.Checked = 0
        StateString := This.UncheckedString
        Else
        StateString := This.UnknownStateString
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
        Else {
            AccessibilityOverlay.Speak(StateString)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.CheckState()
        If This.ControlID != CurrentControlID {
            If This.Checked = 1
            StateString := This.CheckedString
            Else If This.Checked = 0
            StateString := This.UncheckedString
            Else
            StateString := This.UnknownStateString
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class CustomComboBox Extends FocusableCustom {
    
    ControlType := "ComboBox"
    ControlTypeLabel := "combo box"
    CurrentOption := 1
    HotkeyLabel := ""
    Label := ""
    OnChangeFunction := Array()
    Options := Array()
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "", OnChangeFunction := "") {
        Super.__New(OnFocusFunction)
        This.Label := Label
        If OnChangeFunction != "" {
            If OnChangeFunction Is Array
            This.OnChangeFunction := OnChangeFunction
            Else
            This.OnChangeFunction := Array(OnChangeFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.GetValue() . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.GetValue() . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
    GetValue() {
        If This.Options.Length > 0 And This.CurrentOption Is Integer And This.CurrentOption > 0 And This.CurrentOption <= This.Options.Length
        Return This.Options[This.CurrentOption]
        Else
        Return ""
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.GetValue())
    }
    
    SelectNextOption() {
        If This.Options.Length > 0 {
            If This.CurrentOption < This.Options.Length
            This.CurrentOption++
        }
        For OnChangeFunction In This.OnChangeFunction
        OnChangeFunction.Call(This)
    }
    
    SelectPreviousOption() {
        If This.Options.Length > 0 {
            If This.CurrentOption > 1
            This.CurrentOption--
        }
        For OnChangeFunction In This.OnChangeFunction
        OnChangeFunction.Call(This)
    }
    
    SelectOption(Option) {
        If Not Option Is Integer Or Option < 1 Or Option > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := Option
    }
    
    SetOptions(Options, DefaultOption := 1) {
        If Options Is Array
        This.Options := Options
        Else
        This.Options := Array(Options)
        If Not DefaultOption Is Integer Or DefaultOption < 1 Or DefaultOption > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := DefaultOption
    }
    
}

Class CustomControl Extends ActivatableCustom {
    
    ControlTypeLabel := "custom"
    HotkeyLabel := ""
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class CustomEdit Extends FocusableCustom {
    
    ControlType := "Edit"
    ControlTypeLabel := "edit"
    HotkeyLabel := ""
    Label := ""
    Value := ""
    BlankString := "blank"
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "") {
        Super.__New(OnFocusFunction)
        This.Label := Label
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.Value = ""
        Value := This.BlankString
        Else
        Value := This.Value
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel . " " . Value)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel . " " . Value)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
    GetValue() {
        Return This.Value
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.Value)
    }
    
    SetValue(Value) {
        This.Value := Value
    }
    
}

Class CustomTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    HotkeyCommand := ""
    HotkeyFunction := Array()
    HotkeyLabel := ""
    OnFocusFunction := Array()
    UnlabelledString := "unlabelled"
    
    __New(Label, OnFocusFunction := "") {
        Super.__New(Label)
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(ControlID := 0) {
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
        If This.ControlID != ControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
        Return 1
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        This.HotkeyLabel := HotkeyLabel
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class CustomToggleButton Extends ActivatableCustom {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    HotkeyLabel := ""
    Label := ""
    CheckStateFunction := ""
    State := 0
    OnString := "on"
    OffString := "off"
    UnknownStateString := "unknown state"
    UnlabelledString := "unlabelled"
    
    __New(Label, CheckStateFunction, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(OnFocusFunction, OnActivateFunction)
        This.Label := Label
        This.CheckStateFunction := CheckStateFunction
    }
    
    CheckState() {
        If This.CheckStateFunction Is Func
        This.State := This.CheckStateFunction.Call(This)
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        This.CheckState()
        If This.State = 1
        StateString := This.OnString
        Else If This.State = 0
        StateString := This.OffString
        Else
        StateString := This.UnknownStateString
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
        Else {
            AccessibilityOverlay.Speak(StateString)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.CheckState()
        If This.ControlID != CurrentControlID {
            If This.State = 1
            StateString := This.OnString
            Else If This.State = 0
            StateString := This.OffString
            Else
            StateString := This.UnknownStateString
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class GraphicalButton Extends ToggleableGraphic {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    HotkeyLabel := ""
    Label := ""
    NotFoundString := "not found"
    OffString := "off"
    OnString := "on"
    UnlabelledString := "unlabelled"
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OffImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OffImage, OnFocusFunction, OnActivateFunction)
        This.Label := Label
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        If This.IsToggle = 1 And This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.OnString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.OnString . " " . This.HotkeyLabel)
            }
            Else {
                AccessibilityOverlay.Speak(This.OnString)
            }
        }
        Else If This.IsToggle = 1 And This.State = 0 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.OffString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.OffString . " " . This.HotkeyLabel)
            }
            Else {
                AccessibilityOverlay.Speak(This.OffString)
            }
        }
        Else If This.IsToggle = 0 And This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            }
        }
        Else {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.IsToggle = 1 And This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.OnString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.OnString . " " . This.HotkeyLabel)
            }
        }
        Else If This.IsToggle = 1 And This.State = 0 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.OffString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.OffString . " " . This.HotkeyLabel)
            }
        }
        Else If This.IsToggle = 0 And This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            }
        }
        Else {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
            }
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class GraphicalCheckbox Extends ToggleableGraphic {
    
    Checked := 0
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    HotkeyLabel := ""
    Label := ""
    CheckedString := "checked"
    UncheckedString := "not checked"
    NotFoundString := "not found"
    UnlabelledString := "unlabelled"
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OffImage := "", OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OffImage, OnFocusFunction, OnActivateFunction)
        This.Label := Label
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        This.Checked := This.State
        If This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.CheckedString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.CheckedString . " " . This.HotkeyLabel)
            }
            Else {
                AccessibilityOverlay.Speak(This.CheckedString)
            }
        }
        Else If This.State = 0 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.UncheckedString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.UncheckedString . " " . This.HotkeyLabel)
            }
            Else {
                AccessibilityOverlay.Speak(This.UncheckedString)
            }
        }
        Else {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.Checked := This.State
        If This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.CheckedString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.CheckedString . " " . This.HotkeyLabel)
            }
        }
        Else If This.State = 0 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.UncheckedString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.UncheckedString . " " . This.HotkeyLabel)
            }
        }
        Else {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
            }
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class GraphicalSlider Extends FocusableGraphic {
    
    ControlType := "Slider"
    ControlTypeLabel := "slider"
    End := 0
    HotkeyLabel := ""
    Label := ""
    NotFoundString := "not found"
    Size := 0
    Start := 0
    Type := False
    UnlabelledString := "unlabelled"
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, Start := "", End := "", OnFocusFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OnFocusFunction)
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
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.State = 1 {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.GetPosition() . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.GetPosition() . " " . This.HotkeyLabel)
            }
        }
        Else {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
            }
        }
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
    
    Decrease() {
        This.Move(-1)
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
            This.SetState()
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
                If Target%Coordinate%Coordinate != This.Found%Coordinate%Coordinate
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
            This.SetState()
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class GraphicalHorizontalSlider Extends GraphicalSlider {
    
    Type := "Horizontal"
    
}

Class GraphicalVerticalSlider Extends GraphicalSlider {
    
    Type := "Vertical"
    
}

Class GraphicalTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    FoundOnImage := False
    FoundXCoordinate := 0
    FoundYCoordinate := 0
    HotkeyCommand := ""
    HotkeyFunction := Array()
    HotkeyLabel := ""
    OnFocusFunction := Array()
    OnImage := Array()
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    State := 0
    UnlabelledString := "unlabelled"
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OnImage, OnFocusFunction := "") {
        Super.__New(Label)
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
        If OnImage = ""
        OnImage := Array()
        If Not OnImage Is Array
        OnImage := Array(OnImage)
        This.OnImage := OnImage
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        This.SetState()
        If This.State != -1 {
            Click This.FoundXCoordinate, This.FoundYCoordinate
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            }
            Sleep 250
        }
        Else {
            If This.ControlID != CurrentControlID {
                If This.Label = ""
                AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
                Else
                AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.NotFoundString . " " . This.HotkeyLabel)
            }
        }
        If This.State = -1
        Return 0
        Return 1
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        This.HotkeyLabel := HotkeyLabel
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
    SetState() {
        If HasProp(This, "OnFocusFunction")
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
        FoundXCoordinate := False
        FoundYCoordinate := False
        Try {
            For OnImage In This.OnImage
            If OnImage != "" And FileExist(OnImage) And Not InStr(FileExist(OnImage), "D") And ImageSearch(&FoundXCoordinate, &FoundYCoordinate, This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, OnImage) {
                This.FoundOnImage := OnImage
                This.FoundXCoordinate := FoundXCoordinate
                This.FoundYCoordinate := FoundYCoordinate
                This.State := 1
                Return True
            }
            This.FoundOnImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := -1
            Return False
        }
        Catch {
            This.FoundOnImage := False
            This.FoundXCoordinate := False
            This.FoundYCoordinate := False
            This.State := -1
            Return False
        }
    }
    
}

Class HotspotButton Extends ActivatableHotspot {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    HotkeyLabel := ""
    Label := ""
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(XCoordinate, YCoordinate, OnFocusFunction, OnActivateFunction)
        This.Label := Label
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class HotspotCheckbox Extends ActivatableHotspot {
    
    Checked := 0
    ControlType := "Checkbox"
    ControlTypeLabel := "checkbox"
    HotkeyLabel := ""
    Label := ""
    CheckedColor := Array()
    UncheckedColor := Array()
    CheckedString := "checked"
    UncheckedString := "not checked"
    UnknownStateString := "unknown state"
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, CheckedColor, UncheckedColor, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(XCoordinate, YCoordinate, OnFocusFunction, OnActivateFunction)
        This.Label := Label
        If Not CheckedColor Is Array
        CheckedColor := Array(CheckedColor)
        This.CheckedColor := CheckedColor
        If Not UncheckedColor Is Array
        UncheckedColor := Array(UncheckedColor)
        This.UncheckedColor := UncheckedColor
    }
    
    CheckState() {
        Sleep 100
        CurrentColor := PixelGetColor(This.XCoordinate, This.YCoordinate)
        For Color In This.CheckedColor
        If CurrentColor = Color {
            This.Checked := 1
            Return 1
        }
        For Color In This.UncheckedColor
        If CurrentColor = Color {
            This.Checked := 0
            Return 0
        }
        This.Checked := -1
        Return -1
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        This.CheckState()
        If This.Checked = 1
        StateString := This.CheckedString
        Else If This.Checked = 0
        StateString := This.UncheckedString
        Else
        StateString := This.UnknownStateString
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
        Else {
            AccessibilityOverlay.Speak(StateString)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.CheckState()
        If This.ControlID != CurrentControlID {
            If This.Checked = 1
            StateString := This.CheckedString
            Else If This.Checked = 0
            StateString := This.UncheckedString
            Else
            StateString := This.UnknownStateString
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class HotspotComboBox Extends FocusableHotspot {
    
    ControlType := "ComboBox"
    ControlTypeLabel := "combo box"
    CurrentOption := 1
    HotkeyLabel := ""
    Label := ""
    OnChangeFunction := Array()
    Options := Array()
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnFocusFunction := "", OnChangeFunction := "") {
        Super.__New(XCoordinate, YCoordinate, OnFocusFunction)
        This.Label := Label
        If OnChangeFunction != "" {
            If OnChangeFunction Is Array
            This.OnChangeFunction := OnChangeFunction
            Else
            This.OnChangeFunction := Array(OnChangeFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.GetValue() . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.GetValue() . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
    GetValue() {
        If This.Options.Length > 0 And This.CurrentOption Is Integer And This.CurrentOption > 0 And This.CurrentOption <= This.Options.Length
        Return This.Options[This.CurrentOption]
        Else
        Return ""
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.GetValue())
    }
    
    SelectNextOption() {
        If This.Options.Length > 0 {
            If This.CurrentOption < This.Options.Length
            This.CurrentOption++
        }
        For OnChangeFunction In This.OnChangeFunction
        OnChangeFunction.Call(This)
    }
    
    SelectPreviousOption() {
        If This.Options.Length > 0 {
            If This.CurrentOption > 1
            This.CurrentOption--
        }
        For OnChangeFunction In This.OnChangeFunction
        OnChangeFunction.Call(This)
    }
    
    SelectOption(Option) {
        If Not Option Is Integer Or Option < 1 Or Option > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := Option
    }
    
    SetOptions(Options, DefaultOption := 1) {
        If Options Is Array
        This.Options := Options
        Else
        This.Options := Array(Options)
        If Not DefaultOption Is Integer Or DefaultOption < 1 Or DefaultOption > This.Options.Length
        This.CurrentOption := 1
        Else
        This.CurrentOption := DefaultOption
    }
    
}

Class HotspotEdit Extends FocusableHotspot {
    
    ControlType := "Edit"
    ControlTypeLabel := "edit"
    HotkeyLabel := ""
    Label := ""
    Value := ""
    BlankString := "blank"
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnFocusFunction := "") {
        Super.__New(XCoordinate, YCoordinate, OnFocusFunction)
        This.Label := Label
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.Value = ""
        Value := This.BlankString
        Else
        Value := This.Value
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel . " " . Value)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel . " " . Value)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
    GetValue() {
        Return This.Value
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.Value)
    }
    
    SetValue(Value) {
        This.Value := Value
    }
    
}

Class HotspotTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    HotkeyCommand := ""
    HotkeyFunction := Array()
    HotkeyLabel := ""
    OnFocusFunction := Array()
    XCoordinate := 0
    YCoordinate := 0
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnFocusFunction := "") {
        Super.__New(Label)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(ControlID := 0) {
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
        Click This.XCoordinate, This.YCoordinate
        If This.ControlID != ControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
        Return 1
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        This.HotkeyLabel := HotkeyLabel
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class HotspotToggleButton Extends ActivatableHotspot {
    
    ControlType := "button"
    ControlTypeLabel := "button"
    HotkeyLabel := ""
    Label := ""
    OnColor := Array()
    OffColor := Array()
    State := 0
    OnString := "on"
    OffString := "off"
    UnknownStateString := "unknown state"
    UnlabelledString := "unlabelled"
    
    __New(Label, XCoordinate, YCoordinate, OnColor, OffColor, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(XCoordinate, YCoordinate, OnFocusFunction, OnActivateFunction)
        This.Label := Label
        If Not OnColor Is Array
        OnColor := Array(OnColor)
        This.OnColor := OnColor
        If Not OffColor Is Array
        OffColor := Array(OffColor)
        This.OffColor := OffColor
    }
    
    CheckState() {
        Sleep 100
        CurrentColor := PixelGetColor(This.XCoordinate, This.YCoordinate)
        For Color In This.OnColor
        If CurrentColor = Color {
            This.State := 1
            Return 1
        }
        For Color In This.OffColor
        If CurrentColor = Color {
            This.State := 0
            Return 0
        }
        This.State := -1
        Return -1
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        This.CheckState()
        If This.State = 1
        StateString := This.OnString
        Else If This.State = 0
        StateString := This.OffString
        Else
        StateString := This.UnknownStateString
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
        Else {
            AccessibilityOverlay.Speak(StateString)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.CheckState()
        If This.ControlID != CurrentControlID {
            If This.State = 1
            StateString := This.OnString
            Else If This.State = 0
            StateString := This.OffString
            Else
            StateString := This.UnknownStateString
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . StateString . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class NativeControl Extends AccessibilityControl {
    
    ControlType := "Native"
    Label := ""
    HotkeyCommand := ""
    HotkeyFunction := Array()
    NativeControlID := ""
    OnActivateFunction := Array()
    OnFocusFunction := Array()
    NotFoundString := "not found"
    
    __New(NativeControlID, Label := "", OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New()
        This.NativeControlID := NativeControlID
        This.Label := Label
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
        If OnActivateFunction != "" {
            If OnActivateFunction Is Array
            This.OnActivateFunction := OnActivateFunction
            Else
            This.OnActivateFunction := Array(OnActivateFunction)
        }
    }
    
    Activate(CurrentControlID := 0) {
        If This.GetControl() == False {
            If This.Label != ""
            AccessibilityOverlay.Speak(This.Label . " " . This.NotFoundString)
            Else
            AccessibilityOverlay.Speak(This.NotFoundString)
        }
        else {
            If HasMethod(This, "Focus")
            This.Focus(CurrentControlID)
            For OnActivateFunction In This.OnActivateFunction
            OnActivateFunction.Call(This)
            If This.ControlID != CurrentControlID {
                If This.Label != ""
                AccessibilityOverlay.Speak(This.Label)
            }
        }
    }
    
    Focus(CurrentControlID := 0) {
        If This.GetControl() == False {
            If This.Label != ""
            AccessibilityOverlay.Speak(This.Label . " " . This.NotFoundString)
            Else
            AccessibilityOverlay.Speak(This.NotFoundString)
        }
        else {
            If ControlGetFocus("A") And ControlGetClassNN(ControlGetFocus("A")) != This.NativeControlID
            ControlFocus This.NativeControlID, "A"
            If CurrentControlID != This.ControlID {
                For OnFocusFunction In This.OnFocusFunction
                OnFocusFunction.Call(This)
                If This.Label != ""
                AccessibilityOverlay.Speak(This.Label)
            }
        }
    }
    
    GetControl() {
        Try
        Return ControlGetHwnd(This.NativeControlID, "A")
        Catch
        Return False
    }
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class OCRButton Extends ActivatableOCR {
    
    ControlType := "Button"
    ControlTypeLabel := "button"
    HotkeyLabel := ""
    Label := ""
    UnlabelledString := ""
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, OnFocusFunction, OnActivateFunction)
    }
    
    Activate(CurrentControlID := 0) {
        Super.Activate(CurrentControlID)
        This.Label := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.Label := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
}

Class OCRComboBox Extends FocusableOCR {
    
    ControlType := "ComboBox"
    ControlTypeLabel := "combo box"
    CurrentOption := 1
    HotkeyLabel := ""
    Label := ""
    OnChangeFunction := Array()
    UnlabelledString := "unlabelled"
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "", OnChangeFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, OnFocusFunction)
        This.Label := Label
        If OnChangeFunction != "" {
            If OnChangeFunction Is Array
            This.OnChangeFunction := OnChangeFunction
            Else
            This.OnChangeFunction := Array(OnChangeFunction)
        }
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.GetValue() . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.GetValue() . " " . This.HotkeyLabel)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
    GetValue() {
        Return AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.GetValue())
    }
    
    SelectNextOption() {
        This.CurrentOption++
        For OnChangeFunction In This.OnChangeFunction
        OnChangeFunction.Call(This)
    }
    
    SelectPreviousOption() {
        This.CurrentOption--
        For OnChangeFunction In This.OnChangeFunction
        OnChangeFunction.Call(This)
    }
    
    SelectOption(Option) {
        If Option Is Integer And Option > 0
        This.CurrentOption := Option
    }
    
}

Class OCREdit Extends FocusableOCR {
    
    ControlType := "Edit"
    ControlTypeLabel := "edit"
    HotkeyLabel := ""
    Label := ""
    Value := ""
    BlankString := "blank"
    UnlabelledString := "unlabelled"
    
    __New(Label, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "") {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale, OnFocusFunction)
        This.Label := Label
    }
    
    Focus(CurrentControlID := 0) {
        Super.Focus(CurrentControlID)
        This.Value := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If This.Value = ""
        Value := This.BlankString
        Else
        Value := This.Value
        If This.ControlID != CurrentControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel . " " . Value)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel . " " . Value)
        }
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        Super.SetHotkey(HotkeyCommand, HotkeyFunction)
        This.HotkeyLabel := HotkeyLabel
    }
    
    GetValue() {
        Return This.Value
    }
    
    ReportValue() {
        AccessibilityOverlay.Speak(This.Value)
    }
    
    SetValue(Value) {
        This.Value := Value
    }
    
}

Class OCRTab Extends AccessibilityOverlay {
    
    ControlType := "Tab"
    ControlTypeLabel := "tab"
    HotkeyCommand := ""
    HotkeyFunction := Array()
    HotkeyLabel := ""
    OnFocusFunction := Array()
    X1Coordinate := 0
    Y1Coordinate := 0
    X2Coordinate := 0
    Y2Coordinate := 0
    OCRLanguage := ""
    OCRScale := 1
    UnlabelledString := ""
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1, OnFocusFunction := "") {
        Super.__New()
        This.X1Coordinate := X1Coordinate
        This.Y1Coordinate := Y1Coordinate
        This.X2Coordinate := X2Coordinate
        This.Y2Coordinate := Y2Coordinate
        This.OCRLanguage := OCRLanguage
        This.OCRScale := OCRScale
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
    }
    
    Focus(ControlID := 0) {
        For OnFocusFunction In This.OnFocusFunction
        OnFocusFunction.Call(This)
        This.Label := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        XCoordinate := This.X1Coordinate + Floor((This.X2Coordinate - This.X1Coordinate)/2)
        YCoordinate := This.Y1Coordinate + Floor((This.Y2Coordinate - This.Y1Coordinate)/2)
        Click XCoordinate, YCoordinate
        If This.ControlID != ControlID {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.HotkeyLabel)
        }
        Return 1
    }
    
    SetHotkey(HotkeyCommand, HotkeyLabel := "", HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        This.HotkeyLabel := HotkeyLabel
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}

Class OCRText Extends OCRControl {
    
    ControlType := "Text"
    ControlTypeLabel := "text"
    Text := ""
    
    __New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage := "", OCRScale := 1) {
        Super.__New(X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, OCRLanguage, OCRScale)
    }
    
    Focus(CurrentControlID := 0) {
        This.Text := AccessibilityOverlay.OCR(This.X1Coordinate, This.Y1Coordinate, This.X2Coordinate, This.Y2Coordinate, This.OCRLanguage, This.OCRScale)
        If This.ControlID != CurrentControlID
        AccessibilityOverlay.Speak(This.Text)
    }
    
}

Class StaticText Extends AccessibilityControl {
    
    ControlType := "Text"
    ControlTypeLabel := "text"
    Text := ""
    
    __New(Text := "") {
        Super.__New()
        This.Text := Text
    }
    
    Focus(CurrentControlID := 0) {
        If CurrentControlID != This.ControlID
        AccessibilityOverlay.Speak(This.Text)
    }
    
}

Class TabControl Extends AccessibilityControl {
    
    ControlType := "TabControl"
    ControlTypeLabel := "tab control"
    Label := ""
    CurrentTab := 1
    Tabs := Array()
    SelectedString := "selected"
    NotFoundString := "not found"
    UnlabelledString := ""
    
    __New(Label := "", Tabs*) {
        Super.__New()
        This.Label := Label
        If Tabs.Length > 0
        For Tab In Tabs
        This.AddTabs(Tab)
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
            If This.Tabs[This.CurrentTab].Focus(This.Tabs[This.CurrentTab].ControlID) = 1 {
                If This.ControlID = CurrentControlID {
                    If This.Tabs[This.CurrentTab].Label = ""
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                }
                Else {
                    If This.Label = "" {
                        If This.Tabs[This.CurrentTab].Label = ""
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                        Else
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                    }
                    Else {
                        If This.Tabs[This.CurrentTab].Label = ""
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                        Else
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.SelectedString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                    }
                }
            }
            Else {
                If This.ControlID = CurrentControlID {
                    If This.Tabs[This.CurrentTab].Label = ""
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                    Else
                    AccessibilityOverlay.Speak(This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                }
                Else {
                    If This.Label = "" {
                        If This.Tabs[This.CurrentTab].Label = ""
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                        Else
                        AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                    }
                    Else {
                        If This.Tabs[This.CurrentTab].Label = ""
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].UnlabelledString . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                        Else
                        AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel . " " . This.Tabs[This.CurrentTab].Label . " " . This.Tabs[This.CurrentTab].ControlTypeLabel . " " . This.NotFoundString . " " . This.Tabs[This.CurrentTab].HotkeyLabel)
                    }
                }
            }
        }
        Else {
            If This.Label = ""
            AccessibilityOverlay.Speak(This.UnlabelledString . " " . This.ControlTypeLabel)
            Else
            AccessibilityOverlay.Speak(This.Label . " " . This.ControlTypeLabel)
        }
    }
    
    GetCurrentTab() {
        Return This.Tabs.Get(This.CurrentTab, 0)
    }
    
    GetTab(TabNumber) {
        Return This.Tabs.Get(TabNumber, 0)
    }
    
}

Class UIAControl Extends AccessibilityControl {
    
    ControlType := "UIA"
    Label := ""
    HotkeyCommand := ""
    HotkeyFunction := Array()
    UIAPath := ""
    OnActivateFunction := Array()
    OnFocusFunction := Array()
    NotFoundString := "not found"
    
    __New(UIAPath, Label := "", OnFocusFunction := "", OnActivateFunction := "") {
        Super.__New()
        This.UIAPath := UIAPath
        This.Label := Label
        If OnFocusFunction != "" {
            If OnFocusFunction Is Array
            This.OnFocusFunction := OnFocusFunction
            Else
            This.OnFocusFunction := Array(OnFocusFunction)
        }
        If OnActivateFunction != "" {
            If OnActivateFunction Is Array
            This.OnActivateFunction := OnActivateFunction
            Else
            This.OnActivateFunction := Array(OnActivateFunction)
        }
    }
    
    Activate(CurrentControlID := 0) {
        ControlElement := This.GetControl()
        If ControlElement == False {
            If This.Label != ""
            AccessibilityOverlay.Speak(This.Label . " " . This.NotFoundString)
            Else
            AccessibilityOverlay.Speak(This.NotFoundString)
        }
        else {
            If This.ControlID != CurrentControlID
            If HasMethod(This, "Focus")
            This.Focus(CurrentControlID)
            ControlElement.Click()
            For OnActivateFunction In This.OnActivateFunction
            OnActivateFunction.Call(This)
            If This.ControlID != CurrentControlID {
                If This.Label != ""
                AccessibilityOverlay.Speak(This.Label)
            }
        }
    }
    
    Focus(CurrentControlID := 0) {
        ControlElement := This.GetControl()
        If ControlElement == False {
            If This.Label != ""
            AccessibilityOverlay.Speak(This.Label . " " . This.NotFoundString)
            Else
            AccessibilityOverlay.Speak(This.NotFoundString)
        }
        else {
            ControlElement.SetFocus()
            If CurrentControlID != This.ControlID {
                For OnFocusFunction In This.OnFocusFunction
                OnFocusFunction.Call(This)
                If This.Label != ""
                AccessibilityOverlay.Speak(This.Label)
            }
        }
    }
    
    GetControl() {
        If !IsSet(UIA)
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
    
    SetHotkey(HotkeyCommand, HotkeyFunction := "") {
        This.HotkeyCommand := HotkeyCommand
        If HotkeyFunction != "" {
            If HotkeyFunction Is Array
            This.HotkeyFunction := HotkeyFunction
            Else
            This.HotkeyFunction := Array(HotkeyFunction)
        }
    }
    
}
