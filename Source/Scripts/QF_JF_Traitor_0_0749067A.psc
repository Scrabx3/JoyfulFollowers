;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_JF_Traitor_0_0749067A Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Rebel1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Rebel1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Harkon
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Harkon Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Rebel0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Rebel0 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RebelStarter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RebelStarter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Serana
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Serana Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Game.EnablePlayerControls(abFighting = false)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Game.SetinCharGen(false, false, false)
Game.EnablePlayerControls()
CompleteAllObjectives()

JoyfulFollowers.AddAffection(3)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

