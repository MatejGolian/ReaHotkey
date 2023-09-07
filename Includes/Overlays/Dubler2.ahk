#Requires AutoHotkey v2.0

DUBLER_OVERLAY_TRIGGERS := Array(
    Map(
        "Label", "Dubler 2 Fix Settings",
        "Generator", DublerCreateFixSettingsOverlay,
        "Detector", DublerDetectFixSettings,
    ),
    Map(
        "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2ApplyScalePopup.png"),
        "FromX", 0,
        "FromY", 0,
        "ToX", A_ScreenWidth,
        "ToY", A_ScreenHeight,
        "Label", "Dubler 2 Apply Scale Popup",
        "Generator", DublerCreateApplyScalePopupOverlay,
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
        "Generator", DublerCreateAudioPopupOverlay,
        "Popup", True,
    ),
    Map(
        "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2SaveProfilePopup.png"),
        "FromX", 0,
        "FromY", 0,
        "ToX", A_ScreenWidth,
        "ToY", A_ScreenHeight,
        "Label", "Dubler 2 Save Profile Popup",
        "Generator", DublerCreateSaveProfilePopupOverlay,
        "Popup", True,
        "Debug", True,
    ),
    Map(
        "Label", "Dubler 2 Recording Takes",
        "Generator", DublerCreateRecordingTakesOverlay,
        "Popup", True,
        "Detector", DublerDetectRecordingTakesOverlay,
    ),
    Map(
        "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2Login.png"),
        "FromX", 345,
        "FromY", 105,
        "ToX", 645,
        "ToY", 405,
        "Label", "Dubler 2 Login",
        "Generator", DublerCreateLoginOverlay,
    ),
    Map(
        "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2Profile.png"),
        "FromX", 0,
        "FromY", 550,
        "ToX", 100,
        "ToY", 650,
        "Label", "Dubler 2 Profile",
        "Generator", DublerCreateProfileOverlay,
        "RestoreLastPosition", True,
        "Detector", DublerDetectProfile,
    ),
    Map(
        "Image", LoadPicture(A_ScriptDir . "\Images\Dubler2Profiles.png"),
        "FromX", 0,
        "FromY", 80,
        "ToX", 300,
        "ToY", 300,
        "Label", "Dubler 2 Profiles",
        "Generator", DublerCreateProfilesOverlay,
    ),
)

DublerProfileLoaded := Map(
    "Index", 0,
    "File", "",
    "Current", "",
    "Backup", ""
)
DublerOverlayPositions := Map()
DublerRestartRequired := False

FixJsonBool(Haystack, Needle) {
    Haystack := StrReplace(Haystack, '"' . Needle . '": 1', '"' . Needle . '": true', true, , -1)
    Haystack := StrReplace(Haystack, '"' . Needle . '": 0', '"' . Needle . '": false', true, , -1)
    Return Haystack
}

FixJson(Text) {
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
        Text := FixJsonBool(Text, Bool)
    Return Text
}

FindControlByLabel(&Control, Label, &OutVar) {

    If InArray(Control.ControlType, ["Overlay", "Tab"]) {
        For NextControl In Control.ChildControls {
            If NextControl.Label == Label {
                OutVar := NextControl
                Return True
            } Else If InArray(NextControl.ControlType, ["Tab", "TabControl"]) {
                Success := FindControlByLabel(&NextControl, Label, &OutVar)

                If Success
                    Return True
            }
        }
    } Else If Control.ControlType == "TabControl" {
        Tab := Control.Tabs[Control.CurrentTab]
        Success := FindControlByLabel(&Tab, Label, &OutVar)

        If Success {
            Return True
        }
    }

    Return False
}

CloseOverlay(Label := "", *) {

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

    Global DublerOverlayPositions, DUBLER_OVERLAY_TRIGGERS

    Local NextControl, Controls

    SoundPlay(A_ScriptDir . "\Sounds\OverlayClosed.mp3")

    If Not ReaHotkey.FoundStandalone Is Standalone
        Return

    For Trigger In DUBLER_OVERLAY_TRIGGERS {
        If Trigger["Label"] == ReaHotkey.FoundStandalone.Overlay.Label And Trigger.Has("RestoreLastPosition") And Trigger["RestoreLastPosition"] == True {
            Overlay := ReaHotkey.FoundStandalone.Overlay
            DublerOverlayPositions.Set(Trigger["Label"], GetPosition(&Overlay, ReaHotkey.FoundStandalone.Overlay.CurrentControlID))
        }
    }

    If Not Type(Label) == "String"
        Label := ""

    ReaHotkey.FoundStandalone.Overlay := DublerCreateLoadingOverlay(AccessibilityOverlay(Label))
}

FocusButton(*) {
    SoundPlay(A_ScriptDir . "\Sounds\FocusButton.mp3")
}

FocusCheckbox(Checkbox) {
    If Checkbox.Checked
        SoundPlay(A_ScriptDir . "\Sounds\CheckboxChecked.mp3")
    Else
        SoundPlay(A_ScriptDir . "\Sounds\CheckboxUnchecked.mp3")
}

FocusInput(*) {
    SoundPlay(A_ScriptDir . "\Sounds\FocusInput.mp3")
}

FocusTab(*) {
    SoundPlay(A_ScriptDir . "\Sounds\FocusTab.mp3")
}

DublerInit(DublerInstance) {
    Global DublerProfileLoaded, DublerRestartRequired, DublerFixSettingsOverlayShown
    DublerInstance.SetTimer(DublerSetOverlay, 100)
    DublerInstance.SetTimer(DublerAutoSaveProfile, 100)
    DublerInstance.SetTimer(DublerSpeakNotes, 100)
    DublerInstance.SetTimer(DublerSpeakRecordedTakes, 100)
    DublerInstance.SetHotkey("^N", DublerToggleNotesAnnouncement)
    DublerInstance.SetHotkey("^1", SelectTab.Bind(1))
    DublerInstance.SetHotkey("^2", SelectTab.Bind(2))
    DublerInstance.SetHotkey("^3", SelectTab.Bind(3))
    DublerInstance.SetHotkey("^4", SelectTab.Bind(4))
    DublerProfileLoaded := Map(
        "Index", 0,
        "File", "",
        "Current", "",
        "Backup", ""
    )
    DublerRestartRequired := False
    DublerFixSettingsOverlayShown := False
    ReaHotkey.AutoFocusStandaloneOverlay := False
}

DublerSync() {
    WindowID := ReaHotkey.FoundStandalone.WindowID
    Path := ProcessGetPath("dubler2.exe")

    ProcessClose("dubler2.exe")
    WinWaitNotActive(WindowID)

    Run(Path)
    WinWaitActive(WindowID)
}

DublerDetectByImage(Trigger) {
    Local x, y
    Found := ImageSearch(&x, &y, Trigger["FromX"], Trigger["FromY"], Trigger["ToX"], Trigger["ToY"], "*20 HBITMAP:*" . Trigger["Image"])

    If Found And Trigger.Has("Debug") And Trigger["Debug"] == True {
        AccessibilityOverlay.Speak(Trigger["Label"] . " detected, coordinates copied to clipboard.")
        A_Clipboard := "Coordinates for " . Trigger["Label"] . ": " . x . ", " . y
    }
    Return Found
}

DublerSetOverlay(*) {

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

    Global DUBLER_OVERLAY_TRIGGERS, DublerOverlayPositions, DublerRestartRequired
    Local Detector

    If DublerRestartRequired {
        DublerSync()
        Return
    }

    For Trigger In DUBLER_OVERLAY_TRIGGERS {
        If Not ReaHotkey.FoundStandalone Is Standalone
            Return
        If ReaHotkey.FoundStandalone.Overlay.Label != "" And (Not Trigger.Has("Popup") Or Trigger["Popup"] == False) Or (ReaHotkey.FoundStandalone.Overlay.Label == Trigger["Label"] And (Trigger.Has("Popup") And Trigger["Popup"] == True))
            Continue
        If Trigger.Has("Detector")
            Detector := Trigger["Detector"]
        Else
            Detector := DublerDetectByImage
        If %Detector.Name%(Trigger) {
            Overlay := AccessibilityOverlay(Trigger["Label"])
            Overlay := %Trigger["Generator"].Name%(Overlay)
            If Trigger.Has("RestoreLastPosition") And Trigger["RestoreLastPosition"] == True And DublerOverlayPositions.Has(Trigger["Label"]) {
                Position := RestorePosition(&Overlay, DublerOverlayPositions[Trigger["Label"]])
                Overlay.CurrentControlID := Position
                DublerOverlayPositions.Delete(Trigger["Label"])
            }
            Overlay.Focus()
            ReaHotkey.FoundStandalone.Overlay := Overlay
            SoundPlay(A_ScriptDir . "\Sounds\OverlayShown.mp3")
            Break
        }
    }
}

numberToMidiNote(Num) {
    Return ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"][Mod(Num, 12) + 1] . " " . Floor(Num / 12) - 1
}

midiNoteToNumber(Note) {

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
#Include Dubler2/AudioPopupOverlay.ahk
#Include Dubler2/FixSettingsOverlay.ahk
#Include Dubler2/LoadingOverlay.ahk
#Include Dubler2/LoginOverlay.ahk
#Include Dubler2/ProfileOverlay.ahk
#Include Dubler2/ProfilesOverlay.ahk
#Include Dubler2/RecordingTakesOverlay.ahk
#Include Dubler2/SaveProfileOverlay.ahk

Standalone.RegisterOverlay("Dubler 2", DublerCreateLoadingOverlay(AccessibilityOverlay()))
