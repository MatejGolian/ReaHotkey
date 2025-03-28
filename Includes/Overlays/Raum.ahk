#Requires AutoHotkey v2.0

Class Raum {
    
    Static __New() {
        Plugin.Register("Raum", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", False, False, 1, False, ObjBindMethod(This, "CheckInstance"))
        RaumOverlay := AccessibilityOverlay("Raum")
        RaumOverlay.AddStaticText("Press Alt+P to open the preset menu. Press Alt+N to hear the name of the currently loaded preset. Press Alt+H to hear this message. Press OK below to dismiss  this dialog until next time the script is reloaded.")
        RaumOverlay.AddCustomButton("OK",,,, ObjBindMethod(This, "dismissHKMessage")).SetHotkey("!O", "Alt+O")
        Plugin.RegisterOverlay("Raum", RaumOverlay)
        Plugin.SetHotkey("Raum", "!H", ObjBindMethod(This, "DoNothing"))
        Plugin.SetHotkey("Raum", "!N", ObjBindMethod(This, "DoNothing"))
        Plugin.SetHotkey("Raum", "!P", ObjBindMethod(This, "DoNothing"))
    }
    
    Static CheckInstance(Instance) {
        Thread "NoTimers"
        If Instance Is Plugin And Instance.ControlClass = GetCurrentControlClass()
        If Instance.Name = "Raum"
        Return True
        If ReaHotkey.AbletonPlugin Or ReaHotkey.ReaperPluginNative {
            UIAElement := This.GetUIAElement()
            If UIAElement
            Return True
        }
        Return False
    }
    
    Static ClickPresetMenu(HK) {
        PluginControlPos := GetPluginControlPos()
        HotkeyWait(HK)
        Click PluginControlPos.X + 265, PluginControlPos.Y + 15
        AccessibilityOverlay.Speak("Preset menu clicked.")
    }
    
    Static dismissHKMessage(OverlayObj) {
        Plugin.SetHotkeyMode("Raum", 2)
        Plugin.SetHotkey("Raum", "!H", ObjBindMethod(This, "SayHelpMessage"))
        Plugin.SetHotkey("Raum", "!N", ObjBindMethod(This, "SayPresetName"))
        Plugin.SetHotkey("Raum", "!P", ObjBindMethod(This, "ClickPresetMenu"))
    }
    
    Static DoNothing(HK) {
        Return
    }
    
    Static GetUIAElement() {
        Critical
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Try
        UIAElement := UIAElement.FindElement({ClassName:"ni::qt::QuickWindow"})
        Catch
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Raum" And UIAElement.Type = 50032
            Return True
            Return False
        }
    }
    
    Static SayHelpMessage(HK) {
        HotkeyWait(HK)
        AccessibilityOverlay.Speak("Press Alt+P to open the preset menu. Press Alt+N to hear the name of the currently loaded preset. Press Alt+H to hear this message.")
    }
    
    Static SayPresetName(HK) {
        PluginControlPos := GetPluginControlPos()
        HotkeyWait(HK)
        AccessibilityOverlay.Speak("Preset " . AccessibilityOverlay.OCR("TesseractBest", PluginControlPos.X + 184, PluginControlPos.Y + 8, PluginControlPos.X + 364, PluginControlPos.Y + 28))
    }
    
}
