#Requires AutoHotkey v2.0

ChangePluginOverlay(ItemName, ItemNumber, OverlayMenu) {
    OverlayList := Plugin.GetOverlays(ReaHotkey.FoundPlugin.Name)
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If ReaHotkey.FoundPlugin.Overlay.OverlayNumber != OverlayNumber {
        ReaHotkey.FoundPlugin.Overlay := AccessibilityOverlay(ItemName)
        ReaHotkey.FoundPlugin.Overlay.OverlayNumber := OverlayNumber
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        ReaHotkey.FoundPlugin.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        ReaHotkey.FoundPlugin.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        ReaHotkey.FoundPlugin.Overlay.AddControl(Plugin.ChooserOverlay.Clone())
        ReaHotkey.FoundPlugin.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . ItemName
        ReaHotkey.FoundPlugin.Overlay.SetCurrentControlID(ReaHotkey.FoundPlugin.Overlay.ChildControls[2].ChildControls[1].ControlID)
        ReaHotkey.FoundPlugin.Overlay.ChildControls[2].ChildControls[1].Focus()
    }
}

ChangeStandaloneOverlay(ItemName, ItemNumber, OverlayMenu) {
    OverlayList := Standalone.GetOverlays(ReaHotkey.FoundStandalone.Name)
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If ReaHotkey.FoundStandalone.Overlay.OverlayNumber != OverlayNumber {
        ReaHotkey.FoundStandalone.Overlay := AccessibilityOverlay(ItemName)
        ReaHotkey.FoundStandalone.Overlay.OverlayNumber := OverlayNumber
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        ReaHotkey.FoundStandalone.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        ReaHotkey.FoundStandalone.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        ReaHotkey.FoundStandalone.Overlay.AddControl(Standalone.ChooserOverlay.Clone())
        ReaHotkey.FoundStandalone.Overlay.ChildControls[2].ChildControls[1].Label := "Overlay: " . ItemName
        ReaHotkey.FoundStandalone.Overlay.SetCurrentControlID(ReaHotkey.FoundStandalone.Overlay.ChildControls[2].ChildControls[1].ControlID)
        ReaHotkey.FoundStandalone.Overlay.ChildControls[2].ChildControls[1].Focus()
    }
}

ChoosePluginOverlay(*) {
    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    CreateOverlayMenu(ReaHotkey.FoundPlugin, "Plugin").Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

ChooseStandaloneOverlay(*) {
    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    CreateOverlayMenu(ReaHotkey.FoundStandalone, "Standalone").Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

CompensatePluginPointCoordinates(PluginControl) {
    If !HasProp(PluginControl, "OriginalXCoordinate")
    PluginControl.OriginalXCoordinate := PluginControl.XCoordinate
    If !HasProp(PluginControl, "OriginalYCoordinate")
    PluginControl.OriginalYCoordinate := PluginControl.YCoordinate
    ControlGetPos &PluginControlXCoordinate, &PluginControlYCoordinate,,, ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)), ReaHotkey.PluginWinCriteria
    PluginControl.XCoordinate := PluginControlXCoordinate + PluginControl.OriginalXCoordinate
    PluginControl.YCoordinate := PluginControlYCoordinate + PluginControl.OriginalYCoordinate
    Return PluginControl
}

CompensatePluginRegionCoordinates(PluginControl) {
    If !HasProp(PluginControl, "OriginalRegionX1Coordinate")
    PluginControl.OriginalRegionX1Coordinate := PluginControl.RegionX1Coordinate
    If !HasProp(PluginControl, "OriginalRegionY1Coordinate")
    PluginControl.OriginalRegionY1Coordinate := PluginControl.RegionY1Coordinate
    If !HasProp(PluginControl, "OriginalRegionX2Coordinate")
    PluginControl.OriginalRegionX2Coordinate := PluginControl.RegionX2Coordinate
    If !HasProp(PluginControl, "OriginalRegionY2Coordinate")
    PluginControl.OriginalRegionY2Coordinate := PluginControl.RegionY2Coordinate
    ControlGetPos &PluginControlXCoordinate, &PluginControlYCoordinate,,, ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)), ReaHotkey.PluginWinCriteria
    PluginControl.RegionX1Coordinate := PluginControlXCoordinate + PluginControl.OriginalRegionX1Coordinate
    PluginControl.RegionY1Coordinate := PluginControlYCoordinate + PluginControl.OriginalRegionY1Coordinate
    PluginControl.RegionX2Coordinate := PluginControlXCoordinate + PluginControl.OriginalRegionX2Coordinate
    PluginControl.RegionY2Coordinate := PluginControlYCoordinate + PluginControl.OriginalRegionY2Coordinate
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

InArray(Needle, Haystack) {
    For FoundIndex, FoundValue In Haystack
    If FoundValue == Needle
    Return FoundIndex
    Return False
}
