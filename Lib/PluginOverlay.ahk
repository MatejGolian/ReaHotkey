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
            CompensationList := ["PreExecFocusFunctions", "PreExecActivationFunctions", "ChangeFunctions"]
            If Control Is AccessibilityOverlay {
                ControlList := Control.AllControls
                ControlList.InsertAt(1, Control)
            }
            Else If Control Is TabControl {
                ControlList := Array(Control)
                For TabObject In Control.Tabs {
                    ControlList.Push(TabObject)
                    For TabObjectControl In TabObject.AllControls
                    ControlList.Push(TabObjectControl)
                }
            }
            Else {
                ControlList := Array(Control)
            }
            For ControlItem In ControlList
            For CompensationItem In CompensationList
            If ControlItem.HasOwnProp(CompensationItem) {
                Found := False
                For ControlFunction In ControlItem.%CompensationItem%
                If ControlFunction == This.CompensationFunction {
                    Found := True
                    Break
                }
                If Not Found
                ControlItem.%CompensationItem%.InsertAt(1, This.CompensationFunction)
            }
        }
        Return Control
    }
    
    RegisterHotkey(Command) {
        Plugin.SetHotkey(This.PluginName, Command)
    }
    
}
