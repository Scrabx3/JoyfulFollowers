;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 25
Scriptname QF_JF_GreenwallBandit_076F0188 Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FortGreenwall
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_FortGreenwall Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HarshnilMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HarshnilMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Harshnil
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Harshnil Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Barkeeper
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Barkeeper Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player healed Harsh here. Disable Timer & let Harshnil introduce himself properly
UnregisterForUpdate()
CompleteAllObjectives()

JoyfulFollowers.AddAffection(3)

EndScene.Forcestart()
JoyfulFollowers.SetTimeout()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
; Harshnil reaches his home
Harshnil02.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; Harshnil dies
JoyfulFollowers.DamageAffection(true)
FailAllObjectives()
Stop()
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

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
; Player comes back later to help Harshnil out

SetObjectiveCompleted(10)
SetObjectiveDisplayed(25)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
; Follower took on Barkeepers request; setup Harshnil
Actor Harshnil = Alias_Harshnil.GetReference() as Actor
Harshnil.EvaluatePackage()
Harshnil.MoveTo(Alias_HarshnilMarker.GetReference())

; Harshnil will die in 1 week from now if not helped
RegisterForSingleUpdateGameTime(168)

FolNotifyPlScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
; Player told Harshnil to "get lost"
JFMainEvents.Singleton().FIsCruel = true
CompleteAllObjectives()
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

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdateGameTime()
		Alias_Harshnil.GetActorRef().Kill()
EndEvent

Scene Property EndScene  Auto

Scene Property PrisonScene  Auto

Scene Property FolNotifyPlScene  Auto  

Quest Property Harshnil02  Auto  
