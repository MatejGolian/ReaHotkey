#Requires AutoHotkey v2.0

ActivateEnginePluginAddLibraryButton(EngineAddLibraryButton) {
    EngineLibrariesTab := AccessibilityOverlay.GetControl(EngineAddLibraryButton.SuperordinateControlID)
    EnginePreferencesTab := AccessibilityOverlay.GetControl(EngineLibrariesTab.SuperordinateControlID)
    EnginePreferencesTab.Focus(EnginePreferencesTab.ControlID)
    EngineLibrariesTab.Focus(EngineLibrariesTab.ControlID)
    EngineAddLibraryButton.Focus(EngineAddLibraryButton.ControlID)
    AccessibilityOverlay.Speak("")
}

ChangePluginOverlay(ItemName, ItemNumber, OverlayMenu) {
    Global FoundPlugin
    OverlayList := Plugin.GetOverlays(FoundPlugin.Name)
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If FoundPlugin.Overlay.OverlayNumber != OverlayNumber {
        FoundPlugin.Overlay := AccessibilityOverlay(ItemName)
        FoundPlugin.Overlay.OverlayNumber := OverlayNumber
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        FoundPlugin.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        FoundPlugin.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        FoundPlugin.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
        FoundPlugin.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . ItemName
        FoundPlugin.Overlay.SetCurrentControlID(FoundPlugin.Overlay.ChildControls[2].ChildControls[1].ControlID)
        FoundPlugin.Overlay.FocusControl(FoundPlugin.Overlay.ChildControls[2].ChildControls[1].ControlID)
    }
}

ChangeStandaloneOverlay(ItemName, ItemNumber, OverlayMenu) {
    Global FoundStandalone
    OverlayList := Standalone.GetOverlays(FoundStandalone.Name)
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If FoundStandalone.Overlay.OverlayNumber != OverlayNumber {
        FoundStandalone.Overlay := AccessibilityOverlay(ItemName)
        FoundStandalone.Overlay.OverlayNumber := OverlayNumber
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        FoundStandalone.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        FoundStandalone.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        FoundStandalone.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
        FoundStandalone.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . ItemName
        FoundStandalone.Overlay.SetCurrentControlID(FoundStandalone.Overlay.ChildControls[2].ChildControls[1].ControlID)
        FoundStandalone.Overlay.FocusControl(FoundStandalone.Overlay.ChildControls[2].ChildControls[1].ControlID)
    }
}

ChoosePluginOverlay(*) {
    Global FoundPlugin
    SetTimer ManageInput, 0
    TurnHotkeysOff()
    CreateOverlayMenu(FoundPlugin, "Plugin").Show()
    TurnHotkeysOn()
    SetTimer ManageInput, 100
}

ChooseStandaloneOverlay(*) {
    Global FoundStandalone
    SetTimer ManageInput, 0
    TurnHotkeysOff()
    CreateOverlayMenu(FoundStandalone, "Standalone").Show()
    TurnHotkeysOn()
    SetTimer ManageInput, 100
}

CompensatePluginCoordinates(PluginControl) {
    Global PluginWinCriteria
    If !HasProp(PluginControl, "OriginalXCoordinate")
    PluginControl.OriginalXCoordinate := PluginControl.XCoordinate
    If !HasProp(PluginControl, "OriginalYCoordinate")
    PluginControl.OriginalYCoordinate := PluginControl.YCoordinate
    ControlGetPos &PluginControlXCoordinate, &PluginControlYCoordinate,,, ControlGetClassNN(ControlGetFocus(PluginWinCriteria)), PluginWinCriteria
    PluginControl.XCoordinate := PluginControlXCoordinate + PluginControl.OriginalXCoordinate
    PluginControl.YCoordinate := PluginControlYCoordinate + PluginControl.OriginalYCoordinate
    Return PluginControl
}

CreateOverlayMenu(Found, Type) {
    CurrentOverlay := Found.Overlay
    OverlayEntries := %Type%.GetOverlays(Found.Name)
    OverlayList := ""
    OverlayMenu := Menu()
    OverlayMenu.OverlayNumbers := Array()
    UnknownProductCounter := 1
    If HasProp(CurrentOverlay, "Metadata") And CurrentOverlay.Metadata.Has("Vendor") And CurrentOverlay.Metadata["Vendor"] != ""
    CurrentVendor := CurrentOverlay.Metadata["Vendor"]
    Else
    CurrentVendor := ""
    For OverlayNumber, OverlayEntry In OverlayEntries {
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Vendor") And OverlayEntry.Metadata["Vendor"] != "" {
            Vendor := OverlayEntry.Metadata["Vendor"]
        }
        Else {
            Vendor := ""
        }
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") And OverlayEntry.Metadata["Product"] != "" {
            Product := OverlayEntry.Metadata["Product"]
        }
        Else If OverlayEntry.Label != "" {
            Product := OverlayEntry.Label
        }
        Else {
            Product := "unknown product " . UnknownProductCounter
            UnknownProductCounter++
        }
        OverlayList .= Vendor . "`t" . Product . "`t" . OverlayNumber . "`n"
        OverlayList := Sort(OverlayList)
    }
    MainMenuItems := Array()
    Submenus := Map()
    Loop parse, OverlayList, "`n" {
        OverlayEntry := StrSplit(A_LoopField, "`t")
        If OverlayEntry.Length == 3 {
            Vendor := OverlayEntry[1]
            For ElementIndex, ElementValue In OverlayEntry {
                If Vendor == "" {
                    If ElementIndex == 1
                    MainMenuItems.Push(Map("Product", "", "OverlayNumber", ""))
                    If ElementIndex == 2
                    MainMenuItems[MainMenuItems.Length]["Product"] := ElementValue
                    If ElementIndex == 3
                    MainMenuItems[MainMenuItems.Length]["OverlayNumber"] := ElementValue
                }
                Else {
                    If ElementIndex == 1 {
                        If Not Submenus.Has(Vendor)
                        Submenus.Set(Vendor, Array())
                        Submenus[Vendor].Push(Map("Product", "", "OverlayNumber", ""))
                    }
                    If ElementIndex == 2
                    Submenus[Vendor][Submenus[Vendor].Length]["Product"] := ElementValue
                    If ElementIndex == 3
                    Submenus[Vendor][Submenus[Vendor].Length]["OverlayNumber"] := ElementValue
                }
            }
        }
    }
    For Vendor, OverlayEntries In Submenus {
        Submenu := Menu()
        Submenu.OverlayNumbers := Array()
        For OverlayEntry In OverlayEntries {
            Submenu.Add(OverlayEntry["Product"], Change%Type%Overlay)
            If OverlayEntry["OverlayNumber"] == CurrentOverlay.OverlayNumber
            Submenu.Check(OverlayEntry["Product"])
            Submenu.OverlayNumbers.Push(OverlayEntry["OverlayNumber"])
        }
        Submenu.Add("")
        Submenu.OverlayNumbers.Push(0)
        OverlayMenu.Add(Vendor, Submenu)
        If Vendor == CurrentVendor
        OverlayMenu.Check(Vendor)
        OverlayMenu.OverlayNumbers.Push(0)
    }
    For OverlayEntry In MainMenuItems {
        OverlayMenu.Add(OverlayEntry["Product"], Change%Type%Overlay)
        If OverlayEntry["OverlayNumber"] == CurrentOverlay.OverlayNumber
        OverlayMenu.Check(OverlayEntry["Product"])
        OverlayMenu.OverlayNumbers.Push(OverlayEntry["OverlayNumber"])
    }
    OverlayMenu.Add("")
    OverlayMenu.OverlayNumbers.Push(0)
    Return OverlayMenu
}
