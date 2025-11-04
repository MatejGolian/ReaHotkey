#Requires AutoHotkey v2.0

CreateGUI(ImageList, LoopX := 1, LoopY := 1) {
    If ImageList.Length = 0
    Return False
    If LoopX < 1
    LoopX := 1
    If LoopY < 1
    LoopY := 1
    ImageGUI := Gui(, "Grid Test")
    Loop LoopY {
        RowNumber := A_Index
        Loop LoopX {
            LoopNumber := A_Index
            For ImageNumber, Image In ImageList {
                Positioning := ""
                If RowNumber == 1 And LoopNumber == 1 And ImageNumber == 1
                Positioning := ""
                Else If LoopNumber == 1 And ImageNumber == 1
                Positioning := "Section XS"
                Else
                Positioning := "YS"
                ImageGUI.AddPicture(Positioning, Image)
            }
        }
    }
    ImageGUI.OnEvent("Close", CloseGUI)
    Return ImageGUI
    CloseGUI(*) {
        ExitApp
    }
}

FindImage(ImageFile, X1Coordinate := 0, Y1Coordinate := 0, X2Coordinate := 0, Y2Coordinate := 0) {
    FoundX := ""
    FoundY := ""
    WinWidth := GetWinWidth()
    WinHeight := GetWinHeight()
    If WinWidth = 0
    WinWidth := A_ScreenWidth
    If WinHeight = 0
    WinHeight := A_ScreenHeight
    If Not X1Coordinate Is Number Or X1Coordinate < 0
    X1Coordinate := 0
    If Not Y1Coordinate Is Number Or Y1Coordinate < 0
    Y1Coordinate := 0
    If Not X2Coordinate Is Number Or X2Coordinate <= 0
    X2Coordinate := WinWidth
    If Not Y2Coordinate Is Number Or Y2Coordinate <= 0
    Y2Coordinate := WinHeight
    If FileExist(ImageFile) {
        Try
        ImageFound := ImageSearch(&FoundX, &FoundY, X1Coordinate, Y1Coordinate, X2Coordinate, Y2Coordinate, ImageFile)
        Catch
        ImageFound := 0
        If ImageFound = 1
        Return {X: FoundX, Y: FoundY}
    }
    Return False
}

GetWinPos() {
    WinX := 0
    WinY := 0
    WinW := 0
    WinH := 0
    Try {
        WinGetPos &WinX, &WinY, &WinW, &WinH, "A"
    }
    Catch {
        WinX := 0
        WinY := 0
        WinW := 0
        WinH := 0
    }
    Return {X: WinX, Y: WinY, W: WinW, H: WinH}
}

GetWinHeight() {
    Return GetWinPos().H
}

GetWinWidth() {
    Return GetWinPos().W
}

InArray(Needle, Haystack) {
    For FoundIndex, FoundValue In Haystack
    If FoundValue == Needle
    Return FoundIndex
    Return False
}

ListPNGs(Directory) {
    List := []
    Loop Files, Directory . "\*.png"
    List.Push(A_LoopFilePath)
    Return List
}

ValueTransformationFunction(Value) {
    Value.File := "`"" . Value.File . "`""
    Return Value
    }
