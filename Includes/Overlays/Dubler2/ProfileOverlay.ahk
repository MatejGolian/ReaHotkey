#Requires AutoHotkey v2.0

Static AnnounceNotes := False
Static NoteAnnouncements := Map()

Class HotspotCheckbox extends HotspotButton {

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

Class CustomCheckbox extends CustomButton {

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

Class TriggerButton extends CustomButton {

    Index := 0
    X := 0
    Y := 0

}

Static CloseProfileOverlay(*) {
    Dubler2.ProfileLoaded := Map(
        "Index", 0,
        "File", "",
        "Current", "",
        "Backup", ""
    )
    Dubler2.CloseOverlay()
    Dubler2.OverlayPositions.Delete("Dubler 2 Profile")
}

Static DetectProfile(Trigger) {

    If Dubler2.ProfileLoaded["Index"] == 0
        Return False

    return Dubler2.DetectByImage(Trigger)
}

Static RevertProfileButton(*) {

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Dubler2.ProfileLoaded.Set("Current", "")
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Backup"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static AutoSaveProfile() {

    If Not ReaHotkey.FoundStandalone Is Standalone Or ReaHotkey.FoundStandalone.Overlay.Label != "Dubler 2 Profile" Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
        Return
    If PixelGetColor(635, 55) == 0xFA9FA8 {
        Click(635, 55)
        Sleep 300

        Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"], "UTF-8")
        Dubler2.ProfileLoaded.Set("Current", Jxon_Load(&Profile))
    }
}

Static ActivateNotesButton(Button) {

    Notes := Dubler2.ProfileLoaded["Current"]["Scale"]["scaleNotes"]["data"]
    Enabled := Dubler2.ProfileLoaded["Current"]["Scale"]["toggleMask"]["data"]

    NotesMenu := AccessibleStandaloneMenu()

    If Notes != 4095 {
        NotesMenu.Add("You cannot add new notes to this scale without changing the key or scale. Please select a different key and/or scale instead.", Dubler2.ClickNotesButton)
        NotesMenu.Disable("You cannot add new notes to this scale without changing the key or scale. Please select a different key and/or scale instead.")
    }

    For Note In ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] {
        NotesMenu.Add(Note, ObjBindMethod(Dubler2, "ClickNotesButton", Note))

        If Enabled & (1 << (A_Index - 1)) > 0 And Notes & (1 << (A_Index - 1)) > 0
            NotesMenu.Check(Note)

        If Notes & (1 << (A_Index - 1)) == 0
            NotesMenu.Disable(Note)
    }

    NotesMenu.Show()
}

Static ClickNotesButton(Note, *) {

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

Static ActivatePitchStickinessButton(Button) {

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

Static ActivatePitchInputGainButton(Button) {

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

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static EnableNotesAnnouncement(*) {

    Dubler2.AnnounceNotes := True

    Standalone.SetTimer("Dubler 2", ObjBindMethod(Dubler2, "SpeakNotes"), 100)

    Local Ctrl
    Overlay := ReaHotkey.FoundStandalone.Overlay

    If Dubler2.FindControlByLabel(&Overlay, "Announce detected notes (press Ctrl+N to toggle)", &Ctrl) {
        Ctrl.SetChecked(True)
        Dubler2.FocusCheckbox(Ctrl)
    }
}

Static DisableNotesAnnouncement(Emitter := "", *) {

    Dubler2.AnnounceNotes := False

    Standalone.SetTimer("Dubler 2", ObjBindMethod(Dubler2, "SpeakNotes"), 0)

    If Type(Emitter) != "String" And Emitter.ControlType == "Tab"
        Dubler2.FocusTab()

    Local Ctrl
    Overlay := ReaHotkey.FoundStandalone.Overlay

    If Dubler2.FindControlByLabel(&Overlay, "Announce detected notes (press Ctrl+N to toggle)", &Ctrl) {
        Ctrl.SetChecked(False)
        Dubler2.FocusCheckbox(Ctrl)
    }
}

Static ToggleNotesAnnouncement(*) {

    If Not ReaHotkey.FoundStandalone Is Standalone Or Not ReaHotkey.FoundStandalone.Overlay.Label == "Dubler 2 Profile" Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
        Return

    For Ctrl In ReaHotkey.FoundStandalone.Overlay.ChildControls {
        If Ctrl.ControlType == "TabControl" And Ctrl.CurrentTab != 2
            Return
    }

    If Not Dubler2.AnnounceNotes
        Dubler2.EnableNotesAnnouncement()
    Else
        Dubler2.DisableNotesAnnouncement()
}

Static SpeakNotes() {

    If Not ReaHotkey.FoundStandalone Is Standalone Or Not ReaHotkey.FoundStandalone.Overlay.Label == "Dubler 2 Profile" Or Not Dubler2.AnnounceNotes Or ReaHotkey.FoundStandalone.Overlay.ChildControls.Length <= 1 Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
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

        Sleep(-1)

        Color := PixelGetColor(Position[1], Position[2])
        
        If Color != 0x242424 {
            If Dubler2.NoteAnnouncements.Has(Position[3]) And Dubler2.NoteAnnouncements[Position[3]]
                Continue
            Dubler2.NoteAnnouncements.Set(Position[3], True)
            AccessibilityOverlay.Speak(Position[3])
            Break
        } Else
            Dubler2.NoteAnnouncements.Set(Position[3], False)
    }
}

Static ClickTriggerButton(Button) {

    Click(Button.X, Button.Y)

    TriggerMenu := AccessibleStandaloneMenu()

    TriggerMenu.Add("Start recording takes...", ObjBindMethod(Dubler2, "StartRecordingTakes"))
    TriggerMenu.Add("Mute trigger", ObjBindMethod(Dubler2, "MuteTrigger", Button.Index))
    TriggerMenu.Add("Velocity Response", ObjBindMethod(Dubler2, "ToggleTriggerVelocityResponse", Button.Index))
    TriggerMenu.Add("MIDI Note: " . Dubler2.NumberToMidiNote(Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["midiNote"]) . " (" . Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["midiNote"] . ")", ObjBindMethod(Dubler2, "ChangeTriggerMidiNote", Button.Index))
    TriggerMenu.Add("Clear all takes", ObjBindMethod(Dubler2, "ClearAllTriggerTakes", Button.Index))
    TriggerMenu.Add("Rename trigger...", ObjBindMethod(Dubler2, "RenameTrigger", Button))
    TriggerMenu.Add("Delete trigger...", ObjBindMethod(Dubler2, "DeleteTrigger", Button.Index))

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["numExamples"] == 12
        TriggerMenu.Disable("Start recording takes...")

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["muted"]
        TriggerMenu.Check("Mute trigger")

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["velocityResponse"]
        TriggerMenu.Check("Velocity Response")

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["numExamples"] == 0
        TriggerMenu.Disable("Clear all takes")

    TriggerMenu.Show()
}

Static RenameTrigger(Button, *) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Name := InputBox("Trigger Name: ", "ReaHotkey", , Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["name"])
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Name.Result != "OK"
        Return

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Button.Index]["name"] := Name.Value

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static DeleteTrigger(Index, *) {

    Criteria := ReaHotkey.StandaloneWinCriteria

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()

    Confirmation := MsgBox("Do you really want to delete the trigger " . Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["name"] . "?", "ReaHotkey", 4)

    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Not Confirmation == "Yes"
        Return

    WinActivate(Criteria)

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    ID := Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["id"]
    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"].RemoveAt(Index)
    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersData"].Delete("" . ID)
    Dubler2.ProfileLoaded["Current"]["triggers"]["numTriggers"] -= 1
    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static MuteTrigger(Index, *) {

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["muted"] := !Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["muted"]

    Click(885, 197)
}

Static ToggleTriggerVelocityResponse(Index, *) {

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["velocityResponse"] := !Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["velocityResponse"]

    Click(581, 295)
}

Static ClearAllTriggerTakes(Index, *) {

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    ID := Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["id"]
    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["numExamples"] := 0
    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersData"]["" . ID] := ""
    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static ChangeTriggerMidiNote(Index, *) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    MidiNote := InputBox("Midi Note (either note or numeric value):", "ReaHotkey", , Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["midiNote"])
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If MidiNote.Result != "OK"
        Return

    If IsNumber(MidiNote.Value) {
        NMidiNote := Integer(MidiNote.Value)
    } Else {
        NMidiNote := Dubler2.MidiNoteToNumber(MidiNote.Value)

        If Not IsNumber(NMidiNote)
            Return
    }

    If NMidiNote > 127
        NMidiNote := 127
    Else If NMidiNote < 0
        NMidiNote := 0

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["midiNote"] := NMidiNote

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static StartRecordingTakes(*) {

    Click(512, 295)

    Dubler2.ShowRecordingTakesOverlay := True

    Dubler2.CloseOverlay()
}

Static ActivatePitchOctaveShiftButton(Button) {

    OctaveShiftMenu := AccessibleStandaloneMenu()

    For Octave In [-3, -2, -1, 0, 1, 2, 3]
        OctaveShiftMenu.Add((Octave >= 0 ? "+" : "") . Octave, ObjBindMethod(Dubler2, "ClickPitchOctaveShiftButton", Button, Octave))

    OctaveShiftMenu.Check((Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"] >= 0 ? "+" : "") . Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"])

    OctaveShiftMenu.Show()
}

Static ClickPitchOctaveShiftButton(Button, Octave, *) {

    Dubler2.ProfileLoaded["Current"]["DublerModel"]["octaveShift"] := Octave

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static ActivateChordsOctaveShiftButton(Button) {

    OctaveShiftMenu := AccessibleStandaloneMenu()

    For Octave In [-3, -2, -1, 0, 1, 2, 3]
        OctaveShiftMenu.Add((Octave >= 0 ? "+" : "") . Octave, ObjBindMethod(Dubler2, "ClickChordsOctaveShiftButton", Button, Octave))

    OctaveShiftMenu.Check((Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"] >= 0 ? "+" : "") . Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"])

    OctaveShiftMenu.Show()
}

Static ClickChordsOctaveShiftButton(Button, Octave, *) {

    Dubler2.ProfileLoaded["Current"]["Chords"]["octaveShift"] := Octave

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(685, 101)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static ActivatePitchBendRangeButton(Button) {

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

Static ActivateTriggerSensitivityButton(Button) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Sensitivity := InputBox("Trigger Sensitivity in % (from 0 to 100):", "ReaHotkey", , Integer(Dubler2.ProfileLoaded["Current"]["DublerModel"]["triggerSensitivity"] * 100))
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Sensitivity.Result != "OK" Or Not IsNumber(Sensitivity.Value)
        Return

    NSensitivity := Integer(Sensitivity.Value)

    If NSensitivity > 100
        NSensitivity := 100
    Else If NSensitivity < 0
        NSensitivity := 0

    Dubler2.ProfileLoaded["Current"]["DublerModel"]["triggerSensitivity"] := NSensitivity / 100

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(362, 56)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(407, 105)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

Static CreateProfileOverlay(Overlay) {

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
            TriggerButton := Dubler2.TriggerButton(ProfileObj["triggers"]["triggersInfo"][A_Index]["name"] . " (" . ProfileObj["triggers"]["triggersInfo"][A_Index]["numExamples"] . " takes), Trigger " . A_Index . " Of " . ProfileObj["triggers"]["triggersInfo"].Length, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ClickTriggerButton"))
            TriggerButton.Index := A_Index
            TriggerButton.X := TriggerSlots[A_Index][1]
            TriggerButton.Y := TriggerSlots[A_Index][2]
            Tab.AddControl(TriggerButton)
        }

        If ProfileObj["triggers"]["numTriggers"] < 8 {
            Tab.AddHotspotButton("Add Trigger", TriggerSlots[ProfileObj["triggers"]["numTriggers"] + 1][1], TriggerSlots[ProfileObj["triggers"]["numTriggers"] + 1][2], ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseOverlay"))
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

    ClickVoicingPreset(Preset) {
        Click(534, 566)
        Sleep 300

        Switch(Preset) {
            Case "Cluster":
                Click(508, 499)
            Case "Spread":
                Click(499, 533)
        }
    }

    ClickChordPreset(Preset) {
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
    }

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"], "UTF-8")
    ProfileObj := Jxon_Load(&Profile)

    If Dubler2.ProfileLoaded["Backup"] == "" {
        Dubler2.ProfileLoaded.Set("Backup", ProfileObj)
    }

    Dubler2.ProfileLoaded.Set("Current", ProfileObj)

    Overlay.AddCustomButton("Revert Changes", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "RevertProfileButton"))
    Overlay.AddHotspotButton("Unload Profile", 362, 56, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseProfileOverlay"))
    ;Overlay.AddHotspotButton("User Settings", 900, 57, FocusButton)

    PlayTab := HotspotTab("Play", 258, 104, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))

    PlayTab.SetHotkey("^1", "Ctrl + 1")
    PlayTab.AddControl(Dubler2.HotspotCheckbox("Inbuilt audio enabled", 730, 619, ProfileObj["DublerModel"]["audioOutputEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))

    SynthPresetCtrl := PopulatedComboBox("Synth Preset", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

    For Preset In ["8 Bit Lead", "Bass Pluck", "Boards", "Pad", "Pure", "Trap Bass", "Trumpet Lead", "Wobble Bass"] {
        SynthPresetCtrl.AddItem(Preset, ClickSynthPreset.Bind(Preset))

        If StrLower(Preset) == StrLower(ProfileObj["synthPreset"])
            SynthPresetCtrl.SetValue(Preset)
    }

    PlayTab.AddControl(SynthPresetCtrl)
    PlayTab.AddControl(Dubler2.HotspotCheckbox("MIDI out enabled", 829, 621, ProfileObj["DublerModel"]["midiOutputEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))

    PitchTab := HotspotTab("Pitch", 258, 104, ObjBindMethod(Dubler2, "FocusTab"))

    PitchTab.SetHotkey("^2", "Ctrl + 2")
    PitchTab.AddControl(Dubler2.HotspotCheckbox("Pitch enabled", 371, 161, ProfileObj["Pitch"]["pitchEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
    PitchTab.AddControl(CustomButton("Input Gain: " . Integer(ProfileObj["Pitch"]["pitchInputGain"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivatePitchInputGainButton")))
    PitchTab.AddControl(CustomButton("Octave shift: " . (ProfileObj["DublerModel"]["octaveShift"] >= 0 ? "+" : "") . ProfileObj["DublerModel"]["octaveShift"], ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivatePitchOctaveShiftButton")))

    KeyCtrl := PopulatedComboBox("Key", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

    For Key In ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] {
        KeyCtrl.AddItem(Key, ClickKey.Bind(Key))

        If StrLower(Key) == StrLower(ProfileObj["Scale"]["rootName"])
            KeyCtrl.SetValue(Key)
    }

    PitchTab.AddControl(KeyCtrl)

    ScaleCtrl := PopulatedComboBox("Scale", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

    For Scale In ["Major", "Minor", "Harmonic Minor", "Major Pentatonic", "Minor Pentatonic", "Blues", "Locrian", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Hungarian (Gypsy) Minor", "Whole Tone", "Aeolian Dominant (Hindu)", "Chromatic"] {
        ScaleCtrl.AddItem(Scale, ClickScale.Bind(Scale))

        If StrLower(Scale) == StrLower(ProfileObj["Scale"]["patternName"])
            ScaleCtrl.SetValue(Scale)
    }

    PitchTab.AddControl(ScaleCtrl)
    PitchTab.AddControl(CustomButton("Toggle active notes", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivateNotesButton")))
    PitchTab.AddControl(Dubler2.HotspotCheckbox("Pitch Bend enabled", 354, 501, ProfileObj["Pitch"]["pitchBendEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
    PitchTab.AddControl(CustomButton("Stickiness: " . Integer(ProfileObj["Pitch"]["pitchStickiness"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivatePitchStickinessButton")))
    PitchTab.AddControl(CustomButton("Pitch Bend Range: " . ProfileObj["Pitch"]["pitchBendRange"] . " semitones", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivatePitchBendRangeButton")))
    PitchTab.AddControl(Dubler2.CustomCheckbox("Announce detected notes (press Ctrl+N to toggle)", Dubler2.AnnounceNotes, ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "ToggleNotesAnnouncement")))

    TriggersTab := HotspotTab("Triggers", 407, 105, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))

    TriggersTab.SetHotkey("^3", "Ctrl + 3")
    TriggersTab.AddControl(Dubler2.HotspotCheckbox("Triggers enabled", 97, 158, ProfileObj["triggers"]["triggersEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
    SetupTriggers(TriggersTab)
    TriggersTab.AddControl(CustomButton("Sensitivity: " . Integer(ProfileObj["DublerModel"]["triggerSensitivity"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivateTriggerSensitivityButton")))

    ChordsTab := HotspotTab("Chords", 685, 101, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))

    ChordsTab.SetHotkey("^4", "Ctrl + 4")
    ChordsTab.AddControl(Dubler2.HotspotCheckbox("Chords enabled", 97, 159, ProfileObj["Chords"]["chordsEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
    ChordsTab.AddControl(Dubler2.HotspotCheckbox("Root Note Bassline", 575, 566, ProfileObj["Chords"]["rootNoteBassline"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
    ChordsTab.AddControl(Dubler2.HotspotCheckbox("Follow Octaves", 806, 567, ProfileObj["Chords"]["octaveFollow"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
    ChordsTab.AddControl(CustomButton("Octave shift: " . (ProfileObj["Chords"]["octaveShift"] >= 0 ? "+" : "") . ProfileObj["Chords"]["octaveShift"], ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivateChordsOctaveShiftButton")))

    VoicingPresetCtrl := PopulatedComboBox("Voicing Preset", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

    For Preset In ["Cluster", "Spread"] {
        VoicingPresetCtrl.AddItem(Preset, ClickVoicingPreset.Bind(Preset))

        If StrLower(Preset) == StrLower(ProfileObj["Chords"]["voicingPreset"])
            VoicingPresetCtrl.SetValue(Preset)
    }

    ChordsTab.AddControl(VoicingPresetCtrl)

    ChordPresetCtrl := PopulatedComboBox("Chord Preset", ObjBindMethod(Dubler2, "FocusComboBox"), ObjBindMethod(Dubler2, "SelectComboBoxItem"))

    Local Presets
    
    If ProfileObj["Scale"]["patternName"] == "Chromatic"
        Presets := ["Custom"]
    Else
        Presets := ["Triads", "Pop Simple", "Pop Advanced"]

    For Preset In Presets {
        ChordPresetCtrl.AddItem(Preset, ClickChordPreset.Bind(Preset))

        If StrLower(Preset) == StrLower(ProfileObj["Chords"]["chordPreset"])
            ChordPresetCtrl.SetValue(Preset)
    }

    ChordsTab.AddControl(ChordPresetCtrl)

    ;AssignTab := HotspotTab("Assign", 815, 104, DublerDisableNotesAnnouncement)

    Overlay.AddTabControl("Profile Settings", PlayTab, PitchTab, TriggersTab, ChordsTab)

    return Overlay
}