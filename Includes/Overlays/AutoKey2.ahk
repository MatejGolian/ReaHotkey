#Requires AutoHotkey v2.0

Class AutoKey2 {
    
    Static __New() {
        Plugin.Register("Auto-Key 2", "^JUCE_[0-9a-f]{1,}$", ObjBindMethod(This, "CheckPlugin"), False, False, False, 1, False)
        Plugin.SetTimer("Auto-Key 2", This.AutoReport, 2000)
        AutoKey2Overlay := PluginOverlay("Auto-Key 2", "Auto-Key 2")
        AutoKey2Overlay.AddHotspotButton("Send To AUTO-TUNE", 265, 318, , , , , "!s", "Alt + S")
        AutoKey2Overlay.AddGraphicalButton("Listen", 18, 38, 162, 102, ["Images/AutoKey2/Listen1.png", "Images/AutoKey2/Listen2.png"], , , , , "!l", "Alt + L")
        AutoKey2Overlay.AddHotspotButton("Use File", 267, 67, , , , , "!f", "Alt + F")
        AutoKey2Overlay.AddOCRText("", "", "UWP", 160, 190, 560, 270, , 4)
    }
    
    Static CheckPlugin(PluginInstance) {
        Thread "NoTimers"
        If PluginInstance Is Plugin And PluginInstance.ControlClass = ReaHotkey.GetPluginControl()
        If PluginInstance.Name = "Auto-Key 2"
        Return True
        If ReaHotkey.AbletonPlugin {
            If RegExMatch(WinGetTitle("A"), "^Auto-Key/[1-9][0-9]*")
            Return True
            If RegExMatch(WinGetTitle("A"), "^Auto-Key 2/[1-9][0-9]*")
            Return True
        }
        If ReaHotkey.ReaperPluginNative {
            ReaperFXInstanceName := GetReaperFXInstanceName()
            ReaperPluginNames := ["VST3: Auto-Key (Antares)", "VST3: Auto-Key 2 (Antares)"]
            If Not ReaperFXInstanceName = ""
            For ReaperPluginName In ReaperPluginNames
            If ReaperFXInstanceName = ReaperPluginName
            Return True
        }
        If ReaHotkey.ReaperPluginBridged {
            Try {
                If RegExMatch(WinGetTitle("A"), "^Auto-Key \(x(64|86) bridged\)$")
                Return True
                If RegExMatch(WinGetTitle("A"), "^Auto-Key 2 \(x(64|86) bridged\)$")
                Return True
            }
            Catch {
                Return False
            }
        }
        Return False
    }
    
    Static GetCentralDisplay() {
        PluginControlPos := GetPluginControlPos()
        Result := Trim(AccessibilityOverlay.Helpers.OCR("UWP", PluginControlPos.X + 160, PluginControlPos.Y + 190, PluginControlPos.X + 560, PluginControlPos.Y + 270, , 4))
        TempoText := Result
        TempoText := StrReplace(TempoText, "O", "0")
        TempoText := StrReplace(TempoText, "o", "0")
        TempoText := StrReplace(TempoText, "I", "1")
        TempoText := StrReplace(TempoText, "i", "1")
        TempoText := StrReplace(TempoText, "l", "1")
        TempoText := StrReplace(TempoText, "S", "5")
        TempoText := StrReplace(TempoText, "s", "5")
        TempoText := StrReplace(TempoText, "B", "8")
        TempoText := StrReplace(TempoText, "b", "8")
        TempoText := StrReplace(TempoText, "Z", "2")
        TempoText := StrReplace(TempoText, "z", "2")
        TempoText := StrReplace(TempoText, "G", "6")
        TempoText := StrReplace(TempoText, "g", "6")
        Output := ""
        If RegExMatch(TempoText, "(\d{2,3})", &TempoMatch)
        If Not TempoMatch[1] = "440"
        Output .= TempoMatch[1] . " BPM "
        If RegExMatch(Result, "i)([A-G][#b]?\s*(?:Major|Minor))", &KeyMatch)
        Output .= KeyMatch[1] . " "
        If RegExMatch(Result, "i)(listening)", &StatusMatch)
        Output .= StatusMatch[1]
        Return Trim(Output)
    }
    
    Class AutoReport {
        Static Call() {
            Static PreviousValue := ""
            ParentClass := SubStr(This.Prototype.__Class, 1, InStr(This.Prototype.__Class, ".") - 1)
            CurrentValue := %ParentClass%.GetCentralDisplay()
            If Not CurrentValue = "" And Not CurrentValue = PreviousValue {
                PreviousValue := CurrentValue
                AccessibilityOverlay.Speak(CurrentValue)
            }
        }
    }
    
}
