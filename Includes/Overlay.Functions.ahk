#Requires AutoHotkey v2.0

Global A_IsUnicode := True

ActivateChooser(OverlayControl) {
    Context := ReaHotkey.GetContext()
    If Context
    Choose%Context%Overlay(OverlayControl)
}

AutoChangeOverlay(Type, Name, CompensatePluginCoordinates := False, ReportChange := False, TypeToFocus := "C", ValueToFocus := 0) {
    Critical
    SourceNumber := ReaHotkey.Found%Type%.Overlay.GetCurrentControlNumber()
    PluginControlPos := GetPluginControlPos()
    OverlayList := %Type%.GetOverlays(Name)
    UnknownProductCounter := 1
    WinWidth := GetWinWidth()
    WinHeight := GetWinHeight()
    If WinWidth = 0
    WinWidth := A_ScreenWidth
    If WinHeight = 0
    WinHeight := A_ScreenHeight
    If ReaHotkey.Found%Type% Is %Type% {
        CurrentOverlay := ReaHotkey.Found%Type%.Overlay
        OverlayFound := 0
        If CurrentOverlay.HasProp("Metadata") And CurrentOverlay.Metadata.Has("DetectionFunction") And CurrentOverlay.Metadata["DetectionFunction"] Is Object And CurrentOverlay.Metadata["DetectionFunction"].HasMethod("Call")
        OverlayFound := CurrentOverlay.Metadata["DetectionFunction"].Call(CurrentOverlay)
        If Not OverlayFound
        OverlayFound := FindOverlayImage(CurrentOverlay)
        If OverlayFound
        Return
    }
    For OverlayNumber, OverlayEntry In OverlayList {
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
            OverlayFound := 0
            If OverlayEntry.HasProp("Metadata") And OverlayEntry.Metadata.Has("DetectionFunction") And OverlayEntry.Metadata["DetectionFunction"] Is Object And OverlayEntry.Metadata["DetectionFunction"].HasMethod("Call")
            OverlayFound := OverlayEntry.Metadata["DetectionFunction"].Call(OverlayEntry)
            If Not OverlayFound
            OverlayFound := FindOverlayImage(OverlayEntry)
            If OverlayFound
            If ReaHotkey.Found%Type%.Chooser {
                ReaHotkey.Found%Type%.Overlay := %Type%Overlay(OverlayEntry.Label)
                ReaHotkey.Found%Type%.Overlay.OverlayNumber := OverlayNumber
                If OverlayEntry.HasProp("Metadata")
                ReaHotkey.Found%Type%.Overlay.Metadata := OverlayEntry.Metadata
                ReaHotkey.Found%Type%.Overlay.AddControl(OverlayEntry.Clone())
                ReaHotkey.Found%Type%.Overlay.AddControl(%Type%.ChooserOverlay.Clone())
                If ReportChange
                Report(Product)
                FocusElement(Type, SourceNumber, TypeToFocus, ValueToFocus)
                Break
            }
            Else {
                ReaHotkey.Found%Type%.Overlay := OverlayEntry.Clone()
                If ReportChange
                Report(Product)
                FocusElement(Type, SourceNumber, TypeToFocus, ValueToFocus)
                Break
            }
        }
    }
    FindOverlayImage(OverlayEntry) {
        FoundX := ""
        FoundY := ""
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
            Return 1
        }
        Return 0
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

AutoChangePluginOverlay(Name, CompensatePluginCoordinates := False, ReportChange := False, TypeToFocus := "C", ValueToFocus := 0) {
    AutoChangeOverlay("Plugin", Name, CompensatePluginCoordinates, ReportChange, TypeToFocus, ValueToFocus)
}

AutoChangeStandaloneOverlay(Name, ReportChange := False, TypeToFocus := "C", ValueToFocus := 0) {
    AutoChangeOverlay("Standalone", Name, False, ReportChange, TypeToFocus, ValueToFocus)
}

ChangeOverlay(Type, ItemName, ItemNumber, OverlayMenu, TypeToFocus := "C", ValueToFocus := 0) {
    Critical
    SourceNumber := ReaHotkey.Found%Type%.Overlay.GetCurrentControlNumber()
    OverlayList := %Type%.GetOverlays(ReaHotkey.Found%Type%.Name)
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemName]
    If Not ReaHotkey.Found%Type%.Overlay.OverlayNumber = OverlayNumber
    If ReaHotkey.Found%Type%.Chooser {
        ReaHotkey.Found%Type%.Overlay := %Type%Overlay(ItemName)
        ReaHotkey.Found%Type%.Overlay.OverlayNumber := OverlayNumber
        If OverlayList[OverlayNumber].HasProp("Metadata")
        ReaHotkey.Found%Type%.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        ReaHotkey.Found%Type%.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        ReaHotkey.Found%Type%.Overlay.AddControl(%Type%.ChooserOverlay.Clone())
    }
    Else {
        ReaHotkey.Found%Type%.Overlay := OverlayList[OverlayNumber].Clone()
    }
    FocusElement(Type, SourceNumber, TypeToFocus, ValueToFocus)
}

ChangePluginOverlay(ItemName, ItemNumber, OverlayMenu, TypeToFocus := "C", ValueToFocus := 0) {
    ChangeOverlay("Plugin", ItemName, ItemNumber, OverlayMenu, TypeToFocus, ValueToFocus)
}

ChangeStandaloneOverlay(ItemName, ItemNumber, OverlayMenu, TypeToFocus := "C", ValueToFocus := 0) {
    ChangeOverlay("Standalone", ItemName, ItemNumber, OverlayMenu, TypeToFocus, ValueToFocus)
}

ChooseOverlay(Type, MenuHandler := False, HandlerParams*) {
    OverlayMenu := CreateOverlayMenu(Type, MenuHandler, HandlerParams*)
    OverlayMenu.Show()
}

ChoosePluginOverlay(OverlayControl, MenuHandler := False, HandlerParams*) {
    ChooseOverlay("Plugin", MenuHandler, HandlerParams*)
}

ChooseStandaloneOverlay(OverlayControl, MenuHandler := False, HandlerParams*) {
    ChooseOverlay("Standalone", MenuHandler, HandlerParams*)
}

ClickPluginCoordinates(XCoordinate, YCoordinate) {
    Click CompensatePluginXCoordinate(XCoordinate), CompensatePluginYCoordinate(YCoordinate)
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

CreateOverlayMenu(Type, MenuHandler := False, HandlerParams*) {
    If Not MenuHandler {
        MenuHandler := "Change" . Type . "Overlay"
        MenuHandler := %MenuHandler%
    }
    MenuHandler := MenuHandler.Bind(,,, HandlerParams*)
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
            ProductSubmenu.Add(OverlayEntry["Patch"], MenuHandler)
            If OverlayEntry["OverlayNumber"] = CurrentOverlay.OverlayNumber {
                VendorSubmenu.Check(OverlayEntry["Product"])
                ProductSubmenu.Check(OverlayEntry["Patch"])
            }
            ProductSubmenu.OverlayNumbers.Set(OverlayEntry["Patch"], OverlayEntry["OverlayNumber"])
        }
        Else {
            VendorSubmenu.Add(OverlayEntry["Product"], MenuHandler)
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
        OverlayMenu.Add(OverlayEntry["Product"], MenuHandler)
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
    WinWidth := GetWinWidth()
    WinHeight := GetWinHeight()
    If WinWidth = 0
    WinWidth := A_ScreenWidth
    If WinHeight = 0
    WinHeight := A_ScreenHeight
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

FocusElement(Type, SourceNumber, TypeToFocus := "C", ValueToFocus := 0) {
    LabelToFocus := ""
    NumberToFocus := 0
    If ValueToFocus Is String
    LabelToFocus := ValueToFocus
    Else
    NumberToFocus := ValueToFocus
    If TypeToFocus = "O" {
        TypeToFocus := "N"
        NumberToFocus := SourceNumber + NumberToFocus
    }
    If TypeToFocus = "L" {
        OverlayControls := ReaHotkey.Found%Type%.Overlay.GetFocusableControls()
        If OverlayControls.Length > 0
        For OverlayControl In OverlayControls
        If OverlayControl.Label = LabelToFocus {
            ReaHotkey.Found%Type%.Overlay.FocusControlID(OverlayControl.ControlID)
            Return
        }
        ReaHotkey.AutoFocus%Type%Overlay := True
    }
    Else {
        PropertyName := "ChildControls"
        MethodName := "FocusChildNumber"
        If TypeToFocus = "N" {
            PropertyName := "FocusableControlIDs"
            MethodName := "FocusControlNumber"
        }
        If Not NumberToFocus Or ReaHotkey.Found%Type%.Overlay.%PropertyName%.Length = 0 {
            ReaHotkey.AutoFocus%Type%Overlay := True
        }
        Else {
            ReaHotkey.AutoFocus%Type%Overlay := False
            If NumberToFocus >= 1 And NumberToFocus <= ReaHotkey.Found%Type%.Overlay.%PropertyName%.Length
            ReaHotkey.Found%Type%.Overlay.%MethodName%(NumberToFocus)
            Else If NumberToFocus < 0 And ReaHotkey.Found%Type%.Overlay.FocusableControlIDs.Length + 1 + NumberToFocus >= 1
            ReaHotkey.Found%Type%.Overlay.%MethodName%(ReaHotkey.Found%Type%.Overlay.%PropertyName%.Length + 1 + NumberToFocus)
            Else
            ReaHotkey.Found%Type%.Overlay.%MethodName%(1)
        }
    }
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
    PluginControlW := 0
    PluginControlH := 0
    Try
    ControlGetPos &PluginControlX, &PluginControlY, &PluginControlW, &PluginControlH, ReaHotkey.GetPluginControl(), ReaHotkey.PluginWinCriteria
    Catch
    Try {
        If ReaHotkey.AbletonPlugin {
            PluginControlX := 0
            PluginControlY := 0
            PluginControlW := 0
            PluginControlH := 0
        }
        Else If ReaHotkey.ReaperPluginBridged {
            PluginControlX := 0
            PluginControlY := 0
            PluginControlW := 0
            PluginControlH := 0
        }
        Else If ReaHotkey.ReaperPluginNative {
            PluginControlX := 210
            PluginControlY := 53
            PluginControlW := 0
            PluginControlH := 0
        }
        Else {
            PluginControlX := 0
            PluginControlY := 0
            PluginControlW := 0
            PluginControlH := 0
        }
    }
    Catch {
        PluginControlX := 0
        PluginControlY := 0
        PluginControlW := 0
        PluginControlH := 0
    }
    Return {X: PluginControlX, Y: PluginControlY, W: PluginControlW, H: PluginControlH}
}

GetPluginHeight() {
    Return GetPluginControlPos().H
}

GetPluginWidth() {
    Return GetPluginControlPos().W
}

GetPluginXCoordinate() {
    Return GetPluginControlPos().X
}

GetPluginYCoordinate() {
    Return GetPluginControlPos().Y
}

GetUIAWindow() {
    If Not IsSet(UIA)
    Return False
    CacheRequest := UIA.CreateCacheRequest(["Type", "LocalizedType", "AutomationId", "Name", "Value", "ClassName", "AcceleratorKey", "WindowCanMaximize"], ["Window"], "Subtree")
    Try
    Window := UIA.ElementFromHandle("ahk_id " . WinGetID("A"), CacheRequest)
    Catch
    Return False
    Return Window
}

GetWinPos() {
    WinX := 0
    WinY := 0
    WinW := 0
    WinH := 0
    Try {
        WinGetPos &WinX, &WinY, &WinW, &WinH, "A"
    }
    Catch {
        WinX := 0
        WinY := 0
        WinW := 0
        WinH := 0
    }
    Return {X: WinX, Y: WinY, W: WinW, H: WinH}
}

GetWinHeight() {
    Return GetWinPos().H
}

GetWinWidth() {
    Return GetWinPos().W
}

GetWinXCoordinate() {
    Return GetWinPos().X
}

GetWinYCoordinate() {
    Return GetWinPos().Y
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
    Return Merged
}

PluginPctClick(XPct, YPct) {
    If XPct < 0 Or YPct < 0
    Return
    If XPct > 100 Or YPct > 100
    Return
    PluginControlPos := GetPluginControlPos()
    X := PluginControlPos.X
    Y := PluginControlPos.Y
    W := PluginControlPos.W
    H := PluginControlPos.H
    If W = 0 Or H = 0
    Return
    If XPct = 0
    XPx := X
    Else If XPct = 100
    XPx := X + W
    Else
    XPx := X + Floor(W / 100 * XPct)
    If YPct = 0
    YPx := Y
    Else If YPct = 100
    YPx := Y + H
    Else
    YPx := Y+ Floor(H / 100 * YPct)
    Click(XPx, YPx)
}

PluginSerialClick(Coordinates*) {
    Return ProduceSerialClick("Plugin", Coordinates*)
}

ProduceMenu(Items, Handler, Type := "Standard") {
    MenuFunc := Object()
    Switch Type {
        Case "Plugin":
        MenuToProduce := "AccessiblePluginMenu"
        Case "Standalone":
        MenuToProduce := "AccessibleStandaloneMenu"
        Case "Standard":
        MenuToProduce := "Menu"
        Default:
        MenuToProduce := "Menu"
        Type := "Standard"
    }
    MenuObj := %MenuToProduce%()
    For Item In Items
    MenuObj.Add(Item, Handler)
    MenuFunc.DefineProp("Handler", {Value: Handler})
    MenuFunc.DefineProp("Items", {Value: Items})
    MenuFunc.DefineProp("Menu", {Value: MenuObj})
    MenuFunc.DefineProp("Type", {Value: Type})
    MenuFunc.DefineProp("Call", {call: CallMenuFunc})
    Return MenuFunc
    CallMenuFunc(This, OverlayObj) {
        This.Menu.Show()
    }
}

ProducePluginMenu(Items, Handler) {
    Return ProduceMenu(Items, Handler, "Plugin")
}

ProduceSerialClick(Type, Coordinates*) {
    ClickFunc := Object()
    ClickFunc.DefineProp("Coordinates", {Value: Coordinates})
    ClickFunc.DefineProp("Type", {Value: Type})
    ClickFunc.DefineProp("Call", {call: CallClickFunc})
    Return ClickFunc
    CallClickFunc(This, OverlayObj) {
        Coordinates := This.Coordinates.Clone()
        If Coordinates.Length < 2
        Return
        If Mod(Coordinates.Length, 2) > 0
        Coordinates.Pop()
        XIndex := 1
        YIndex := 2
        Loop Coordinates.Length / 2 {
            If This.Type = "Plugin"
            ClickPluginCoordinates(Coordinates[XIndex], Coordinates[YIndex])
            Else
            Click(Coordinates[XIndex], Coordinates[YIndex])
            XIndex += 2
            YIndex += 2
        }
    }
}

ProduceSleep(Period) {
    SleepFunc := Object()
    SleepFunc.DefineProp("Period", {Value: Period})
    SleepFunc.DefineProp("Call", {call: CallSleepFunc})
    Return SleepFunc
    CallSleepFunc(This, OverlayObj) {
        Sleep This.Period
    }
}

ProduceStandaloneMenu(Items, Handler) {
    Return ProduceMenu(Items, Handler, "Standalone")
}

ProduceStandardMenu(Items, Handler) {
    Return ProduceMenu(Items, Handler, "Standard")
}

SerialClick(Coordinates*) {
    Return ProduceSerialClick("Standalone", Coordinates*)
}

StandaloneSerialClick(Coordinates*) {
    Return ProduceSerialClick("Standalone", Coordinates*)
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

WinPctClick(XPct, YPct) {
    If XPct < 0 Or YPct < 0
    Return
    If XPct > 100 Or YPct > 100
    Return
    WinPos := GetWinPos()
    W := WinPos.W
    H := WinPos.H
    If W = 0 Or H = 0
    Return
    If XPct = 0
    XPx := 0
    Else If XPct = 100
    XPx := W
    Else
    XPx := Floor(W / 100 * XPct)
    If YPct = 0
    YPx := 0
    Else If YPct = 100
    YPx := H
    Else
    YPx := Floor(H / 100 * YPct)
    Click(XPx, YPx)
}
