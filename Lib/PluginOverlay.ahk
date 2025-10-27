#Requires AutoHotkey v2.0

Class PluginOverlay Extends AccessibilityOverlay {
    
    OverlayNumber := 0
    PluginName := ""
    
    __New(PluginName, OverlayLabel := "") {
        Super.__New(OverlayLabel)
        This.PluginName := PluginName
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            OverlayNumber := This.List[PluginNumber]["Overlays"].Length + 1
            This.OverlayNumber := OverlayNumber
            Plugin.List[PluginNumber]["Overlays"].Push(This)
        }
    }
    
    AddControl(Control) {
        Control := Super.AddControl(Control)
        Plugin.RegisterOverlayHotkeys(This.PluginName, This)
        If Control.HasOwnProp("PreExecFocusFunctions") {
            Found := False
            For FocusFunction In Control.PreExecFocusFunctions
            If FocusFunction == CompensatePluginCoordinates {
                Found := True
                Break
            }
            If Not Found
            Control.PreExecFocusFunctions.Push(CompensatePluginCoordinates)
        }
        If Control.HasOwnProp("PreExecActivationFunctions") {
            Found := False
            For ActivationFunction In Control.PreExecActivationFunctions
            If ActivationFunction == CompensatePluginCoordinates {
                Found := True
                Break
            }
            If Not Found
            Control.PreExecActivationFunctions.Push(CompensatePluginCoordinates)
        }
        Return Control
    }
    
}
