#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe reaper.exe ahk_class #32770")

F6:: {
    Thread "NoTimers"
    Controls := WinGetControls(ReaHotkey.PluginWinCriteria)
    ContainerIndex := 0
    Try
    For Index, Control In Controls
    If Control = "reaperPluginHostWrapProc1" And Index < Controls.Length {
        ContainerIndex := Index + 1
        Break
    }
    CurrentIndex := 0
    Try
    For Index, Control In Controls
    If Control = ControlGetClassNN(ControlGetFocus(ReaHotkey.PluginWinCriteria)) {
        CurrentIndex := Index
        Break
    }
    If CurrentIndex > 0 And ContainerIndex > 0 And CurrentIndex <= 6 And CurrentIndex != ContainerIndex {
        Try
        ControlFocus Controls[ContainerIndex], ReaHotkey.PluginWinCriteria
        }
    Else {
        Hotkey A_ThisHotkey, "Off"
        Send "{" . A_ThisHotkey . "}"
        Hotkey A_ThisHotkey, "On"
    }
}

#Include Contextual.Hotkeys.ahk
#Include Global.Hotkeys.ahk

#HotIf

#IncludeAgain Contextual.Hotkeys.ahk
#IncludeAgain Global.Hotkeys.ahk
