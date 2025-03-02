#Requires AutoHotkey v2.0

Class AbletonLive {
    
    Static __New() {
        Standalone.Register("Ableton Main Window", "ahk_class Ableton Live Window Class ahk_exe Ableton Live 12( Beta)?.exe", ObjBindMethod(This, "InitMainWindow"), False, True)
        Standalone.Register("Ableton Plugin Window", "ahk_class Vst3PlugWindow ahk_exe Ableton Live 12( Beta)?.exe", ObjBindMethod(This, "InitPluginWindow"), False, True)
    }
    
    Static CheckForPluginWindow() {
        AccessibilityOverlay.Speak("Main timer is running")
    }
    
    Static CheckForSupportedPlugin() {
        AccessibilityOverlay.Speak("Plugin timer is running")
    }
    
    Static InitMainWindow(Instance) {
        Standalone.SetTimer(Instance.Name, ObjBindMethod(This, "CheckForPluginWindow"), 5000)
    }
    
    Static InitPluginWindow(Instance) {
        Standalone.SetTimer(Instance.Name, ObjBindMethod(This, "CheckForSupportedPlugin"), 5000)
    }
    
}
