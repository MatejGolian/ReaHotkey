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

ActivateThresholdButton(ENV, Input, MinMax, Button) {

    Local MinMaxText := ""
    Local Min := 0.0
    Local Max := 127.0
    Local Key := ""

    If Input
        Key := ENV . "InputThresholds"
    Else
        Key := ENV . "OutputThresholds"

    If MinMax == "min" {
        MinMaxText := "Minimum"
        Max := Float(Dubler2.ProfileLoaded["Current"][Key]["max"])
    } Else {
        MinMaxText := "Maximum"
        Min := Float(Dubler2.ProfileLoaded["Current"][Key]["min"])
    }

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Th := InputBox(ENV . " " . MinMaxText . " threshold (from " . Min . " to " . Max . "):", "ReaHotkey", , Float(Dubler2.ProfileLoaded["Current"][Key][MinMax]))
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Th.Result != "OK" Or Not IsFloat(Th.Value)
        Return

    NTh := Float(Th.Value)

    If NTh > Max
        NTh := Max
    Else If NTh < Min
        NTh := Min

    Dubler2.ProfileLoaded["Current"][Key][MinMax] := NTh

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
    Button.Label := SubStr(Button.Label, 0, InStr(Button.Label, ":") + 1) . NTh
}

ActivateCCButton(ENV, Button) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Th := InputBox(ENV . " CC value (from 0 to 127):", "ReaHotkey", , Integer(Dubler2.ProfileLoaded["Current"][ENV . "ccNum"]))
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Th.Result != "OK" Or Not IsNumber(Th.Value)
        Return

    NTh := Integer(Th.Value)

    If NTh > 127
        NTh := 127
    Else If NTh < 0
        NTh := 0

    Dubler2.ProfileLoaded["Current"][ENV . "ccNum"] := NTh

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
    Button.Label := SubStr(Button.Label, 0, InStr(Button.Label, ":") + 1) . NTh
}

ClickPitchBendType(Preset) {
    Click(334, 519)
    Sleep 300

    Switch(Preset) {
        Case 0:
            Click(323, 556)
        Case 1:
            Click(332, 588)
    }
}

ClickChordsPreset(Preset) {
    Click(470, 372)
    Sleep 300

    Switch(Preset) {
        Case "Pure":
            Click(426, 118)
        Case "Pad":
            Click(459, 148)
        Case "Boards":
            Click(446, 177)
        Case "8 Bit Lead":
            Click(458, 208)
        Case "Bass Pluck":
            Click(462, 238)
        Case "Wobble Bass":
            Click(462, 276)
        Case "Trumpet Lead":
            Click(471, 304)
        Case "Trap Bass":
            Click(454, 337)
    }
}

AssignTab := HotspotTab("Assign", 821, 102, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))
AssignTab.SetHotkey("^5", "Ctrl + 5")

AssignTab.AddControl(Dubler2.HotspotCheckbox("Pitch bend enabled", 131, 446, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("Stickiness: " . Integer(Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchStickiness"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchStickinessButton))
AssignTab.AddControl(CustomButton("Pitch Bend Range: " . Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendRange"] . " semitones", ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchBendRangeButton))

PitchBendTypeCtrl := PopulatedComboBox("Pitch Bend Type", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

For Preset In [0, 1] {

    If Preset == 0
        PresetText := "IntelliBend"
    Else
        PresetText := "TrueBend"

    PitchBendTypeCtrl.AddItem(PresetText, ClickPitchBendType.Bind(Preset))

    If Preset == Dubler2.ProfileLoaded["Current"]["PitchBendType"]
        PitchBendTypeCtrl.SetValue(PresetText)
}

AssignTab.AddControl(PitchBendTypeCtrl)
AssignTab.AddControl(CustomButton("Pitch MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["PitchMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchMidiChannelButton))
AssignTab.AddControl(Dubler2.HotspotCheckbox("Chords bend enabled", 264, 446, Dubler2.ProfileLoaded["Current"]["PitchBendChords"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("Chords MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["ChordsMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivateChordsMidiChannelButton))

ChordsPresetCtrl := PopulatedComboBox("Chords Preset", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

For Preset In ["8 Bit Lead", "Bass Pluck", "Boards", "Pad", "Pure", "Trap Bass", "Trumpet Lead", "Wobble Bass"] {
    ChordsPresetCtrl.AddItem(Preset, ClickChordsPreset.Bind(Preset))

    If StrLower(Preset) == StrLower(Dubler2.ProfileLoaded["Current"]["chordsPreset"])
        ChordsPresetCtrl.SetValue(Preset)
}

AssignTab.AddControl(ChordsPresetCtrl)

AssignTab.AddControl(CustomButton("Triggers MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["TriggersMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivateTriggersMidiChannelButton))

AssignTab.AddControl(Dubler2.HotspotCheckbox("AAA enabled", 636, 230, Not Dubler2.ProfileLoaded["Current"]["AAALocked"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("AAA Input Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["AAAInputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("AAA", True, "min")))
AssignTab.AddControl(CustomButton("AAA Input Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["AAAInputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("AAA", True, "max")))
AssignTab.AddControl(CustomButton("AAA Output Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["AAAOutputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("AAA", False, "min")))
AssignTab.AddControl(CustomButton("AAA Output Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["AAAOutputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("AAA", False, "max")))
AssignTab.AddControl(CustomButton("AAA CC Value: " . Dubler2.ProfileLoaded["Current"]["AAAccNum"], ObjBindMethod(Dubler2, "FocusButton"), ActivateCCButton.Bind("AAA")))

AssignTab.AddControl(Dubler2.HotspotCheckbox("EEE enabled", 852, 230, Not Dubler2.ProfileLoaded["Current"]["EEELocked"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("EEE Input Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["EEEInputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("EEE", True, "min")))
AssignTab.AddControl(CustomButton("EEE Input Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["EEEInputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("EEE", True, "max")))
AssignTab.AddControl(CustomButton("EEE Output Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["EEEOutputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("EEE", False, "min")))
AssignTab.AddControl(CustomButton("EEE Output Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["EEEOutputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("EEE", False, "max")))
AssignTab.AddControl(CustomButton("EEE CC Value: " . Dubler2.ProfileLoaded["Current"]["EEEccNum"], ObjBindMethod(Dubler2, "FocusButton"), ActivateCCButton.Bind("EEE")))

AssignTab.AddControl(Dubler2.HotspotCheckbox("OOO enabled", 637, 447, Not Dubler2.ProfileLoaded["Current"]["OOOLocked"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("OOO Input Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["OOOInputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("OOO", True, "min")))
AssignTab.AddControl(CustomButton("OOO Input Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["OOOInputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("OOO", True, "max")))
AssignTab.AddControl(CustomButton("OOO Output Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["OOOOutputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("OOO", False, "min")))
AssignTab.AddControl(CustomButton("OOO Output Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["OOOOutputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("OOO", False, "max")))
AssignTab.AddControl(CustomButton("OOO CC Value: " . Dubler2.ProfileLoaded["Current"]["OOOccNum"], ObjBindMethod(Dubler2, "FocusButton"), ActivateCCButton.Bind("OOO")))

AssignTab.AddControl(Dubler2.HotspotCheckbox("ENV enabled", 854, 445, Dubler2.ProfileLoaded["Current"]["ENVEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
AssignTab.AddControl(CustomButton("ENV Input Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["ENVInputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("ENV", True, "min")))
AssignTab.AddControl(CustomButton("ENV Input Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["ENVInputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("ENV", True, "max")))
AssignTab.AddControl(CustomButton("ENV Output Threshold Minimum: " . Dubler2.ProfileLoaded["Current"]["ENVOutputThresholds"]["min"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("ENV", False, "min")))
AssignTab.AddControl(CustomButton("ENV Output Threshold Maximum: " . Dubler2.ProfileLoaded["Current"]["ENVOutputThresholds"]["max"], ObjBindMethod(Dubler2, "FocusButton"), ActivateThresholdButton.Bind("ENV", False, "max")))
AssignTab.AddControl(CustomButton("ENV CC Value: " . Dubler2.ProfileLoaded["Current"]["ENVccNum"], ObjBindMethod(Dubler2, "FocusButton"), ActivateCCButton.Bind("ENV")))
