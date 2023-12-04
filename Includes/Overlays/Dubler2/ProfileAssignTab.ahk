#Requires AutoHotkey v2.0

ActivateChordsMidiChannelButton(Button, *) {
    Local menu := AccessibleStandaloneMenu()

    Loop 16 {
        menu.Add(A_Index, ClickChordsMidiChannel.Bind(A_Index, Button))
            
        If Dubler2.ProfileLoaded["Current"]["ChordsMidiChannel"] == A_Index
            menu.Check(A_Index)
    }

    menu.Show()
}

ClickChordsMidiChannel(Channel, Button, *) {
    Dubler2.ProfileLoaded["Current"]["ChordsMidiChannel"] := Channel

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000

    Click(821, 102)

    ReaHotkey.FoundStandalone.Overlay.Label := ""

    Button.Label := "Chords MIDI Channel: " . Channel
}

ActivatePitchMidiChannelButton(Button, *) {
    Local menu := AccessibleStandaloneMenu()

    Loop 16 {
        menu.Add(A_Index, ClickPitchMidiChannel.Bind(A_Index, Button))
            
        If Dubler2.ProfileLoaded["Current"]["PitchMidiChannel"] == A_Index
            menu.Check(A_Index)
    }

    menu.Show()
}

ClickPitchMidiChannel(Channel, Button, *) {
    Dubler2.ProfileLoaded["Current"]["PitchMidiChannel"] := Channel

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000

    Click(821, 102)

    ReaHotkey.FoundStandalone.Overlay.Label := ""

    Button.Label := "Pitch MIDI Channel: " . Channel
}

ActivateTriggersMidiChannelButton(Button, *) {
    Local menu := AccessibleStandaloneMenu()

    Loop 16 {
        menu.Add(A_Index, ClickTriggersMidiChannel.Bind(A_Index, Button))
            
        If Dubler2.ProfileLoaded["Current"]["TriggersMidiChannel"] == A_Index
            menu.Check(A_Index)
    }

    menu.Show()
}

ClickTriggersMidiChannel(Channel, Button, *) {
    Dubler2.ProfileLoaded["Current"]["TriggersMidiChannel"] := Channel

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000

    Click(821, 102)

    ReaHotkey.FoundStandalone.Overlay.Label := ""

    Button.Label := "Triggers MIDI Channel: " . Channel
}

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

    Sleep 1000
    
    Click(821, 102)

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

    Sleep 1000
    
    Click(821, 102)

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

    Click(821, 102)

    ReaHotkey.FoundStandalone.Overlay.Label := ""

    If Type == 0
        Button.Label := "Pitch Bend Type: IntelliBend"
    Else
        Button.Label := "Pitch Bend Type: TrueBend"
}

AssignTab := HotspotTab("Assign", 821, 102, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))
AssignTab.SetHotkey("^5", "Ctrl + 5")

AssignTab.AddControl(Dubler2.HotspotCheckbox("Pitch bend enabled", 131, 446, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("Stickiness: " . Integer(Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchStickiness"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchStickinessButton))
AssignTab.AddControl(CustomButton("Pitch Bend Range: " . Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendRange"] . " semitones", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchBendRangeButton))

PitchBendTypeCtrl := CustomButton("", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchBendTypeButton)

If Dubler2.ProfileLoaded["Current"]["PitchBendType"] == 0
    PitchBendTypeCtrl.Label := "Pitch Bend Type: IntelliBend"
Else
    PitchBendTypeCtrl.Label := "Pitch Bend Type: TrueBend"

AssignTab.AddControl(PitchBendTypeCtrl)
AssignTab.AddControl(CustomButton("Pitch MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["PitchMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchMidiChannelButton))
AssignTab.AddControl(Dubler2.HotspotCheckbox("Chords bend enabled", 264, 446, Dubler2.ProfileLoaded["Current"]["PitchBendChords"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("Chords MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["ChordsMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivateChordsMidiChannelButton))
AssignTab.AddControl(CustomButton("Triggers MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["TriggersMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivateTriggersMidiChannelButton))
AssignTab.AddControl(Dubler2.HotspotCheckbox("AAA enabled", 636, 230, Not Dubler2.ProfileLoaded["Current"]["AAALocked"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(Dubler2.HotspotCheckbox("EEE enabled", 852, 230, Not Dubler2.ProfileLoaded["Current"]["EEELocked"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(Dubler2.HotspotCheckbox("OOO enabled", 637, 447, Not Dubler2.ProfileLoaded["Current"]["OOOLocked"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(Dubler2.HotspotCheckbox("ENV enabled", 854, 445, Dubler2.ProfileLoaded["Current"]["ENVEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
