#Requires AutoHotkey v2.0

Global A_IsUnicode := True

AutoChangeOverlay(Type, Name, CompensatePluginCoordinates := False, ReportChange := False) {
    Critical
    PluginControlPos := GetPluginControlPos()
    OverlayList := %Type%.GetOverlays(Name)
    UnknownProductCounter := 1
    WinWidth := ""
    WinHeight := ""
    Try {
        WinGetPos ,, &WinWidth, &WinHeight, "A"
    }
    Catch {
        WinWidth := A_ScreenWidth
        WinHeight := A_ScreenHeight
    }
    For OverlayNumber, OverlayEntry In OverlayList {
        FoundX := ""
        FoundY := ""
        If OverlayEntry.HasProp("Metadata") And OverlayEntry.Metadata.Has("Product") And Not OverlayEntry.Metadata["Product"] = "" {
            Product := OverlayEntry.Metadata["Product"]
        }
        Else If Not OverlayEntry.Label = "" {
            Product := OverlayEntry.Label
        }
        Else {
            Product := "unknown product " . UnknownProductCounter
            UnknownProductCounter++
        }
        If ReaHotkey.Found%Type% Is %Type% And ReaHotkey.Found%Type%.Overlay.HasProp("OverlayNumber") And Not ReaHotkey.Found%Type%.Overlay.OverlayNumber = OverlayEntry.OverlayNumber {
            ImageEntries := Array()
            If OverlayEntry.HasProp("Metadata") And OverlayEntry.Metadata.Has("Image") And Not OverlayEntry.Metadata["Image"] = "" {
                ImageEntries := OverlayEntry.Metadata["Image"].Clone()
                If Not ImageEntries Is Array
                ImageEntries := Array(ImageEntries)
                For ImageIndex, ImageEntry In ImageEntries
                ImageEntries[ImageIndex] := ProcessImageEntry(Type, CompensatePluginCoordinates, ImageEntry, WinWidth, WinHeight)
            }
            For ImageEntry In ImageEntries
            If FileExist(ImageEntry["File"]) {
                Try
                ImageFound := ImageSearch(&FoundX, &FoundY, ImageEntry["X1Coordinate"], ImageEntry["Y1Coordinate"], ImageEntry["X2Coordinate"], ImageEntry["Y2Coordinate"], ImageEntry["File"])
                Catch
                ImageFound := 0
                If ImageFound
                If ReaHotkey.Found%Type%.Chooser {
                    ReaHotkey.Found%Type%.Overlay := AccessibilityOverlay(OverlayEntry.Label)
                    ReaHotkey.Found%Type%.Overlay.OverlayNumber := OverlayNumber
                    If OverlayEntry.HasProp("Metadata")
                    ReaHotkey.Found%Type%.Overlay.Metadata := OverlayEntry.Metadata
                    ReaHotkey.Found%Type%.Overlay.AddControl(OverlayEntry.Clone())
                    ReaHotkey.Found%Type%.Overlay.AddControl(%Type%.ChooserOverlay.Clone())
                    If ReportChange
                    Report(Product)
                    FocusElement(Type)
                    Break 2
                }
                Else {
                    ReaHotkey.Found%Type%.Overlay := OverlayEntry.Clone()
                    If ReportChange
                    Report(Product)
                    FocusElement(Type)
                    Break 2
                }
            }
        }
    }
    FocusElement(Type) {
        If ReaHotkey.AutoFocus%Type%Overlay
        ReaHotkey.AutoFocus%Type%Overlay := False
        If ReaHotkey.Found%Type%.Chooser {
            ReaHotkey.Found%Type%.Overlay.ChildControls[2].Focus()
            ReaHotkey.Found%Type%.Overlay.SetCurrentControlID(ReaHotkey.Found%Type%.Overlay.ChildControls[2].CurrentControlID)
        }
        Else {
            ReaHotkey.Found%Type%.Overlay.Focus()
        }
    }
    ProcessImageEntry(Type, CompensatePluginCoordinates, ImageEntry, WinWidth, WinHeight) {
        If Not ImageEntry Is Map
        EntryData := Map("File", ImageEntry)
        Else
        EntryData := ImageEntry.Clone()
        If Not EntryData.Has("File")
        EntryData.Set("File", ImageEntry)
        If Not EntryData.Has("X1Coordinate")
        EntryData.Set("X1Coordinate", 0)
        If Not EntryData.Has("Y1Coordinate")
        EntryData.Set("Y1Coordinate", 0)
        If Not EntryData.Has("X2Coordinate")
        EntryData.Set("X2Coordinate", WinWidth)
        If Not EntryData.Has("Y2Coordinate")
        EntryData.Set("Y2Coordinate", WinHeight)
        If Not EntryData["X1Coordinate"] Is Number Or EntryData["X1Coordinate"] < 0
        EntryData["X1Coordinate"] := 0
        If Not EntryData["Y1Coordinate"] Is Number Or EntryData["Y1Coordinate"] < 0
        EntryData["Y1Coordinate"] := 0
        If Not EntryData["X2Coordinate"] Is Number Or EntryData["X2Coordinate"] <= 0
        EntryData["X2Coordinate"] := WinWidth
        If Not EntryData["Y2Coordinate"] Is Number Or EntryData["Y2Coordinate"] <= 0
        EntryData["Y2Coordinate"] := WinHeight
        If Type = "Plugin" And CompensatePluginCoordinates = True {
            EntryData["X1Coordinate"] := PluginControlPos.X + EntryData["X1Coordinate"]
            EntryData["Y1Coordinate"] := PluginControlPos.Y + EntryData["Y1Coordinate"]
            EntryData["X2Coordinate"] := PluginControlPos.X + EntryData["X2Coordinate"]
            EntryData["Y2Coordinate"] := PluginControlPos.Y + EntryData["Y2Coordinate"]
            If EntryData["X2Coordinate"] > WinWidth
            EntryData["X2Coordinate"] := WinWidth
            If EntryData["Y2Coordinate"] > WinHeight
            EntryData["Y2Coordinate"] := WinHeight
        }
        Return EntryData
    }
    Report(Product) {
        AccessibilityOverlay.Speak(Product . " overlay active")
        Wait(1250)
    }
}

AutoChangePluginOverlay(Name, CompensatePluginCoordinates := False, ReportChange := False) {
    AutoChangeOverlay("Plugin", Name, CompensatePluginCoordinates, ReportChange)
}

AutoChangeStandaloneOverlay(Name, ReportChange := False) {
    AutoChangeOverlay("Standalone", Name, False, ReportChange)
}

ChangeOverlay(Type, ItemName, ItemNumber, OverlayMenu) {
    Critical
    OverlayList := %Type%.GetOverlays(ReaHotkey.Found%Type%.Name)
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemName]
    If Not ReaHotkey.Found%Type%.Overlay.OverlayNumber = OverlayNumber
    If ReaHotkey.Found%Type%.Chooser {
        ReaHotkey.Found%Type%.Overlay := AccessibilityOverlay(ItemName)
        ReaHotkey.Found%Type%.Overlay.OverlayNumber := OverlayNumber
        If OverlayList[OverlayNumber].HasProp("Metadata")
        ReaHotkey.Found%Type%.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        ReaHotkey.Found%Type%.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        ReaHotkey.Found%Type%.Overlay.AddControl(%Type%.ChooserOverlay.Clone())
    }
    Else {
        ReaHotkey.Found%Type%.Overlay := OverlayList[OverlayNumber].Clone()
    }
    Else
    ReaHotkey.Found%Type%.Overlay.SetCurrentControlID(0)
    If ReaHotkey.AutoFocus%Type%Overlay
    ReaHotkey.AutoFocus%Type%Overlay := False
    If ReaHotkey.Found%Type%.Chooser {
        ReaHotkey.Found%Type%.Overlay.ChildControls[2].Focus()
        ReaHotkey.Found%Type%.Overlay.SetCurrentControlID(ReaHotkey.Found%Type%.Overlay.ChildControls[2].CurrentControlID)
    }
    Else {
        ReaHotkey.Found%Type%.Overlay.Focus()
    }
}

ChangePluginOverlay(ItemName, ItemNumber, OverlayMenu) {
    ChangeOverlay("Plugin", ItemName, ItemNumber, OverlayMenu)
}

ChangeStandaloneOverlay(ItemName, ItemNumber, OverlayMenu) {
    ChangeOverlay("Standalone", ItemName, ItemNumber, OverlayMenu)
}

ChooseOverlay(Type) {
    OverlayMenu := CreateOverlayMenu(Type)
    OverlayMenu.Show()
}

ChoosePluginOverlay(*) {
    ChooseOverlay("Plugin")
}

ChooseStandaloneOverlay(*) {
    ChooseOverlay("Standalone")
}

CompensateFocusedControlXCoordinate(ControlXCoordinate) {
    Try
    ControlGetPos &FocusedControlXCoordinate, &FocusedControlYCoordinate,,, ControlGetClassNN(ControlGetFocus("A")), "A"
    Catch
    Return ControlXCoordinate
    ControlXCoordinate := FocusedControlXCoordinate + ControlXCoordinate
    Return ControlXCoordinate
}

CompensateFocusedControlYCoordinate(ControlYCoordinate) {
    Try
    ControlGetPos &FocusedControlXCoordinate, &FocusedControlYCoordinate,,, ControlGetClassNN(ControlGetFocus("A")), "A"
    Catch
    Return ControlYCoordinate
    ControlYCoordinate := FocusedControlYCoordinate + ControlYCoordinate
    Return ControlYCoordinate
}

CompensatePluginCoordinates(PluginControl) {
    PluginControlPos := GetPluginControlPos()
    If PluginControl.HasProp("Start") And Not PluginControl.HasProp("OriginalStart")
    PluginControl.OriginalStart := PluginControl.Start
    If PluginControl.HasProp("End") And Not PluginControl.HasProp("OriginalEnd")
    PluginControl.OriginalEnd := PluginControl.End
    If PluginControl.HasProp("XCoordinate") And Not PluginControl.HasProp("OriginalXCoordinate")
    PluginControl.OriginalXCoordinate := PluginControl.XCoordinate
    If PluginControl.HasProp("YCoordinate") And Not PluginControl.HasProp("OriginalYCoordinate")
    PluginControl.OriginalYCoordinate := PluginControl.YCoordinate
    If PluginControl.HasProp("X1Coordinate") And Not PluginControl.HasProp("OriginalX1Coordinate")
    PluginControl.OriginalX1Coordinate := PluginControl.X1Coordinate
    If PluginControl.HasProp("Y1Coordinate") And Not PluginControl.HasProp("OriginalY1Coordinate")
    PluginControl.OriginalY1Coordinate := PluginControl.Y1Coordinate
    If PluginControl.HasProp("X2Coordinate") And Not PluginControl.HasProp("OriginalX2Coordinate")
    PluginControl.OriginalX2Coordinate := PluginControl.X2Coordinate
    If PluginControl.HasProp("Y2Coordinate") And Not PluginControl.HasProp("OriginalY2Coordinate")
    PluginControl.OriginalY2Coordinate := PluginControl.Y2Coordinate
    If PluginControl Is GraphicalHorizontalSlider {
        If PluginControl.HasProp("OriginalStart")
        PluginControl.Start := PluginControlPos.X + PluginControl.OriginalStart
        If PluginControl.HasProp("OriginalEnd")
        PluginControl.End := PluginControlPos.X + PluginControl.OriginalEnd
    }
    If PluginControl Is GraphicalVerticalSlider {
        If PluginControl.HasProp("OriginalStart")
        PluginControl.Start := PluginControlPos.Y + PluginControl.OriginalStart
        If PluginControl.HasProp("OriginalEnd")
        PluginControl.End := PluginControlPos.Y + PluginControl.OriginalEnd
    }
    If PluginControl.HasProp("OriginalXCoordinate")
    PluginControl.XCoordinate := PluginControlPos.X + PluginControl.OriginalXCoordinate
    If PluginControl.HasProp("OriginalYCoordinate")
    PluginControl.YCoordinate := PluginControlPos.Y + PluginControl.OriginalYCoordinate
    If PluginControl.HasProp("OriginalX1Coordinate")
    PluginControl.X1Coordinate := PluginControlPos.X + PluginControl.OriginalX1Coordinate
    If PluginControl.HasProp("OriginalY1Coordinate")
    PluginControl.Y1Coordinate := PluginControlPos.Y + PluginControl.OriginalY1Coordinate
    If PluginControl.HasProp("OriginalX2Coordinate")
    PluginControl.X2Coordinate := PluginControlPos.X + PluginControl.OriginalX2Coordinate
    If PluginControl.HasProp("OriginalY2Coordinate")
    PluginControl.Y2Coordinate := PluginControlPos.Y + PluginControl.OriginalY2Coordinate
    Return PluginControl
}

CompensatePluginXCoordinate(PluginXCoordinate) {
    PluginControlPos := GetPluginControlPos()
    PluginXCoordinate := PluginControlPos.X + PluginXCoordinate
    Return PluginXCoordinate
}

CompensatePluginYCoordinate(PluginYCoordinate) {
    PluginControlPos := GetPluginControlPos()
    PluginYCoordinate := PluginControlPos.Y + PluginYCoordinate
    Return PluginYCoordinate
}

ConvertBase(InputBase, OutputBase, nptr)    ; Base 2 - 36
{
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    s := ""
    VarSetStrCapacity(&s, 66)
    value := DllCall("msvcrt.dll\" u, "Str", nptr, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}

CreateOverlayMenu(Type) {
    Found := ReaHotkey.Found%Type%
    CurrentOverlay := Found.Overlay
    OverlayEntries := %Type%.GetOverlays(Found.Name)
    OverlayList := ""
    OverlayMenu := Accessible%Type%Menu()
    OverlayMenu.OverlayNumbers := Map()
    UnknownProductCounter := 1
    UnknownPatchCounter := 1
    If CurrentOverlay.HasProp("Metadata") And CurrentOverlay.Metadata.Has("Vendor") And Not CurrentOverlay.Metadata["Vendor"] = ""
    CurrentVendor := CurrentOverlay.Metadata["Vendor"]
    Else
    CurrentVendor := ""
    ProductSubmenus := Map()
    For OverlayNumber, OverlayEntry In OverlayEntries {
        If OverlayEntry.HasProp("Metadata") And OverlayEntry.Metadata.Has("Vendor") And Not OverlayEntry.Metadata["Vendor"] = "" {
            Vendor := OverlayEntry.Metadata["Vendor"]
        }
        Else {
            Vendor := ""
        }
        If Not ProductSubmenus.Has(Vendor)
        ProductSubmenus.Set(Vendor, Map())
        If OverlayEntry.HasProp("Metadata") And OverlayEntry.Metadata.Has("Product") And Not OverlayEntry.Metadata["Product"] = "" {
            Product := OverlayEntry.Metadata["Product"]
        }
        Else If Not OverlayEntry.Label = "" {
            Product := OverlayEntry.Label
        }
        Else {
            Product := "unknown product " . UnknownProductCounter
            UnknownProductCounter++
        }
        If OverlayEntry.HasProp("Metadata") And OverlayEntry.Metadata.Has("Patch") And Not OverlayEntry.Metadata["Patch"] = "" {
            Patch  := OverlayEntry.Metadata["Patch"]
            If Not ProductSubmenus[Vendor].Has(Product)
            ProductSubmenus[Vendor].Set(Product, Accessible%Type%Menu())
        }
        Else {
            Patch := "unknown patch " . UnknownPatchCounter
            UnknownPatchCounter++
        }
        OverlayList .= Vendor . "`t" . Product . "`t" . Patch . "`t" . OverlayNumber . "`n"
        OverlayList := Sort(OverlayList, "CLogical")
    }
    MainMenuItems := Array()
    VendorSubmenus := Map()
    Loop parse, OverlayList, "`n" {
        OverlayEntry := StrSplit(A_LoopField, "`t")
        If OverlayEntry.Length = 4 {
            Vendor := OverlayEntry[1]
            For ElementIndex, ElementValue In OverlayEntry {
                If Vendor = "" {
                    If ElementIndex = 1
                    MainMenuItems.Push(Map("Product", "", "Patch", "", "OverlayNumber", ""))
                    If ElementIndex = 2
                    MainMenuItems[MainMenuItems.Length]["Product"] := ElementValue
                    If ElementIndex = 3
                    MainMenuItems[MainMenuItems.Length]["Patch"] := ElementValue
                    If ElementIndex = 4
                    MainMenuItems[MainMenuItems.Length]["OverlayNumber"] := ElementValue
                }
                Else {
                    If ElementIndex = 1 {
                        If Not VendorSubmenus.Has(Vendor)
                        VendorSubmenus.Set(Vendor, Array())
                        VendorSubmenus[Vendor].Push(Map("Product", "", "Patch", "", "OverlayNumber", ""))
                    }
                    If ElementIndex = 2
                    VendorSubmenus[Vendor][VendorSubmenus[Vendor].Length]["Product"] := ElementValue
                    If ElementIndex = 3
                    VendorSubmenus[Vendor][VendorSubmenus[Vendor].Length]["Patch"] := ElementValue
                    If ElementIndex = 4
                    VendorSubmenus[Vendor][VendorSubmenus[Vendor].Length]["OverlayNumber"] := ElementValue
                }
            }
        }
    }
    For Vendor, OverlayEntries In VendorSubmenus {
        VendorSubmenu := Accessible%Type%Menu()
        VendorSubmenu.OverlayNumbers := Map()
        AddedProductSubmenus := Map()
        For ProductName, ProductSubmenu In ProductSubmenus[Vendor]
        AddedProductSubmenus.Set(ProductName, False)
        For OverlayEntry In OverlayEntries
        If ProductSubmenus[Vendor].Has(OverlayEntry["Product"]) {
            ProductSubmenu := ProductSubmenus[Vendor][OverlayEntry["Product"]]
            If Not AddedProductSubmenus[OverlayEntry["Product"]] {
                VendorSubmenu.Add(OverlayEntry["Product"], ProductSubmenu)
                AddedProductSubmenus[OverlayEntry["Product"]] := True
            }
            If Not ProductSubmenu.HasProp("OverlayNumbers")
            ProductSubmenu.OverlayNumbers := Map()
            ProductSubmenu.Add(OverlayEntry["Patch"], Change%Type%Overlay)
            If OverlayEntry["OverlayNumber"] = CurrentOverlay.OverlayNumber {
                VendorSubmenu.Check(OverlayEntry["Product"])
                ProductSubmenu.Check(OverlayEntry["Patch"])
            }
            ProductSubmenu.OverlayNumbers.Set(OverlayEntry["Patch"], OverlayEntry["OverlayNumber"])
        }
        Else {
            VendorSubmenu.Add(OverlayEntry["Product"], Change%Type%Overlay)
            If OverlayEntry["OverlayNumber"] = CurrentOverlay.OverlayNumber
            VendorSubmenu.Check(OverlayEntry["Product"])
            VendorSubmenu.OverlayNumbers.Set(OverlayEntry["Product"], OverlayEntry["OverlayNumber"])
        }
        For ProductName, ProductSubmenu In ProductSubmenus[Vendor]
        ProductSubmenu.Add("")
        VendorSubmenu.Add("")
        OverlayMenu.Add(Vendor, VendorSubmenu)
        If Vendor = CurrentVendor
        OverlayMenu.Check(Vendor)
    }
    For OverlayEntry In MainMenuItems {
        OverlayMenu.Add(OverlayEntry["Product"], Change%Type%Overlay)
        If OverlayEntry["OverlayNumber"] = CurrentOverlay.OverlayNumber
        OverlayMenu.Check(OverlayEntry["Product"])
        OverlayMenu.OverlayNumbers.Set(OverlayEntry["Product"], OverlayEntry["OverlayNumber"])
    }
    OverlayMenu.Add("")
    Return OverlayMenu
}

FindImage(ImageFile, X1Coordinate := 0, Y1Coordinate := 0, X2Coordinate := 0, Y2Coordinate := 0) {
    FoundX := ""
    FoundY := ""
    WinWidth := ""
    WinHeight := ""
    Try {
        WinGetPos ,, &WinWidth, &WinHeight, "A"
    }
    Catch {
        WinWidth := A_ScreenWidth
        WinHeight := A_ScreenHeight
    }
    If Not X1Coordinate Is Number Or X1Coordinate < 0
    X1Coordinate := 0
    If Not Y1Coordinate Is Number Or Y1Coordinate < 0
    Y1Coordinate := 0
    If Not X2Coordinate Is Number Or X2Coordinate <= 0
    X2Coordinate := WinWidth
    If Not Y2Coordinate Is Number Or Y2Coordinate <= 0
    Y2Coordinate := WinHeight
    If FileExist(ImageFile) {
        Try
        ImageFound := ImageSearch(&FoundX, &FoundY, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, ImageFile)
        Catch
        ImageFound := 0
        If ImageFound = 1
        Return {X: FoundX, Y: FoundY}
    }
    Return False
}

GetCurrentControlClass() {
    Try
    If ControlGetFocus("A") = 0
    ControlClass := False
    Else
    ControlClass := ControlGetClassNN(ControlGetFocus("A"))
    Catch
    ControlClass := False
    Return ControlClass
}

GetCurrentWindowID() {
    Try
    WindowID := WinGetID("A")
    Catch
    WindowID := False
    Return WindowID
}

GetImgSize(Img) {
    BaseDir := A_WorkingDir
    If Not SubStr(BaseDir, 0, 1) = "\"
    BaseDir .= "\"
    Img := StrReplace(Img, "/", "\")
    If SubStr(Img, 2, 1) = ":" Or SubStr(Img, 2, 1) = "\"
    SplitPath Img, &FileName, &Dir
    Else
    SplitPath BaseDir . Img, &FileName, &Dir
    (Dir = "" && Dir := BaseDir)
    ObjShell := ComObject("Shell.Application")
    ObjFolder := objShell.NameSpace(Dir), ObjFolderItem := ObjFolder.ParseName(FileName)
    Scale := StrSplit(RegExReplace(ObjFolder.GetDetailsOf(ObjFolderItem, 31), ".(.+).", "$1"), " x ")
    Try
    ReturnObject := {W: Scale[1], H: Scale[2]}
    Catch
    ReturnObject := {W: 0, H: 0}
    Return ReturnObject
}

GetPluginControlPos() {
    PluginControlX := 0
    PluginControlY := 0
    Try
    ControlGetPos &PluginControlX, &PluginControlY,,, ReaHotkey.GetPluginControl(), ReaHotkey.PluginWinCriteria
    Catch
    Try {
        If ReaHotkey.AbletonPlugin {
            PluginControlX := 0
            PluginControlY := 0
        }
        Else If ReaHotkey.ReaperPluginBridged {
            PluginControlX := 0
            PluginControlY := 0
        }
        Else If ReaHotkey.ReaperPluginNative {
            PluginControlX := 210
            PluginControlY := 53
        }
        Else {
            PluginControlX := 0
            PluginControlY := 0
        }
    }
    Catch {
        PluginControlX := 0
        PluginControlY := 0
    }
    Return {X: PluginControlX, Y: PluginControlY}
}

GetPluginXCoordinate() {
    Return GetPluginControlPos().X
}

GetPluginYCoordinate() {
    Return GetPluginControlPos().Y
}

GetUIAElement(UIAPath) {
    If Not IsSet(UIA)
    Return False
    Try {
        Element := UIA.ElementFromHandle("ahk_id " . WinGetID("A"))
        Element := Element.ElementFromPath(UIAPath)
    }
    Catch {
        Return False
    }
    Return Element
}

InArray(Needle, Haystack) {
    For FoundIndex, FoundValue In Haystack
    If FoundValue == Needle
    Return FoundIndex
    Return False
}

MergeArrays(Params*) {
    Merged := Array()
    For Param In Params
    If Param Is Array
    For Item In Param
    Merged.Push(Item)
    Else
    Merged.Push(Param)
    Return Merged
}

StrJoin(obj,delimiter:="",OmitChars:=""){
    S := obj[1]
    Loop obj.Length - 1
    S .= delimiter Trim(obj[A_Index+1],OmitChars)
    return S
}

Wait(Period) {
    If IsInteger(Period) And Period > 0 And Period <= 4294967295 {
        PeriodEnd := A_TickCount + Period
        Loop
        If A_TickCount > PeriodEnd
        Break
    }
}
