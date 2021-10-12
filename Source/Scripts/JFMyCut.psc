Scriptname JFMyCut extends Quest

; ------------------------------------- Property
JFMCM Property MCM Auto
Quest Property CoreQ Auto
Actor Property PlayerRef Auto
MiscObject Property Gold001 Auto
Scene Property StartScene Auto
Scene Property ReturnScene Auto
; ------------------------------------- Variables
int taken = 0
; ------------------------------------- Code
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  MCM.bCooldown = false
  taken = 0
EndEvent

Event OnUpdateGameTime()
  ReturnScene.Start()
EndEvent

Function GiveMoney(float Percent)
  SetStage(10)
  taken = Math.Floor(PlayerRef.GetItemCount(Gold001) * percent)
  PlayerRef.RemoveItem(Gold001, taken)
EndFunction

Function giveBack()
  If(CoreQ.GetStage() < 600)
    PlayerRef.AddItem(Gold001, Math.Floor(taken*(Utility.RandomFloat(0.1, 0.2))))
  else
    PlayerRef.AddItem(Gold001, Math.Floor(taken*(Utility.RandomFloat(0.15, 0.3))))
  EndIf
EndFunction
