#Requires AutoHotkey v2.0

Class Tesseract {
    
    Static LeptonicaExe := A_WorkingDir . "\Leptonica\leptonica_util.exe"
    Static language := ""
    Static OCRResult := ""
    Static OCRTextFile := A_Temp . "\TesseractResult.txt"
    Static ProcessedImage := A_Temp . "\TesseractProcessed.tif"
    Static ScreenshotImage := A_Temp . "\TesseractScreenshot.bmp"
    Static TesseractExe32 := A_WorkingDir . "\Tesseract32\tesseract.exe"
    Static TesseractExe64 := A_WorkingDir . "\Tesseract64\tesseract.exe"
    Static TessData32 := A_WorkingDir . "\Tesseract32\tessdata"
    Static TessData64 := A_WorkingDir . "\Tesseract64\tessdata"
    
    Static __Call(X, Y, W, H, Language := "", ScaleFactor := "") {
        Return This.OCR(X, Y, W, H, Language, ScaleFactor)
    }
    
    Static Cleanup(ScreenshotImage, ProcessedImage, OCRTextFile) {
        If FileExist(ScreenshotImage)
        FileDelete ScreenshotImage
        If FileExist(ProcessedImage)
        FileDelete ProcessedImage
        If FileExist(OCRTextFile)
        FileDelete OCRTextFile
    }
    
    Static Convert(Input := "", Output := "") {
        Input := (Input) ? Input : This.ProcessedImage
        Output := (Output) ? Output : This.OCRTextFile
        If Not FileExist(Input)
        Return
        TesseractExe := "TesseractExe" . A_PtrSize * 8
        TesseractExe := This.%TesseractExe%
        TessData := "TessData" . A_PtrSize * 8
        TessData := This.%TessData%
        If Not FileExist(TesseractExe)
        Return
        Static Quote := Chr(0x22)
        Command := Quote . TesseractExe . Quote . " --tessdata-dir " . Quote . TessData . Quote . " " . Quote . Input . Quote . " " . Quote . SubStr(Output, 1, -4) . Quote
        Command .= (This.Language) ? " -l " . Quote . This.Language . Quote : ""
        Command := A_ComSpec . " /C " . Quote . Command . Quote
        RunWait Command,, "Hide"
        If Not FileExist(Output)
        Return
        Return Output
    }
    
    Static FromRect(X, Y, W, H, Language := "", ScaleFactor := "") {
        Return This.OCR(X, Y, W, H, Language, ScaleFactor)
    }
    
    Static GetResult(Input := "") {
        Input := (Input != "") ? Input : This.OCRTextFile
        If Not FileExist(Input)
        Return
        Output := FileRead(Input)
        Output := StrReplace(Output, "`n", " ")
        Output := StrReplace(Output, Chr(0x7c), "")
        Output := StrReplace(Output, Chr(0xc), "")
        Output := Trim(Output)
        Return Output
    }
    
    Static OCR(X, Y, W, H, Language := "", ScaleFactor := "") {
        ID := A_TickCount
        This.Language := Language
        ScreenshotImage := This.UniqueName(This.ScreenshotImage, ID)
        ProcessedImage := This.UniqueName(This.ProcessedImage, ID)
        OCRTextFile := This.UniqueName(This.OCRTextFile, ID)
        ScreenshotImage := ImagePutFile({Image: [X, Y, W, H]}, ScreenshotImage)
        This.Preprocess(ScreenshotImage, ProcessedImage, ScaleFactor)
        This.Convert(ProcessedImage, OCRTextFile)
        This.OCRResult := This.GetResult(OCRTextFile)
        This.Cleanup(ScreenshotImage, ProcessedImage, OCRTextFile)
        Return This.OCRResult
    }
    
    Static Preprocess(Input := "", Output := "", ScaleFactor := "") {
        Static OCRPreProcessing := 1
        Static NegateArg := 2
        Static PerformScaleArg := 1
        Input := (Input != "") ? Input : This.ScreenshotImage
        Output := (Output != "") ? Output : This.ProcessedImage
        ScaleFactor := (ScaleFactor != "") ? ScaleFactor : 3.5
        If Not FileExist(Input)
        Return
        If Not FileExist(This.LeptonicaExe)
        Return
        Static Quote := Chr(0x22)
        Command := Quote . This.LeptonicaExe . Quote . " " . Quote . Input . Quote . " " . Quote . Output . Quote
        Command .= " " . NegateArg . " 0.5 " . PerformScaleArg . " " . ScaleFactor . " " . OCRPreProcessing . " 5 2.5 " . OCRPreProcessing . " 2000 2000 0 0 0.0"
        Command := A_ComSpec . " /C " . Quote . Command . Quote
        RunWait Command,, "Hide"
        If Not FileExist(Output)
        Return
        Return Output
    }
    
    Static UniqueName(Name, ID) {
        SplitPath Name,, &Dir, &Ext, &NameNoExt
        Name := Dir . "\" . NameNoExt . ID . "." . Ext
        Return Name
    }
    
}
