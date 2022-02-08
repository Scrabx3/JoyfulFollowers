;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname QF_JF_Traitor_1_074B3E2F Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Rebel1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Rebel1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Rebel0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Rebel0 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Falion
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Falion Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RebelStarter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RebelStarter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; enable collision plains to avoid the Player jumping out of the Troll Pen..

int Count = CollisionPlanes.Length
While Count
  Count -= 1
  CollisionPlanes[Count].EnableNoWait()
endWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Give back all player controls
Game.SetinCharGen(false, false, false)
Game.EnablePlayerControls()
CompleteAllObjectives()
Alias_JoyFol.GetActorReference().SetAV("WaitingForPlayer", 0)

; Disable the Collision planes again..

int Count = CollisionPlanes.Length
While Count
  Count -= 1
  CollisionPlanes[Count].DisableNoWait()
endWhile

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

ObjectReference[] Property CollisionPlanes  Auto  
