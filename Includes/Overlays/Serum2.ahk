#Requires AutoHotkey v2.0

Class Serum2 {
    
    Static __New() {
        This.InitConfig()
        Plugin.Register("Serum 2", "^VSTGUI[0-9A-F]+$", False, False, 1, False, ObjBindMethod(This, "Check"))
        Serum2Overlay := AccessibilityOverlay("Serum 2")
        Serum2Overlay.AddCustomButton("Main Menu", ObjBindMethod(This, "ClickOrMoveToCoords",, "Move", 1058, 4),,, ObjBindMethod(This, "ClickOrMoveToCoords",, "Click", 1058, 4)).SetHotkey("^M", "Ctrl+M")
        Serum2Overlay.AddCustomButton("Save Preset As...", ObjBindMethod(This, "ClickOrMoveToCoords",, "Move", 518, 4),,, ObjBindMethod(This, "ClickOrMoveToCoords",, "Click", 518, 4)).SetHotkey("^S", "Ctrl+S")
        Serum2Overlay.AddOCRButton("Preset Menu, currently loaded", "Preset Menu, preset name not detected", "TesseractBest", 540, 13, 608, 23,,, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!M", "Alt+M")
        Serum2Overlay.AddHotspotButton("Previous Preset", 938, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!P", "Alt+P")
        Serum2Overlay.AddHotspotButton("Next Preset", 968, 4, CompensatePluginCoordinates,, CompensatePluginCoordinates).SetHotkey("!N", "Alt+N")
        Plugin.RegisterOverlay("Serum 2", Serum2Overlay)
    }
    
    Static Check(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Serum 2"
        Return True
        If PluginInstance Is Plugin And PluginInstance.ControlClass = KompleteKontrol.GetPluginControl()
        If PluginInstance.Name = "Serum 2"
        Return True
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        If ReaHotkey.Config.Get("Serum2ImageSearch") = 1 And FindImage("Images/Serum2/Serum2.png", PluginControlPos.X, PluginControlPos.Y, PluginControlPos.X + 200, PluginControlPos.Y + 100) Is Object
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
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        If Action = "Click"
        Send "{Click " . PluginControlPos.X + XCoord . " " . PluginControlPos.Y + YCoord . "}"
        Else
        MouseMove PluginControlPos.X + XCoord, PluginControlPos.Y + YCoord
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "Serum2ImageSearch", 1, "Use image search for Serum 2 plug-in detection", "Misc")
    }
    
}
