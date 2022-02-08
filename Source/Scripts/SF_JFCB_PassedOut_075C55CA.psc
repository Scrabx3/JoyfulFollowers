;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 25
Scriptname SF_JFCB_PassedOut_075C55CA Extends Scene Hidden

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
If BedInn.IsFurnitureInUse()
  Game.FindClosestActorFromRef(BedInn, 5).MoveTo(InnEntry)
endIf
If ChairInn.IsFurnitureInUse()
   Game.FindClosestActorFromRef(ChairInn, 5).MoveTo(InnEntry)
endIf
Utility.Wait(0.3)

Game.DisablePlayerControls(ablooking = true, abCamSwitch = true)
Game.ForceFirstPerson()
PlayerRef.MoveTo(PlayerBedInn)
JoyFol.GetReference().MoveTo(ChairInn)
Woozy.Apply()
PlayerRef.PlayIdle(WakeUp)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
FadeToBlackHoldImod.PopTo(Woozy)
PlayerRef.PlayIdle(WakeUp)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
GetOwningQuest().SetStage(1200)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Game.DisablePlayerControls(ablooking = true, abCamSwitch = true)
Game.ForceFirstPerson()
PlayerRef.MoveTo(PlayerBedAM)
JoyFol.GetReference().MoveTo(FollowersChairAM)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
FadeToBlackHoldImod.Apply()
Game.ForceFirstPerson()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
Game.EnablePlayerControls()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property FollowersChairAM  Auto

ObjectReference Property PlayerBedAM  Auto

ReferenceAlias Property JoyFol  Auto

Actor Property PlayerRef  Auto

ObjectReference Property BedInn  Auto

ObjectReference Property ChairInn Auto

ObjectReference Property PlayerBedInn Auto

ObjectReference Property InnEntry  Auto

ImageSpaceModifier Property Woozy  Auto

Idle Property WakeUp  Auto

ImageSpaceModifier Property FadeToBlackHoldImod  Auto
