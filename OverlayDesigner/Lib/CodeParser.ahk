#Requires AutoHotkey v2.0

Class CodeParser {
    
    Segments := Array()
    SkipSequences := Array(
    "```"",
    )
    Tags := Map(
    "`"", "`"",
    "(", ")",
    "[", "]",
    "{", "}",
    )
    
    InArray(Needle, Haystack, CaseSensitive := False) {
        For FoundIndex, FoundValue In Haystack
        If CaseSensitive {
            If FoundValue == Needle
            Return FoundIndex
        }
        Else {
            If FoundValue = Needle
            Return FoundIndex
        }
        Return False
    }
    
    IsNumberOrOperator(Value) {
        If Value Is Number Or This.IsOperator(Value)
        Return True
        If This.IsOperator(SubStr(Value, 1, 1)) And StrLen(Value) > 1 {
            Try
            NumberTest := SubStr(Value, 2) + 0
            Catch
            NumberTest := ""
            If NumberTest Is Number
            Return True
        }
        Return False
    }
    
    IsOperator(Value) {
        Operators := ["+", "-", "*", "/"]
        Return This.InArray(Value, Operators)
    }
    
    ParseSegment(Segment) {
        Segment := Trim(Segment)
        SegmentIsNumber := False
        If Not Segment = "" And Not SubStr(Segment, 1, 1) = "`"" And Not SubStr(Segment, -1) = "`"" {
            Try
            NumberTest := Segment + 0
            Catch
            NumberTest := ""
            If NumberTest Is Number
            SegmentIsNumber := True
        }
        If SubStr(Segment, 1, 1) = "[" And SubStr(Segment, -1) = "]"
        Return This.ProcessArray(Segment)
        If SubStr(Segment, 1, 6) = "Array(" And SubStr(Segment, -1) = ")"
        Return This.ProcessArray(Segment)
        If RegExMatch(Segment, "^([A-Za-z_][0-9A-Za-z_]+)\s*:=\s*(.*)", &Match)
        Return This.ProcessAssignment(Match)
        If RegExMatch(Segment, "^(\s*;.*)", &Match)
        Return This.ProcessComment(Match)
        If RegExMatch(Segment, "^([A-Za-z_][0-9A-Za-z_]+)\((.*)\)$", &Match)
        Return This.ProcessFunc(Match)
        If RegExMatch(Segment, "^([A-Za-z_][0-9A-Za-z_]+)\.([A-Za-z_][0-9A-Za-z_]+)$", &Match)
        Return This.ProcessParamInvocation(Match)
        If RegExMatch(Segment, "^([A-Za-z_][0-9A-Za-z_]+)\.([A-Za-z_][0-9A-Za-z_]+.*)", &Match)
        Return This.ProcessMethodInvocation(Match)
        If SubStr(Segment, 1, 1) = "{" And SubStr(Segment, -1) = "}"
        Return This.ProcessObject(Segment)
        If SubStr(Segment, 1, 7) = "Object(" And SubStr(Segment, -1) = ")"
        Return This.ProcessObject(Segment)
        If This.IsOperator(Segment)
        Return This.ProcessOperator(Segment)
        If RegExMatch(Segment, "^([A-Za-z_][0-9A-Za-z_]+)$", &Match)
        Return This.ProcessVar(Match)
        If SegmentIsNumber
        Return This.ProcessNumber(Segment)
        Return This.ProcessString(Segment)
    }
    
    ProcessArray(Match) {
        ReturnArray := Array()
        If SubStr(Match, 1, 1) = "["
        StartPos := 2
        Else
        StartPos := 7
        If Trim(SubStr(Match, StartPos, -1)) = ""
        Return ReturnArray
        InnerItems := This.Split(Trim(SubStr(Match, StartPos, -1)), ",")
        For InnerItem In InnerItems
        ReturnArray.Push(This.ParseSegment(Trim(InnerItem)))
        Return ReturnArray
    }
    
    ProcessAssignment(Match) {
        Global
        Local Param1, Param2
        Param1 := Trim(Match[1])
        Param2 := Trim(Match[2])
        Param2 := This.ParseSegment(Param2)
        %Param1% := Param2
        Return Param2
    }
    
    ProcessComment(Match) {
        Return Match[0]
    }
    
    ProcessExpression(Code) {
        If InStr(Code, ";")
        Code := SubStr(Code, 1, InStr(Code, ";") - 1)
        Items := Array()
        Segments := Array()
        Code := This.Split(Code, " ")
        For Segment In Code {
            If Segment Is String
            Segment := Trim(Segment)
            If Not Segment = ""
            If Not Segment = "."
            Items.Push(This.ParseSegment(Segment))
        }
        For Segment In Items {
            If Segment Is Func Or Segment Is BoundFunc
            Segment := Segment.Call()
            Try
            Segment := Segment + 0
            Catch
            Segment := Segment
            If Segment Is String
            Segment := Trim(Segment)
            If Not Segment = ""
            Segments.Push(Segment)
        }
        Expression := ""
        Skip := 0
        For SegmentIndex, Segment In Segments {
            If Skip > 0 {
                Skip -= 1
                Continue
            }
            If This.IsNumberOrOperator(Segment) {
                If SegmentIndex = Segments.Length {
                    Expression .= Segment
                    Break
                }
                NextSegment := Segments[SegmentIndex + 1]
                If This.IsOperator(NextSegment) And Segments.Length = SegmentIndex + 1 {
                    Expression .= Segment . NextSegment
                    Break
                }
                SegmentBuffer := Array()
                TempBuffer := Array()
                For Value In Segments
                If A_Index >= SegmentIndex {
                    If This.IsNumberOrOperator(Value)
                    TempBuffer.Push(Value)
                }
                LoopCount := TempBuffer.Length
                Loop TempBuffer.Length {
                    If TempBuffer.Length > 0
                    If This.IsOperator(TempBuffer[TempBuffer.Length])
                    TempBuffer.Pop()
                }
                Skip := TempBuffer.Length - 1
                Loop TempBuffer.Length
                If TempBuffer[A_Index] Is Number And Not This.IsOperator(SubStr(TempBuffer[A_Index], 1, 1)) {
                    SegmentBuffer.Push("+" . TempBuffer[A_Index])
                }
                Else If This.IsOperator(TempBuffer[A_Index]) {
                    If TempBuffer[A_Index + 1] Is Number And Not This.IsOperator(SubStr(TempBuffer[A_Index + 1], 1, 1)) {
                        SegmentBuffer.Push(TempBuffer[A_Index] . TempBuffer[A_Index + 1])
                    }
                    Else {
                        SegmentBuffer.Push(TempBuffer[A_Index + 1])
                    }
                    A_Index := A_Index + 1
                }
                Else {
                    SegmentBuffer.Push(TempBuffer[A_Index])
                }
                If SegmentBuffer.Length = 0
                Result := Segment
                Else
                Result := 0
                For Item In SegmentBuffer {
                    Operator := SubStr(Item, 1, 1)
                    NumberValue := SubStr(Item, 2)
                    If Operator = "+"
                    Result := Result + NumberValue
                    Else If Operator = "-"
                    Result := Result - NumberValue
                    Else If Operator = "*"
                    Result := Result * NumberValue
                    Else If Operator = "/"
                    Result := Result / NumberValue
                }
                Expression .= Result
            }
            Else If Segment Is String {
                Expression .= Segment
            }
        }
        Return Expression
    }
    
    ProcessFunc(Match) {
        Name := Trim(Match[1])
        Params := Trim(Match[2])
        SplitParams := This.Split(Params, ",")
        FuncParams := Array()
        If Not Params = ""
        For Key, Value In SplitParams {
            Value := This.ParseSegment(Trim(Value))
            FuncParams.Push(Value)
        }
        FuncObj := False
        If FuncParams.Length > 0
        Return ObjBindMethod(%Name%,, FuncParams*)
        Else
        Return %Name%
    }
    
    ProcessMethodInvocation(Match) {
        Param1 := Trim(Match[1])
        Param2 := Trim(Match[2])
        RegExMatch(Param2, "^([A-Za-z_][0-9A-Za-z_]+)\((.*)\)$", &Match)
        MethodName := Match[1]
        MethodParams := Match[2]
        MethodParams := This.Split(MethodParams, ",")
        For MethodParam In MethodParams
        MethodParams[A_Index] := This.ParseSegment(MethodParam)
        Return ObjBindMethod(%Param1%, MethodName, MethodParams*)
    }
    
    ProcessNumber(Segment) {
        Return Segment + 0
    }
    
    ProcessObject(Match) {
        ReturnObject := Object()
        If SubStr(Match, 1, 7) = "Object("
        Return ReturnObject
        If SubStr(Match, 1, 1) = "{"
        StartPos := 2
        Else
        StartPos := 8
        If Trim(SubStr(Match, StartPos, -1)) = ""
        Return ReturnObject
        InnerItems := This.Split(Trim(SubStr(Match, StartPos, -1)), ",")
        For InnerItem In InnerItems {
            InnerItem := This.Split(InnerItem, ":")
            If InnerItem Is Array And InnerItem.Length = 2
            ReturnObject.%Trim(InnerItem[1])% := This.ParseSegment(InnerItem[2])
        }
        Return ReturnObject
    }
    
    ProcessOperator(Segment) {
        Return Segment
    }
    
    ProcessParamInvocation(Match) {
        Global
        Local Param1, Param2
        Param1 := Trim(Match[1])
        Param2 := Trim(Match[2])
        Return %Param1%.%Param2%
    }
    
    ProcessString(Match) {
        If SubStr(Match, 1, 1) = "`""
        Match := SubStr(Match, 2)
        If SubStr(Match, -1) = "`""
        Match := SubStr(Match, 1, -1)
        Return Match
    }
    
    ProcessVar(Match) {
        Global
        Local Name
        Name := Trim(Match[1])
        Try
        Return %Name% + 0
        Catch
        Return %Name%
    }
    
    Split(Segment, Subpattern) {
        If Not InStr(Segment, Subpattern)
        Return Array(Segment)
        CurrentSegment := Segment
        ExpectedClosures := Array()
        Pointer := 1
        Subpatterns := Array()
        SubpatternLength := StrLen(Subpattern)
        While Pointer <= StrLen(CurrentSegment) {
            If SubStr(CurrentSegment, Pointer, SubpatternLength) = Subpattern And ExpectedClosures.Length = 0 {
                Subpatterns.Push(SubStr(CurrentSegment, 1, Pointer - 1))
                CurrentSegment := SubStr(CurrentSegment, Pointer + SubpatternLength)
                Pointer := 1
                Continue
            }
            If Pointer = StrLen(CurrentSegment) {
                Subpatterns.Push(CurrentSegment)
                Break
            }
            For Sequence In This.SkipSequences
            If SubStr(CurrentSegment, Pointer, StrLen(Sequence)) = Sequence {
                Pointer := Pointer + StrLen(Sequence)
                Continue 2
            }
            For TagOpening, TagClosure In This.Tags {
                If ExpectedClosures.Length > 0 And ExpectedClosures[1] = "`""
                Break
                If SubStr(CurrentSegment, Pointer, StrLen(TagOpening)) = TagOpening {
                    ExpectedClosures.InsertAt(1, TagClosure)
                    Pointer := Pointer + StrLen(TagOpening)
                    Continue 2
                }
            }
            For TagOpening, TagClosure In This.Tags
            If SubStr(CurrentSegment, Pointer, StrLen(TagClosure)) = TagClosure And ExpectedClosures.Length > 0 And ExpectedClosures[1] = TagClosure {
                ExpectedClosures.RemoveAt(1)
                Pointer := Pointer + StrLen(TagClosure)
                Continue 2
            }
            Pointer++
        }
        Return Subpatterns
    }
    
}
