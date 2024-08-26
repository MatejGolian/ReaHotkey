#Requires AutoHotkey v2.0

Static FixSettingsOverlayShown := False
Static Settings := Map(
        "showWelcomeScreen", False,
        "windowScale", 1.0,
        "showTrialReminders", False,
        "showAudioSetupOnStartup", False,
        "showAboutChromaticScalePopup", False,
        "newFeatureAnnouncement", 2,
    )

Static DetectFixSettings(*) {

    If Dubler2.FixSettingsOverlayShown
        return False

    Settings := FileRead(A_AppData . "\Vochlea\Dubler2\dublersettings.json", "UTF-8")
    SettingsObj := Jxon_Load(&Settings)

    For Setting, Value In Dubler2.Settings {
        If Not SettingsObj["AppSettings"].Has(Setting) Or SettingsObj["AppSettings"][Setting] != Value
            Return True
    }

    Return False
}

Static ClickApplySettingsButton(*) {
    Settings := FileRead(A_AppData . "\Vochlea\Dubler2\dublersettings.json", "UTF-8")
    SettingsObj := Jxon_Load(&Settings)

    For Setting, Value In Dubler2.Settings {
        SettingsObj["AppSettings"][Setting] := Value
    }

    FileDelete(A_AppData . "\Vochlea\Dubler2\dublersettings.json")
    FileAppend(Dubler2.FixJson(Jxon_Dump(SettingsObj, 4)), A_AppData . "\Vochlea\Dubler2\dublersettings.json")

    Dubler2.RestartRequired := True

    Dubler2.CloseOverlay()
}

Static CreateFixSettingsOverlay(Overlay) {

    Overlay.AddStaticText("I detected Dubler settings that can interfere with the accessibility overlay. Should I fix them for you automatically? NOTE: Dubler will restart if you say 'yes'.")
    Overlay.AddControl(CustomButton("Yes, let's go!", ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "ClickApplySettingsButton")))
    Overlay.AddControl(CustomButton("No, I decide not to.", ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "CloseOverlay")))

    Dubler2.FixSettingsOverlayShown := True

    return Overlay
}
