#Requires AutoHotkey v2.0

Class GenericPlugin {
    
    Static ImageChecks := Array()
    
    Static __New() {
        Plugin.Register("Generic Plug-in", ".*",, True, False, True)
        Plugin.RegisterOverlay("Generic Plug-in", AccessibilityOverlay())
        GenericPlugin.AddImageCheck("Engine 2", "Images/Engine2/Engine2.png")
        GenericPlugin.AddImageCheck("sforzando", "Images/Sforzando/Sforzando.png")
        Plugin.SetTimer("Generic Plug-in", ObjBindMethod(GenericPlugin, "DetectPlugin"), 250)
    }
    
    Static AddImageCheck(PluginName, ImageFile) {
        GenericPlugin.ImageChecks.Push(Map("PluginName", PluginName, "ImageFile", ImageFile))
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
        For ImageCheck In GenericPlugin.ImageChecks
        If FindImage(ImageCheck["ImageFile"], GetPluginXCoordinate(), GetPluginYCoordinate()) Is Object {
            If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != ImageCheck["PluginName"]
            ReaHotkey.FoundPlugin := GenericPlugin.Load(ReaHotkey.FoundPlugin.InstanceNumber, ImageCheck["PluginName"], ReaHotkey.FoundPlugin.ControlClass)
            Return True
        }
        If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != "Generic Plug-in"
        ReaHotkey.FoundPlugin := GenericPlugin.Unload(ReaHotkey.FoundPlugin.InstanceNumber)
        Return False
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
                NewInstance.OriginalInstanceNumber := NewInstance.InstanceNumber
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
            Plugin.Instances[PluginInstance.OriginalInstanceNumber].Overlay := PluginInstance.Overlay
            Plugin.Instances[PluginInstance.OriginalInstanceNumber].Overlays := Array()
            For PluginOverlay In PluginInstance.Overlays
            Plugin.Instances[PluginInstance.OriginalInstanceNumber].Overlays.Push(PluginOverlay)
            NewInstance := Plugin("Generic Plug-in", PluginInstance.ControlClass)
            NewInstance.InstanceNumber := InstanceNumber
            Plugin.Instances[InstanceIndex] := NewInstance
            Return NewInstance
        }
        Return False
    }
    
}
