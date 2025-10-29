#Requires AutoHotkey v2.0

Class PluginOverlay Extends AccessibilityOverlay {
    
    CompensationFunction := ""
    OverlayNumber := 0
    PluginName := ""
    
    __New(OverlayLabel := "", PluginName := "", CompensationFunction := CompensatePluginCoordinates) {
        Super.__New(OverlayLabel)
        If PluginName = ""
        PluginName := Plugin.UnnamedPluginName
        This.PluginName := PluginName
        This.CompensationFunction := CompensationFunction
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            OverlayNumber := Plugin.List[PluginNumber]["Overlays"].Length + 1
            This.OverlayNumber := OverlayNumber
            Plugin.List[PluginNumber]["Overlays"].Push(This)
        }
    }
    
    AddControl(Control) {
        Control := Super.AddControl(Control)
        If This.CompensationFunction Is Object {
            If Control Is AccessibilityOverlay {
                ControlList := Control.GetAllControls()
                ControlList.InsertAt(1, Control)
            }
            Else {
                ControlList := Array(Control)
            }
            For ListItem In ControlList {
                If ListItem.HasOwnProp("PreExecFocusFunctions") {
                    Found := False
                    For FocusFunction In ListItem.PreExecFocusFunctions
                    If FocusFunction == This.CompensationFunction {
                        Found := True
                        Break
                    }
                    If Not Found
                    ListItem.PreExecFocusFunctions.InsertAt(1, This.CompensationFunction)
                }
                If ListItem.HasOwnProp("PreExecActivationFunctions") {
                    Found := False
                    For ActivationFunction In ListItem.PreExecActivationFunctions
                    If ActivationFunction == This.CompensationFunction {
                        Found := True
                        Break
                    }
                    If Not Found
                    ListItem.PreExecActivationFunctions.InsertAt(1, This.CompensationFunction)
                }
            }
        }
        Return Control
    }
    
    RegisterHotkey(Command) {
        Plugin.SetHotkey(This.PluginName, Command)
    }
    
}
