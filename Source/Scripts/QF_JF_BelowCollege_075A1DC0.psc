;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 16
Scriptname QF_JF_BelowCollege_075A1DC0 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Reward
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Reward Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MiddenTrigger
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MiddenTrigger Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AtronachForge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AtronachForge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bedroll
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bedroll Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Intro
; Follower was already teasing the Event in a "joke"
SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; Player fears they might faint, so Follower brings them to either the Archmage Quarters or
; Frozen Hearth (depending on Story Progression)

EscortScene.Start()
kmyQuest.Core.GainAffection(silent = true)
GameDaysPassed.Value += 2
GameDay.Value += 2
CompleteAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; Quest completed with the Default Scenario. Switch back Levers & Complete Quest
; Player is angry here, jajaja. Maybe use it for tracking, idk

kmyQuest.MCM.Cooldown()
kmyQuest.Core.GainAffection(silent = true)

CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Intro
; Folower has to explain everything when we get there
; Player didnt ask any Questions about the Event itself
SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Quest didnt officially start here, set Log Entry n stuff from 10 onwards

JoyFol = Alias_JoyFol.GetActorReference()

JoyFol.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
; Ritual is over, Staff has been placed on the Forge. The Player can either take the Staff which
; will force the Player to forcegreet or ignore the staff and talk to the Follower directly
; We point them at the Staff of course :) 

JoyFol.ModActorValue("Conjuration", JoyFol.GetBaseActorValue("Conjuration") + 5.0)

SetObjectiveCompleted(60)
SetObjectiveDisplayed(80)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; This only enables a Forcegreet that is triggered after the Player took the Staff
; The player may also engage into this Dialogue themselves before taking the staff

JoyFol.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; Queest officially starts here, we consider this the Starts here and is considered Active
; We set Cooldown here and Register for Sleep
; The Follower will idle near the Atronach Forge until the Player has slept for a while
; This Stage will also force a Blocking Dialogue until then

kmyQuest.SleepReady()
SetObjectiveCompleted(10)
SetObjectiveDisplayed(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; Quest completed with the Default Scenario. Jus Complete Quest

kmyQuest.MCM.Cooldown()
kmyQuest.Core.GainAffection(silent = true)

CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
; Player cancels Quest after intiailly agreeing to it

FailAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; Follower pulled the Lever, Ritual starts & blabla

kmyQuest.ActivateForge()
SetObjectiveCompleted(50)
SetObjectiveDisplayed(60)
Util.KCollegeRitual = true
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Intro
; Player knows about the Ritual and that itl will require Materials
SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Meeting up with Follower & start the Ritual

SetObjectiveCompleted(30)
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; Quest technically ended but we got a post Quest scenario going. Yay.
; Player stated to Faint and RNG happened so thus they did! Yay!
; Quest stops through the Forcegreet at the End of the Scene

PassOut.Start()
kmyQuest.Core.GainAffection(true, true)
GameDaysPassed.Value += 2
GameDay.Value += 2
CompleteAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference[] Property ForgeLevers  Auto  

Scene Property EscortScene  Auto  

GlobalVariable Property GameDaysPassed  Auto

GlobalVariable Property GameDay  Auto

Scene Property PassOut  Auto  

JFEventStorage Property Util  Auto  

Actor Property JoyFol  Auto Hidden 
