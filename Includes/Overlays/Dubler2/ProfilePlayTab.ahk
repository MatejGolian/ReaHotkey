#Requires AutoHotkey v2.0

ActivateRenameProfileButton(ButtonObj) {

    SetTimer ReaHotkey.ManageState, 0
    ReaHotkey.TurnStandaloneTimersOff()
    ReaHotkey.TurnStandaloneHotkeysOff()
    Name := InputBox("Name of the profile:", "ReaHotkey", , Dubler2.ProfileLoaded["Current"]["profileName"])
    ReaHotkey.TurnStandaloneHotkeysOn()
    ReaHotkey.TurnStandaloneTimersOn()
    SetTimer ReaHotkey.ManageState, 100

    ReaHotkey.AutoFocusStandaloneOverlay := False

    If Name.Result != "OK"
        Return

    Dubler2.ProfileLoaded["Current"]["profileName"] := Name.Value

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

PlayTab := HotspotTab("Play", 250, 73, ObjBindMethod(Dubler2, "DisableNotesAnnouncement"))

PlayTab.SetHotkey("^1", "Ctrl + 1")
PlayTab.AddControl(CustomButton("Rename profile", ObjBindMethod(Dubler2, "FocusButton"), , ActivateRenameProfileButton))
PlayTab.AddControl(Dubler2.HotspotCheckbox("Inbuilt audio enabled", 722, 588, Dubler2.ProfileLoaded["Current"]["DublerModel"]["audioOutputEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
PlayTab.AddControl(Dubler2.HotspotCheckbox("MIDI out enabled", 821, 590, Dubler2.ProfileLoaded["Current"]["DublerModel"]["midiOutputEnabled"], ObjBindMethod(Dubler2, "FocusCheckbox"), ObjBindMethod(Dubler2, "FocusCheckbox")))
