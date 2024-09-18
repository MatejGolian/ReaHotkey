#Requires AutoHotkey v2.0

Global A_IsUnicode := True

AutoChangeOverlay(Type, Name, CompensatePluginCoordinates := False, ReportChange := False) {
    Critical
    PluginControlPos := GetPluginControlPos()
    OverlayList := %Type%.GetOverlays(Name)
    UnknownProductCounter := 1
    For OverlayNumber, OverlayEntry In OverlayList {
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
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") And Not OverlayEntry.Metadata["Product"] = "" {
            Product := OverlayEntry.Metadata["Product"]
        }
        Else If Not OverlayEntry.Label = "" {
            Product := OverlayEntry.Label
        }
        Else {
            Product := "unknown product " . UnknownProductCounter
            UnknownProductCounter++
        }
        If ReaHotkey.Found%Type% Is %Type% And HasProp(ReaHotkey.Found%Type%.Overlay, "OverlayNumber") And Not ReaHotkey.Found%Type%.Overlay.OverlayNumber = OverlayEntry.OverlayNumber
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Image") And Not OverlayEntry.Metadata["Image"] = "" {
            If Not OverlayEntry.Metadata["Image"] Is Map
            OverlayMetadata := Map("File", OverlayEntry.Metadata["Image"])
            Else
            OverlayMetadata := OverlayEntry.Metadata["Image"].Clone()
            If Not OverlayMetadata.Has("File")
            OverlayMetadata.Set("File", OverlayEntry.Metadata["Image"])
            If Not OverlayMetadata.Has("X1Coordinate")
            OverlayMetadata.Set("X1Coordinate", 0)
            If Not OverlayMetadata.Has("Y1Coordinate")
            OverlayMetadata.Set("Y1Coordinate", 0)
            If Not OverlayMetadata.Has("X2Coordinate")
            OverlayMetadata.Set("X2Coordinate", WinWidth)
            If Not OverlayMetadata.Has("Y2Coordinate")
            OverlayMetadata.Set("Y2Coordinate", WinHeight)
            If Not OverlayMetadata["X1Coordinate"] Is Number Or OverlayMetadata["X1Coordinate"] < 0
            OverlayMetadata["X1Coordinate"] := 0
            If Not OverlayMetadata["Y1Coordinate"] Is Number Or OverlayMetadata["Y1Coordinate"] < 0
            OverlayMetadata["Y1Coordinate"] := 0
            If Not OverlayMetadata["X2Coordinate"] Is Number Or OverlayMetadata["X2Coordinate"] <= 0
            OverlayMetadata["X2Coordinate"] := WinWidth
            If Not OverlayMetadata["Y2Coordinate"] Is Number Or OverlayMetadata["Y2Coordinate"] <= 0
            OverlayMetadata["Y2Coordinate"] := WinHeight
            If Type = "Plugin" And CompensatePluginCoordinates = True {
                OverlayMetadata["X1Coordinate"] := PluginControlPos.X + OverlayMetadata["X1Coordinate"]
                OverlayMetadata["Y1Coordinate"] := PluginControlPos.Y + OverlayMetadata["Y1Coordinate"]
                OverlayMetadata["X2Coordinate"] := PluginControlPos.X + OverlayMetadata["X2Coordinate"]
                OverlayMetadata["Y2Coordinate"] := PluginControlPos.Y + OverlayMetadata["Y2Coordinate"]
                If OverlayMetadata["X2Coordinate"] > WinWidth
                OverlayMetadata["X2Coordinate"] := WinWidth
                If OverlayMetadata["Y2Coordinate"] > WinHeight
                OverlayMetadata["Y2Coordinate"] := WinHeight
            }
            If FileExist(OverlayMetadata["File"]) {
                Try
                ImageFound := ImageSearch(&FoundX, &FoundY, OverlayMetadata["X1Coordinate"], OverlayMetadata["Y1Coordinate"], OverlayMetadata["X2Coordinate"], OverlayMetadata["Y2Coordinate"], OverlayMetadata["File"])
                Catch
                ImageFound := 0
                If ImageFound = 1
                If ReaHotkey.Found%Type%.Chooser = True {
                    OverlayHeader := ReaHotkey.Found%Type%.Overlay.ChildControls[1].Clone()
                    ReaHotkey.Found%Type%.Overlay := AccessibilityOverlay(OverlayEntry.Label)
                    ReaHotkey.Found%Type%.Overlay.OverlayNumber := OverlayNumber
                    If HasProp(OverlayEntry, "Metadata")
                    ReaHotkey.Found%Type%.Overlay.Metadata := OverlayEntry.Metadata
                    ReaHotkey.Found%Type%.Overlay.AddControl(OverlayHeader)
                    ReaHotkey.Found%Type%.Overlay.AddControl(OverlayEntry.Clone())
                    ReaHotkey.Found%Type%.Overlay.AddControl(%Type%.ChooserOverlay.Clone())
                    If ReportChange = True {
                        AccessibilityOverlay.Speak(Product . " overlay active")
                        ReaHotkey.Wait(1250)
                    }
                    ReaHotkey.Found%Type%.Overlay.FocusControl(ReaHotkey.Found%Type%.Overlay.ChildControls[2].ChildControls[2].ControlID)
                    If ReaHotkey.AutoFocus%Type%Overlay = True
                    ReaHotkey.AutoFocus%Type%Overlay := False
                    Break
                }
                Else {
                    ReaHotkey.Found%Type%.Overlay := OverlayEntry.Clone()
                    If ReportChange = True {
                        AccessibilityOverlay.Speak(Product . " overlay active")
                        ReaHotkey.Wait(1250)
                    }
                    ReaHotkey.Found%Type%.Overlay.FocusControl(ReaHotkey.Found%Type%.Overlay.ChildControls[2].ControlID)
                    If ReaHotkey.AutoFocus%Type%Overlay = True
                    ReaHotkey.AutoFocus%Type%Overlay := False
                    Break
                }
            }
        }
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
    OverlayNumber := OverlayMenu.OverlayNumbers[ItemNumber]
    If Not ReaHotkey.Found%Type%.Overlay.OverlayNumber = OverlayNumber
    If ReaHotkey.Found%Type%.Chooser = True {
        OverlayHeader := ReaHotkey.Found%Type%.Overlay.ChildControls[1].Clone()
        ReaHotkey.Found%Type%.Overlay := AccessibilityOverlay(ItemName)
        ReaHotkey.Found%Type%.Overlay.OverlayNumber := OverlayNumber
        If HasProp(OverlayList[OverlayNumber], "Metadata")
        ReaHotkey.Found%Type%.Overlay.Metadata := OverlayList[OverlayNumber].Metadata
        ReaHotkey.Found%Type%.Overlay.AddControl(OverlayHeader)
        ReaHotkey.Found%Type%.Overlay.AddControl(OverlayList[OverlayNumber].Clone())
        ReaHotkey.Found%Type%.Overlay.AddControl(%Type%.ChooserOverlay.Clone())
        ReaHotkey.Found%Type%.Overlay.SetCurrentControlID(ReaHotkey.Found%Type%.Overlay.ChildControls[3].ChildControls[ReaHotkey.Found%Type%.Overlay.ChildControls[3].ChildControls.Length].ControlID)
        ReaHotkey.Found%Type%.Overlay.ChildControls[3].ChildControls[ReaHotkey.Found%Type%.Overlay.ChildControls[3].ChildControls.Length].Focus()
    }
    Else {
        ReaHotkey.Found%Type%.Overlay := OverlayList[OverlayNumber].Clone()
        ReaHotkey.Found%Type%.Overlay.Focus()
    }
    Else
    ReaHotkey.Found%Type%.Overlay.Focus()
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
    Return False
    ControlXCoordinate := FocusedControlXCoordinate + ControlXCoordinate
    Return ControlXCoordinate
}

CompensateFocusedControlYCoordinate(ControlYCoordinate) {
    Try
    ControlGetPos &FocusedControlXCoordinate, &FocusedControlYCoordinate,,, ControlGetClassNN(ControlGetFocus("A")), "A"
    Catch
    Return False
    ControlYCoordinate := FocusedControlYCoordinate + ControlYCoordinate
    Return ControlYCoordinate
}

CompensateGraphicalHorizontalPluginSlider(PluginControl) {
    If Not HasProp(PluginControl, "OriginalStart")
    PluginControl.OriginalStart := PluginControl.Start
    If Not HasProp(PluginControl, "OriginalEnd")
    PluginControl.OriginalEnd := PluginControl.End
    PluginControlPos := GetPluginControlPos()
    PluginControl.Start := PluginControlPos.X + PluginControl.OriginalStart
    PluginControl.End := PluginControlPos.X + PluginControl.OriginalEnd
    Return PluginControl
}

CompensateGraphicalVerticalPluginSlider(PluginControl) {
    If Not HasProp(PluginControl, "OriginalStart")
    PluginControl.OriginalStart := PluginControl.Start
    If Not HasProp(PluginControl, "OriginalEnd")
    PluginControl.OriginalEnd := PluginControl.End
    PluginControlPos := GetPluginControlPos()
    PluginControl.Start := PluginControlPos.Y + PluginControl.OriginalStart
    PluginControl.End := PluginControlPos.Y + PluginControl.OriginalEnd
    Return PluginControl
}

CompensatePluginPointCoordinates(PluginControl) {
    If Not HasProp(PluginControl, "OriginalXCoordinate")
    PluginControl.OriginalXCoordinate := PluginControl.XCoordinate
    If Not HasProp(PluginControl, "OriginalYCoordinate")
    PluginControl.OriginalYCoordinate := PluginControl.YCoordinate
    PluginControlPos := GetPluginControlPos()
    PluginControl.XCoordinate := PluginControlPos.X + PluginControl.OriginalXCoordinate
    PluginControl.YCoordinate := PluginControlPos.Y + PluginControl.OriginalYCoordinate
    Return PluginControl
}

CompensatePluginRegionCoordinates(PluginControl) {
    If Not HasProp(PluginControl, "OriginalX1Coordinate")
    PluginControl.OriginalX1Coordinate := PluginControl.X1Coordinate
    If Not HasProp(PluginControl, "OriginalY1Coordinate")
    PluginControl.OriginalY1Coordinate := PluginControl.Y1Coordinate
    If Not HasProp(PluginControl, "OriginalX2Coordinate")
    PluginControl.OriginalX2Coordinate := PluginControl.X2Coordinate
    If Not HasProp(PluginControl, "OriginalY2Coordinate")
    PluginControl.OriginalY2Coordinate := PluginControl.Y2Coordinate
    PluginControlPos := GetPluginControlPos()
    PluginControl.X1Coordinate := PluginControlPos.X + PluginControl.OriginalX1Coordinate
    PluginControl.Y1Coordinate := PluginControlPos.Y + PluginControl.OriginalY1Coordinate
    PluginControl.X2Coordinate := PluginControlPos.X + PluginControl.OriginalX2Coordinate
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
    OverlayMenu.OverlayNumbers := Array()
    UnknownProductCounter := 1
    If HasProp(CurrentOverlay, "Metadata") And CurrentOverlay.Metadata.Has("Vendor") And Not CurrentOverlay.Metadata["Vendor"] = ""
    CurrentVendor := CurrentOverlay.Metadata["Vendor"]
    Else
    CurrentVendor := ""
    For OverlayNumber, OverlayEntry In OverlayEntries {
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Vendor") And Not OverlayEntry.Metadata["Vendor"] = "" {
            Vendor := OverlayEntry.Metadata["Vendor"]
        }
        Else {
            Vendor := ""
        }
        If HasProp(OverlayEntry, "Metadata") And OverlayEntry.Metadata.Has("Product") And Not OverlayEntry.Metadata["Product"] = "" {
            Product := OverlayEntry.Metadata["Product"]
        }
        Else If Not OverlayEntry.Label = "" {
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
        If OverlayEntry.Length = 3 {
            Vendor := OverlayEntry[1]
            For ElementIndex, ElementValue In OverlayEntry {
                If Vendor = "" {
                    If ElementIndex = 1
                    MainMenuItems.Push(Map("Product", "", "OverlayNumber", ""))
                    If ElementIndex = 2
                    MainMenuItems[MainMenuItems.Length]["Product"] := ElementValue
                    If ElementIndex = 3
                    MainMenuItems[MainMenuItems.Length]["OverlayNumber"] := ElementValue
                }
                Else {
                    If ElementIndex = 1 {
                        If Not Submenus.Has(Vendor)
                        Submenus.Set(Vendor, Array())
                        Submenus[Vendor].Push(Map("Product", "", "OverlayNumber", ""))
                    }
                    If ElementIndex = 2
                    Submenus[Vendor][Submenus[Vendor].Length]["Product"] := ElementValue
                    If ElementIndex = 3
                    Submenus[Vendor][Submenus[Vendor].Length]["OverlayNumber"] := ElementValue
                }
            }
        }
    }
    For Vendor, OverlayEntries In Submenus {
        Submenu := Accessible%Type%Menu()
        Submenu.OverlayNumbers := Array()
        For OverlayEntry In OverlayEntries {
            Submenu.Add(OverlayEntry["Product"], Change%Type%Overlay)
            If OverlayEntry["OverlayNumber"] = CurrentOverlay.OverlayNumber
            Submenu.Check(OverlayEntry["Product"])
            Submenu.OverlayNumbers.Push(OverlayEntry["OverlayNumber"])
        }
        Submenu.Add("")
        Submenu.OverlayNumbers.Push(0)
        OverlayMenu.Add(Vendor, Submenu)
        If Vendor = CurrentVendor
        OverlayMenu.Check(Vendor)
        OverlayMenu.OverlayNumbers.Push(0)
    }
    For OverlayEntry In MainMenuItems {
        OverlayMenu.Add(OverlayEntry["Product"], Change%Type%Overlay)
        If OverlayEntry["OverlayNumber"] = CurrentOverlay.OverlayNumber
        OverlayMenu.Check(OverlayEntry["Product"])
        OverlayMenu.OverlayNumbers.Push(OverlayEntry["OverlayNumber"])
    }
    OverlayMenu.Add("")
    OverlayMenu.OverlayNumbers.Push(0)
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
    Try {
        ControlGetPos &PluginControlX, &PluginControlY,,, ReaHotkey.GetPluginControl(), ReaHotkey.PluginWinCriteria
    }
    Catch {
        PluginControlX := 210
        PluginControlY := 53
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

KeyWaitCombo() {
    IH := InputHook()
    IH.VisibleNonText := True
    IH.KeyOpt("{All}", "E")
    IH.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")
    IH.Timeout := 0.125
    IH.Start()
    IH.Wait(0.125)
    Return RegExReplace(IH.EndMods . IH.EndKey, "[<>](.)(?:>\1)?", "$1")
}

KeyWaitSingle() {
    IH := InputHook()
    IH.VisibleNonText := True
    IH.KeyOpt("{All}", "E")
    IH.Start()
    IH.Wait()
    Return IH.EndKey
}

StrJoin(obj,delimiter:="",OmitChars:=""){
    S := obj[1]
    Loop obj.Length - 1
    S .= delimiter Trim(obj[A_Index+1],OmitChars)
    return S
}
