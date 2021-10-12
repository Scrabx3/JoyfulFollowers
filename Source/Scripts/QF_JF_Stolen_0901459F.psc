;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 24
Scriptname QF_JF_Stolen_0901459F Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PetDog
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PetDog Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SetObjectiveDisplayed(0)
If(JF_Stolen_Start_1.Show() == 1)
  JF_Stolen_Start_2.Show()
EndIf
Core.FadeBlackBack()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
; Same as 900 but youre allowed to wear clothes here
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;Sleep with your pet dog for the solution
SetObjectiveDisplayed(200)
JF_Stolen_PathToClothes_Dog.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;Waiting, to make sure the follower actually waits, evaluate package here
Alias_JoyFol.GetActorRef().EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; Close Quest
CompleteAllObjectives()
SetStage(955)

; Enable FG for PG Interaction
; Alias_JoyFol.GetActorRef().EvaluatePackage()
; No longer necessary, just tell the mod a Punishment Game should start now
Core.SendGameEvent()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_22
Function Fragment_22()
;BEGIN CODE
;Testing if Quest can actually start here and setting the Cooldown
If((Satchel as JFStealClothes).StripPlayer())
  SetStage(10)
  MCM.bCooldown = false
else
  Stop()
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
;Punishment Dialogue Started, handling that in the PG Quest
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
SetObjectiveDisplayed(100)
JF_Stolen_PathToClothes_JF.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
;Collar is being removed here
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
; "I unlock you any time, just tell me" - Is what the JF said
; (Talk to them in town and say you want to stay locked up)

; This stage does nothin beyond letting the System know that
; the JF unlocks the player whenever they want
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
SetObjectiveDisplayed(100)
JF_Stolen_PathToClothes_JF.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
FailAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
; PetPlay (Dog) Stages
; 90 enables dialogue, 115 leads to the bag
; setting stage to 900 as a mark that the collar is worn through Stolen Main Script
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; Wearing collar. Quest officially finished but is still running in the background until the collar is removed
CompleteAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
;Same as 906 but youre allowed to wear clothes here
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
MCM.Cooldown()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
;Dog sniffed you and showed you way to clothes. No scene etc
SetObjectiveDisplayed(200)
JF_Stolen_PathToClothes_Dog.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
SetObjectiveDisplayed(100)
JF_Stolen_PathToClothes_JF.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property JF_Stolen_Start_1  Auto

Message Property JF_Stolen_Start_2  Auto

Scene Property JF_Stolen_PathToClothes_Dog  Auto

Scene Property JF_Stolen_PathToClothes_JF  Auto

JFMCM Property MCM  Auto

ObjectReference Property Satchel  Auto

JFCore Property Core  Auto
