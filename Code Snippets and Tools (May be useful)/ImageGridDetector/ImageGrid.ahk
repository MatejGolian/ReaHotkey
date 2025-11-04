#Requires AutoHotkey v2.0

Class ImageGrid {
    
    Cellnames := Array()
    ColumnCount := 0
    Count := 0
    DefaultMode := "Horizontal"
    ImageList := Array()
    Length := 0
    Mode := ""
    RawRecords := Array()
    RowCount := 0
    X1 := 0
    X2 := 0
    Y1 := 0
    Y2 := 0
    
    __New(ImageList, Mode := "Horizontal", X1 := 0, Y1 := 0, X2 := 0, Y2 := 0) {
        ImageGrid := Array()
        If Not ImageList Is Array
        ImageList := Array(ImageList)
        This.ImageList := ImageList
        This.Mode := Mode
        This.X1 := X1
        This.Y1 := Y1
        This.X2 := X2
        This.Y2 := Y2
        This.RawRecords := This.GetRawRecords()
        This.RowCount := This.GetRowCount()
        This.ColumnCount := This.GetColumnCount()
        This.Count := This.RawRecords.Length
        This.Length := This.RawRecords.Length
        This.SetCellNames()
        This.__Item := This.Records
    }
    
    __Enum(NumberOfVars) {
        OneParameterEnumerator(&Out) {
            Static IterationNumber := 0
            Records := This.Records
            RecordCount := Records.Length
            If RecordCount > 0
            While IterationNumber < RecordCount {
                IterationNumber++
                Out := Records[IterationNumber]
                Return True
            }
            IterationNumber := 0
            Return False
        }
        TwoParameterEnumerator(&Out1, &Out2) {
            Static IterationNumber := 0
            Records := This.Records
            RecordCount := Records.Length
            If RecordCount > 0
            While IterationNumber < RecordCount {
                IterationNumber++
                Out1 := IterationNumber
                Out2 := Records[IterationNumber]
                Return True
            }
            IterationNumber := 0
            Return False
        }
        Return (NumberOfVars = 1 ? OneParameterEnumerator : TwoParameterEnumerator)
    }
    
    __Get(Name, Params) {
        Try
        If Params.Length == 0
        Return This.Get%Name%()
        Else
        Return This.Get%Name%(Params*)
        Catch As ErrorMessage
        Throw ErrorMessage
    }
    
    GetColumnCount() {
        ColumnCount := 0
        If This.RawRecords.Length > 0 {
            If This.Mode = "Horizontal"
            ColumnCount := This.RawRecords[1].Length
            Else
            ColumnCount := This.RawRecords.Length
        }
        Return ColumnCount
    }
    
    GetDataRecords() {
        ImageList := This.ImageList
        Mode := This.Mode
        X1 := This.X1
        Y1 := This.Y1
        X2 := This.X2
        Y2 := This.Y2
        Records := Array()
        WinWidth := GetWinWidth()
        WinHeight := GetWinHeight()
        If ImageList.Length == 0
        Return Records
        If WinWidth == 0 Or WinHeight == 0
        Return Records
        If Not X1 Is Number Or X1 < 0
        X1 := 0
        If Not Y1 Is Number Or Y1 < 0
        Y1 := 0
        If Not X2 Is Number Or X2 <= 0
        X2 := WinWidth
        If Not Y2 Is Number Or Y2 <= 0
        Y2 := WinHeight
        If Not Mode = "Horizontal" And Not Mode = "Vertical"
        Mode := This.DefaultMode
        RecordData := ""
        For Image In ImageList {
            Y := Y1
            Loop {
                X := X1
                LastFoundY := 0
                While Result := FindImage(Image, X, Y, X2, Y2) {
                    If Mode = "Horizontal"
                    RecordData .= Result.Y . "`t" . Result.X . "`t" . Image . "`n"
                    Else
                    RecordData .= Result.X . "`t" . Result.Y . "`t" . Image . "`n"
                    FoundX := Result.X
                    FoundY := Result.Y
                    If LastFoundY == 0 Or LastFoundY == FoundY {
                        X := FoundX + 1
                        LastFoundY := FoundY
                    }
                    Else {
                        Break
                    }
                }
                Y := LastFoundY + 1
            }
            Until X == X1 And Not Result
        }
        RecordData := Trim(RecordData)
        RecordData := Sort(RecordData, "CLogical")
        If Mode = "Horizontal" {
            XKey := 2
            YKey := 1
            FileKey := 3
        }
        Else {
            XKey := 1
            YKey := 2
            FileKey := 3
        }
        LastSortingValue := ""
        Loop parse, RecordData, "`n" {
            ParsedEntry := StrSplit(A_LoopField, "`t")
            If Not ParsedEntry.Length = 3
            Continue
            SortingValue := ParsedEntry[1]
            XCoordinate := ParsedEntry[XKey]
            YCoordinate := ParsedEntry[YKey]
            ImageFile := ParsedEntry[FileKey]
            If Not SortingValue == LastSortingValue {
                LastSortingValue := SortingValue
                Records.Push(Array())
            }
            Records[Records.Length].Push({X: XCoordinate, Y: YCoordinate, File: ImageFile})
        }
        Return Records
    }
    
    GetNamedRecords() {
        Records := Array()
        For Record In This.RawRecords {
            Records.Push(Map())
            For CellNumber, Cell In Record
            Records[Records.Length].Set(This.CellNames[CellNumber], Cell.Value)
        }
        Return Records
    }
    
    GetNumberedRecords() {
        Records := Array()
        For Record In This.RawRecords {
            Records.Push(Array())
            For CellNumber, Cell In Record
            Records[Records.Length].Push(Cell.Value)
        }
        Return Records
    }
    
    GetRawRecords() {
        Mode := This.Mode
        Records := Array()
        DataRecords := This.DataRecords
        If DataRecords.Length == 0
        Return Records
        If Not Mode = "Horizontal" And Not Mode = "Vertical"
        Mode := This.DefaultMode
        If Mode = "Horizontal" {
            Prop := "X"
        }
        Else {
            Prop := "Y"
        }
        UniqueProps := Array()
        For DataRecord In DataRecords
        For Image In DataRecord
        If Not InArray(Image.%Prop%, UniqueProps)
        UniqueProps.Push(Image.%Prop%)
        LastRecordNumber := 0
        For RecordNumber, DataRecord In DataRecords
        For UniqueNumber, UniqueProp In UniqueProps {
            If Not RecordNumber == LastRecordNumber {
                LastRecordNumber := RecordNumber
                Records.Push(Array())
            }
            Records[Records.Length].Push({Name: "", Value: {X: "", Y: "", File: ""}})
        }
        For RecordNumber, DataRecord In DataRecords
        For UniqueNumber, UniqueProp In UniqueProps {
            For Image In DataRecord
            If UniqueProp == Image.%Prop% {
                Records[RecordNumber][UniqueNumber] := {Name: "", Value: Image}
                Break
            }
        }
        Return Records
    }
    
    GetRecords() {
        Return This.NamedRecords
    }
    
    GetRowCount() {
        RowCount := 0
        If This.RawRecords.Length > 0 {
            If This.Mode = "Horizontal"
            RowCount := This.RawRecords.Length
            Else
            RowCount := This.RawRecords[1].Length
        }
        Return RowCount
    }
    
    SetCellNames(NewCellNames*) {
        OldCellNames := This.CellNames
        TempCellNames := Array()
        Loop This.ColumnCount
        TempCellNames.Push(A_Index)
        For Key, Value In OldCellnames
        If TempCellNames.Has(Key)
        TempCellNames[Key] := Value
        Else
        Break
        For Key, Value In NewCellnames
        If TempCellNames.Has(Key)
        TempCellNames[Key] := Value
        Else
        Break
        NewCellNames := TempCellNames
        This.CellNames := NewCellNames
        If NewCellNames.Length > 0
        For RecordNumber, Record In This.RawRecords
        For CellNumber, Cell In Record
        Cell.Name := NewCellNames[CellNumber]
        This.__Item := This.Records
    }
    
    TransformCellValues(TransformationFunction) {
        For RecordNumber, Record In This.RawRecords
        For Cell In Record
        Cell.Value := TransformationFunction(Cell.Value)
        This.__Item := This.Records
    }
    
}
