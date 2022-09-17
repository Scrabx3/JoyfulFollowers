;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_JF_Harshnil02_07A42CB3 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Boss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Boss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Note
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Note Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Harshnil
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Harshnil Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Leader
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Leader Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ThievesLoc
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_ThievesLoc Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Payment
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Payment Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Collected payment
SetObjectiveCompleted(15)

Rug.Disable()
RugRoilled.Enable()
Ladder.Enable()
Alias_Leader.GetReference().Enable()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Talked to Harshnil but denied his request
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; End of Scene, black out and start Part 3
Alias_Leader.GetReference().Disable()

If IsObjectiveDisplayed(40)
SetObjectiveFailed(40)
EndIf
SetObjectiveCompleted(50)

Harshnil03.Start()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Accepted Job
SetObjectiveDisplayed(10)
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player reads note from boss
FollowerNoteScene.Start()
SetObjectiveDisplayed(40)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Player enters Harshnils house after collecting the payment
BetrayalScene.ForceStart()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Boss died
SetObjectiveCompleted(10)
SetObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property FollowerNoteScene  Auto  

Scene Property BetrayalScene  Auto  

ObjectReference Property Rug  Auto  

ObjectReference Property RugRoilled  Auto  

ObjectReference Property Ladder  Auto  

ImageSpaceModifier Property BackStabImod  Auto  

Quest Property Harshnil03  Auto  
