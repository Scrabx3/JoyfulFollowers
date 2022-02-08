;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF_JF_Prank_Drugged_073984CC Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
RegisterForSingleUpdateGameTime(2)
Game.GetPlayer().EquipItem(Skooma, false, true)

Drugchance.Value += 3
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdateGameTime()
  Stop()
EndEvent

Potion Property Skooma  Auto  

GlobalVariable Property DrugChance  Auto  
