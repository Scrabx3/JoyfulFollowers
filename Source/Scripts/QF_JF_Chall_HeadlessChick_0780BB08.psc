;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname QF_JF_Chall_HeadlessChick_0780BB08 Extends Quest Hidden

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
MCM.bCooldown = false
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player left Dungeon
FailAllObjectives()
Core.LoseAffection()
FailScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
MCM.Cooldown(true)
Game.EnablePlayerControls()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Boss died here, considering this Challenge Cleared
CompleteAllObjectives()
Core.GainAffection()
Core.ManipulateAffection(3, 2)
EndScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property FailScene  Auto  

Scene Property EndScene  Auto  

JFCore Property Core  Auto  

JFMCM Property MCM  Auto  
