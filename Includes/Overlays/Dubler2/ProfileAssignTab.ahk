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

AssignTab := HotspotTab("Assign", 821, 102, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))
AssignTab.SetHotkey("^6", "Ctrl + 6")

AssignTab.AddControl(CustomButton("Pitch MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["PitchMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivatePitchMidiChannelButton))
AssignTab.AddControl(CustomButton("Chords MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["ChordsMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivateChordsMidiChannelButton))
AssignTab.AddControl(CustomButton("Triggers MIDI Channel: " . Dubler2.ProfileLoaded["Current"]["TriggersMidiChannel"], ObjBindMethod(Dubler2, "FocusButton"), ActivateTriggersMidiChannelButton))
