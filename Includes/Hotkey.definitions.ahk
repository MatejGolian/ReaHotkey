#Requires AutoHotkey v2.0

Tab::TabHK(ThisHotkey)
+Tab::ShiftTabHK(ThisHotkey)
^Tab::ControlTabHK(ThisHotkey)
^+Tab::ControlShiftTabHK(ThisHotkey)
Left::LeftRightHK(ThisHotkey)
Right::LeftRightHK(ThisHotkey)
Up::UpDownHK(ThisHotkey)
Down::UpDownHK(ThisHotkey)
Enter::EnterSpaceHK(ThisHotkey)
Space::EnterSpaceHK(ThisHotkey)

#SuspendExempt
^+#F1::ReadmeHK(ThisHotkey)
^+#F5::ReloadHK(ThisHotkey)
Ctrl::ControlHK(ThisHotkey)
^+#A::AboutHK(ThisHotkey)
^+#C::ConfigHK(ThisHotkey)
^+#P::PauseHK(ThisHotkey)
^+#Q::QuitHK(ThisHotkey)
^+#R::ReaHotkeyMenuHK(ThisHotkey)
^+#U::UpdateCheckHK(ThisHotkey)
#SuspendExempt False
