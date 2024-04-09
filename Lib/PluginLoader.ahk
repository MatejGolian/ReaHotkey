#Requires AutoHotkey v2.0

Class PluginLoader {
    
    Static ImageChecks := Array()
    
    Static AddImageCheck(PluginName, ImageFile, X1Coordinate := 0, Y1Coordinate := 0, X2Coordinate := 0, Y2Coordinate := 0) {
        PluginLoader.ImageChecks.Push(Map("PluginName", PluginName, "ImageFile", ImageFile, "X1Coordinate", X1Coordinate, "Y1Coordinate", Y1Coordinate, "X2Coordinate", X2Coordinate, "Y2Coordinate", Y2Coordinate))
    }
    
    Static AddTimers(LoaderName, PluginName) {
        If PluginName != LoaderName {
            PluginNumber := Plugin.FindName(PluginName)
            If PluginNumber > 0 {
                LoaderEntry := False
                LoaderNumber := Plugin.FindName(LoaderName)
                If LoaderNumber > 0
                LoaderEntry := Plugin.List[LoaderNumber]
                If LoaderEntry != False
                For TimerNumber, LoaderTimer In LoaderEntry["Timers"] {
                    TimerFound := False
                    For PluginTimer In Plugin.List[PluginNumber]["Timers"]
                    If PluginTimer["Function"] = LoaderTimer["Function"] {
                        TimerFound := True
                        Break
                    }
                    If TimerFound = False
                    Plugin.List[PluginNumber]["Timers"].InsertAt(TimerNumber, LoaderTimer)
                }
                Return True
            }
        }
        Return False
    }
    
    Static DetectPlugin(LoaderName) {
        Critical
        For ImageCheck In PluginLoader.ImageChecks {
            X2Coordinate := 0
            If ImageCheck["X2Coordinate"] > 0
            X2Coordinate := GetPluginXCoordinate() + ImageCheck["X2Coordinate"]
            Y2Coordinate := 0
            If ImageCheck["Y2Coordinate"] > 0
            Y2Coordinate := GetPluginYCoordinate() + ImageCheck["Y2Coordinate"]
            If FindImage(ImageCheck["ImageFile"], GetPluginXCoordinate() + ImageCheck["X1Coordinate"], GetPluginYCoordinate() + ImageCheck["Y1Coordinate"], X2Coordinate, Y2Coordinate) Is Object {
                If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != ImageCheck["PluginName"]
                ReaHotkey.FoundPlugin := PluginLoader.Load(LoaderName, ReaHotkey.FoundPlugin.InstanceNumber, ImageCheck["PluginName"], ReaHotkey.FoundPlugin.ControlClass)
                Return True
            }
        }
        If ReaHotkey.FoundPlugin Is Plugin And ReaHotkey.FoundPlugin.Name != LoaderName
        ReaHotkey.FoundPlugin := PluginLoader.Unload(LoaderName, ReaHotkey.FoundPlugin.InstanceNumber)
        Return False
    }
    
    Static Load(LoaderName, InstanceNumber, PluginName, ControlClass) {
        If Plugin.FindName(PluginName) > 0 {
            ReaHotkey.TurnPluginTimersOff(LoaderName)
            NewInstance := PluginLoader.OverridePluginInstance(InstanceNumber, Plugin.Instantiate(PluginName, ControlClass))
            PluginLoader.AddTimers(LoaderName, NewInstance.Name)
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
    
    Static RemoveTimers(LoaderName, PluginName) {
        If PluginName != LoaderName {
            PluginNumber := Plugin.FindName(PluginName)
            If PluginNumber > 0 {
                LoaderEntry := False
                LoaderNumber := Plugin.FindName(LoaderName)
                If LoaderNumber > 0
                LoaderEntry := Plugin.List[LoaderNumber]
                If LoaderEntry != False
                For LoaderTimer In LoaderEntry["Timers"]
                For TimerNumber, PluginTimer In Plugin.List[PluginNumber]["Timers"]
                If PluginTimer["Function"] = LoaderTimer["Function"] {
                    Plugin.List[PluginNumber]["Timers"].RemoveAt(TimerNumber)
                    Break
                }
            }
            Return True
        }
        Return False
    }
    
    Static Unload(LoaderName, InstanceNumber) {
        PluginNumber := Plugin.FindName(LoaderName)
        If PluginNumber > 0
        For InstanceIndex, PluginInstance In Plugin.Instances
        If PluginInstance Is Plugin And PluginInstance.InstanceNumber = InstanceNumber {
            ReaHotkey.TurnPluginTimersOff()
            ReaHotkey.TurnPluginHotkeysOff()
            PluginLoader.RemoveTimers(LoaderName, PluginInstance.Name)
            Plugin.Instances[PluginInstance.OriginalInstanceNumber].Overlay := PluginInstance.Overlay
            Plugin.Instances[PluginInstance.OriginalInstanceNumber].Overlays := Array()
            For PluginOverlay In PluginInstance.Overlays
            Plugin.Instances[PluginInstance.OriginalInstanceNumber].Overlays.Push(PluginOverlay)
            NewInstance := Plugin(LoaderName, PluginInstance.ControlClass)
            NewInstance.InstanceNumber := InstanceNumber
            Plugin.Instances[InstanceIndex] := NewInstance
            Return NewInstance
        }
        Return False
    }
    
}
