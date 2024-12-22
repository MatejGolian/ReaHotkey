#Requires AutoHotkey v2.0

Static ShowRecordingTakesOverlay := False
Static TakesDetected := 0

Static DetectRecordingTakesOverlay(*) {
    Return Dubler2.ShowRecordingTakesOverlay
}

Static SpeakRecordedTakes() {
    Critical

    If Not ReaHotkey.FoundStandalone Is Standalone Or Not ReaHotkey.FoundStandalone.Overlay.Label == "Dubler 2 Recording Takes" Or Not Dubler2.ShowRecordingTakesOverlay Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
        Return

    OldTakes := Dubler2.TakesDetected

    For Take In [
                [372, 317],
                [422, 317],
                [473, 317],
                [524, 317],
                [574, 316],
                [625, 316],
                [676, 316],
                [728, 313],
                [776, 315],
                [814, 305],
                [865, 304],
                [911, 306],
            ] {

        If A_Index <= Dubler2.TakesDetected
            Continue

        If Not InArray(PixelGetColor(Take[1], Take[2]), [
                    0x292929,
                    0x282828,
                    0x272727,
                    0x262626,
                ])
            Dubler2.TakesDetected += 1

        Break
    }

    If Dubler2.TakesDetected > OldTakes
        AccessibilityOverlay.Speak(Dubler2.TakesDetected . " takes")
}

Static ClickStopRecordingTakesButton(*) {

    Dubler2.ShowRecordingTakesOverlay := False
    Standalone.SetTimer("Dubler 2", ObjBindMethod(Dubler2, "SpeakRecordedTakes"), 0)
    Dubler2.CloseOverlay()
}

Static CreateRecordingTakesOverlay(Overlay) {
    
    Dubler2.TakesDetected := 0

    Standalone.SetTimer("Dubler 2", ObjBindMethod(Dubler2, "SpeakRecordedTakes"), 100)

    Overlay.AddHotspotButton("Stop recording", 504, 264, ObjBindMethod(Dubler2, "FocusButton"), , ObjBindMethod(Dubler2, "ClickStopRecordingTakesButton"))

    Return Overlay
}