#Requires AutoHotkey v2.0

DublerShowRecordingTakesOverlay := False
DublerTakesDetected := 0

DublerDetectRecordingTakesOverlay(*) {
    Global DublerShowRecordingTakesOverlay
    Return DublerShowRecordingTakesOverlay
}

DublerSpeakRecordedTakes() {
    Critical

    Global DublerShowRecordingTakesOverlay, DublerTakesDetected, FoundStandalone, StandaloneWinCriteria
    
    If Not FoundStandalone Is Standalone Or Not FoundStandalone.Overlay.Label == "Dubler 2 Recording Takes" Or Not DublerShowRecordingTakesOverlay Or Not WinActive(StandaloneWinCriteria)
        Return

    OldTakes := DublerTakesDetected

    For Take In [
                [380, 348],
                [430, 348],
                [481, 348],
                [532, 348],
                [582, 347],
                [633, 347],
                [684, 347],
                [736, 344],
                [784, 346],
                [822, 336],
                [873, 335],
                [919, 337],
            ] {

        If A_Index <= DublerTakesDetected
            Continue

        If Not InArray(PixelGetColor(Take[1], Take[2]), [
                    0x292929,
                    0x282828,
                    0x272727,
                    0x262626,
                ])
            DublerTakesDetected += 1

        Break
    }

    If DublerTakesDetected > OldTakes
        AccessibilityOverlay.Speak(DublerTakesDetected . " takes")
}

DublerClickStopRecordingTakesButton(*) {
    Global DublerShowRecordingTakesOverlay

    DublerShowRecordingTakesOverlay := False
    CloseOverlay()
}

DublerCreateRecordingTakesOverlay(Overlay) {
    Global DublerTakesDetected
    
    DublerTakesDetected := 0

    Overlay.AddHotspotButton("Stop recording", 512, 295, FocusButton, DublerClickStopRecordingTakesButton)

    Return Overlay
}