#Requires AutoHotkey v2.0

Class PluginOverlay Extends AccessibilityOverlay {
    
    OverlayNumber := 0
    PluginName := ""
    
    __New(OverlayLabel := "", PluginName := "") {
        Super.__New(OverlayLabel)
        If PluginName = ""
        PluginName := Plugin.UnnamedPluginName
        This.PluginName := PluginName
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            OverlayNumber := This.List[PluginNumber]["Overlays"].Length + 1
            This.OverlayNumber := OverlayNumber
            Plugin.List[PluginNumber]["Overlays"].Push(This)
            For PluginInstance In Plugin.Instances
            If PluginName = PluginInstance.Name
            PluginInstance.Overlays.Push(This.Clone())
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
        For PluginInstance In Plugin.Instances
        If This.PluginName = PluginInstance.Name
        For PluginOverlay In PluginInstance.Overlays
        If PluginOverlay.HasOwnProp("OverlayNumber") And PluginOverlay.OverlayNumber = This.OverlayNumber
        PluginOverlay.AddControl(Control)
        Return Control
    }
    
}
