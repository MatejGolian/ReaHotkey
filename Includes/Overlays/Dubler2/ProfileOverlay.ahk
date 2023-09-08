#Requires AutoHotkey v2.0

DublerAnnounceNotes := False
DublerNoteAnnouncements := Map()

Class DublerHotspotCheckbox extends HotspotButton {

    Checked := False

    __New(Label, XCoordinate, YCoordinate, Checked := False, OnFocusFunction := "", OnActivateFunction := "") {

        Super.__New(Label, XCoordinate, YCoordinate, OnFocusFunction, OnActivateFunction)

        This.SetChecked(Checked)
    }

    UpdateLabel() {
        If This.Checked
            This.ControlTypeLabel := "Checkbox Checked"
        Else
            This.ControlTypeLabel := "Checkbox not checked"
    }

    SetChecked(Checked) {
        This.Checked := Checked
        This.UpdateLabel()
    }

    Activate(CurrentControlID := 0) {
        This.SetChecked(!This.Checked)

        Super.Activate(CurrentControlID)
    }
}

Class DublerCustomCheckbox extends CustomButton {

    Checked := False

    __New(Label, Checked := False, OnFocusFunction := "", OnActivateFunction := "") {

        Super.__New(Label, OnFocusFunction, OnActivateFunction)

        This.SetChecked(Checked)
    }

    UpdateLabel() {
        If This.Checked
            This.ControlTypeLabel := "Checkbox Checked"
        Else
            This.ControlTypeLabel := "Checkbox not checked"
    }

    SetChecked(Checked) {
        This.Checked := Checked
        This.UpdateLabel()
    }

    Activate(CurrentControlID := 0) {
        This.SetChecked(!This.Checked)

        Super.Activate(CurrentControlID)
    }
}

Class DublerTriggerButton extends CustomButton {

    Index := 0
    X := 0
    Y := 0

}

SelectTab(Tab, *) {
    For Ctrl In ReaHotkey.FoundStandalone.Overlay.ChildControls {
        If Ctrl.ControlType == "TabControl" {
            Ctrl.CurrentTab := Tab
            Ctrl.Focus()
            ReaHotkey.FoundStandalone.Overlay.CurrentControlID := Ctrl.ControlID
            Break
        }
    }
}

DublerCloseProfileOverlay(*) {
    Global DublerOverlayPositions, DublerProfileLoaded
    DublerProfileLoaded := Map(
        "Index", 0,
        "File", "",
        "Current", "",
        "Backup", ""
    )
    CloseOverlay()
    DublerOverlayPositions.Delete("Dubler 2 Profile")
}

DublerDetectProfile(Trigger) {
    Global DublerProfileLoaded

    If DublerProfileLoaded["Index"] == 0
        Return False

    return DublerDetectByImage(Trigger)
}

DublerRevertProfileButton(*) {
    Global DublerProfileLoaded

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    DublerProfileLoaded.Set("Current", "")
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Backup"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerAutoSaveProfile() {
    Global DublerProfileLoaded

    If Not ReaHotkey.FoundStandalone Is Standalone Or ReaHotkey.FoundStandalone.Overlay.Label != "Dubler 2 Profile" Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
        Return
    If PixelGetColor(635, 55) == 0xFA9FA8 {
        Click(635, 55)
        Sleep 300

        Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"], "UTF-8")
        DublerProfileLoaded.Set("Current", Jxon_Load(&Profile))
    }
}

DublerActivateSynthPresetButton(Button) {
    Global DublerProfileLoaded

    PresetsMenu := Menu()

    For Preset In ["8 Bit Lead", "Bass Pluck", "Boards", "Pad", "Pure", "Trap Bass", "Trumpet Lead", "Wobble Bass"]
        PresetsMenu.Add(Preset, DublerClickSynthPresetButton.Bind(Button, Preset))

    PresetsMenu.Check(DublerProfileLoaded["Current"]["synthPreset"])

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    PresetsMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickSynthPresetButton(Button, Preset, *) {

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

    Button.Label := "Synth Preset: " . Preset
}

DublerActivateChordsVoicingPresetButton(Button) {
    Global DublerProfileLoaded

    PresetsMenu := Menu()

    For Preset In ["Cluster", "Spread"]
        PresetsMenu.Add(Preset, DublerClickChordsVoicingPresetButton.Bind(Button, Preset))

    PresetsMenu.Check(DublerProfileLoaded["Current"]["Chords"]["voicingPreset"])

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    PresetsMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickChordsVoicingPresetButton(Button, Preset, *) {

    Click(534, 566)
    Sleep 300

    Switch(Preset) {
        Case "Cluster":
            Click(508, 499)
        Case "Spread":
            Click(499, 533)
    }

    Button.Label := "Voicing Preset: " . Preset
}

DublerActivateChordPresetButton(Button) {
    Global DublerProfileLoaded

    Local Presets
    
    If DublerProfileLoaded["Current"]["Scale"]["patternName"] == "Chromatic"
        Presets := ["Custom"]
    Else
        Presets := ["Triads", "Pop Simple", "Pop Advanced", "Custom"]

    PresetsMenu := Menu()

    For Preset In Presets
        PresetsMenu.Add(Preset, DublerClickChordPresetButton.Bind(Button, Preset))

    PresetsMenu.Check(DublerProfileLoaded["Current"]["Chords"]["chordPreset"])
    PresetsMenu.Disable("Custom")

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    PresetsMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickChordPresetButton(Button, Preset, *) {

    Click(253, 227)
    Sleep 300

    Switch(Preset) {
        Case "Triads":
            Click(270, 264)
        Case "Pop Simple":
            Click(273, 298)
        Case "Pop Advanced":
            Click(252, 335)
    }

    Button.Label := "Chord Preset: " . Preset
}

DublerActivateKeyButton(Button) {
    Global DublerProfileLoaded

    KeyMenu := Menu()

    For Key In ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] {
        KeyMenu.Add(Key, DublerClickKeyButton.Bind(Button, Key))
    }

    KeyMenu.Check(DublerProfileLoaded["Current"]["Scale"]["rootName"])

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    KeyMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickKeyButton(Button, Key, *) {

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

    Button.Label := "Key: " . Key
}

DublerActivateScaleButton(Button) {
    Global DublerProfileLoaded

    ScaleMenu := Menu()

    For Scale In ["Major", "Minor", "Harmonic Minor", "Major Pentatonic", "Minor Pentatonic", "Blues", "Locrian", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Hungarian (Gypsy) Minor", "Whole Tone", "Aeolian Dominant (Hindu)", "Chromatic"] {
        ScaleMenu.Add(Scale, DublerClickScaleButton.Bind(Button, Scale))
    }

    ScaleMenu.Check(DublerProfileLoaded["Current"]["Scale"]["patternName"])

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    ScaleMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickScaleButton(Button, Scale, *) {

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

    Button.Label := "Scale: " . Scale
}

DublerActivateNotesButton(Button) {
    Global DublerProfileLoaded

    Notes := DublerProfileLoaded["Current"]["Scale"]["scaleNotes"]["data"]
    Enabled := DublerProfileLoaded["Current"]["Scale"]["toggleMask"]["data"]

    NotesMenu := Menu()

    If Notes != 4095 {
        NotesMenu.Add("You cannot add new notes to this scale without changing the key or scale. Please select a different key and/or scale instead.", DublerClickNotesButton)
        NotesMenu.Disable("You cannot add new notes to this scale without changing the key or scale. Please select a different key and/or scale instead.")
    }

    For Note In ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] {
        NotesMenu.Add(Note, DublerClickNotesButton.Bind(Note))

        If Enabled & (1 << (A_Index - 1)) > 0 And Notes & (1 << (A_Index - 1)) > 0
            NotesMenu.Check(Note)

        If Notes & (1 << (A_Index - 1)) == 0
            NotesMenu.Disable(Note)
    }

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    NotesMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickNotesButton(Note, *) {

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

DublerActivatePitchStickinessButton(Button) {
    Global DublerProfileLoaded

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    Stickiness := InputBox("Pitch Bend Stickiness in % (from 0 to 100):", "ReaHotkey", , Integer(DublerProfileLoaded["Current"]["Pitch"]["pitchStickiness"] * 100))
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Stickiness.Result != "OK" Or Not IsNumber(Stickiness.Value)
        Return

    NStickiness := Integer(Stickiness.Value)

    If NStickiness > 100
        NStickiness := 100
    Else If NStickiness < 0
        NStickiness := 0

    DublerProfileLoaded["Current"]["Pitch"]["pitchStickiness"] := NStickiness / 100

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerActivatePitchInputGainButton(Button) {
    Global DublerProfileLoaded

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    Gain := InputBox("Pitch Input Gain in % (from 0 to 100):", "ReaHotkey", , Integer(DublerProfileLoaded["Current"]["Pitch"]["pitchInputGain"] * 100))
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Gain.Result != "OK" Or Not IsNumber(Gain.Value)
        Return

    NGain := Integer(Gain.Value)

    If NGain > 100
        NGain := 100
    Else If NGain < 0
        NGain := 0

    DublerProfileLoaded["Current"]["Pitch"]["pitchInputGain"] := NGain / 100

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerEnableNotesAnnouncement(*) {
    Global DublerAnnounceNotes

    DublerAnnounceNotes := True

    Local Ctrl
    Overlay := ReaHotkey.FoundStandalone.Overlay

    If FindControlByLabel(&Overlay, "Announce detected notes (press Ctrl+N to toggle)", &Ctrl) {
        Ctrl.SetChecked(True)
        FocusCheckbox(Ctrl)
    }
}

DublerDisableNotesAnnouncement(Emitter := "", *) {
    Global DublerAnnounceNotes

    DublerAnnounceNotes := False

    If Type(Emitter) != "String" And Emitter.ControlType == "Tab"
        FocusTab()

    Local Ctrl
    Overlay := ReaHotkey.FoundStandalone.Overlay

    If FindControlByLabel(&Overlay, "Announce detected notes (press Ctrl+N to toggle)", &Ctrl) {
        Ctrl.SetChecked(False)
        FocusCheckbox(Ctrl)
    }
}

DublerToggleNotesAnnouncement(*) {
    Global DublerAnnounceNotes

    If Not ReaHotkey.FoundStandalone Is Standalone Or Not ReaHotkey.FoundStandalone.Overlay.Label == "Dubler 2 Profile" Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
        Return

    For Ctrl In ReaHotkey.FoundStandalone.Overlay.ChildControls {
        If Ctrl.ControlType == "TabControl" And Ctrl.CurrentTab != 2
            Return
    }

    If Not DublerAnnounceNotes
        DublerEnableNotesAnnouncement()
    Else
        DublerDisableNotesAnnouncement()
}

DublerSpeakNotes() {
    Critical

    Global DublerAnnounceNotes, DublerNoteAnnouncements

    If Not ReaHotkey.FoundStandalone Is Standalone Or Not ReaHotkey.FoundStandalone.Overlay.Label == "Dubler 2 Profile" Or Not DublerAnnounceNotes Or ReaHotkey.FoundStandalone.Overlay.ChildControls.Length <= 1 Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
        Return

    For Position In [
        [527, 207, "C"],
        [573, 242, "C#"],
        [614, 282, "D"],
        [631, 343, "D#"],
        [623, 376, "E"],
        [577, 411, "F"],
        [510, 427, "F#"],
        [471, 427, "G"],
        [415, 398, "G#"],
        [410, 335, "A"],
        [419, 251, "A#"],
        [433, 235, "B"]] {

        Color := PixelGetColor(Position[1], Position[2])
        
        If Color != 0x242424 {
            If DublerNoteAnnouncements.Has(Position[3]) And DublerNoteAnnouncements[Position[3]]
                Continue
            DublerNoteAnnouncements.Set(Position[3], True)
            AccessibilityOverlay.Speak(Position[3])
            Break
        } Else
            DublerNoteAnnouncements.Set(Position[3], False)
    }
}

DublerClickTriggerButton(Button) {

    Global DublerProfileLoaded

    Click(Button.X, Button.Y)

    TriggerMenu := Menu()

    TriggerMenu.Add("Start recording takes...", DublerStartRecordingTakes)
    TriggerMenu.Add("Mute trigger", DublerMuteTrigger.Bind(Button.Index))
    TriggerMenu.Add("Velocity Response", DublerToggleTriggerVelocityResponse.Bind(Button.Index))
    TriggerMenu.Add("MIDI Note: " . numberToMidiNote(DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["midiNote"]) . " (" . DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["midiNote"] . ")", DublerChangeTriggerMidiNote.Bind(Button.Index))
    TriggerMenu.Add("Clear all takes", DublerClearAllTriggerTakes.Bind(Button.Index))
    TriggerMenu.Add("Rename trigger...", DublerRenameTrigger.Bind(Button))
    TriggerMenu.Add("Delete trigger...", DublerDeleteTrigger.Bind(Button.Index))

    If DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["numExamples"] == 12
        TriggerMenu.Disable("Start recording takes...")

    If DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["muted"]
        TriggerMenu.Check("Mute trigger")

    If DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["velocityResponse"]
        TriggerMenu.Check("Velocity Response")

    If DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["numExamples"] == 0
        TriggerMenu.Disable("Clear all takes")

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    TriggerMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerRenameTrigger(Button, *) {
    Global DublerProfileLoaded

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    Name := InputBox("Trigger Name: ", "ReaHotkey", , DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["name"])
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Name.Result != "OK"
        Return

    DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["name"] := Name.Value

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerDeleteTrigger(Index, *) {

    Global DublerProfileLoaded

    Criteria := ReaHotkey.StandaloneWinCriteria

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()

    Confirmation := MsgBox("Do you really want to delete the trigger " . DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["name"] . "?", "ReaHotkey", 4)
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Not Confirmation == "Yes"
        Return

    WinActivate(Criteria)

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    ID := DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["id"]
    DublerProfileLoaded["Current"]["triggers"]["triggersInfo"].RemoveAt(Index)
    DublerProfileLoaded["Current"]["triggers"]["triggersData"].Delete("" . ID)
    DublerProfileLoaded["Current"]["triggers"]["numTriggers"] -= 1
    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerMuteTrigger(Index, *) {

    Global DublerProfileLoaded

    DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["muted"] := !DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["muted"]

    Click(885, 197)
}

DublerToggleTriggerVelocityResponse(Index, *) {

    Global DublerProfileLoaded

    DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["velocityResponse"] := !DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["velocityResponse"]

    Click(581, 295)
}

DublerClearAllTriggerTakes(Index, *) {

    Global DublerProfileLoaded

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    ID := DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["id"]
    DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["numExamples"] := 0
    DublerProfileLoaded["Current"]["triggers"]["triggersData"]["" . ID] := ""
    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerChangeTriggerMidiNote(Index, *) {
    Global DublerProfileLoaded

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    MidiNote := InputBox("Midi Note (either note or numeric value):", "ReaHotkey", , DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["midiNote"])
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If MidiNote.Result != "OK"
        Return

    If IsNumber(MidiNote.Value) {
        NMidiNote := Integer(MidiNote.Value)
    } Else {
        NMidiNote := midiNoteToNumber(MidiNote.Value)

        If Not IsNumber(NMidiNote)
            Return
    }

    If NMidiNote > 127
        NMidiNote := 127
    Else If NMidiNote < 0
        NMidiNote := 0

    DublerProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["midiNote"] := NMidiNote

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerStartRecordingTakes(*) {
    Global DublerShowRecordingTakesOverlay

    Click(512, 295)

    DublerShowRecordingTakesOverlay := True

    CloseOverlay()
}

DublerActivatePitchOctaveShiftButton(Button) {
    Global DublerProfileLoaded

    OctaveShiftMenu := Menu()

    For Octave In [-3, -2, -1, 0, 1, 2, 3]
        OctaveShiftMenu.Add((Octave >= 0 ? "+" : "") . Octave, DublerClickPitchOctaveShiftButton.Bind(Button, Octave))

    OctaveShiftMenu.Check((DublerProfileLoaded["Current"]["DublerModel"]["octaveShift"] >= 0 ? "+" : "") . DublerProfileLoaded["Current"]["DublerModel"]["octaveShift"])

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    OctaveShiftMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickPitchOctaveShiftButton(Button, Octave, *) {
    Global DublerProfileLoaded

    DublerProfileLoaded["Current"]["DublerModel"]["octaveShift"] := Octave

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerActivateChordsOctaveShiftButton(Button) {
    Global DublerProfileLoaded

    OctaveShiftMenu := Menu()

    For Octave In [-3, -2, -1, 0, 1, 2, 3]
        OctaveShiftMenu.Add((Octave >= 0 ? "+" : "") . Octave, DublerClickChordsOctaveShiftButton.Bind(Button, Octave))

    OctaveShiftMenu.Check((DublerProfileLoaded["Current"]["Chords"]["octaveShift"] >= 0 ? "+" : "") . DublerProfileLoaded["Current"]["Chords"]["octaveShift"])

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    OctaveShiftMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100
}

DublerClickChordsOctaveShiftButton(Button, Octave, *) {
    Global DublerProfileLoaded

    DublerProfileLoaded["Current"]["Chords"]["octaveShift"] := Octave

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    Sleep 1000
    
    Click(685, 101)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerActivatePitchBendRangeButton(Button) {
    Global DublerProfileLoaded

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    Range := InputBox("Pitch Bend Range (From 1 to 48 semitones):", "ReaHotkey", , DublerProfileLoaded["Current"]["Pitch"]["pitchBendRange"])
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Range.Result != "OK" Or Not IsNumber(Range.Value)
        Return

    NRange := Integer(Range.Value)

    If NRange > 48
        NRange := 48
    Else If NRange < 1
        NRange := 1

    DublerProfileLoaded["Current"]["Pitch"]["pitchBendRange"] := NRange

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerActivateTriggerSensitivityButton(Button) {
    Global DublerProfileLoaded

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    Sensitivity := InputBox("Trigger Sensitivity in % (from 0 to 100):", "ReaHotkey", , Integer(DublerProfileLoaded["Current"]["DublerModel"]["triggerSensitivity"] * 100))
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Sensitivity.Result != "OK" Or Not IsNumber(Sensitivity.Value)
        Return

    NSensitivity := Integer(Sensitivity.Value)

    If NSensitivity > 100
        NSensitivity := 100
    Else If NSensitivity < 0
        NSensitivity := 0

    DublerProfileLoaded["Current"]["DublerModel"]["triggerSensitivity"] := NSensitivity / 100

    CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    FileAppend(FixJson(Jxon_Dump(DublerProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"])
    DublerProfileLoaded.Set("Current", "")
    DublerClickLoadProfileButton(DublerProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DublerCreateProfileOverlay(Overlay) {

    SetupTriggers(Tab) {
        TriggerSlots := [
            [134, 245],
            [243, 243],
            [130, 340],
            [243, 341],
            [133, 442],
            [245, 438],
            [130, 536],
            [244, 541]
        ]

        Loop ProfileObj["triggers"]["numTriggers"] {
            TriggerButton := DublerTriggerButton(ProfileObj["triggers"]["triggersInfo"][A_Index]["name"] . " (" . ProfileObj["triggers"]["triggersInfo"][A_Index]["numExamples"] . " takes), Trigger " . A_Index . " Of " . ProfileObj["triggers"]["triggersInfo"].Length, FocusButton, DublerClickTriggerButton)
            TriggerButton.Index := A_Index
            TriggerButton.X := TriggerSlots[A_Index][1]
            TriggerButton.Y := TriggerSlots[A_Index][2]
            Tab.AddControl(TriggerButton)
        }

        If ProfileObj["triggers"]["numTriggers"] < 8 {
            Tab.AddHotspotButton("Add Trigger", TriggerSlots[ProfileObj["triggers"]["numTriggers"] + 1][1], TriggerSlots[ProfileObj["triggers"]["numTriggers"] + 1][2], FocusButton, CloseOverlay)
        }
    }

    Global DublerAnnounceNotes, DublerProfileLoaded

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . DublerProfileLoaded["File"], "UTF-8")
    ProfileObj := Jxon_Load(&Profile)

    If DublerProfileLoaded["Backup"] == "" {
        DublerProfileLoaded.Set("Backup", ProfileObj)
    }

    DublerProfileLoaded.Set("Current", ProfileObj)

    Overlay.AddCustomButton("Revert Changes", FocusButton, DublerRevertProfileButton)
    Overlay.AddHotspotButton("Unload Profile", 362, 56, FocusButton, DublerCloseProfileOverlay)
    ;Overlay.AddHotspotButton("User Settings", 900, 57, FocusButton)

    PlayTab := HotspotTab("Play (press Ctrl+1 to select)", 258, 104, DublerDisableNotesAnnouncement)

    PlayTab.AddControl(DublerHotspotCheckbox("Inbuilt audio enabled", 730, 619, ProfileObj["DublerModel"]["audioOutputEnabled"], FocusCheckbox, FocusCheckbox))
    PlayTab.AddControl(CustomButton("Synth Preset: " . ProfileObj["synthPreset"], FocusButton, DublerActivateSynthPresetButton))
    PlayTab.AddControl(DublerHotspotCheckbox("MIDI out enabled", 829, 621, ProfileObj["DublerModel"]["midiOutputEnabled"], FocusCheckbox, FocusCheckbox))

    PitchTab := HotspotTab("Pitch (press Ctrl+2 to select)", 258, 104, FocusTab)

    PitchTab.AddControl(DublerHotspotCheckbox("Pitch enabled", 371, 161, ProfileObj["Pitch"]["pitchEnabled"], FocusCheckbox, FocusCheckbox))
    PitchTab.AddControl(CustomButton("Input Gain: " . Integer(ProfileObj["Pitch"]["pitchInputGain"] * 100) . "%", FocusButton, DublerActivatePitchInputGainButton))
    PitchTab.AddControl(CustomButton("Octave shift: " . (ProfileObj["DublerModel"]["octaveShift"] >= 0 ? "+" : "") . ProfileObj["DublerModel"]["octaveShift"], FocusButton, DublerActivatePitchOctaveShiftButton))
    PitchTab.AddControl(CustomButton("Key: " . ProfileObj["Scale"]["rootName"], FocusButton, DublerActivateKeyButton))
    PitchTab.AddControl(CustomButton("Scale: " . ProfileObj["Scale"]["patternName"], FocusButton, DublerActivateScaleButton))
    PitchTab.AddControl(CustomButton("Toggle active notes", FocusButton, DublerActivateNotesButton))
    PitchTab.AddControl(DublerHotspotCheckbox("Pitch Bend enabled", 354, 501, ProfileObj["Pitch"]["pitchBendEnabled"], FocusCheckbox, FocusCheckbox))
    PitchTab.AddControl(CustomButton("Stickiness: " . Integer(ProfileObj["Pitch"]["pitchStickiness"] * 100) . "%", FocusButton, DublerActivatePitchStickinessButton))
    PitchTab.AddControl(CustomButton("Pitch Bend Range: " . ProfileObj["Pitch"]["pitchBendRange"] . " semitones", FocusButton, DublerActivatePitchBendRangeButton))
    PitchTab.AddControl(DublerCustomCheckbox("Announce detected notes (press Ctrl+N to toggle)", DublerAnnounceNotes, FocusCheckbox, DublerEnableNotesAnnouncement))

    TriggersTab := HotspotTab("Triggers (press Ctrl+3 to select)", 407, 105, DublerDisableNotesAnnouncement)

    TriggersTab.AddControl(DublerHotspotCheckbox("Triggers enabled", 97, 158, ProfileObj["triggers"]["triggersEnabled"], FocusCheckbox, FocusCheckbox))
    SetupTriggers(TriggersTab)
    TriggersTab.AddControl(CustomButton("Sensitivity: " . Integer(ProfileObj["DublerModel"]["triggerSensitivity"] * 100) . "%", FocusButton, DublerActivateTriggerSensitivityButton))

    ChordsTab := HotspotTab("Chords (press Ctrl+4 to select)", 685, 101, DublerDisableNotesAnnouncement)

    ChordsTab.AddControl(DublerHotspotCheckbox("Chords enabled", 97, 159, ProfileObj["Chords"]["chordsEnabled"], FocusCheckbox, FocusCheckbox))
    ChordsTab.AddControl(DublerHotspotCheckbox("Root Note Bassline", 575, 566, ProfileObj["Chords"]["rootNoteBassline"], FocusCheckbox, FocusCheckbox))
    ChordsTab.AddControl(DublerHotspotCheckbox("Follow Octaves", 806, 567, ProfileObj["Chords"]["octaveFollow"], FocusCheckbox, FocusCheckbox))
    ChordsTab.AddControl(CustomButton("Octave shift: " . (ProfileObj["Chords"]["octaveShift"] >= 0 ? "+" : "") . ProfileObj["Chords"]["octaveShift"], FocusButton, DublerActivateChordsOctaveShiftButton))
    ChordsTab.AddControl(CustomButton("Voicing Preset: " . ProfileObj["Chords"]["voicingPreset"], FocusButton, DublerActivateChordsVoicingPresetButton))
    ChordsTab.AddControl(CustomButton("Chord Preset: " . ProfileObj["Chords"]["chordPreset"], FocusButton, DublerActivateChordPresetButton))

    ;AssignTab := HotspotTab("Assign", 815, 104, DublerDisableNotesAnnouncement)

    Overlay.AddTabControl("Profile Settings", PlayTab, PitchTab, TriggersTab, ChordsTab)

    SetupAudioCalibrationButton(Overlay)

    return Overlay
}