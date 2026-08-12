#Requires AutoHotkey v2.0

Class Gateway {
    
    Static __New() {
        Plugin.Register("Gateway", "^IPlugWndClass1$", ObjBindMethod(This, "CheckPlugin"), False, False, False, 1, False)
        GatewayOverlay := PluginOverlay("Gateway", "Gateway")
        GatewayOverlay.AddOCRButton("Model", "Select model..", "TesseractBest", 270, 316, 400, 332)
        GatewayOverlay.AddHotspotButton("Unload model", 479, 324)
        GatewayOverlay.AddOCRButton("IR", "Select IR...", "TesseractBest", 288, 354, 400, 370)
        GatewayOverlay.AddHotspotButton("Unload IR", 479, 362)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Gateway"
        Return True
        If ReaHotkey.AbletonPlugin {
            If RegExMatch(WinGetTitle("A"), "^Gateway/[1-9][0-9]*")
            Return True
        }
        If ReaHotkey.ReaperPluginNative {
            ReaperFXInstanceName := GetReaperFXInstanceName()
            ReaperPluginNames := ["VST3: Gateway (Atkinson Advanced Modeling, LLC)"]
            If Not ReaperFXInstanceName = ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperFXInstanceName = ReaperPluginName
            Return True
        }
        If ReaHotkey.ReaperPluginBridged {
            Try
            If RegExMatch(WinGetTitle("A"), "^Gateway \(x(64|86) bridged\)$")
            Return True
            Catch
            Return False
        }
        Return False
    }
    
}
