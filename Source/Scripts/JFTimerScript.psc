Scriptname JFTimerScript extends Quest  Conditional

GlobalVariable Property MaxGameTime Auto
GlobalVariable Property GameDaysPassed Auto

int Property StageToSet = 0 Auto
{Stage to set after the game ended. 0 doesnt set a Stage | Default = 0}

float Property gametime Auto Hidden Conditional
float Property quarter Auto Hidden Conditional
float Property half Auto Hidden Conditional
float Property secondquarter Auto Hidden Conditional
float Property unlockat Auto Hidden Conditional

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  gametime = Utility.RandomFloat(4.0, MaxGameTime.Value)
  unlockat = gametime + GameDaysPassed.GetValue()
  secondquarter = gametime * 0.75 + GameDaysPassed.GetValue()
  half = gametime * 0.5 + GameDaysPassed.GetValue()
  quarter = gametime * 0.25 + GameDaysPassed.GetValue()
  If(StageToSet > 0)
    RegisterForSingleUpdateGameTime(gametime)
  EndIf
EndEvent

Event OnUpdateGameTime()
  SetStage(StageToSet)
EndEvent