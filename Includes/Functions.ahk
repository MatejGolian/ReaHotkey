#Requires AutoHotkey v2.0

ChangePluginOverlay(ItemName, ItemNumber, *) {
    Global FoundPlugin
    OverlayList := FoundPlugin.GetOverlays()
    If FoundPlugin.Overlay.Label != ItemName {
        FoundPlugin.Overlay := AccessibilityOverlay(ItemName)
        FoundPlugin.Overlay.AddControl(OverlayList[ItemNumber].Clone())
        FoundPlugin.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
    }
}

ChangeStandaloneOverlay(ItemName, ItemNumber, *) {
    Global FoundStandalone
    OverlayList := FoundStandalone.GetOverlays()
    If FoundStandalone.Overlay.Label != ItemName {
        FoundStandalone.Overlay := AccessibilityOverlay(ItemName)
        FoundStandalone.Overlay.AddControl(OverlayList[ItemNumber].Clone())
        FoundStandalone.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
    }
}

ChoosePluginOverlay(*) {
    Global FoundPlugin
    OverlayList := FoundPlugin.GetOverlays()
    If OverlayList.Length > 0 {
        OverlayMenu := Menu()
        For OverlayEntry In OverlayList {
            OverlayMenu.Add(OverlayEntry.Label, ChangePluginOverlay)
            If FoundPlugin.Overlay.Label == OverlayEntry.Label
            OverlayMenu.Check(OverlayEntry.Label)
        }
        OverlayMenu.Add("")
        SetTimer ManageHotkeys, 0
        TurnHotkeysOff()
        OverlayMenu.Show()
        TurnHotkeysOn()
        SetTimer ManageHotkeys, 100
    }
}

ChooseStandaloneOverlay(*) {
    Global FoundStandalone
    OverlayList := FoundStandalone.GetOverlays()
    If OverlayList.Length > 0 {
        OverlayMenu := Menu()
        For OverlayEntry In OverlayList {
            OverlayMenu.Add(OverlayEntry.Label, ChangeStandaloneOverlay)
            If FoundStandalone.Overlay.Label == OverlayEntry.Label
            OverlayMenu.Check(OverlayEntry.Label)
        }
        OverlayMenu.Add("")
        SetTimer ManageHotkeys, 0
        TurnHotkeysOff()
        OverlayMenu.Show()
        TurnHotkeysOn()
        SetTimer ManageHotkeys, 100
    }
}

FocusDefaultOverlay(Overlay) {
    AccessibilityOverlay.Speak("No overlay defined")
}

FocusEnginePlugin(EngineInstance) {
    EngineOverlay := EngineInstance.GetOverlay()
    CurrentEngineControl := EngineOverlay.GetCurrentControl()
    If CurrentEngineControl Is HotspotButton And CurrentEngineControl.Label == "Add library"
    For EngineControl In EngineOverlay.GetAllFocusableControls() {
        EngineControl := AccessibilityOverlay.GetControl(EngineControl)
        If EngineControl Is TabControl And EngineControl.CurrentTab == 5 And EngineControl.GetCurrentTab() Is HotspotTab {
            EnginePreferencesTab := EngineControl.GetCurrentTab()
            For EnginePreferenceControl In EnginePreferencesTab.GetAllFocusableControls() {
                EnginePreferenceControl := AccessibilityOverlay.GetControl(EnginePreferenceControl)
                If EnginePreferenceControl Is TabControl And EnginePreferenceControl.CurrentTab == 2 And EnginePreferenceControl.GetCurrentTab() Is HotspotTab {
                    EngineLibrariesTab := EnginePreferenceControl.GetCurrentTab()
                    EnginePreferencesTab.Focus(EnginePreferencesTab.ControlID)
                    EngineLibrariesTab.Focus(EngineLibrariesTab.ControlID)
                    CurrentEngineControl.Focus(CurrentEngineControl.ControlID)
                }
            }
        }
    }
}

GetPluginControl() {
    Global PluginWinCriteria
    Controls := WinGetControls(PluginWinCriteria)
    For PluginEntry In Plugin.List {
        If IsObject(PluginEntry["ControlClasses"]) And PluginEntry["ControlClasses"].Length > 0
        For ControlClass In PluginEntry["ControlClasses"]
        For Control In Controls
        If RegExMatch(Control, ControlClass)
        Return Control
    }
    Return False
}

ManageHotkeys() {
    Global PluginWinCriteria, StandaloneWinCriteria
    If WinActive(PluginWinCriteria) {
        If WinExist("ahk_class #32768") {
            TurnHotkeysOff()
            Return False
        }
        Else If ControlGetFocus(PluginWinCriteria) == 0 {
            TurnHotkeysOff()
            Return False
        }
        Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) == 0 {
            TurnHotkeysOff()
            Return False
        }
        Else {
            TurnHotkeysOn()
            Return True
        }
    }
    Else {
        If WinExist("ahk_class #32768") {
            TurnHotkeysOff()
            Return False
        }
        Else {
            For Program In Standalone.List
            If WinActive(Program["WinCriteria"]) {
                StandaloneWinCriteria := Program["WinCriteria"]
                TurnHotkeysOn()
                Return True
            }
            TurnHotkeysOff()
            Return False
        }
    }
}

TurnHotkeysOff() {
    Global PluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    Hotkey "Tab", "Off"
    Hotkey "+Tab", "Off"
    Hotkey "Right", "Off"
    Hotkey "^Tab", "Off"
    Hotkey "Left", "Off"
    Hotkey "^+Tab", "Off"
    Hotkey "Space", "Off"
    Hotkey "Enter", "Off"
    Hotkey "Ctrl", "Off"
    Hotkey "^R", "Off"
    If WinActive(PluginWinCriteria) And WinExist("ahk_class #32768")
    Hotkey "F6", "Off"
}

TurnHotkeysOn() {
    Global PluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    Hotkey "Tab", "On"
    Hotkey "+Tab", "On"
    Hotkey "Right", "On"
    Hotkey "^Tab", "On"
    Hotkey "Left", "On"
    Hotkey "^+Tab", "On"
    Hotkey "Space", "On"
    Hotkey "Enter", "On"
    Hotkey "Ctrl", "On"
    Hotkey "^R", "On"
    If WinActive(PluginWinCriteria) And !WinExist("ahk_class #32768")
    Hotkey "F6", "On"
}
