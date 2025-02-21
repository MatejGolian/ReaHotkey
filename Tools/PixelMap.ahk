#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 1
#SingleInstance Force
#Warn All
SendMode "Input"
SetTitleMatchMode 2
SetWorkingDir "../"
CoordMode "Caret", "Client"
CoordMode "Menu", "Client"
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"

AppName := "PixelMap"
CreationCanceled := False
Map1 := Map()
Map2 := Map()
X1Coordinate := 0
Y1Coordinate := 0
X2Coordinate := 0
Y2Coordinate := 0

Try
JAWS := ComObject("FreedomSci.JawsApi")
Catch
JAWS := False

Try
SAPI := ComObject("SAPI.SpVoice")
Catch
SAPI := False

#+Escape::CancelCreation()
#+F1::SetX1Coordinate()
#+F2::SetY1Coordinate()
#+F3::SetX2Coordinate()
#+F4::SetY2Coordinate()
#+F5::Create1()
#+F6::Create2()
#+F7::Copy1()
#+F8::Copy2()
#+F9::Compare()

A_IconTip := AppName
Speak(AppName . " ready")

CancelCreation() {
    Global CreationCanceled
    CreationCanceled := True
}

Compare() {
    Global Map1, Map2
    If Map1.Count = 0 Or Map2.Count = 0 Or Not Map1.Count = Map2.Count {
        Speak("Nothing to compare.")
        Return
    }
    Speak("Comparing maps, please wait...")
    CompResults := False
    For Key, Value In Map1
    If Not Map1[Key] = Map2[Key] {
        If Not CompResults
        CompResults := "Coordinate:`tMap 1:`tMap 2:`n"
        CompResults .= Key . "`t" . Map1[Key] . "`t" . Map2[Key] . "`n"
    }
    If Not CompResults {
        Speak("Maps are identical.")
    }
    Else {
        A_Clipboard := Sort(CompResults, "CLogical")
        Speak("Comparison results copied to clipboard.")
    }
}

Copy(MapNumber) {
    Global Map1, Map2
    If Map%MapNumber%.Count = 0 {
        Speak("Nothing to copy.")
        Return
    }
    Speak("Copying map " . MapNumber . ", please wait...")
    CopyResult := "Coordinate:`tColor:`n"
    For Key, Value In Map%MapNumber%
    CopyResult .= Key . "`t" . Map%MapNumber%[Key] . "`n"
    A_Clipboard := Sort(CopyResult, "CLogical")
    Speak("Map " . MapNumber . " copied to clipboard.")
}

Copy1() {
    Copy(1)
}

Copy2() {
    Copy(2)
}

Create(MapNumber) {
    Global CreationCanceled, Map1, Map2, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate
    WinWidth := ""
    WinHeight := ""
    Try {
        WinGetPos ,, &WinWidth, &WinHeight, "A"
    }
    Catch {
        WinWidth := A_ScreenWidth
        WinHeight := A_ScreenHeight
    }
    If Not X1Coordinate
    X1Coordinate := 0
    If Not Y1Coordinate
    Y1Coordinate := 0
    If Not X2Coordinate
    X2Coordinate := WinWidth
    If Not Y2Coordinate
    Y2Coordinate := WinHeight
    MapBackup := Map%MapNumber%.Clone()
    Map%MapNumber% := Map()
    CurrentRow := 1
    RowCount := Y2Coordinate - Y1Coordinate
    Loop WinHeight + 1 {
        If CreationCanceled {
            ReportCancellation()
            Break
        }
        If A_Index = 1
        Speak("Creating map " . MapNumber . ", please wait...")
        CurrentY := A_Index - 1
        If CurrentY < Y1Coordinate
        Continue
        If CurrentY > Y2Coordinate
        Continue
        If CurrentRow <= RowCount
        Speak("Creating map " . MapNumber . " (row " . CurrentRow . " of " . RowCount . "), please wait...")
        CurrentRow++
        Loop WinWidth + 1 {
            If CreationCanceled {
                ReportCancellation()
                Break 2
            }
            CurrentX := A_Index - 1
            If CurrentX < X1Coordinate
            Continue
            If CurrentX > X2Coordinate
            Break
            Map%MapNumber%.Set("X " CurrentX . ", Y " . CurrentY, PixelGetColor(CurrentX, CurrentY, "Slow"))
        }
    }
    If Not CreationCanceled
    Speak("Map " . MapNumber . " created.")
    Else
    Map%MapNumber% := MapBackup
    CreationCanceled := False
    ReportCancellation() {
        Speak("Map creation cancelled.")
    }
}

Create1() {
    Create(1)
}

Create2() {
    Create(2)
}

SetCoordinate(Type, Value) {
    Global X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate
    CoordinateDialog := InputBox("Enter the Value.", "Set " . Type . " coordinate", "", Value)
    If CoordinateDialog.Result == "OK"
    Try {
        If CoordinateDialog.Value + 0 Is Integer {
            %Type%Coordinate := CoordinateDialog.Value
        }
        Else {
            MsgBox "The value must be an integer", "Error"
            SetCoordinate(Type, CoordinateDialog.Value)
        }
    }
    Catch {
        MsgBox "The value must be an integer", "Error"
        SetCoordinate(Type, CoordinateDialog.Value)
    }
}

SetX1Coordinate() {
    Global X1Coordinate
    SetCoordinate("X1", X1Coordinate)
}

SetY1Coordinate() {
    Global Y1Coordinate
    SetCoordinate("Y1", Y1Coordinate)
}

SetX2Coordinate() {
    Global X2Coordinate
    SetCoordinate("X2", X2Coordinate)
}

SetY2Coordinate() {
    Global Y2Coordinate
    SetCoordinate("Y2", Y2Coordinate)
}

Speak(Message) {
    Global JAWS, SAPI
    If (Not JAWS = False And ProcessExist("jfw.exe")) Or (FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And Not DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning")) {
        If Not JAWS = False And ProcessExist("jfw.exe") {
            JAWS.SayString(Message)
        }
        If FileExist("NvdaControllerClient" . A_PtrSize * 8 . ".dll") And Not DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_testIfRunning") {
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_cancelSpeech")
            DllCall("NvdaControllerClient" . A_PtrSize * 8 . ".dll\nvdaController_speakText", "Wstr", Message)
        }
    }
    Else {
        If Not SAPI = False {
            SAPI.Speak("", 0x1|0x2)
            SAPI.Speak(Message, 0x1)
        }
    }
}
