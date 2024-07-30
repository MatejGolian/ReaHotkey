#Requires AutoHotkey v2.0

#SuspendExempt

Ctrl:: {
    Thread "NoTimers"
    AccessibilityOverlay.StopSpeech()
}

^+#F5:: {
    ReaHotkey.Reload()
}

^+#A:: {
    ReaHotkey.ShowAboutBox()
}

^+#C:: {
    ReaHotkey.ShowConfigBox()
}

^+#P:: {
    ReaHotkey.TogglePause()
    If A_IsSuspended = 1
    AccessibilityOverlay.Speak("Paused ReaHotkey")
    Else
    AccessibilityOverlay.Speak("ReaHotkey ready")
}

^+#Q:: {
    AccessibilityOverlay.Speak("Quitting ReaHotkey")
    ReaHotkey.Quit()
}

^+#R:: {
    ReaHotkey.ViewReadme()
}

#SuspendExempt False
