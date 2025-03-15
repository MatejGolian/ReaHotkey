#Requires AutoHotkey v2.0

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
