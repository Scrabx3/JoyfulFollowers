;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 21
Scriptname QF_JF_GreenwallBandit_076F0188 Extends Quest Hidden

;BEGIN ALIAS PROPERTY HarshnilMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HarshnilMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Keerava
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Keerava Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FortGreenwall
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_FortGreenwall Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Harshnil
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Harshnil Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
; Follower took on the request from the Barkeeper, enabling & moving Harshnil
Actor Harshnil = Alias_Harshnil.GetReference() as Actor
Harshnil.Enable()
Harshnil.MoveTo(Alias_HarshnilMarker.GetReference())

; If the Player doesnt help Harshnil within a week, kill him (poor guy)
RegisterForSingleUpdateGameTime(168)

FolNotifyPlScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; Harshnil dies because Player didnt help him at all

FailAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
; Player comes back later to help Harshnil out

SetObjectiveCompleted(10)
SetObjectiveDisplayed(25)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
; Player told Harshnil to "get lost"
JFMainEvents.Singleton().FIsCruel = true
SetObjectiveCompleted(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
; Talked to Follower and got the Objective here
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; Entered Prison, starting Dialogue Scene here

PrisonScene.Start()
; Debug.SendAnimationEvent(Alias_Harshnil.GetReference(), "IdleInjured")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player healed Harsh here. Disable Timer & let Harshnil introduce himself properly
UnregisterForUpdate()
CompleteAllObjectives()

If(GetStageDone(20) == false) ; only add affection if the Player wasnt mean to poor Harshnil D:
  JoyfulFollowers.AddAffection(3)
  JFMainEvents.Singleton().FIsCruel = false
EndIf

EndScene.Forcestart()
JoyfulFollowers.SetTimeout()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Harshnir gives Player the Dagger after they helped him
Actor Harshnil = Alias_Harshnil.GetActorRef()
Harshnil.SetRelationshipRank(Game.GetPlayer(), 1)
Harshnil.SetRelationshipRank(Alias_JoyFol.GetActorRef(), 1)

CompleteAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdateGameTime()
		Alias_Harshnil.GetActorRef().Kill()
EndEvent

Scene Property EndScene  Auto

Scene Property PrisonScene  Auto

Scene Property FolNotifyPlScene  Auto  
