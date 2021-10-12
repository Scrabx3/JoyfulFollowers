;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 21
Scriptname QF_JF_GreenwallBandit_076F0188 Extends Quest Hidden

;BEGIN ALIAS PROPERTY FortGreenwall
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_FortGreenwall Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Keerava
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Keerava Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HarshnilMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HarshnilMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Harshnil
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Harshnil Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
; Scene ended here, moving Harshnil into Position
Alias_Harshnil.GetActorRef().MoveTo(Alias_HarshnilMarker.GetReference())
; Registering for Update, if the Player doesnt help Harshnil within a week, kill him (poor guy)
RegisterForSingleUpdateGameTime(168)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
SetStage(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
; Player entered spider infested area in the Prison, setting up the Loop now
; PrepareWound()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Harshnir gives Player the Dagger after they helped him
Alias_Harshnil.GetActorRef().SetRelationshipRank(Game.GetPlayer(), 1)
Alias_Harshnil.GetActorRef().SetRelationshipRank(Alias_JoyFol.GetActorRef(), 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; Entered Prison, starting Dialogue Scene here
UnregisterForUpdateGameTime()
PrisonScene.Start()
Actor Harshnil = Alias_Harshnil.GetReference() as Actor
; Harshnil.SetAV("HealRate", 0)
Harshnil.SetRestrained(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Player helped Harshnil but was originally mean to them
Alias_Harshnil.GetActorRef().SetRelationshipRank(Alias_JoyFol.GetActorRef(), 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player healed Harsh here
CompleteAllObjectives()
Util.FIsCruel = false
Core.ManipulateAffection(5, 3)
EndScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
; Player healed Harsh here but after being originally mean to him >:(
UnregisterForUpdate()
Core.GainAffection()
EndScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
; IntroScene.Forcestart()
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

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
; Player let Hashnil go in a rather harsh tone and didnt heal them
Util.FIsCruel = true
SetObjectiveCompleted(10)

; We treat this Stage equal to Stage 25 but Harshnil will die after some time has passed
RegisterForSingleUpdate(180)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; Harshnil dies because Player didnt help him at all
Alias_Harshnil.GetActorRef().Kill()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
; Tracking Stage: Player comes back later
SetObjectiveCompleted(10)
SetObjectiveDisplayed(25)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdateGameTime()
	If(GetStage() < 15)
		; Alias_Harshnil.GetActorRef().Kill()
		; FailAllObjectives()
		; CompleteQuest()
		; Stop()
		SetStage(300)
	EndIf
EndEvent


Event OnUpdate()
	If(GetStage() < 25)
		SetStage(300)
	EndIf
EndEvent


JFEventStorage Property Util  Auto

JFCore Property Core  Auto

Scene Property EndScene  Auto

ObjectReference Property HarshnilMarker  Auto

Scene Property PrisonScene  Auto

Scene Property introScene  Auto
