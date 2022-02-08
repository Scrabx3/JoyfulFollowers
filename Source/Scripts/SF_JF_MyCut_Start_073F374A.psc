;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_JF_MyCut_Start_073F374A Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
JoyfulFollowers.LockTimeout()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
If(GetOwningQuest().GetStage() < 10)
  GetOwningQuest().Stop()
  JoyfulFollowers.UnlockTimeout(true)
Else
  ; Disable the Follower & Register for Update in the Mainscript to start the respawn Scene
  JoyFol.GetReference().Disable()
  ; Follower should be back at no later than 19.30, Events starts no no earler than 10 and latest at 16.15
  ; Min duration is thus 3h, max Duration 19.30 - currenthour
  float timeaway
  float upper = 19.5 - GameHour.Value
  If(upper < 0.25) ; to avoid anything weird in case the Player waits until after 19.30
    timeaway = 3.0
  Else
    timeaway = Utility.RandomFloat(3.0, upper)
  EndIf
  GetOwningQuest().RegisterForSingleUpdateGameTime(timeaway)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property JoyFol  Auto  

GlobalVariable Property GameHour Auto
