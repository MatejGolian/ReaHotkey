Version := "0.2.1"
BuildNumber := "0"

GetVersion() {
    Global Version, BuildNumber
    If BuildNumber != "0"
        Return Version . "-b" . BuildNumber
    Return Version
}
