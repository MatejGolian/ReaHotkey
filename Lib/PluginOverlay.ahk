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
            For PluginInstance In Plugin.Instances
            If PluginName = PluginInstance.Name
            PluginInstance.Overlays.Push(This.Clone())
        }
    }
    
    AddControl(Control) {
        Control := Super.AddControl(Control)
        Plugin.RegisterOverlayHotkeys(This.PluginName, This)
        If This.CompensationFunction Is Object {
            If Control.HasOwnProp("PreExecFocusFunctions") {
                Found := False
                For FocusFunction In Control.PreExecFocusFunctions
                If FocusFunction == This.CompensationFunction {
                    Found := True
                    Break
                }
                If Not Found
                Control.PreExecFocusFunctions.InsertAt(1, This.CompensationFunction)
            }
            If Control.HasOwnProp("PreExecActivationFunctions") {
                Found := False
                For ActivationFunction In Control.PreExecActivationFunctions
                If ActivationFunction == This.CompensationFunction {
                    Found := True
                    Break
                }
                If Not Found
                Control.PreExecActivationFunctions.InsertAt(1, This.CompensationFunction)
            }
        }
        For PluginInstance In Plugin.Instances
        If This.PluginName = PluginInstance.Name
        For PluginOverlay In PluginInstance.Overlays
        If PluginOverlay.HasOwnProp("OverlayNumber") And PluginOverlay.OverlayNumber = This.OverlayNumber
        PluginOverlay.AddControl(Control)
        Return Control
    }
    
}
