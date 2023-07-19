#Requires AutoHotkey v2.0

ChangePluginOverlay(ItemName, ItemNumber, OverlayMenu) {
    Global FoundPlugin
    OverlayList := FoundPlugin.GetOverlays()
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If FoundPlugin.Overlay.Label != OverlayList[OverlayNumber].Label {
        FoundPlugin.Overlay := AccessibilityOverlay(ItemName)
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        FoundPlugin.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        FoundPlugin.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        FoundPlugin.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
        FoundPlugin.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . ItemName
        FoundPlugin.Overlay.FocusControl(FoundPlugin.Overlay.ChildControls[2].ChildControls[1].ControlID)
    }
}

ChangeStandaloneOverlay(ItemName, ItemNumber, OverlayMenu) {
    Global FoundStandalone
    OverlayList := FoundStandalone.GetOverlays()
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If FoundStandalone.Overlay.Label != OverlayList[OverlayNumber].Label {
        FoundStandalone.Overlay := AccessibilityOverlay(ItemName)
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        FoundStandalone.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        FoundStandalone.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        FoundStandalone.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
        FoundStandalone.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . ItemName
        FoundStandalone.Overlay.FocusControl(FoundStandalone.Overlay.ChildControls[2].ChildControls[1].ControlID)
    }
}

ChoosePluginOverlay(*) {
    Global FoundPlugin
    SetTimer ManageHotkeys, 0
    TurnAllHotkeysOff()
    CreateOverlayMenu(FoundPlugin, "Plugin").Show()
    TurnAllHotkeysOn()
    SetTimer ManageHotkeys, 100
}

ChooseStandaloneOverlay(*) {
    Global FoundStandalone
    SetTimer ManageHotkeys, 0
    TurnAllHotkeysOff()
    CreateOverlayMenu(FoundStandalone, "Standalone").Show()
    TurnAllHotkeysOn()
    SetTimer ManageHotkeys, 100
}

CreateOverlayMenu(Found, Type) {
    OverlayList := Found.GetOverlays()
    SortedOverlayList := Map()
    For OverlayNumber, OverlayEntry In OverlayList
    If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") And OverlayEntry.Metadata["Product"] != ""
    SortedOverlayList.Set(OverlayEntry.Metadata["Product"], OverlayNumber)
    Else
    SortedOverlayList.Set(OverlayEntry.Label, OverlayNumber)
    OverlayMenu := Menu()
    OverlayMenu.OverlayNumbers := Array()
    If OverlayList.Length > 0 {
        VendorList := Array()
        VendorMenuList := Map()
        For OverlayEntry In OverlayList
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Vendor") And OverlayEntry.Metadata["Vendor"] != ""
        VendorMenuList.Set(OverlayEntry.Metadata["Vendor"], OverlayEntry.Metadata["Vendor"])
        For VendorMenu In VendorMenuList
        OverlayMenu.Add(VendorMenu, Menu())
        VendorMenuList := Array()
        For OverlayText, OverlayNumber In SortedOverlayList {
            OverlayEntry := OverlayList[OverlayNumber]
            If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Vendor") And OverlayEntry.Metadata["Vendor"] != "" {
                If !InArray(OverlayEntry.Metadata["Vendor"], VendorList) {
                    VendorList.Push(OverlayEntry.Metadata["Vendor"])
                    VendorMenuList.Push(Menu())
                    VendorMenuNumber := InArray(OverlayEntry.Metadata["Vendor"], VendorList)
                    VendorMenuList[VendorMenuNumber].OverlayNumbers := Array()
                    OverlayMenu.Add(OverlayEntry.Metadata["Vendor"], VendorMenuList[VendorMenuNumber])
                }
                VendorMenuNumber := InArray(OverlayEntry.Metadata["Vendor"], VendorList)
                If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") {
                    VendorMenuList[VendorMenuNumber].Add(OverlayEntry.Metadata["Product"], Change%Type%Overlay)
                    VendorMenuList[VendorMenuNumber].OverlayNumbers.Push(OverlayNumber)
                    If HasProp(Found.Overlay, "Metadata") And Found.Overlay.Metadata["Product"] == OverlayEntry.Metadata["Product"] {
                        OverlayMenu.Check(VendorList[VendorMenuNumber])
                        VendorMenuList[VendorMenuNumber].Check(OverlayEntry.Metadata["Product"])
                    }
                }
                Else {
                    VendorMenuList[VendorMenuNumber].Add(OverlayEntry.Label, Change%Type%Overlay)
                    VendorMenuList[VendorMenuNumber].OverlayNumbers.Push(OverlayNumber)
                    If Found.Overlay.Label == OverlayEntry.Label {
                        OverlayMenu.Check(VendorList[VendorMenuNumber])
                        VendorMenuList[VendorMenuNumber].Check(OverlayEntry.Label)
                    }
                }
            }
            Else {
                If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") {
                    OverlayMenu.Add(OverlayEntry.Metadata["Product"], Change%Type%Overlay)
                    OverlayMenu.OverlayNumbers.Push(OverlayNumber)
                    If HasProp(Found.Overlay, "Metadata") And Found.Overlay.Metadata["Product"] == OverlayEntry.Metadata["Product"]
                    OverlayMenu.Check(OverlayEntry.Metadata["Product"])
                }
                Else {
                    OverlayMenu.Add(OverlayEntry.Label, Change%Type%Overlay)
                    OverlayMenu.OverlayNumbers.Push(OverlayNumber)
                    If Found.Overlay.Label == OverlayEntry.Label
                    OverlayMenu.Check(OverlayEntry.Label)
                }
            }
        }
        For VendorMenu In VendorMenuList
        VendorMenu.Add("")
        OverlayMenu.Add("")
    }
    Return OverlayMenu
}

FocusDefaultOverlay(Overlay) {
    AccessibilityOverlay.Speak("No overlay defined")
}

FocusEnginePlugin(EngineInstance) {
    EngineOverlay := EngineInstance.GetOverlay()
    CurrentEngineControl := EngineOverlay.GetCurrentControl()
    EngineAddLibraryButton := FocusedEnginePluginAddLibraryButton()
    If EngineAddLibraryButton Is Object And CurrentEngineControl == EngineAddLibraryButton {
        EngineLibrariesTab := AccessibilityOverlay.GetControl(EngineAddLibraryButton.SuperordinateControlID)
        EnginePreferencesTab := AccessibilityOverlay.GetControl(EngineLibrariesTab.SuperordinateControlID)
        EnginePreferencesTab.Focus(EnginePreferencesTab.ControlID)
        EngineLibrariesTab.Focus(EngineLibrariesTab.ControlID)
        EngineAddLibraryButton.Focus(EngineAddLibraryButton.ControlID)
    }
}

FocusedEnginePluginAddLibraryButton(OverlayObject := False) {
    Static
    If !IsSet(AddLibraryButton)
    AddLibraryButton := False
    If OverlayObject Is Object
    AddLibraryButton := OverlayObject
    Return AddLibraryButton
}

GetPluginControl() {
    Global PluginWinCriteria
    Controls := WinGetControls(PluginWinCriteria)
    For PluginEntry In Plugin.List {
        If PluginEntry["ControlClasses"] Is Array And PluginEntry["ControlClasses"].Length > 0
        For ControlClass In PluginEntry["ControlClasses"]
        For Control In Controls
        If RegExMatch(Control, ControlClass)
        Return Control
    }
    Return False
}

InArray(Needle, Haystack) {
    For FoundIndex, FoundValue In Haystack
    If FoundValue == Needle
    Return FoundIndex
    Return False
}

ImportOverlays() {
    #Include Overlays.ahk
}

ManageHotkeys() {
    Global FoundPlugin, FoundStandalone, PluginWinCriteria, StandaloneWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria)
    If WinExist("ahk_class #32768") {
        TurnAllHotkeysOff()
        Return False
    }
    Else If ControlGetFocus(PluginWinCriteria) == 0 {
        TurnAllHotkeysOff()
        Return False
    }
    Else If Plugin.FindClass(ControlGetClassNN(ControlGetFocus(PluginWinCriteria))) == 0 {
        TurnAllHotkeysOff()
        Return False
    }
    Else {
        Hotkey "F6", "On"
        Hotkey "Tab", "On"
        Hotkey "+Tab", "On"
        Hotkey "Right", "On"
        Hotkey "^Tab", "On"
        Hotkey "Left", "On"
        Hotkey "^+Tab", "On"
        If FoundPlugin Is Plugin And FoundPlugin.Overlay.GetCurrentControl().ControlType == "Edit" {
            Hotkey "Space", "Off"
            Hotkey "Enter", "Off"
        }
        Else {
            Hotkey "Space", "On"
            Hotkey "Enter", "On"
        }
        Hotkey "Ctrl", "On"
        Hotkey "^R", "On"
        Return True
    }
    Else
    If WinExist("ahk_class #32768") {
        TurnAllHotkeysOff()
        Return False
    }
    Else {
        For Program In Standalone.List
        If WinActive(Program["WinCriteria"]) {
            StandaloneWinCriteria := Program["WinCriteria"]
            Hotkey "Tab", "On"
            Hotkey "+Tab", "On"
            Hotkey "Right", "On"
            Hotkey "^Tab", "On"
            Hotkey "Left", "On"
            Hotkey "^+Tab", "On"
            If FoundStandalone Is Standalone And FoundStandalone.Overlay.GetCurrentControl().ControlType == "Edit" {
                Hotkey "Space", "Off"
                Hotkey "Enter", "Off"
            }
            Else {
                Hotkey "Space", "On"
                Hotkey "Enter", "On"
            }
            Hotkey "Ctrl", "On"
            Hotkey "^R", "On"
            Return True
        }
        TurnAllHotkeysOff()
        Return False
    }
}

TurnAllHotkeysOff() {
    Global FoundPluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria) And WinExist("ahk_class #32768")
    Hotkey "F6", "Off"
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
}

TurnAllHotkeysOn() {
    Global PluginWinCriteria
    If WinActive(PluginWinCriteria)
    HotIfWinActive(PluginWinCriteria)
    Else
    HotIf
    If WinActive(PluginWinCriteria) And !WinExist("ahk_class #32768")
    Hotkey "F6", "On"
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
}
