#Requires AutoHotkey v2.0

Class Raum {
    
    Static __New() {
        This.InitConfig()
        Plugin.Register("Raum", "^Qt6[0-9][0-9]QWindowIcon\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}1$", ObjBindMethod(This, "InitInstance"), False, 1, False, ObjBindMethod(This, "CheckInstance"))
        RaumOverlay := PluginOverlay("Raum", "Raum", KompleteKontrol.CompensatePluginCoordinates)
        RaumOverlay.AddStaticText("Press Alt+P to open the preset menu. Press Alt+N to hear the name of the currently loaded preset. Press Alt+H to hear this message. Press OK below to dismiss  this dialog.")
        RaumOverlay.AddCustomCheckbox("Don't show this again",, ObjBindMethod(This, "InitHKMessageCheckbox"),, ObjBindMethod(This, "ToggleHKMessageCheckbox"))
        RaumOverlay.AddCustomButton("OK",,,, ObjBindMethod(This, "dismissHKMessage")).SetHotkey("!O", "Alt+O")
    }
    
    Static CheckInstance(Instance) {
        Thread "NoTimers"
        If Instance Is Plugin And Instance.ControlClass = ReaHotkey.GetPluginControl()
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
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        HotkeyWait(HK)
        Click PluginControlPos.X + 265, PluginControlPos.Y + 15
        AccessibilityOverlay.Speak("Preset menu clicked.")
    }
    
    Static dismissHKMessage(OverlayObj) {
        HelpCheckbox := ReaHotkey.FoundPlugin.Overlay.ChildControls[2]
        If HelpCheckbox.Checked = 1
        HelpSettingValue := 0
        Else
        HelpSettingValue := 1
        ReaHotkey.Config.Set("Config", "RaumHelpMessage", HelpSettingValue)
        Plugin.SetHotkeyMode("Raum", 2)
        Plugin.SetHotkey("Raum", "!H", ObjBindMethod(This, "SayHelpMessage"))
        Plugin.SetHotkey("Raum", "!N", ObjBindMethod(This, "SayPresetName"))
        Plugin.SetHotkey("Raum", "!O", "Off")
        Plugin.SetHotkey("Raum", "!P", ObjBindMethod(This, "ClickPresetMenu"))
    }
    
    Static DoNothing(HK) {
        Return
    }
    
    Static GetUIAElement() {
        Critical
        Static Criteria := [{ClassName: "ni::qt::QuickWindow"}, {ClassName: "QWindowIcon", MatchMode: "Substring"}]
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := AccessibilityOverlay.Helpers.GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        Try
        If CheckElement(UIAElement)
        Return UIAElement
        Loop Criteria.Length {
            Try
            UIAElements := UIAElement.FindElements(Criteria[A_Index])
            Catch
            UIAElements := Array()
            Try
            For UIAElement In UIAElements
            If CheckElement(UIAElement)
            Return UIAElement
        }
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Name = "Raum"
            If UIAElement.Type = 50032 Or UIAElement.Type = 50033
            Return True
            Return False
        }
    }
    
    Static InitHKMessageCheckbox(OverlayObj) {
        Static FirstRun := True
        If FirstRun And ReaHotkey.Config.Get("Config", "RaumHelpMessage") = 1
        OverlayObj.Checked := 0
        FirstRun := False
    }
    
    Static InitInstance(Instance) {
        If ReaHotkey.Config.Get("Config", "RaumHelpMessage") = 1 {
            Plugin.SetHotkey("Raum", "!H", ObjBindMethod(This, "DoNothing"))
            Plugin.SetHotkey("Raum", "!N", ObjBindMethod(This, "DoNothing"))
            Plugin.SetHotkey("Raum", "!P", ObjBindMethod(This, "DoNothing"))
        }
        Else {
            Plugin.SetHotkeyMode("Raum", 2)
            Plugin.SetHotkey("Raum", "!H", ObjBindMethod(This, "SayHelpMessage"))
            Plugin.SetHotkey("Raum", "!N", ObjBindMethod(This, "SayPresetName"))
            Plugin.SetHotkey("Raum", "!O", "Off")
            Plugin.SetHotkey("Raum", "!P", ObjBindMethod(This, "ClickPresetMenu"))
        }
    }
    
    Static InitConfig() {
        ReaHotkey.Config.Add("ReaHotkey.ini", "Config", "RaumHelpMessage", 1, "Show help message in Raum", "Misc")
    }
    
    Static SayHelpMessage(HK) {
        HotkeyWait(HK)
        AccessibilityOverlay.Speak("Press Alt+P to open the preset menu. Press Alt+N to hear the name of the currently loaded preset. Press Alt+H to hear this message.")
    }
    
    Static SayPresetName(HK) {
        PluginControlPos := KompleteKontrol.GetPluginControlPos()
        HotkeyWait(HK)
        AccessibilityOverlay.Speak("Preset " . AccessibilityOverlay.Helpers.OCR("TesseractBest", PluginControlPos.X + 184, PluginControlPos.Y + 8, PluginControlPos.X + 364, PluginControlPos.Y + 28))
    }
    
    Static ToggleHKMessageCheckbox(OverlayObj) {
        If OverlayObj.Checked = 1
        OverlayObj.Checked := 0
        Else
        OverlayObj.Checked := 1
    }
    
}
