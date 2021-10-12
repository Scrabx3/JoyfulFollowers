;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 19
Scriptname SF_JFTraitorA_Start_0749577B Extends Scene Hidden

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
game.disablePlayerControls()
Game.SetPlayerAIDriven()
Game.SetinCharGen(false, true, false)
GetOwningQuest().SetStage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
PrisonDoor.SetOpen(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16(ReferenceAlias akAlias)
;BEGIN CODE
If(!IsActionComplete(25))
  Stop()
  GetOwningQuest().Stop()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
JoyFol.GetActorReference().SetAV("WaitingForPlayer", 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
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
Player.EquipItem(PrisonerCuffs, true, true)
Player.PlayIdle(OffsetBoundStandingStart)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
(GetOwningQuest() as JFTraitor).StartWaiting()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
Game.SetPlayerAIDriven(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
Actor Player = Game.GetPlayer()
Player.RemoveItem(Prisonercuffs, abSilent =true)
Player.PlayIdle(BoundOffsetCut)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Game.EnablePlayerControls(abMenu = false, abActivate = false, abJournalTabs = false, abFighting = false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
PrisonDoor.SetOpen(false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
;WARNING: Unable to load fragment source from function Fragment_17 in script SF_JFTraitorA_Start_0749577B
;Source NOT loaded
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property JoyFol  Auto

ObjectReference  Property PrisonDoor  Auto

Idle Property OffsetBoundStandingStart  Auto  

Armor Property PrisonerCuffs  Auto  

Idle Property BoundOffsetCut  Auto  
