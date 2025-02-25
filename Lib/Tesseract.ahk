#Requires AutoHotkey v2.0

Class Tesseract {
    
    Static language := ""
    Static LeptonicaExe := A_WorkingDir . "\Leptonica_Util\leptonica_util.exe"
    Static OCRResult := ""
    Static OCRTextFile := A_Temp . "\TesseractResult.txt"
    Static OriginalImage := A_Temp . "\TesseractOriginal.bmp"
    Static ProcessedImage := A_Temp . "\TesseractProcessed.tif"
    Static TesseractExe := A_WorkingDir . "\Tesseract\tesseract.exe"
    Static TessDataBest := A_WorkingDir . "\Tesseract\tessdata_best"
    Static TessDataFast := A_WorkingDir . "\Tesseract\tessdata_fast"
    
    Static __Call(X, Y, W, H, Language := "", ScaleFactor := "", Fast := 1) {
        Return This.OCR(X, Y, W, H, Language, ScaleFactor, Fast)
    }
    
    Static Cleanup() {
        FileDelete This.OriginalImage
        FileDelete This.ProcessedImage
        FileDelete This.OCRTextFile
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
        This.Language := Language
        Screenshot := ImagePutFile({Image: [X, Y, W, H, "A"]}, This.OriginalImage)
        This.Preprocess(Screenshot, This.ProcessedImage, ScaleFactor)
        If Fast
        This.ConvertFast(This.ProcessedImage, This.OCRTextFile)
        Else
        This.ConvertBest(This.ProcessedImage, This.OCRTextFile)
        This.OCRResult := This.GetResult(This.OCRTextFile)
        This.Cleanup()
        Return This.OCRResult
    }
    
    Static Preprocess(Input := "", Output := "", ScaleFactor := "") {
        Static OCRPreProcessing := 1
        Static NegateArg := 2
        Static PerformScaleArg := 1
        Input := (Input != "") ? Input : This.OriginalImage
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
    
}
