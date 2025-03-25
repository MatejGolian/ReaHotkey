#Requires AutoHotkey v2.0

Class SinePlayer {
    
    Static __New() {
        Plugin.Register("SINE Player", "^JUCE_[0-9a-f]+$",, False, True, False, ObjBindMethod(This, "CheckInstance"))
        Plugin.SetTimer("SINE Player", This.ClickUI, -1)
    }
    
    Static CheckInstance(Instance) {
        Thread "NoTimers"
        If Instance Is Plugin And Instance.ControlClass = GetCurrentControlClass()
        If Instance.Name = "SINE Player"
        Return True
        UIAElement := This.GetUIAElement()
        If UIAElement
        Return True
        Return False
    }
    
    Static GetUIAElement() {
        Critical
        If Not ReaHotkey.PluginWinCriteria Or Not WinActive(ReaHotkey.PluginWinCriteria)
        Return False
        Try
        UIAElement := GetUIAWindow()
        Catch
        Return False
        If Not UIAElement Is UIA.IUIAutomationElement
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Try
        UIAElement := UIAElement.FindElement({Name:"SINE Player"})
        Catch
        Return False
        If CheckElement(UIAElement)
        Return UIAElement
        Return False
        CheckElement(UIAElement) {
            If UIAElement Is UIA.IUIAutomationElement And UIAElement.Type = 50025
            Return True
            Return False
        }
    }
    
    Class ClickUI {
        Static Call() {
            UIAElement := SinePlayer.GetUIAElement()
            If UIAElement
            UIAElement.Click("Left")
        }
    }
    
}
