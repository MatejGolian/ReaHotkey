#Requires AutoHotkey v2.0

Directory := "Images"
Mode := "Horizontal"

#SingleInstance Force

If Mode == "Horizontal" {
    Label1 := "Row"
    Label2 := "Column"
}
Else {
    Label1 := "Column"
    Label2 := "Row"
}

#Include Functions.ahk
#Include ImageGrid.ahk

#^+F3:: {
    PNGList := ListPNGs(Directory)
    If PNGList.Length == 0 {
        MsgBox "There are no images in the " . Directory . " Directory.", "Information"
        Return
    }
    Grid := ImageGrid(PNGList, Mode)
    If Grid.ColumnCount == 0 {
        MsgBox "None of the images in the " . Directory . " directory have been found on the screen", "Information"
        Return
    }
    MsgBox "The grid has " . Grid.ColumnCount . " columns and " . Grid.RowCount . " rows.", "Information"
    For RecordNumber, Record In Grid
    For CellName, Cell In Record
    MsgBox Label1 . " " . RecordNumber . ", " . Label2 . " " . CellName . "`nFile: " . Cell.File . "`nCoordinates: X " . Cell.X . ", Y " . Cell.Y, "Information"
}

MsgBox "Press Win+Ctrl+Shift+F3 to scan the active window for images in the " . Directory . " directory.", "Information"
