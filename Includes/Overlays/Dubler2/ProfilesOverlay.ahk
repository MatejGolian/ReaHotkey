#Requires AutoHotkey v2.0

Class DublerProfileButton extends CustomButton {

    Index := 0
    ProfileFile := ""

}

ActivateProfileButton(Button) {
    ActionsMenu := Menu()
    If Button.Index <= 5
        ActionsMenu.Add("Load Profile", LoadProfile.Bind(Button.Index, Button.ProfileFile))
    Else {
        ActionsMenu.Add("Only active profiles can be loaded", LoadProfile.Bind(Button.Index))
        ActionsMenu.Disable("Only active profiles can be loaded")
    }
    If Button.Index > 5 {
        MoveMenu := Menu()
        MoveMenu.Add("Slot 1", MoveProfile.Bind(Button.ProfileFile, 1))
        MoveMenu.Add("Slot 2", MoveProfile.Bind(Button.ProfileFile, 2))
        MoveMenu.Add("Slot 3", MoveProfile.Bind(Button.ProfileFile, 3))
        MoveMenu.Add("Slot 4", MoveProfile.Bind(Button.ProfileFile, 4))
        MoveMenu.Add("Slot 5", MoveProfile.Bind(Button.ProfileFile, 5))
        ActionsMenu.Add("Set Profile Active", MoveMenu)
    }
    ActionsMenu.Add("Duplicate Profile", DuplicateProfile.Bind(Button.ProfileFile))
    ActionsMenu.Add("Delete Profile", DeleteProfile.Bind(Button.ProfileFile, Button.Index))

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    ActionsMenu.Show()
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False
}

MoveProfile(ProfileFile, Slot, *) {

    Global DublerRestartRequired

    TempFile := A_AppData . "\Vochlea\Dubler2\" . ProfileFile . "_"
    SlotFile := A_AppData . "\Vochlea\Dubler2\Profile" . Slot . ".dubler"
    FileMove(A_AppData . "\Vochlea\Dubler2\" . ProfileFile, TempFile)
    If FileExist(SlotFile) != ""
        FileMove(SlotFile, A_AppData . "\Vochlea\Dubler2\" . ProfileFile)
    FileMove(TempFile, SlotFile)
    DublerRestartRequired := True
    CloseOverlay()
}

DuplicateProfile(ProfileFile, *) {

    Global DublerRestartRequired

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . ProfileFile, "UTF-8")
    ProfileObj := Jxon_Load(&Profile)

    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()
    Confirmation := MsgBox("Do you want to duplicate the profile " . ProfileObj["profileName"], "ReaHotkey", 4)
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    If Not Confirmation == "Yes"
        Return

    ; finding an empty slot
    Slot := 1

    While FileExist(A_AppData . "\Vochlea\Dubler2\Profile" . Slot . ".dubler")
        Slot += 1

    ProfileObj["profileName"] .= " (new)"

    FileAppend(FixJson(Jxon_Dump(ProfileObj, 4)), A_AppData . "\Vochlea\Dubler2\Profile" . Slot . ".dubler")

    If Slot <= 5
        DublerRestartRequired := True

    CloseOverlay()
}

DublerClickLoadProfileButton(Index) {
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

LoadProfile(Index, ProfileFile, *) {
    Global DublerProfileLoaded
    DublerClickLoadProfileButton(Index)
    DublerProfileLoaded.Set("File", ProfileFile)
    DublerProfileLoaded.Set("Index", Index)
    CloseOverlay()
}

DeleteProfile(ProfileFile, Index, *) {

    Global DublerRestartRequired

    Profile := FileRead(A_AppData . "\Vochlea\Dubler2\" . ProfileFile, "UTF-8")
    ProfileObj := Jxon_Load(&Profile)
    SetTimer ReaHotkey.ManageInput, 0
    ReaHotkey.TurnHotkeysOff()

    Confirmation := MsgBox("Do you really want to delete the profile " . ProfileObj["profileName"] . "?", "ReaHotkey", 4)
    ReaHotkey.TurnHotkeysOn()
    SetTimer ReaHotkey.ManageInput, 100

    If Not Confirmation == "Yes"
        Return

    FileDelete(A_AppData . "\Vochlea\Dubler2\" . ProfileFile)

    If Index <= 5
        DublerRestartRequired := True

    CloseOverlay()
    ReaHotkey.AutoFocusStandaloneOverlay := False
}

DublerCreateNewProfileButton(*) {
    Click(200, 256)
    Sleep 1000
    Click(362, 56)
    Sleep 300

    CloseOverlay()
}

DublerCreateProfilesOverlay(Overlay) {

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

        Button := DublerProfileButton(Profiles[A_LoopField]["profileName"] . " " . Suffix, FocusButton, ActivateProfileButton)
        Button.Index := A_Index
        Button.ProfileFile := A_LoopField
        Overlay.AddControl(Button)
    }

    Overlay.AddCustomButton("Create new profile", FocusButton, DublerCreateNewProfileButton)
    ;Overlay.AddHotspotButton("Audio Device Settings", 863, 55, FocusButton)
    ;Overlay.AddHotspotButton("User Settings", 900, 57, FocusButton)

    return Overlay
}