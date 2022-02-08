Scriptname JFMyCut extends Quest

Actor Property PlayerRef Auto
MiscObject Property Gold001 Auto
Scene Property ReturnScene Auto

int taken = 0 ; When the Follower returns, they may give the Player back some of the cash given to them

Function GiveMoney(float Percent)
  SetStage(10)
  If(percent == 0)
    taken = 0
  Else
    taken = Math.Floor(PlayerRef.GetItemCount(Gold001) * percent)
    PlayerRef.RemoveItem(Gold001, taken)
  EndIf
EndFunction

Event OnUpdate()
  ; When the Intro Scene ends on Stage 10 (meaning GiveMoney() has been called) it will register an Update here to complete the Event
  ReturnScene.Start()
EndEvent

Function giveBack()
  If(JoyfulFollowers.GetAffectionLevel() < 3)
    PlayerRef.AddItem(Gold001, Math.Floor(taken*(Utility.RandomFloat(0.15, 0.3))))
  else
    PlayerRef.AddItem(Gold001, Math.Floor(taken*(Utility.RandomFloat(0.1, 0.2))))
  EndIf
EndFunction
