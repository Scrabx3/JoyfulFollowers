;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 11
Scriptname QF_JF_Chall_HelpingHand_07848732 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Staff
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Staff Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DungeonLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DungeonLoc Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DungeonBoss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DungeonBoss Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Boss died here, considering this Challenge Cleared
CompleteAllObjectives()
JoyfulFollowers.AddAffection(2)

WinScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
JoyfulFollowers.LockTimeout()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Rulebreak
FailAllObjectives()
JoyfulFollowers.DamageAffection()

FailScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Follower into Bleedout
FailAllObjectives()

Actor Player = Game.GetPlayer()
While(Player.IsInCombat())
  Utility.Wait(2)
EndWhile

Alias_JoyFol.GetActorReference().ResetHealthAndLimbs()
KnockdownScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; Challenge officially starting here
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
Game.GetPlayer().RemoveItem(Alias_Staff.GetReference())
Alias_Joyfol.GetReference().RemoveItem(Alias_Staff.GetReference())
JoyfulFollowers.UnlockTimeout(GetStageDone(7))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor PlayerRef = Game.GetPlayer()
Alias_JoyFol.GetActorRef().RemoveItem(Alias_Staff.GetReference(), abSilent = true, akOtherContainer =  PlayerRef)
PlayerRef.Equipitem(Alias_Staff.GetReference(), true)

SetStage(10)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

WEAPON Property HealStaff  Auto  

Scene Property KnockdownScene  Auto  

Scene Property FailScene  Auto  

Scene Property WinScene  Auto  

Event OnInit()
  Debug.Notification("Helping Hand started")
EndEvent
