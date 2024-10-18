#Requires AutoHotkey v2.0

ActivatePitchInputGainButton(Button) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Gain := InputBox("Pitch Input Gain in % (from 0 to 100):", "ReaHotkey", , Integer(Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchInputGain"] * 100))
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Gain.Result != "OK" Or Not IsNumber(Gain.Value)
        Return

    NGain := Integer(Gain.Value)

    If NGain > 100
        NGain := 100
    Else If NGain < 0
        NGain := 0

    Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchInputGain"] := NGain / 100

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(258, 104)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ActivatePitchOctaveShiftButton(ButtonObj) {

    OctaveShiftMenu := AccessibleStandaloneMenu()

    For Octave In [-3, -2, -1, 0, 1, 2, 3]
        OctaveShiftMenu.Add((Octave >= 0 ? "+" : "") . Octave, ClickPitchOctaveShiftButton.Bind(Button, Octave))

    OctaveShiftMenu.Check((Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"] >= 0 ? "+" : "") . Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"])

    OctaveShiftMenu.Show()
}

ActivateNotesButton(ButtonObj) {

    Notes := Dubler2.ProfileLoaded["Current"]["Scale"]["scaleNotes"]["data"]
    Enabled := Dubler2.ProfileLoaded["Current"]["Scale"]["toggleMask"]["data"]

    NotesMenu := AccessibleStandaloneMenu()

    If Notes != 4095 {
        NotesMenu.Add("You cannot add new notes to this scale without changing the key or scale. Please select a different key and/or scale instead.", ClickNotesButton)
        NotesMenu.Disable("You cannot add new notes to this scale without changing the key or scale. Please select a different key and/or scale instead.")
    }

    For Note In ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] {
        NotesMenu.Add(Note, ClickNotesButton.Bind(Note))

        If Enabled & (1 << (A_Index - 1)) > 0 And Notes & (1 << (A_Index - 1)) > 0
            NotesMenu.Check(Note)

        If Notes & (1 << (A_Index - 1)) == 0
            NotesMenu.Disable(Note)
    }

    NotesMenu.Show()
}

ClickNotesButton(Note, *) {

    Switch(Note) {
        Case "C":
            Click(527, 207)
        Case "C#":
            Click(573, 242)
        Case "D":
            Click(614, 282)
        Case "D#":
            Click(631, 343)
        Case "E":
            Click(623, 376)
        Case "F":
            Click(577, 411)
        Case "F#":
            Click(510, 427)
        Case "G":
            Click(471, 427)
        Case "G#":
            Click(415, 398)
        Case "A":
            Click(410, 335)
        Case "A#":
            Click(419, 251)
        Case "B":
            Click(433, 235)
    }
}

ClickKey(Key) {
    Click(543, 501)
    Sleep 300

    Switch(Key) {
        Case "C":
            Click(542, 198)
        Case "C#":
            Click(547, 223)
        Case "D":
            Click(543, 250)
        Case "D#":
            Click(548, 272)
        Case "E":
            Click(536, 295)
        Case "F":
            Click(543, 321)
        Case "F#":
            Click(543, 347)
        Case "G":
            Click(546, 370)
        Case "G#":
            Click(545, 393)
        Case "A":
            Click(544, 422)
        Case "A#":
            Click(542, 445)
        Case "B":
            Click(547, 467)
    }
}

ClickPitchOctaveShiftButton(ButtonObj, Octave, *) {

    Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"] := Octave

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(258, 104)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ClickScale(Scale) {
    Click(662, 502)
    Sleep 300

    Switch(Scale) {
        Case "Major":
            Click(700, 97)
        Case "Minor":
            Click(682, 123)
        Case "Harmonic Minor":
            Click(690, 151)
        Case "Major Pentatonic":
            Click(690, 171)
        Case "Minor Pentatonic":
            Click(697, 193)
        Case "Blues":
            Click(698, 221)
        Case "Locrian":
            Click(699, 247)
        Case "Dorian":
            Click(683, 272)
        Case "Phrygian":
            Click(694, 295)
        Case "Lydian":
            Click(684, 326)
        Case "Mixolydian":
            Click(678, 344)
        Case "Hungarian (Gypsy) Minor":
            Click(723, 371)
        Case "Whole Tone":
            Click(681, 400)
        Case "Aeolian Dominant (Hindu)":
            Click(719, 420)
        Case "Chromatic":
            Click(684, 449)
    }
}

ClickSynthPreset(Preset) {
    Click(678, 620)
    Sleep 300

    Switch(Preset) {
        Case "Pure":
            Click(679, 468)
        Case "Pad":
            Click(675, 490)
        Case "Boards":
            Click(686, 506)
        Case "8 Bit Lead":
            Click(699, 524)
        Case "Bass Pluck":
            Click(694, 542)
        Case "Wobble Bass":
            Click(700, 558)
        Case "Trumpet Lead":
            Click(699, 578)
        Case "Trap Bass":
            Click(693, 597)
    }
}

PitchTab := HotspotTab("Pitch", 258, 104, ObjBindMethod(Dubler2, "FocusTab"))
PitchTab.SetHotkey("^2", "Ctrl + 2")

PitchTab.AddControl(Dubler2.HotspotCheckbox("Pitch enabled", 371, 161, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
PitchTab.AddControl(Dubler2.HotspotCheckbox("Pitch Bend enabled", 354, 501, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))

SynthPresetCtrl := PopulatedComboBox("Synth Preset", ObjBindMethod(Dubler2, "FocusComboBox"), , ObjBindMethod(Dubler2, "SelectComboBoxItem"))

For Preset In ["8 Bit Lead", "Bass Pluck", "Boards", "Pad", "Pure", "Trap Bass", "Trumpet Lead", "Wobble Bass"] {
    SynthPresetCtrl.AddItem(Preset, ClickSynthPreset.Bind(Preset))

    If StrLower(Preset) == StrLower(Dubler2.ProfileLoaded["Current"]["synthPreset"])
        SynthPresetCtrl.SetValue(Preset)
}

PitchTab.AddControl(SynthPresetCtrl)

PitchTab.AddControl(CustomButton("Input Gain: " . Integer(Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchInputGain"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), , ActivatePitchInputGainButton))
PitchTab.AddControl(CustomButton("Octave shift: " . (Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"] >= 0 ? "+" : "") . Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"], ObjBindMethod(Dubler2, "FocusButton"), , ActivatePitchOctaveShiftButton))

KeyCtrl := PopulatedComboBox("Key", ObjBindMethod(Dubler2, "FocusComboBox"), , ObjBindMethod(Dubler2, "SelectComboBoxItem"))

For Key In ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] {
    KeyCtrl.AddItem(Key, ClickKey.Bind(Key))

    If StrLower(Key) == StrLower(Dubler2.ProfileLoaded["Current"]["Scale"]["rootName"])
        KeyCtrl.SetValue(Key)
}

PitchTab.AddControl(KeyCtrl)

ScaleCtrl := PopulatedComboBox("Scale", ObjBindMethod(Dubler2, "FocusComboBox"), , ObjBindMethod(Dubler2, "SelectComboBoxItem"))

For Scale In ["Major", "Minor", "Harmonic Minor", "Major Pentatonic", "Minor Pentatonic", "Blues", "Locrian", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Hungarian (Gypsy) Minor", "Whole Tone", "Aeolian Dominant (Hindu)", "Chromatic"] {
    ScaleCtrl.AddItem(Scale, ClickScale.Bind(Scale))

    If StrLower(Scale) == StrLower(Dubler2.ProfileLoaded["Current"]["Scale"]["patternName"])
        ScaleCtrl.SetValue(Scale)
}

PitchTab.AddControl(ScaleCtrl)
PitchTab.AddControl(CustomButton("Toggle active notes", ObjBindMethod(Dubler2, "FocusButton"), , ActivateNotesButton))
PitchTab.AddControl(Dubler2.CustomCheckbox("Announce detected notes (press Ctrl+N to toggle)", Dubler2.AnnounceNotes, ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "ToggleNotesAnnouncement")))
