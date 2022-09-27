;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 28
Scriptname QF_JF_Stolen_0901459F Extends Quest Hidden

;BEGIN ALIAS PROPERTY SatchelLocation
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SatchelLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PetDog
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PetDog Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Satchel
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Satchel Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_27
Function Fragment_27()
;BEGIN CODE
; "Anything" begging branch
SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;Waiting, to make sure the follower actually waits, evaluate package here
Actor follower = Alias_JoyFol.GetActorRef()
follower.EvaluatePackage()
follower.SetAV("WaitingForPlayer", 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Default ending
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; Close Quest
CompleteAllObjectives()
Stop()

JoyfulFollowers.StartGame()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Alias_Satchel.GetReference().Enable()
If(JF_Stolen_Start_1.Show() == 1)
  JF_Stolen_Start_2.Show()
EndIf

SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
; Player finding the satchel while the follower waits
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
JoyfulFollowers.UnlockTimeout(true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Found Statchel after time up
FailAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_25
Function Fragment_25()
;BEGIN CODE
; Begging, dog event denied
JFMainEvents.Singleton().petplay = false
JFMainEvents.Submit(false)
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

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;Sleep with your pet dog for the solution
SetObjectiveDisplayed(200)
JF_Stolen_PathToClothes_Dog.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Found Statchel with the Followers help
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_26
Function Fragment_26()
;BEGIN CODE
; Flag to signify that the pet dog is considered aroused
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

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
; Set when player aggress to a game
; set 100 to do the pathing
SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property JF_Stolen_Start_1  Auto

Message Property JF_Stolen_Start_2  Auto

Scene Property JF_Stolen_PathToClothes_Dog  Auto

Scene Property JF_Stolen_PathToClothes_JF  Auto

JFStealClothes  Property Satchel  Auto
