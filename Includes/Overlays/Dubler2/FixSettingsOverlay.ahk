#Requires AutoHotkey v2.0

DublerFixSettingsOverlayShown := False
DublerSettings := Map(
        "showWelcomeScreen", False,
        "windowScale", 1.0,
        "showTrialReminders", False,
        "showAudioSetupOnStartup", False,
        "showAboutChromaticScalePopup", False,
    )

DublerDetectFixSettings(*) {

    Global DublerFixSettingsOverlayShown

    If DublerFixSettingsOverlayShown
        return False

    Settings := FileRead(A_AppData . "\Vochlea\Dubler2\dublersettings.json", "UTF-8")
    SettingsObj := Jxon_Load(&Settings)

    For Setting, Value In DublerSettings {
        If Not SettingsObj["AppSettings"].Has(Setting) Or SettingsObj["AppSettings"][Setting] != Value
            Return True
    }

    Return False
}

DublerClickApplySettingsButton(*) {
    Global DublerRestartRequired

    Settings := FileRead(A_AppData . "\Vochlea\Dubler2\dublersettings.json", "UTF-8")
    SettingsObj := Jxon_Load(&Settings)

    For Setting, Value In DublerSettings {
        SettingsObj["AppSettings"][Setting] := Value
    }

    FileDelete(A_AppData . "\Vochlea\Dubler2\dublersettings.json")
    FileAppend(FixJson(Jxon_Dump(SettingsObj, 4)), A_AppData . "\Vochlea\Dubler2\dublersettings.json")

    DublerRestartRequired := True

    CloseOverlay()
}

DublerCreateFixSettingsOverlay(Overlay) {

    Global DublerFixSettingsOverlayShown

    Overlay.AddStaticText("I detected Dubler settings that can interfere with the accessibility overlay. Should I fix them for you automatically? NOTE: Dubler will restart if you say 'yes'.")
    Overlay.AddControl(CustomButton("Yes, let's go!", FocusButton, DublerClickApplySettingsButton))
    Overlay.AddControl(CustomButton("No, I decide not to.", FocusButton, CloseOverlay))

    DublerFixSettingsOverlayShown := True

    return Overlay
}
