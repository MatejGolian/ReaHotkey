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

    Click(354, 25)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(250, 73)

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
            Click(519, 176)
        Case "C#":
            Click(565, 211)
        Case "D":
            Click(606, 251)
        Case "D#":
            Click(623, 312)
        Case "E":
            Click(615, 345)
        Case "F":
            Click(569, 380)
        Case "F#":
            Click(502, 396)
        Case "G":
            Click(463, 396)
        Case "G#":
            Click(407, 367)
        Case "A":
            Click(402, 304)
        Case "A#":
            Click(411, 220)
        Case "B":
            Click(425, 204)
    }
}

ClickKey(Key) {
    Click(535, 470)
    Sleep 300

    Switch(Key) {
        Case "C":
            Click(534, 167)
        Case "C#":
            Click(539, 192)
        Case "D":
            Click(535, 219)
        Case "D#":
            Click(540, 241)
        Case "E":
            Click(528, 264)
        Case "F":
            Click(535, 290)
        Case "F#":
            Click(535, 316)
        Case "G":
            Click(538, 339)
        Case "G#":
            Click(537, 362)
        Case "A":
            Click(536, 391)
        Case "A#":
            Click(534, 414)
        Case "B":
            Click(539, 436)
    }
}

ClickPitchOctaveShiftButton(ButtonObj, Octave, *) {

    Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"] := Octave

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(354, 25)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(250, 73)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ClickScale(Scale) {
    Click(654, 471)
    Sleep 300

    Switch(Scale) {
        Case "Major":
            Click(692, 66)
        Case "Minor":
            Click(674, 92)
        Case "Harmonic Minor":
            Click(682, 120)
        Case "Major Pentatonic":
            Click(682, 140)
        Case "Minor Pentatonic":
            Click(689, 162)
        Case "Blues":
            Click(690, 190)
        Case "Locrian":
            Click(691, 216)
        Case "Dorian":
            Click(675, 241)
        Case "Phrygian":
            Click(686, 264)
        Case "Lydian":
            Click(676, 295)
        Case "Mixolydian":
            Click(670, 313)
        Case "Hungarian (Gypsy) Minor":
            Click(715, 340)
        Case "Whole Tone":
            Click(673, 369)
        Case "Aeolian Dominant (Hindu)":
            Click(711, 389)
        Case "Chromatic":
            Click(676, 418)
    }
}

ClickSynthPreset(Preset) {
    Click(670, 589)
    Sleep 300

    Switch(Preset) {
        Case "Pure":
            Click(671, 437)
        Case "Pad":
            Click(667, 459)
        Case "Boards":
            Click(678, 475)
        Case "8 Bit Lead":
            Click(691, 493)
        Case "Bass Pluck":
            Click(686, 511)
        Case "Wobble Bass":
            Click(692, 527)
        Case "Trumpet Lead":
            Click(691, 547)
        Case "Trap Bass":
            Click(685, 566)
    }
}

PitchTab := HotspotTab("Pitch", 250, 73, ObjBindMethod(Dubler2, "FocusTab"))
PitchTab.SetHotkey("^2", "Ctrl + 2")

PitchTab.AddControl(Dubler2.HotspotCheckbox("Pitch enabled", 363, 130, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
PitchTab.AddControl(Dubler2.HotspotCheckbox("Pitch Bend enabled", 346, 470, Dubler2.ProfileLoaded["Current"]["Pitch"]["pitchBendEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))

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
