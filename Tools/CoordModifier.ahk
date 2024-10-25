#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode 2
SetWorkingDir A_InitialWorkingDir

XOffset := 0
YOffset := 0

^+M::ModifyCoordinates()
^+X::SetXOffset()
^+Y::SetYOffset()

SetXOffset()
SetYOffset()

Return

ModifyCoordinates() {
    Global XOffset, YOffset
    ClipBoardBK := ClipboardAll()
    Send "^C"
    Sleep 50
    ClipBoardText := A_Clipboard
    If RegExMatch(ClipBoardText, "(\D*)([0-9]+)(\D*)([0-9]+)(\D*)", &Output) {
        Output1 := Output[1]
        Output2 := Output[2]
        Output2 := Output2 + XOffset
        Output3 := Output[3]
        Output4 := Output[4]
        Output4 := Output4 + YOffset
        Output5 := Output[5]
        ClipBoardText := ""
        Loop 5
        ClipBoardText .= Output%A_Index%
        Send "{Del]}"
        Sleep 50
        A_Clipboard := ClipBoardText
        Send "^V"
        Sleep 50
    }
    A_Clipboard := ClipboardBK
}

SetOffset(Type, Value) {
    Global XOffset, YOffset
    OffsetDialog := InputBox("Enter the Value.", "Set " . Type . " offset", "", Value)
    If OffsetDialog.Result == "OK"
    Try {
        If OffsetDialog.Value + 0 Is Integer {
            %Type%Offset := OffsetDialog.Value
        }
        Else {
            MsgBox "The offset must be an integer", "Error"
            SetOffset(Type, OffsetDialog.Value)
        }
    }
    Catch {
        MsgBox "The offset must be an integer", "Error"
        SetOffset(Type, OffsetDialog.Value)
    }
}

SetXOffset() {
    Global XOffset
    SetOffset("X", XOffset)
}

SetYOffset() {
    Global YOffset
    SetOffset("Y", YOffset)
}
