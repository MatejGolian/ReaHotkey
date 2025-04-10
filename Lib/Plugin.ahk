#Requires AutoHotkey v2.0

Class Plugin Extends Program {
    
    CheckerFunction := ""
    Chooser := True
    ControlClass := ""
    HotkeyMode := 1
    InitFunction := ""
    InstanceNumber := 0
    Name := ""
    Overlay := AccessibilityOverlay()
    Overlays := Array()
    PluginNumber := 0
    SingleInstance := False
    WinTitle := ""
    Static ChooserOverlay := AccessibilityOverlay()
    Static DefaultOverlay := AccessibilityOverlay()
    Static Instances := Array()
    Static List := Array()
    Static UnnamedPluginName := "Unnamed Plugin"
    
    __New(Name, ControlClass, WinTitle) {
        Super.__New(Name)
        This.ControlClass := ControlClass
        PluginNumber := Plugin.FindName(Name)
        If PluginNumber > 0 {
            PluginEntry := Plugin.List[PluginNumber]
            This.SingleInstance := PluginEntry["SingleInstance"]
        }
        This.WinTitle := WinTitle
    }
    
    Static FindClass(ClassName) {
        PluginNumbers := Array()
        For PluginNumber, PluginEntry In This.List {
            If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
            For ControlClass In PluginEntry["ControlClasses"]
            If RegExMatch(ClassName, ControlClass)
            PluginNumbers.Push(PluginNumber)
        }
        Return PluginNumbers
    }
    
    Static GetByClass(Value) {
        Return This.GetByCriteria(Value, "ControlClass", Value)
    }
    
    Static GetByCriteria(ControlClass, PropertyName, PropertyValue) {
        Static TestPluginInstance := Plugin("", "", "")
        PluginNumbers := This.FindClass(ControlClass)
        If PluginNumbers.Length > 0 {
            WinTitle := WinGetTitle("A")
            For PluginNumber In PluginNumbers {
                PluginName := This.List[PluginNumber]["Name"]
                SingleInstance := This.List[PluginNumber]["SingleInstance"]
                If SingleInstance = True {
                    For PluginInstance In This.Instances
                    If PluginInstance.PluginNumber = PluginNumber And PluginInstance.Check() = True {
                        PluginInstance.ControlClass := ControlClass
                        PluginInstance.WinTitle := WinTitle
                        PluginInstance.%PropertyName% := PropertyValue
                        Return PluginInstance
                    }
                }
                Else {
                    For PluginInstance In This.Instances
                    If PluginInstance.PluginNumber = PluginNumber And PluginInstance.%PropertyName% = PropertyValue And PluginInstance.Check() = True {
                        Return PluginInstance
                    }
                }
            }
            For PluginNumber In PluginNumbers {
                CheckResult := This.List[PluginNumber]["CheckerFunction"].Call(TestPluginInstance)
                If CheckResult = True {
                    PluginInstance := Plugin(This.List[PluginNumber]["Name"], ControlClass, WinTitle)
                    PluginInstance.%PropertyName% := PropertyValue
                    Return PluginInstance
                }
            }
        }
        Return False
    }
    
    Static GetByWinTitle(Value) {
        ControlClass := ReaHotkey.GetPluginControl()
        PluginInstance := This.GetByCriteria(ControlClass, "WinTitle", Value)
        If PluginInstance Is Plugin
        PluginInstance.ControlClass := ControlClass
        Return PluginInstance
    }
    
    Static GetInstance(ControlClass) {
        For PluginInstance In This.Instances
        If PluginInstance.ControlClass = ControlClass
        Return PluginInstance
        Return False
    }
    
    Static Instantiate(PluginName, ControlClass, WinTitle) {
        PluginNumber := This.FindName(PluginName)
        If PluginNumber > 0 {
            SingleInstance := This.List[PluginNumber]["SingleInstance"]
            If SingleInstance = True {
                For PluginInstance In This.Instances
                If PluginInstance.PluginNumber = PluginNumber
                Return PluginInstance
            }
            Else {
                For PluginInstance In This.Instances
                If PluginInstance.PluginNumber = PluginNumber And PluginInstance.ControlClass = ControlClass And PluginInstance.WinTitle = WinTitle
                Return PluginInstance
            }
            Return Plugin(PluginName, ControlClass, WinTitle)
        }
        Return False
    }
    
    Static Register(PluginName, ControlClasses, InitFunction := False, Chooser := False, HotkeyMode := 1, SingleInstance := False, CheckerFunction := False) {
        If Super.Register(PluginName, InitFunction, Chooser, HotkeyMode, CheckerFunction) = True {
            PluginEntry := This.List[This.List.Length]
            If Not SingleInstance = True And Not SingleInstance = False
            SingleInstance := True
            If ControlClasses Is Array
            PluginEntry["ControlClasses"] := ControlClasses
            Else
            PluginEntry["ControlClasses"] := Array(ControlClasses)
            PluginEntry["SingleInstance"] := SingleInstance
        }
    }
    
    Static SetHotkey(PluginName, KeyName, Action := "", Options := "") {
        PluginWinCriteria := ReaHotkey.PluginWinCriteria
        StandaloneWinCriteria := ReaHotkey.StandaloneWinCriteria
        If Super.SetHotkey(PluginName, KeyName, Action, Options) = True {
            Options := Super.GetHotkeyOptions(Options)
            If PluginWinCriteria And WinActive(PluginWinCriteria) {
                HotIfWinActive(PluginWinCriteria)
                If ReaHotkey.FoundPlugin Is Plugin And PluginName = ReaHotkey.FoundPlugin.Name
                Hotkey KeyName, Action, Options.String
            }
            If PluginWinCriteria And WinActive(PluginWinCriteria)
            HotIfWinActive(PluginWinCriteria)
            Else If StandaloneWinCriteria And WinActive(StandaloneWinCriteria)
            HotIfWinActive(StandaloneWinCriteria)
            Else
            HotIf
        }
    }
    
    Class DefaultChecker {
        Static Call(*) {
            Return True
        }
    }
    
    Class TriggerOverlayHotkey {
        Static Call(ThisHotkey) {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Overlay Is AccessibilityOverlay {
                HotkeyWait(ThisHotkey)
                ReaHotkey.FoundPlugin.Overlay.TriggerHotkey(ThisHotkey)
            }
        }
    }
    
}
