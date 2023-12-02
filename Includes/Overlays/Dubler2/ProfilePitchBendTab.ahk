#Requires AutoHotkey v2.0

ActivatePitchStickinessButton(Button) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Stickiness := InputBox("Pitch Bend Stickiness in % (from 0 to 100):", "ReaHotkey", , Integer(Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchStickiness"] * 100))
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Stickiness.Result != "OK" Or Not IsNumber(Stickiness.Value)
        Return

    NStickiness := Integer(Stickiness.Value)

    If NStickiness > 100
        NStickiness := 100
    Else If NStickiness < 0
        NStickiness := 0

    Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchStickiness"] := NStickiness / 100

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ActivatePitchBendRangeButton(Button) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Range := InputBox("Pitch Bend Range (From 1 to 48 semitones):", "ReaHotkey", , Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendRange"])
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Range.Result != "OK" Or Not IsNumber(Range.Value)
        Return

    NRange := Integer(Range.Value)

    If NRange > 48
        NRange := 48
    Else If NRange < 1
        NRange := 1

    Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendRange"] := NRange

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ActivatePitchBendTypeButton(Button) {
    Local menu := AccessibleStandaloneMenu()

    menu.Add("IntelliBend", ClickPitchBendType.Bind(0, Button))
    menu.Add("TrueBend", ClickPitchBendType.Bind(1, Button))

    If Dubler2.ProfileLoaded["Current"]["PitchBendType"] == 0
        menu.Check("IntelliBend")
    Else
        menu.Check("TrueBend")

    menu.Show()
}

ClickPitchBendType(Type, Button, *) {
    Dubler2.ProfileLoaded["Current"]["PitchBendType"] := Type

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000

    ReaHotkey.FoundStandalone.Overlay.Label := ""

    If Type == 0
        Button.Label := "Pitch Bend Type: IntelliBend"
    Else
        Button.Label := "Pitch Bend Type: TrueBend"
}

PitchBendTab := HotspotTab("Pitch Bend", 258, 104, ObjBindMethod(Dubler2, "FocusTab"))

PitchBendTab.SetHotkey("^3", "Ctrl + 3")

PitchBendTab.AddControl(Dubler2.HotspotCheckbox("Pitch Bend enabled", 354, 501, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
PitchBendTab.AddControl(CustomButton("Stickiness: " . Integer(Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchStickiness"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchStickinessButton))
PitchBendTab.AddControl(CustomButton("Pitch Bend Range: " . Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendRange"] . " semitones", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchBendRangeButton))

PitchBendTypeCtrl := CustomButton("", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchBendTypeButton)

If Dubler2.ProfileLoaded["Current"]["PitchBendType"] == 0
    PitchBendTypeCtrl.Label := "Pitch Bend Type: IntelliBend"
Else
    PitchBendTypeCtrl.Label := "Pitch Bend Type: TrueBend"

PitchBendTab.AddControl(PitchBendTypeCtrl)
