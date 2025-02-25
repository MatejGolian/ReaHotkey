#Requires AutoHotkey v2.0

Class Tesseract {
    
    Static language := ""
    Static LeptonicaExe := A_WorkingDir . "\Leptonica_Util\leptonica_util.exe"
    Static OCRResult := ""
    Static OCRTextFile := A_Temp . "\TesseractResult.txt"
    Static ProcessedImage := A_Temp . "\TesseractProcessed.tif"
    Static ScreenshotImage := A_Temp . "\TesseractScreenshot.bmp"
    Static TesseractExe := A_WorkingDir . "\Tesseract\tesseract.exe"
    Static TessDataBest := A_WorkingDir . "\Tesseract\tessdata_best"
    Static TessDataFast := A_WorkingDir . "\Tesseract\tessdata_fast"
    
    Static __Call(X, Y, W, H, Language := "", ScaleFactor := "", Fast := 1) {
        Return This.OCR(X, Y, W, H, Language, ScaleFactor, Fast)
    }
    
    Static Cleanup(ScreenshotImage, ProcessedImage, OCRTextFile) {
        FileDelete ScreenshotImage
        FileDelete ProcessedImage
        FileDelete OCRTextFile
    }
    
    Static Convert(Input := "", Output := "", Fast := 1) {
        Input := (Input) ? Input : This.ProcessedImage
        Output := (Output) ? Output : This.OCRTextFile
        Fast := (Fast) ? This.TessDataFast : This.TessDataBest
        If Not FileExist(Input)
        Return
        If Not FileExist(This.TesseractExe)
        Return
        Static Quote := Chr(0x22)
        Command := Quote . This.TesseractExe . Quote . " --tessdata-dir " . Quote . Fast . Quote . " " . Quote . Input . Quote . " " . Quote . SubStr(Output, 1, -4) . Quote
        Command .= (This.Language) ? " -l " . Quote . This.Language . Quote : ""
        Command := A_ComSpec . " /C " . Quote . Command . Quote
        RunWait Command,, "Hide"
        If Not FileExist(Output)
        Return
        Return Output
    }
    
    Static ConvertBest(Input :="", Output := "") {
        Return This.Convert(Input, Output, 0)
    }
    
    Static ConvertFast(Input := "", Output := "") {
        Return This.Convert(Input, Output, 1)
    }
    
    Static FromRect(X, Y, W, H, Language := "", ScaleFactor := "", Fast := 1) {
        Return This.OCR(X, Y, W, H, Language, ScaleFactor, Fast)
    }
    
    Static GetResult(Input := "") {
        Input := (Input != "") ? Input : This.OCRTextFile
        If Not FileExist(Input)
        Return
        Output := FileRead(Input)
        Output := StrReplace(Output, "`n", " ")
        Output := StrReplace(Output, Chr(0xc), "")
        Output := Trim(Output)
        Return Output
    }
    
    Static OCR(X, Y, W, H, Language := "", ScaleFactor := "", Fast := 1) {
        Fast := (Fast) ? 1 : 0
        ID := A_TickCount
        This.Language := Language
        ScreenshotImage := This.UniqueName(This.ScreenshotImage, ID)
        ProcessedImage := This.UniqueName(This.ProcessedImage, ID)
        OCRTextFile := This.UniqueName(This.OCRTextFile, ID)
        Screenshot := ImagePutFile({Image: [X, Y, W, H]}, ScreenshotImage)
        This.Preprocess(Screenshot, ProcessedImage, ScaleFactor)
        If Fast
        This.ConvertFast(ProcessedImage, OCRTextFile)
        Else
        This.ConvertBest(ProcessedImage, OCRTextFile)
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
