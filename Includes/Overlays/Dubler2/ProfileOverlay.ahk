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

Static CreateProfileOverlay(Overlay) {

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . Dubler2.ProfileLoaded["File"], "UTF-8")
    ProfileObj := Jxon_Load(&Profile)

    If Dubler2.ProfileLoaded["Backup"] == "" {
        Dubler2.ProfileLoaded.Set("Backup", ProfileObj)
    }

    Dubler2.ProfileLoaded.Set("Current", ProfileObj)

    Overlay.AddCustomButton("Revert Changes", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "RevertProfileButton"))
    Overlay.AddHotspotButton("Unload Profile", 362, 56, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CloseProfileOverlay"))
    ;Overlay.AddHotspotButton("User Settings", 900, 57, FocusButton)

    #Include ProfileAssignTab.ahk
    #Include ProfileChordsTab.ahk
    #Include ProfilePitchBendTab.ahk
    #Include ProfilePitchTab.ahk
    #Include ProfilePlayTab.ahk
    #Include ProfileTriggersTab.ahk

    Overlay.AddTabControl("Profile Settings", PlayTab, PitchTab, PitchBendTab, ChordsTab, TriggersTab, AssignTab)

    return Overlay
}