;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname QF_JF_Puppy_073AC8E1 Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Quest officially starts here
; SetObjectiveDisplayed(10)

JFMainEvents.Singleton().kPuppyEffect = true
Actor pl = Game.GetPlayer()
pl.AddItem(PuppyCollar, abSilent = true)
pl.EquipItem(PuppyCollar, true, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Actor pl = Game.GetPlayer()
pl.UnequipItem(PuppyCollar)
pl.RemoveItem(PuppyCollar)

JoyfulFollowers.AddAffection(2)

CompleteAllObjectives()
CompleteQuest()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Dialogue Flag to recognize that the Follower already told the Player that the Collar can come off
; SetObjectiveDisplayed(95)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Armor Property puppyCollar  Auto  
