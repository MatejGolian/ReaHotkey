#Requires AutoHotkey v2.0

Class GenericPlugin {
    
    Static Init() {
        Plugin.Register("Generic Plug-in", "^(?!(Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1)).*$",, True, False, True)
        Plugin.RegisterOverlay("Generic Plug-in", AccessibilityOverlay())
        Plugin.SetTimer("Generic Plug-in", ObjBindMethod(GenericPlugin, "DetectPlugin"), 100)
    }
    
    Static AddTimers(PluginName) {
        If PluginName != "Generic Plug-in" {
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
        }
        Return False
    }
    
    Static DetectPlugin() {
        Critical
        If FindImage("Images/Engine/Engine.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "Engine"
            ReaHotkey.FoundPlugin := GenericPlugin.Load(ReaHotkey.FoundPlugin.InstanceNumber, "Engine", ReaHotkey.FoundPlugin.ControlClass)
        }
        Else If FindImage("Images/Sforzando/Sforzando.png", GetPluginXCoordinate(), GetPluginYCoordinate()) Is Array {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "sforzando"
            ReaHotkey.FoundPlugin := GenericPlugin.Load(ReaHotkey.FoundPlugin.InstanceNumber, "sforzando", ReaHotkey.FoundPlugin.ControlClass)
        }
        Else {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "Generic Plug-in"
            ReaHotkey.FoundPlugin := GenericPlugin.Unload(ReaHotkey.FoundPlugin.InstanceNumber)
        }
    }
    
    Static Load(InstanceNumber, PluginName, ControlClass) {
        If Plugin.FindName(PluginName) > 0 {
            ReaHotkey.TurnPluginTimersOff("Generic Plug-in")
            NewInstance := GenericPlugin.OverridePluginInstance(InstanceNumber, Plugin.Instantiate(PluginName, ControlClass))
            GenericPlugin.AddTimers(NewInstance.Name)
            ReaHotkey.TurnPluginTimersOn(PluginName)
            Return NewInstance
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
                Return NewInstance
            }
        }
        Return False
    }
    
    Static RemoveTimers(PluginName) {
        If PluginName != "Generic Plug-in" {
            PluginNumber := Plugin.FindName(PluginName)
            If PluginNumber > 0 {
                GenericEntry := False
                GenericNumber := Plugin.FindName("Generic Plug-in")
                If GenericNumber > 0
                GenericEntry := Plugin.List[GenericNumber]
                If GenericEntry != False
                For GenericTimer In GenericEntry["Timers"]
                For TimerNumber, PluginTimer In Plugin.List[PluginNumber]["Timers"]
                If PluginTimer["Function"] = GenericTimer["Function"] {
                    Plugin.List[PluginNumber]["Timers"].RemoveAt(TimerNumber)
                    Break
                }
            }
            Return True
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
            GenericPlugin.RemoveTimers(PluginInstance.Name)
            NewInstance := Plugin("Generic Plug-in", PluginInstance.ControlClass)
            NewInstance.InstanceNumber := InstanceNumber
            Plugin.Instances[InstanceIndex] := NewInstance
            Return NewInstance
        }
        Return False
    }
    
}

GenericPlugin.Init()
