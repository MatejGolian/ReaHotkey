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
        CompensationList := Array("PreExecFocusFunctions", "PreExecActivationFunctions", "ChangeFunctions")
        RequiredPropList := Array("Start", "End", "XCoordinate", "YCoordinate", "X1Coordinate", "Y1Coordinate", "X2Coordinate", "Y2Coordinate")
        If This.CompensationFunction Is Object {
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
            For ControlItem In ControlList {
                Found := False
                For RequiredProp In RequiredPropList
                If ControlItem.HasOwnProp(RequiredProp) {
                    Found := True
                    Break
                }
                If Found
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
        }
        Return Control
    }
    
    RegisterHotkey(Command) {
        Plugin.SetHotkey(This.PluginName, Command)
    }
    
}
