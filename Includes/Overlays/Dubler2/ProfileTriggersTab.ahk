#Requires AutoHotkey v2.0

SetupTriggers(TabObj) {
    TriggerSlots := [
        [126, 214],
        [235, 212],
        [122, 309],
        [235, 310],
        [125, 411],
        [237, 407],
        [122, 505],
        [236, 510]
    ]

    Loop Dubler2.ProfileLoaded["Current"]["triggers"]["numTriggers"] {
        TB := TriggerButton(Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][A_Index]["name"] . " (" . Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][A_Index]["numExamples"] . " takes), Trigger " . A_Index . " Of " . Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"].Length, ObjBindMethod(Dubler2, "FocusButton"), , , ClickTriggerButton)
        TB.Index := A_Index
        TB.X := TriggerSlots[A_Index][1]
        TB.Y := TriggerSlots[A_Index][2]
        TabObj.AddControl(TB)
    }

    If Dubler2.ProfileLoaded["Current"]["triggers"]["numTriggers"] < 8 {
        TabObj.AddHotspotButton("Add Trigger", TriggerSlots[Dubler2.ProfileLoaded["Current"]["triggers"]["numTriggers"] + 1][1], TriggerSlots[Dubler2.ProfileLoaded["Current"]["triggers"]["numTriggers"] + 1][2], ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay"))
    }
}

ClickTriggerButton(ButtonObj) {

    Click(ButtonObj.X, ButtonObj.Y)

    TriggerMenu := AccessibleStandaloneMenu()

    TriggerMenu.Add("Start recording takes...", StartRecordingTakes)
    TriggerMenu.Add("Mute trigger", MuteTrigger.Bind(ButtonObj.Index))
    TriggerMenu.Add("Velocity Response", ToggleTriggerVelocityResponse.Bind(ButtonObj.Index))
    TriggerMenu.Add("MIDI Note: " . Dubler2.NumberToMidiNote(Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["midiNote"]) . " (" . Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["midiNote"] . ")", ChangeTriggerMidiNote.Bind(ButtonObj.Index))
    TriggerMenu.Add("Clear all takes", ClearAllTriggerTakes.Bind(ButtonObj.Index))
    TriggerMenu.Add("Rename trigger...", RenameTrigger.Bind(ButtonObj))
    TriggerMenu.Add("Delete trigger...", DeleteTrigger.Bind(ButtonObj.Index))

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["numExamples"] == 12
        TriggerMenu.Disable("Start recording takes...")

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["muted"]
        TriggerMenu.Check("Mute trigger")

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["velocityResponse"]
        TriggerMenu.Check("Velocity Response")

    If Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["numExamples"] == 0
        TriggerMenu.Disable("Clear all takes")

    TriggerMenu.Show()
}

StartRecordingTakes(*) {

    Click(504, 264)

    Dubler2.ShowRecordingTakesOverlay := True

    Dubler2.CloseOverlay()
}

MuteTrigger(Index, *) {

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["muted"] := !Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["muted"]

    Click(877, 166)
}

ToggleTriggerVelocityResponse(Index, *) {

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["velocityResponse"] := !Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["velocityResponse"]

    Click(573, 264)
}

ChangeTriggerMidiNote(Index, *) {

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

    Click(354, 25)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(399, 74)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ClearAllTriggerTakes(Index, *) {

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(354, 25)
    Sleep 1000

    ID := Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["id"]
    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][Index]["numExamples"] := 0
    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersData"]["" . ID] := ""
    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(399, 74)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

RenameTrigger(ButtonObj, *) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Name := InputBox("Trigger Name: ", "ReaHotkey", , Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["name"])
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Name.Result != "OK"
        Return

    Dubler2.ProfileLoaded["Current"]["triggers"]["triggersInfo"][ButtonObj.Index]["name"] := Name.Value

    Dubler2.CloseOverlay("Dubler 2 Profile")

    Click(354, 25)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(399, 74)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

DeleteTrigger(Index, *) {

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

    Click(354, 25)
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
    
    Click(399, 74)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

ActivateTriggerSensitivityButton(ButtonObj) {

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

    Click(354, 25)
    Sleep 1000

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    FileAppend(Dubler2.FixJson(Jxon_Dump(Dubler2.ProfileLoaded["Current"], 4)), A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"])
    Dubler2.ProfileLoaded.Set("Current", "")
    Dubler2.ClickLoadProfileButton(Dubler2.ProfileLoaded["Index"])

    Sleep 1000
    
    Click(399, 74)

    ReaHotkey.FoundStandalone.Overlay.Label := ""
}

TriggersTab := HotspotTab("Triggers", 399, 74, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))
TriggersTab.SetHotkey("^4", "Ctrl + 4")

TriggersTab.AddControl(Dubler2.HotspotCheckbox("Triggers enabled", 89, 127, Dubler2.ProfileLoaded["Current"]["triggers"]["triggersEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
SetupTriggers(TriggersTab)
TriggersTab.AddControl(CustomButton("Sensitivity: " . Integer(Dubler2.ProfileLoaded["Current"]["DublerModel"]["triggerSensitivity"] * 100) . "%", ObjBindMethod(Dubler2, "FocusButton"), , ActivateTriggerSensitivityButton))
