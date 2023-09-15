#Requires AutoHotkey v2.0

Class PopulatedComboBox extends CustomComboBox {

    Values := Array()
    
    __New(Label, OnFocusFunction := "", OnChangeFunction := "") {

        Change := Array(ObjBindMethod(This, "OnChange"))

        If OnChangeFunction != "" {
            If Not OnChangeFunction Is Array
                Change.Push(OnChangeFunction)
            Else
                Change.Push(OnChangeFunction*)
        }

        Super.__New(Label, OnFocusFunction, Change)
    }

    AddItem(Label, Selector := "") {
        This.Values.Push(Map(
            "Label", Label,
            "Selector", Selector,
        ))

        If This.Value == ""
            This.Value := Label
    }

    OnChange(*) {

        FI := 0
        Hk := A_ThisHotkey
        
        If This.Values.Length == 0
            Return

        Loop This.Values.Length {
            If This.Values[A_Index]["Label"] == This.Value {
                FI := A_Index
                Break
            }
        }

        If FI == 0
            Return
        
        If Hk == "Up" And FI > 1
            FI -= 1
        Else If Hk == "Down" And FI < This.Values.Length
            FI += 1

        This.SetValue(This.Values[FI]["Label"])
        
        If This.Values[FI]["Selector"] != ""
            This.Values[FI]["Selector"]()
    }

    ClearItems() {
        This.Values := Array()
        This.SetValue("")
    }
}

Class Dubler2 {

    Static OVERLAY_TRIGGERS := Array(
        Map(
            "Label", "Dubler 2 Fix Settings",
            "Generator", ObjBindMethod(Dubler2, "CreateFixSettingsOverlay"),
            "Detector", ObjBindMethod(Dubler2, "DetectFixSettings"),
        ),
        Map(
            "Label", "Dubler 2 Audio Calibration",
            "Generator", ObjBindMethod(Dubler2, "CreateAudioCalibrationOverlay"),
            "Detector", ObjBindMethod(Dubler2, "DetectAudioCalibrationOverlay"),
            "Popup", True,
        ),
        Map(
            "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2ApplyScalePopup.png"),
            "FromX", 0,
            "FromY", 0,
            "ToX", A_ScreenWidth,
            "ToY", A_ScreenHeight,
            "Label", "Dubler 2 Apply Scale Popup",
            "Generator", ObjBindMethod(Dubler2, "CreateApplyScalePopupOverlay"),
            "Popup", True,
            "Debug", True,
        ),
        Map(
            "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2AudioPopup.png"),
            "FromX", 700,
            "FromY", 50,
            "ToX", 1000,
            "ToY", 300,
            "Label", "Dubler 2 Audio Popup",
            "Generator", ObjBindMethod(Dubler2, "CreateAudioPopupOverlay"),
            "Popup", True,
        ),
        Map(
            "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2SaveProfilePopup.png"),
            "FromX", 0,
            "FromY", 0,
            "ToX", A_ScreenWidth,
            "ToY", A_ScreenHeight,
            "Label", "Dubler 2 Save Profile Popup",
            "Generator", ObjBindMethod(Dubler2, "CreateSaveProfilePopupOverlay"),
            "Popup", True,
            "Debug", True,
        ),
        Map(
            "Label", "Dubler 2 Recording Takes",
            "Generator", ObjBindMethod(Dubler2, "CreateRecordingTakesOverlay"),
            "Popup", True,
            "Detector", ObjBindMethod(Dubler2, "DetectRecordingTakesOverlay"),
        ),
        Map(
            "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2Login.png"),
            "FromX", 345,
            "FromY", 105,
            "ToX", 645,
            "ToY", 405,
            "Label", "Dubler 2 Login",
            "Generator", ObjBindMethod(Dubler2, "CreateLoginOverlay"),
        ),
        Map(
            "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2Profile.png"),
            "FromX", 0,
            "FromY", 550,
            "ToX", 100,
            "ToY", 650,
            "Label", "Dubler 2 Profile",
            "Generator", ObjBindMethod(Dubler2, "CreateProfileOverlay"),
            "RestoreLastPosition", True,
            "Detector", ObjBindMethod(Dubler2, "DetectProfile"),
        ),
        Map(
            "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2Profiles.png"),
            "FromX", 0,
            "FromY", 80,
            "ToX", 300,
            "ToY", 300,
            "Label", "Dubler 2 Profiles",
            "Generator", ObjBindMethod(Dubler2, "CreateProfilesOverlay"),
        ),
    )

    Static ProfileLoaded := Map(
        "Index", 0,
        "File", "",
        "Current", "",
        "Backup", ""
    )
    Static OverlayPositions := Map()
    Static RestartRequired := False

    Static FixJsonBool(Haystack, Needle) {
        Haystack := StrReplace(Haystack, '"' . Needle . '": 1', '"' . Needle . '": true', true, , -1)
        Haystack := StrReplace(Haystack, '"' . Needle . '": 0', '"' . Needle . '": false', true, , -1)
        Return Haystack
    }

    Static FixJson(Text) {
        For Bool In [
                    "AAALocked",
                    "audioOutputEnabled",
                    "autoKeyDetect",
                    "chordsEnabled",
                    "EEELocked",
                    "ENVEnabled",
                    "midiOutputEnabled",
                    "muted",
                    "octaveFollow",
                    "OOOLocked",
                    "pitchBendEnabled",
                    "pitchEnabled",
                    "PitchBendChords",
                    "PitchBendSynth",
                    "rootNoteBassline",
                    "showAboutChromaticScalePopup",
                    "showAudioSetupOnStartup",
                    "showTrialReminders",
                    "showWelcomeScreen",
                    "triggersEnabled",
                    "velocityResponse",
                ]
            Text := Dubler2.FixJsonBool(Text, Bool)
        Return Text
    }

    Static SoundPlay(File) {
        Try {
            SoundPlay(A_ScriptDir . "\Sounds\" . File)
        } Catch {
            Return
        }
    }

    Static FindControlByLabel(&Control, Label, &OutVar) {

        If InArray(Control.ControlType, ["Overlay", "Tab"]) {
            For NextControl In Control.ChildControls {
                If NextControl.Label == Label {
                    OutVar := NextControl
                    Return True
                } Else If InArray(NextControl.ControlType, ["Tab", "TabControl"]) {
                    Success := Dubler2.FindControlByLabel(&NextControl, Label, &OutVar)

                    If Success
                        Return True
                }
            }
        } Else If Control.ControlType == "TabControl" {
            Tab := Control.Tabs[Control.CurrentTab]
            Success := Dubler2.FindControlByLabel(&Tab, Label, &OutVar)

            If Success {
                Return True
            }
        }

        Return False
    }

    Static CloseOverlay(Label := "", *) {

        GetPosition(&Control, ID) {

            If InArray(Control.ControlType, ["Overlay", "Tab"]) {
                For NextControl In Control.ChildControls {
                    If NextControl.ControlID == ID {
                        Return [A_Index]
                    } Else If InArray(NextControl.ControlType, ["Tab", "TabControl"]) {
                        Position := GetPosition(&NextControl, ID)

                        If Position.Length > 0 { 
                            Return Array(A_Index, Position*)
                        }
                    }
                }
            } Else If Control.ControlType == "TabControl" {
                Tab := Control.Tabs[Control.CurrentTab]
                Position := GetPosition(&Tab, ID)

                If Position.Length > 0 {
                    Return Array(Control.CurrentTab, Position*)
                }
            }

            Return []
        }

        Local NextControl, Controls

        Dubler2.SoundPlay("OverlayClosed.mp3")

        If Not ReaHotkey.FoundStandalone Is Standalone
            Return

        For Trigger In Dubler2.OVERLAY_TRIGGERS {
            If Trigger["Label"] == ReaHotkey.FoundStandalone.Overlay.Label And Trigger.Has("RestoreLastPosition") And Trigger["RestoreLastPosition"] == True {
                Overlay := ReaHotkey.FoundStandalone.Overlay
                Dubler2.OverlayPositions.Set(Trigger["Label"], GetPosition(&Overlay, ReaHotkey.FoundStandalone.Overlay.CurrentControlID))
            }
        }

        If Not Type(Label) == "String"
            Label := ""

        ReaHotkey.FoundStandalone.Overlay := Dubler2.CreateLoadingOverlay(AccessibilityOverlay(Label))
    }

    Static FocusButton(*) {
        Dubler2.SoundPlay("FocusButton.mp3")
    }

    Static FocusCheckbox(Checkbox) {
        If Checkbox.Checked
            Dubler2.SoundPlay("CheckboxChecked.mp3")
        Else
            Dubler2.SoundPlay("CheckboxUnchecked.mp3")
    }

    Static FocusInput(*) {
        Dubler2.SoundPlay("FocusInput.mp3")
    }

    Static FocusTab(*) {
        Dubler2.SoundPlay("FocusTab.mp3")
    }

    Static Init(Instance) {
        Instance.SetTimer(ObjBindMethod(Dubler2, "SetOverlay"), 100)
        Instance.SetTimer(ObjBindMethod(Dubler2, "AutoSaveProfile"), 100)
        Instance.SetTimer(ObjBindMethod(Dubler2, "SpeakNotes"), 100)
        Instance.SetTimer(ObjBindMethod(Dubler2, "SpeakRecordedTakes"), 100)
        Instance.SetHotkey("^N", ObjBindMethod(Dubler2, "ToggleNotesAnnouncement"))
        Instance.SetHotkey("^1", ObjBindMethod(Dubler2, "SelectTab", 1))
        Instance.SetHotkey("^2", ObjBindMethod(Dubler2, "SelectTab", 2))
        Instance.SetHotkey("^3", ObjBindMethod(Dubler2, "SelectTab", 3))
        Instance.SetHotkey("^4", ObjBindMethod(Dubler2, "SelectTab", 4))
        Dubler2.ProfileLoaded := Map(
            "Index", 0,
            "File", "",
            "Current", "",
            "Backup", ""
        )
        Dubler2.RestartRequired := False
        Dubler2.FixSettingsOverlayShown := False
        ReaHotkey.AutoFocusStandaloneOverlay := False
    }

    Static Sync() {
        WindowID := ReaHotkey.FoundStandalone.WindowID
        Path := ProcessGetPath("dubler2.exe")

        ProcessClose("dubler2.exe")
        WinWaitNotActive(WindowID)

        Run(Path)
        WinWaitActive(WindowID)
    }

    Static DetectByImage(Trigger) {
        Local x, y
        Found := ImageSearch(&x, &y, Trigger["FromX"], Trigger["FromY"], Trigger["ToX"], Trigger["ToY"], "*20 HBITMAP:*" . Trigger["Image"])

        If Found And Trigger.Has("Debug") And Trigger["Debug"] == True And Not A_IsCompiled {
            AccessibilityOverlay.Speak(Trigger["Label"] . " detected, coordinates copied to clipboard.")
            A_Clipboard := "Coordinates for " . Trigger["Label"] . ": " . x . ", " . y
        }
        Return Found
    }

    Static SetOverlay(*) {

        RestorePosition(&Control, Position) {

            Local NextControl
            Local ControlID

            If Position.Length == 0
                Return

            If Control.ControlType != "TabControl" {
                NextControl := Control.ChildControls[Position[1]]
                ControlID := NextControl.ControlID
            } Else {
                NextControl := Control.Tabs[Position[1]]
                Control.CurrentTab := Position[1]
                ControlID := Control.Tabs[Position[1]].ControlID
            }

            If Position.Length > 1 {
                Position.RemoveAt(1)
                Return RestorePosition(&NextControl, Position)
            }

            Return ControlID
        }

        Local Detector

        If Dubler2.RestartRequired {
            Dubler2.Sync()
            Return
        }

        For Trigger In Dubler2.OVERLAY_TRIGGERS {
            If Not ReaHotkey.FoundStandalone Is Standalone
                Return
            If ReaHotkey.FoundStandalone.Overlay.Label != "" And (Not Trigger.Has("Popup") Or Trigger["Popup"] == False) Or (ReaHotkey.FoundStandalone.Overlay.Label == Trigger["Label"] And (Trigger.Has("Popup") And Trigger["Popup"] == True))
                Continue
            If Trigger.Has("Detector")
                Detector := Trigger["Detector"]
            Else
                Detector := ObjBindMethod(Dubler2, "DetectByImage")
A_Clipboard := Trigger["Label"]
            If Detector(Trigger) {
                Overlay := AccessibilityOverlay(Trigger["Label"])
                Overlay := Trigger["Generator"](Overlay)
                If Trigger.Has("RestoreLastPosition") And Trigger["RestoreLastPosition"] == True And Dubler2.OverlayPositions.Has(Trigger["Label"]) {
                    Position := RestorePosition(&Overlay, Dubler2.OverlayPositions[Trigger["Label"]])
                    Overlay.CurrentControlID := Position
                    Dubler2.OverlayPositions.Delete(Trigger["Label"])
                }
                Overlay.Focus()
                ReaHotkey.FoundStandalone.Overlay := Overlay
                Dubler2.SoundPlay("OverlayShown.mp3")
                Break
            }
        }
    }

    Static NumberToMidiNote(Num) {
        Return ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"][Mod(Num, 12) + 1] . " " . Floor(Num / 12) - 1
    }

    Static MidiNoteToNumber(Note) {

        Local Match

        If Not Type(Note) == "String"
            Return
        
        If RegExMatch(Note, ")([a-gA-G]#?) *(-?\d+)", &Match) == 0
            Return
        
        Return 12 * (Integer(Match[2]) + 1) + Map(
            "c", 0,
            "c#", 1,
            "d", 2,
            "d#", 3,
            "e", 4, 
            "f", 5,
            "f#", 6,
            "g", 7,
            "g#", 8,
            "a", 9,
            "a#", 10,
            "b", 11,
        )[StrLower(Match[1])]
    }

    #Include Dubler2/ApplyScalePopupOverlay.ahk
    #Include Dubler2/AudioCalibrationOverlay.ahk
    #Include Dubler2/AudioPopupOverlay.ahk
    #Include Dubler2/FixSettingsOverlay.ahk
    #Include Dubler2/LoadingOverlay.ahk
    #Include Dubler2/LoginOverlay.ahk
    #Include Dubler2/ProfileOverlay.ahk
    #Include Dubler2/ProfilesOverlay.ahk
    #Include Dubler2/RecordingTakesOverlay.ahk
    #Include Dubler2/SaveProfileOverlay.ahk

}

Plugin.Register("Dubler 2", "JUCE_18a5c54cc971", , , False)
Standalone.Register("Dubler 2", "Vochlea\sDubler\s2\.1 ahk_class Qt5155QWindowOwnDCIcon", Dubler2.Init, True)
Standalone.RegisterOverlay("Dubler 2", Dubler2.CreateLoadingOverlay(AccessibilityOverlay()))
