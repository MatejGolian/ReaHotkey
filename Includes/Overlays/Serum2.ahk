#Requires AutoHotkey v2.0

Class Serum2 {
    
    Static __New() {
        This.InitConfig()
        Plugin.Register("Serum 2", "^VSTGUI[0-9A-F]+$",, False, False, False, ObjBindMethod(This, "Check"))
        Ol := AccessibilityOverlay("Serum 2")
        Ol.AddCustomButton("Main Menu", ObjBindMethod(This, "ClickOrMoveToCoords",, "Move", 1058, 4),,, ObjBindMethod(This, "ClickOrMoveToCoords",, "Click", 1058, 4)).SetHotkey("^M", "Ctrl+M")
        Ol.AddCustomButton("Save Preset As...", ObjBindMethod(This, "ClickOrMoveToCoords",, "Move", 518, 4),,, ObjBindMethod(This, "ClickOrMoveToCoords",, "Click", 518, 4)).SetHotkey("^S", "Ctrl+S")
        Ol.AddOCRButton("Presets Menu, currently loaded", "Presets Menu, preset name not detected", "TesseractBest", 540, 13, 608, 23,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        Ol.AddHotspotButton("Previous Preset", 938, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        Ol.AddHotspotButton("Next Preset", 968, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        Plugin.RegisterOverlay("Serum 2", Ol)
    }
    
    Static Check(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = GetCurrentControlClass()
        If PluginInstance.Name = "Serum 2"
        Return True
        If ReaHotkey.Config.Get("Serum2ImageSearch") = 1 And FindImage("Images/Serum2/Serum2.png", GetPluginXCoordinate(), GetPluginYCoordinate(), GetPluginXCoordinate() + 200, GetPluginYCoordinate() + 100) Is Object
        Return True
        If ReaHotkey.AbletonPlugin {
            If RegExMatch(WinGetTitle("A"), "^Serum 2/[1-9][0-9]*-Serum 2$")
            Return True
        }
        If ReaHotkey.ReaperPluginNative {
            ReaperPluginNames := ["VST3i: Serum 2 (Xfer Records)"]
            Try
            ReaperListItem := ListViewGetContent("Focused", "SysListView321", ReaHotkey.PluginWinCriteria)
            Catch
            ReaperListItem := ""
            If Not ReaperListItem = ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperListItem = ReaperPluginName
            Return True
        }
        If ReaHotkey.ReaperPluginBridged {
            Try
            If RegExMatch(WinGetTitle("A"), "^Serum 2 \(x(64) bridged\)$")
            Return True
            Catch
            Return False
        }
        Return False
    }
    
    Static ClickOrMoveToCoords(OverlayObj, Action, XCoord, YCoord) {
        If Action = "Click"
        Send "{Click " . CompensatePluginXCoordinate(XCoord) . " " . CompensatePluginYCoordinate(YCoord) . "}"
        Else
        MouseMove CompensatePluginXCoordinate(XCoord), CompensatePluginYCoordinate(YCoord)
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "Serum2ImageSearch", 1, "Use image search for plug-in detection", "Serum 2")
    }
    
}
