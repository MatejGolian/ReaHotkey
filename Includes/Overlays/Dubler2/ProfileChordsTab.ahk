#Requires AutoHotkey v2.0

ActivateChordsOctaveShiftButton(ButtonObj) {

    OctaveShiftMenu := AccessibleStandaloneMenu()

    For Octave In [-3, -2, -1, 0, 1, 2, 3]
        OctaveShiftMenu.Add((Octave >= 0 ? "+" : "") . Octave, ClickChordsOctaveShiftButton.Bind(ButtonObj, Octave))

    OctaveShiftMenu.Check((Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"] >= 0 ? "+" : "") . Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"])

    OctaveShiftMenu.Show()
}

ClickChordsOctaveShiftButton(ButtonObj, Octave, *) {

    Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"] := Octave

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(354, 25)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(677, 70)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ClickVoicingPreset(Preset) {
    Click(526, 535)
    Sleep 300

    Switch(Preset) {
        Case "Cluster":
            Click(500, 468)
        Case "Spread":
            Click(491, 502)
    }
}

ClickChordPreset(Preset) {
    Click(245, 196)
    Sleep 300

    Switch(Preset) {
        Case "Triads":
            Click(262, 233)
        Case "Pop Simple":
            Click(265, 267)
        Case "Pop Advanced":
            Click(244, 304)
    }
}

ChordsTab := HotspotTab("Chords", 677, 70, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))
ChordsTab.SetHotkey("^3", "Ctrl + 3")

ChordsTab.AddControl(Dubler2.HotspotCheckbox("Chords enabled", 89, 128, Dubler2.ProfileLoaded["Current"]["Chords"]["chordsEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
ChordsTab.AddControl(Dubler2.HotspotCheckbox("Root Note Bassline", 567, 535, Dubler2.ProfileLoaded["Current"]["Chords"]["rootNoteBassline"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
ChordsTab.AddControl(Dubler2.HotspotCheckbox("Follow Octaves", 798, 536, Dubler2.ProfileLoaded["Current"]["Chords"]["octaveFollow"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
ChordsTab.AddControl(CustomButton("Octave shift: " . (Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"] >= 0 ? "+" : "") . Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"], ObjBindMethod(Dubler2, "FocusButton"), , ActivateChordsOctaveShiftButton))

VoicingPresetCtrl := PopulatedComboBox("Voicing Preset", ObjBindMethod(Dubler2, "FocusComboBox"), , ObjBindMethod(Dubler2, "SelectComboBoxItem"))

For Preset In ["Cluster", "Spread"] {
    VoicingPresetCtrl.AddItem(Preset, ClickVoicingPreset.Bind(Preset))

    If StrLower(Preset) == StrLower(Dubler2.ProfileLoaded["Current"]["Chords"]["voicingPreset"])
        VoicingPresetCtrl.SetValue(Preset)
}

ChordsTab.AddControl(VoicingPresetCtrl)

ChordPresetCtrl := PopulatedComboBox("Chord Preset", ObjBindMethod(Dubler2, "FocusComboBox"), , ObjBindMethod(Dubler2, "SelectComboBoxItem"))

Local Presets
    
If Dubler2.ProfileLoaded["Current"]["Scale"]["patternName"] == "Chromatic"
    Presets := ["Custom"]
Else
    Presets := ["Triads", "Pop Simple", "Pop Advanced"]

For Preset In Presets {
    ChordPresetCtrl.AddItem(Preset, ClickChordPreset.Bind(Preset))

    If StrLower(Preset) == StrLower(Dubler2.ProfileLoaded["Current"]["Chords"]["chordPreset"])
        ChordPresetCtrl.SetValue(Preset)
}

ChordsTab.AddControl(ChordPresetCtrl)
