#Requires AutoHotkey v2.0

Static ShowReadingGainOverlay := False

Static DetectReadingGainOverlay(*) {
    Return Dubler2.ShowReadingGainOverlay
}

Static CreateReadingGainOverlay(Overlay) {
    
    DataCallback(Input, Channel, Buffer, Length, User) {
        Return 0
    }

    StopReadingGain(*) {
        DllCall(Dll . "\BASS_ASIO_Stop", "Char")
        DllCall(Dll . "\BASS_ASIO_ChannelEnable", "Char", True, "Int", I, "Ptr", 0, "Ptr", 0, "Char")
        CallbackFree(CB)
        Dubler2.ShowReadingGainOverlay := False
        Standalone.SetTimer("Dubler 2", ObjBindMethod(Dubler2, "SpeakGain"), 0)
        DllCall(Dll . "\BASS_ASIO_Free", "Int")
        Dubler2.CloseOverlay()
    }

    Dll := A_ScriptDir . "\bassasio" . (A_PtrSize * 8) . ".dll"
    Success := True
    I := 0

    While Success {
        Success := DllCall(Dll . "\BASS_ASIO_Init", "Int", I, "Int", 0, "Char")
        I += 1
        Err := DllCall(Dll . "\BASS_ASIO_ErrorGetCode", "Int")
        If Not Success {
            If Err != 3
                Break
            Success := True
            Continue
        }
        Info := Buffer(64, 0)
        DllCall(Dll . "\BASS_ASIO_GetInfo", "Ptr", Info, "Int")
        If StrGet(Info, "UTF-8") == Dubler2.AudioSettings["audioInputDeviceName"]
            Break
        DllCall(Dll . "\BASS_ASIO_Free", "Int")
    }

    SpeakGain() {

        If Not ReaHotkey.FoundStandalone Is Standalone Or Not ReaHotkey.FoundStandalone.Overlay.Label == "Dubler 2 Reading Gain" Or Not Dubler2.ShowReadingGainOverlay Or Not WinActive(ReaHotkey.StandaloneWinCriteria)
            Return

        Level := DllCall(Dll . "\BASS_ASIO_ChannelGetLevel", "Char", True, "Int", I, "Float")

        LevelDB := Level > 0 ? 20 * Log(Level) : -144.0
        
        Recommendation := ""
        
        If LevelDB > -30
            Recommendation := "To Loud"
        Else If LevelDB < -40
            Recommendation := "To Quiet"
        Else
            Recommendation := "Optimal Gain"

        AccessibilityOverlay.Speak(Round(LevelDB, 1) . " dB (" . Recommendation . ")")
    }

    CB := CallbackCreate(DataCallback, "Fast")

    I := 0
    
    While (ConvertBase(2, 10, Dubler2.AudioSettings["audioDeviceInChans"]) >> I) != 1
        I += 1

    DllCall(Dll . "\BASS_ASIO_ChannelEnable", "Char", True, "Int", I, "Ptr", CB, "Ptr", 0, "Char")

    DllCall(Dll . "\BASS_ASIO_Start", "Int", 0, "Int", 0, "Char")

    Overlay.AddControl(CustomButton("Stop Reading Gain", ObjBindMethod(Dubler2, "FocusButton"), , StopReadingGain))

    Standalone.SetTimer("Dubler 2", SpeakGain, 1000)

    Return Overlay
}