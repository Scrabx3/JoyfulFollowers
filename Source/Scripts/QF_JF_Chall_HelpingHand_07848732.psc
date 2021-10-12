;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname QF_JF_Chall_HelpingHand_07848732 Extends Quest Hidden

;BEGIN ALIAS PROPERTY DungeonLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DungeonLoc Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Staff
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Staff Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DungeonBoss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DungeonBoss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
MCM.bCooldown = false
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
FailAllObjectives()
Core.LoseAffection()
FailScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor PlayerRef = Game.GetPlayer()
Alias_JoyFol.GetActorRef().RemoveItem(Alias_Staff.GetReference(), abSilent = true, akOtherContainer =  PlayerRef)
PlayerRef.Equipitem(Alias_Staff.GetReference(), true)
Utility.Wait(1)
SetStage(10)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Boss died here, considering this Challenge Cleared
CompleteAllObjectives()
Core.GainAffection()
Core.ManipulateAffection(5, 2)
WinScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
Game.GetPlayer().RemoveItem(Alias_Staff.GetReference())
MCM.Cooldown(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
FailAllObjectives()
Actor JF = Alias_JoyFol.GetReference() as Actor
Actor Player = Game.GetPlayer()
While(Player.IsInCombat())
	Utility.Wait(5)
EndWhile
JF.ResetHealthAndLimbs()
KnockdownScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

WEAPON Property HealStaff  Auto  

Scene Property KnockdownScene  Auto  

Scene Property FailScene  Auto  

Scene Property WinScene  Auto  

JFCore Property Core  Auto  

JFMCM Property MCM  Auto  
