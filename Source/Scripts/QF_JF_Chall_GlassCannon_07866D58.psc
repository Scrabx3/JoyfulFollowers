;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname QF_JF_Chall_GlassCannon_07866D58 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Axe
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Axe Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DungeonLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DungeonLoc Auto
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

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Game.GetPlayer().RemoveItem(Alias_Axe.GetReference(), abSilent = true)
Game.GetPlayer().RemoveSpell(CurseSpell)
MCM.Cooldown(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
MCM.bCooldown = false
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor PlayerRef = Game.GetPlayer()
PlayerRef.UnequipAll()
Alias_JoyFol.GetActorRef().RemoveItem(Alias_Axe.GetReference(), abSilent = true, akOtherContainer =  PlayerRef)
PlayerRef.Equipitem(Alias_Axe.GetReference(), true)
PlayerRef.AddSpell(CurseSpell, false)
Utility.Wait(1)
SetStage(10)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Lost Challenge
FailAllObjectives()
Core.LoseAffection()
LoseScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Boss died here, considering this Challenge Cleared
CompleteAllObjectives()
Core.GainAffection()
Core.ManipulateAffection(5, 2)
WinScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property WinScene  Auto  

JFCore Property Core  Auto  

JFMCM Property MCM  Auto  

Scene Property LoseScene  Auto  

SPELL Property CurseSpell  Auto  

WEAPON Property Axe  Auto  
