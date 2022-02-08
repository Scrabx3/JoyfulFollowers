;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname QF_JF_Chall_GlassCannon_07866D58 Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Axe
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Axe Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DungeonLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_DungeonLoc Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DungeonBoss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DungeonBoss Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Rulebreak
FailAllObjectives()

Actor Player = Game.GetPlayer()
While(Player.IsInCombat())
  Utility.Wait(2)
EndWhile

Losescene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Challenge officially starting here
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor PlayerRef = Game.GetPlayer()
ObjectReference wp = Alias_Axe.GetReference()
Alias_JoyFol.GetActorRef().RemoveItem(wp, abSilent = true, akOtherContainer =  PlayerRef)
PlayerRef.UnequipAll()
PlayerRef.Equipitem(wp, true)
PlayerRef.AddSpell(CurseSpell, false)

SetStage(10)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
Actor Player = Game.GetPlayer()
ObjectReference ax = Alias_Axe.GetReference()
Player.RemoveItem(ax, abSilent = true)
Alias_JoyFol.GetReference().RemoveItem(ax, abSilent = true)
Player.RemoveSpell(CurseSpell)

JoyfulFollowers.UnlockTimeout(GetStageDone(7))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Boss died here, considering this Challenge Cleared
CompleteAllObjectives()
JoyfulFollowers.AddAffection(2)

WinScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
JoyfulFollowers.LockTimeout()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property WinScene  Auto  

Scene Property LoseScene  Auto  

SPELL Property CurseSpell  Auto  

WEAPON Property Axe  Auto  

Event OnInit()
  Debug.Notification("Glasscannon started")
EndEvent
