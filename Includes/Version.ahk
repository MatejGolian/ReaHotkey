Version := "0.4.0", BuildNumber := "0"

GetVersion() {
    Global Version, BuildNumber
    If BuildNumber != "0"
        Return Version . "-b" . BuildNumber
    Return Version
}

