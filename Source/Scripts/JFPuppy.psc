Scriptname JFPuppy extends Quest  Conditional

JFMCM Property MCM Auto
GlobalVariable Property GameDaysPassed Auto

float Property gametime Auto Hidden Conditional
float Property quarter Auto Hidden Conditional
float Property half Auto Hidden Conditional
float Property secondquarter Auto Hidden Conditional
float Property unlockat Auto Hidden Conditional

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  gametime = Utility.RandomFloat(4.0, MCM.fPuppyDur)
  unlockat = gametime + GameDaysPassed.GetValue()
  quarter = gametime * 0.25 + GameDaysPassed.GetValue()
  half = gametime * 0.5 + GameDaysPassed.GetValue()
  secondquarter = gametime * 0.75 + GameDaysPassed.GetValue()
EndEvent