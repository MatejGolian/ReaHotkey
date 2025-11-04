#Requires AutoHotkey v2.0

ReturnSleepFunc(Period) {
    SleepFunc := Object()
    SleepFunc.DefineProp("Period", {Value: Period})
    SleepFunc.DefineProp("Call", {call: CallSleepFunc})
    Return SleepFunc
    CallSleepFunc(This, OverlayObj) {
        Sleep This.Period
    }
}
