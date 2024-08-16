Version := "0.4.9"
;@Ahk2Exe-Let U_version = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%
BuildNumber := "0"
;@Ahk2Exe-Let U_OrigFilename = %A_ScriptName~\.[^\.]+$~.exe%
;@Ahk2Exe-SetDescription ReaHotkey
;@Ahk2Exe-SetFileVersion %U_Version%
;@Ahk2Exe-SetProductName ReaHotkey
;@Ahk2Exe-SetProductVersion %U_Version%
;@Ahk2Exe-SetOrigFilename %U_OrigFilename%

GetVersion() {
    Global Version, BuildNumber
    If BuildNumber != "0"
        Return Version . "-b" . BuildNumber
    Return Version
}
