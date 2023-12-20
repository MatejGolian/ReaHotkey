#Requires AutoHotkey v2.0

Class GenericPlugin {
    
    Static Init() {
        Plugin.Register("Generic Plug-in", "^Plugin[0-9A-F]{17}$",, True, False, True)
        Plugin.RegisterOverlay("Generic Plug-in", AccessibilityOverlay("Plug-in"))
        Plugin.SetTimer("Generic Plug-in", ObjBindMethod(GenericPlugin, "DetectPlugin"), 100)
    }
    
    Static AddTimers(PluginName) {
        PluginNumber := Plugin.FindName(PluginName)
        If PluginNumber > 0 {
            GenericEntry := False
            GenericNumber := Plugin.FindName("Generic Plug-in")
            If GenericNumber > 0
            GenericEntry := Plugin.List[GenericNumber]
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
        If FindImage("Images/Engine/Engine.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "Engine"
            GenericPlugin.Load(ReaHotkey.FoundPlugin.InstanceNumber, "Engine", ReaHotkey.FoundPlugin.ControlClass)
        }
        Else {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "Generic Plug-in"
            GenericPlugin.Unload(ReaHotkey.FoundPlugin.InstanceNumber)
        }
    }
    
    Static Load(InstanceNumber, PluginName, ControlClass) {
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
            NewInstance := NewInstance.Clone()
                NewInstance.InstanceNumber := InstanceNumber
                NewInstance.PluginNumber := PluginInstance.PluginNumber
                Plugin.Instances[InstanceIndex] := NewInstance
                GenericPlugin.AddTimers(NewInstance.Name)
                Return True
            }
        }
        Return False
    }
    
    Static Unload(InstanceNumber) {
        PluginNumber := Plugin.FindName("Generic Plug-in")
        If PluginNumber > 0
        For InstanceIndex, PluginInstance In Plugin.Instances
        If PluginInstance Is Plugin And PluginInstance.InstanceNumber = InstanceNumber {
            ReaHotkey.TurnPluginTimersOff()
            ReaHotkey.TurnPluginHotkeysOff()
            NewInstance := Plugin("Generic Plug-in", PluginInstance.ControlClass)
            NewInstance.InstanceNumber := InstanceNumber
            Plugin.Instances[InstanceIndex] := NewInstance
            ReaHotkey.FoundPlugin := NewInstance
            Return True
        }
        Return False
    }
    
}

GenericPlugin.Init()
