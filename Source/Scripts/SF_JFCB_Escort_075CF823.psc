;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 13
Scriptname SF_JFCB_Escort_075CF823 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
Game.EnablePlayerControls()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Game.DisablePlayerControls(ablooking = true, abCamSwitch = true)
Game.ForceFirstPerson()
PlayerRef.MoveTo(PlayerBedAM)
JoyFol.GetReference().MoveTo(ChamberAM)
FadeToBlackHoldImod.PopTo(Woozy)
PlayerRef.PlayIdle(WakeUp)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
If BedInn.IsFurnitureInUse()
  Game.FindClosestActorFromRef(BedInn, 5).MoveTo(InnEntry)
endIf

Game.DisablePlayerControls(ablooking = true, abCamSwitch = true)
Game.ForceFirstPerson()
PlayerRef.MoveTo(PlayerBedInn)
JoyFol.GetReference().MoveTo(InnEntry)
FadeToBlackHoldImod.PopTo(Woozy)
PlayerRef.PlayIdle(WakeUp)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
FadeToBlackHoldImod.Apply()
JoyFol.GetActorReference().SetAV("WaitingForPlayer", 1)
(GetOwningQuest() as JFBelowCollege).Core.Fatigue.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
JoyFol.GetActorReference().SetAV("WaitingForPlayer", 0)
GetOwningQuest().CompleteQuest()
(GetOwningQuest() as JFBelowCollege).MCM.Cooldown()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property PlayerBedAM  Auto

ReferenceAlias Property JoyFol  Auto

Actor Property PlayerRef  Auto

ObjectReference Property BedInn  Auto

ObjectReference Property PlayerBedInn Auto

ObjectReference Property InnEntry  Auto

ImageSpaceModifier Property Woozy  Auto

Idle Property WakeUp  Auto

ObjectReference Property ChamberAM  Auto

ImageSpaceModifier Property FadeToBlackHoldImod  Auto
