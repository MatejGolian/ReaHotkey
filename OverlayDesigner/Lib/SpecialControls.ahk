#Requires AutoHotkey v2.0

Class Marker Extends ActivatableControl {
    
    ControlType := "Marker"
    ControlTypeLabel := "marker"
    DefaultLabel := "unlabelled"
    XCoordinate := 0
    YCoordinate := 0
    
    __New(Label, XCoordinate, YCoordinate, HotkeyCommand := "", HotkeyLabel := "") {
        Super.__New(Label,,,,, HotkeyCommand, HotkeyLabel)
        This.XCoordinate := XCoordinate
        This.YCoordinate := YCoordinate
        This.DeleteProp("PreExecFocusFunctions")
        This.DeleteProp("PostExecFocusFunctions")
        This.DeleteProp("PreExecActivationFunctions")
        This.DeleteProp("PostExecActivationFunctions")
    }
    
    Activate(Speak := True) {
        If This.MasterControl Is AccessibilityOverlay And Not This.ControlID = This.MasterControl.CurrentControlID
        This.Focus(False)
        This.CheckFocus()
        If This.HasFocus() {
            This.CheckFocus()
            If This.HasFocus() {
                If This.HasMethod("ExecuteOnActivationPreSpeech")
                This.ExecuteOnActivationPreSpeech()
                This.CheckState()
                This.SpeakOnActivation(Speak)
                If This.HasMethod("ExecuteOnActivationPostSpeech")
                This.ExecuteOnActivationPostSpeech()
            }
        }
    }
    
    ExecuteOnActivationPostSpeech() {
        Click This.XCoordinate, This.YCoordinate
    }
    
    ExecuteOnFocusPreSpeech() {
        MouseMove This.XCoordinate, This.YCoordinate
    }
    
    Focus(Speak := True) {
        This.CheckFocus()
        If This.HasFocus() {
            This.GetValue()
            If This.HasMethod("ExecuteOnFocusPreSpeech")
            This.ExecuteOnFocusPreSpeech()
            This.CheckState()
            This.SpeakOnFocus(Speak)
            If This.HasMethod("ExecuteOnFocusPostSpeech")
            This.ExecuteOnFocusPostSpeech()
        }
    }
    
}

Class Separator Extends FocusableControl {
    
    OriginalLabel := ""
    
    __New(Label := "Separator") {
        Super.__New(Label)
        This.OriginalLabel := Label
    }
    
    ExecuteOnFocusPreSpeech() {
        SuperordinateControl := This.SuperordinateControl
        This.Label := SuperordinateControl.Label . " " . SuperordinateControl.ControlTypeLabel . " " . This.OriginalLabel
    }
    
}

Class StartSeparator Extends Separator {
    
    __New(Label := "Start") {
        Super.__New(Label)
    }
    
}

Class EndSeparator Extends Separator {
    
    __New(Label := "End") {
        Super.__New(Label)
    }
    
}
