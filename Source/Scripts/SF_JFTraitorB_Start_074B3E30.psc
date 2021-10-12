;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 17
Scriptname SF_JFTraitorB_Start_074B3E30 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_11
Function Fragment_11(ReferenceAlias akAlias)
;BEGIN CODE
If(!IsActionComplete(22))
  Stop()
  GetOwningQuest().Stop()
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
Actor Player = Game.GetPlayer()
Player.RemoveItem(PrisonerCuffs, abSilent = true)
Player.PlayIdle(BoundStandingCut)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Game.EnablePlayerControls(abMenu = false, abActivate = false, abJournalTabs = false, abFighting = false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
PrisonDoor.SetOpen(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
Game.SetPlayerAIDriven(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
Traitor.StartWaiting()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
Actor Player = Game.GetPlayer()
Weapon Righty = Player.GetEquippedWeapon()
Weapon Lefty = Player.GetEquippedWeapon(true)
If(Righty)
  Player.UnequipItem(Righty, abSilent = true)
EndIf
If(Lefty && Lefty != Righty)
  Player.UnequipItem(Lefty, abSilent = true)
EndIf
Player.EquipItem(PrisonerCuffs)
Player.PlayIdle(OffsetBoundStandingStart)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
game.disablePlayerControls()
Game.SetPlayerAIDriven()
Game.SetinCharGen(false, true, false)
GetOwningQuest().SetStage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
PrisonDoor.SetOpen(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
JoyFol.GetActorReference().SetAV("WaitingForPlayer", 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property JoyFol  Auto  

ObjectReference Property PrisonDoor  Auto  

JFTraitor Property Traitor  Auto  

Armor Property PrisonerCuffs  Auto  

Idle Property OffsetBoundStandingStart  Auto  

Idle Property BoundStandingCut  Auto  
