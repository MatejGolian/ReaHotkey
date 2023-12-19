#Requires AutoHotkey v2.0

Class GenericPlugin {
    
    Static Init() {
        Plugin.Register("Generic Plug-in", "^Plugin[0-9A-F]{17}$",, True, False)
        Plugin.RegisterOverlay("Generic Plug-in", AccessibilityOverlay("Generic Plug-in"))
        Plugin.SetTimer("Generic Plug-in", ObjBindMethod(GenericPlugin, "DetectPlugin"), 500)
    }
    
    Static AddTimersTo(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            GenericEntry := False
            For PluginEntry In Plugin.List
            If PluginEntry["Name"] = "Generic Plug-in" {
                GenericEntry := PluginEntry
                Break
            }
            If GenericEntry != False
            For TimerNumber, GenericTimer In GenericEntry["Timers"] {
                TimerFound := False
                For PluginTimer In Plugin.List[PluginNumber]["Timers"]
                If PluginTimer["Function"] = GenericTimer["Function"] {
                    TimerFound := True
                    Break
                }
                If TimerFound = False
                Plugin.List[PluginNumber]["Timers"].InsertAt(TimerNumber, GenericTimer)
            }
            Return True
        }
        Return False
    }
    
    Static DetectPlugin() {
        If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "Engine"
        GenericPlugin.LoadInto(ReaHotkey.FoundPlugin.InstanceNumber, "Engine", ReaHotkey.FoundPlugin.ControlClass)
    }
    
    Static LoadInto(InstanceNumber, PluginName, ControlClass) {
        If Plugin.FindName(PluginName) > 0 {
            ReaHotkey.TurnPluginTimersOff("Generic Plug-in")
            GenericPlugin.OverridePluginInstance(InstanceNumber, Plugin.Instantiate(PluginName, ControlClass))
            ReaHotkey.TurnPluginTimersOn(PluginName)
            Return True
        }
        Return False
    }
    
    Static OverridePluginInstance(InstanceNumber, NewInstance) {
        If NewInstance Is Plugin {
            For InstanceIndex, PluginInstance In Plugin.Instances
            If PluginInstance Is Plugin And PluginInstance.InstanceNumber = InstanceNumber {
                NewInstance.InstanceNumber := InstanceNumber
                NewInstance.PluginNumber := PluginInstance.PluginNumber
                Plugin.Instances[InstanceIndex] := NewInstance
                GenericPlugin.AddTimersTo(NewInstance.Name)
                Return True
            }
        }
        Return False
    }
    
}

GenericPlugin.Init()
