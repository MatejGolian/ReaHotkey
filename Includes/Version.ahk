Version := "0.4.0", BuildNumber := "0"
;@Ahk2Exe-Let U_Version = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%
;@Ahk2Exe-Let U_BuildNumber = %A_PriorLine~U)^(.+"){3}(.+)".*$~$2%
;@Ahk2Exe-SetFileVersion %U_Version%.%U_BuildNumber%
;@Ahk2Exe-Let U_Version = %U_Version%-b%U_BuildNumber%
;@Ahk2Exe-Let U_OrigFilename = %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetOrigFilename %U_OrigFilename%
;@Ahk2Exe-SetDescription ReaHotkey application
;@Ahk2Exe-SetProductName ReaHotkey
;@Ahk2Exe-SetProductVersion %U_Version%

GetVersion() {
    Global Version, BuildNumber
    If BuildNumber != "0"
        Return Version . "-b" . BuildNumber
    Return Version
}

