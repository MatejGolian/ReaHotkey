#Requires AutoHotkey v2.0

Class ProfileButton extends CustomButton {

    Index := 0
    ProfileFile := ""

}

Static ActivateProfileButton(Button) {
    ActionsMenu := Menu()
    If Button.Index <= 5
        ActionsMenu.Add("Load Profile", ObjBindMethod(Dubler2, "LoadProfile", Button.Index, Button.ProfileFile))
    Else {
        ActionsMenu.Add("Only active profiles can be loaded", ObjBindMethod(Dubler2, "LoadProfile", Button.Index))
        ActionsMenu.Disable("Only active profiles can be loaded")
    }
    If Button.Index > 5 {
        MoveMenu := Menu()
        MoveMenu.Add("Slot 1", ObjBindMethod(Dubler2, "MoveProfile", Button.ProfileFile, 1))
        MoveMenu.Add("Slot 2", ObjBindMethod(Dubler2, "MoveProfile", Button.ProfileFile, 2))
        MoveMenu.Add("Slot 3", ObjBindMethod(Dubler2, "MoveProfile", Button.ProfileFile, 3))
        MoveMenu.Add("Slot 4", ObjBindMethod(Dubler2, "MoveProfile", Button.ProfileFile, 4))
        MoveMenu.Add("Slot 5", ObjBindMethod(Dubler2, "MoveProfile", Button.ProfileFile, 5))
        ActionsMenu.Add("Set Profile Active", MoveMenu)
    }
    ActionsMenu.Add("Duplicate Profile", ObjBindMethod(Dubler2, "DuplicateProfile", Button.ProfileFile))
    ActionsMenu.Add("Delete Profile", ObjBindMethod(Dubler2, "DeleteProfile", Button.ProfileFile, Button.Index))

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnHotkeysOff()
    ActionsMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False
}

Static MoveProfile(ProfileFile, Slot, *) {

    TempFile := A_AppData . "\Vochlea\Dubler2\" . ProfileFile . "_"
    SlotFile := A_AppData . "\Vochlea\Dubler2\Profile" . Slot . ".dubler"
    FileMove(A_AppData . "\Vochlea\Dubler2\" . ProfileFile, TempFile)
    If FileExist(SlotFile) != ""
        FileMove(SlotFile, A_AppData . "\Vochlea\Dubler2\" . ProfileFile)
    FileMove(TempFile, SlotFile)
    Dubler2.RestartRequired := True
    Dubler2.CloseOverlay()
}

Static DuplicateProfile(ProfileFile, *) {

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . ProfileFile, "UTF-8")
    ProfileObj := Jxon_Load(&Profile)

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnHotkeysOff()
    Confirmation := MsgBox("Do you want to duplicate the profile " . ProfileObj["profileName"], "ReaHotkey", 4)
    ReaHotkey.TurnHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    If Not Confirmation == "Yes"
        Return

    ; finding an empty slot
    Slot := 1

    While FileExist(A_AppData . "\Vochlea\Dubler2\Profile" . Slot . ".dubler")
        Slot += 1

    ProfileObj["profileName"] .= " (new)"

    FileAppend(Dubler2.FixJson(Jxon_Dump(ProfileObj, 4)), A_AppData . "\Vochlea\Dubler2\Profile" . Slot . ".dubler")

    If Slot <= 5
        Dubler2.RestartRequired := True

    Dubler2.CloseOverlay()
}

Static ClickLoadProfileButton(Index) {
    Local X, Y

    If Index <= 2
        Y := 330
    Else
        Y := 521

    If Index == 1 Or Index == 4
        X := 567
    Else If Index == 2 Or Index == 5
        X := 848
    Else If Index == 3
        X := 293

    Click(X, Y)
}

Static LoadProfile(Index, ProfileFile, *) {
    Dubler2.ClickLoadProfileButton(Index)
    Dubler2.ProfileLoaded.Set("File", ProfileFile)
    Dubler2.ProfileLoaded.Set("Index", Index)
    Dubler2.CloseOverlay()
}

Static DeleteProfile(ProfileFile, Index, *) {

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . ProfileFile, "UTF-8")
    ProfileObj := Jxon_Load(&Profile)
    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnHotkeysOff()

    Confirmation := MsgBox("Do you really want to delete the profile " . ProfileObj["profileName"] . "?", "ReaHotkey", 4)
    ReaHotkey.TurnHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    If Not Confirmation == "Yes"
        Return

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . ProfileFile)

    If Index <= 5
        Dubler2.RestartRequired := True

    Dubler2.CloseOverlay()
    ReaHotkey.AutoFocusStandaloneOverlay := False
}

Static CreateNewProfileButton(*) {
    Click(200, 256)
    Sleep 1000
    Click(362, 56)
    Sleep 300

    Dubler2.CloseOverlay()
}

Static CreateProfilesOverlay(Overlay) {

    Profiles := Map()
    Loop Files A_AppData . "\Vochlea\Dubler2\*.dubler" {
        Profile := FileRead(A_LoopFileFullPath, "UTF-8")
        ProfileObj := Jxon_Load(&Profile)
        Profiles.Set(A_LoopFileName, ProfileObj)
    }

    FileList := ""

    For FileName, _ In Profiles
        FileList .= FileName . "`n"

    FileList := Sort(FileList)

    Loop Parse, FileList, "`n" {

        Local Suffix

        If A_LoopField == ""
            Continue

        If A_Index <= 5
            Suffix := "(Active)"
        Else
            Suffix := "(Passive)"

        Button := Dubler2.ProfileButton(Profiles[A_LoopField]["profileName"] . " " . Suffix, ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "ActivateProfileButton"))
        Button.Index := A_Index
        Button.ProfileFile := A_LoopField
        Overlay.AddControl(Button)
    }

    Overlay.AddCustomButton("Create new profile", ObjBindMethod(Dubler2, "FocusButton"), ObjBindMethod(Dubler2, "CreateNewProfileButton"))
    Dubler2.SetupAudioCalibrationButton(Overlay)
    ;Overlay.AddHotspotButton("User Settings", 900, 57, FocusButton)

    return Overlay
}