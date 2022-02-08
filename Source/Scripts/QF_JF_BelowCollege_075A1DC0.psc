;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 25
Scriptname QF_JF_BelowCollege_075A1DC0 Extends Quest Hidden

;BEGIN ALIAS PROPERTY MiddenTrigger
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MiddenTrigger Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Reward
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Reward Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bedroll
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bedroll Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AtronachForge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AtronachForge Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
; Player passed out, Follower takes them to some safe location & triggers a Scene
; This Stage is called AFTER the Scene to stop the Quest

JoyfulFollowers.AddAffection(2)

CompleteAllObjectives()
Stop()
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

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
; Ritual is over, Staff has been placed on the Forge. The Player can either take the Staff which
; will force the Player to forcegreet or ignore the staff and talk to the Follower directly
; We point them at the Staff of course :) 

SetObjectiveCompleted(60)
SetObjectiveDisplayed(80)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
; Player killed all the Atronachs, check on the Follower

SetObjectiveCompleted(400)
SetObjectiveDisplayed(410)

Actor fol = ALias_joyfol.GetActorReference()
fol.SetNoBleedoutRecovery(false)
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

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE JFBelowCollege
Quest __temp = self as Quest
JFBelowCollege kmyQuest = __temp as JFBelowCollege
;END AUTOCAST
;BEGIN CODE
; The Follower will idle near the Atronach Forge until the Player has slept for a while
; Cooldown is set here, as the Player is now intended to play the Quest until completed

kmyQuest.SleepReady()
SetObjectiveCompleted(10)
SetObjectiveDisplayed(30)

JoyfulFollowers.LockTimeOut()
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

JFMainEvents.Singleton().KCollegeRitual = true
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
; Follower escorts the Player out of the midden

JoyfulFollowers.AddAffection(2)

CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
; Meeting up with Follower, then realizing theyre in.. a bit of a predicament

SetObjectiveCompleted(30)
SetObjectiveDisplayed(50)
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
; This Scene completes the Quest

EscortScene.Start()
JoyfulFollowers.AddAffection(2)
GameDaysPassed.Value += 2
GameDay.Value += 2
CompleteAllObjectives()
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

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
; College Scenario 2 end
JoyfulFollowers.AddAffection(2)

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

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
; Player sees follower being.. "busy" with the atronachs
; IDEA: Add options for Player to help follower?
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Intro
; Follower was already teasing the Event in a "joke"
SetObjectiveDisplayed(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
; Follower Scenes done, enable Dialogue with Follower
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
; player wakes up with Atronachs going crrrrrazy
int i = 0
While(i < AtronachSpawns.Length)
  AtronachSpawns[i].PlaceActorAtMe(AtronachAny)
  i += 1
EndWhile

Actor fol = Alias_Joyfol.GetActorReference()
fol.SetNoBleedoutRecovery(true)
fol.DamageAV("Health", fol.GetAV("Health"))

SetObjectiveCompleted(30)
SetObjectiveDisplayed(400)
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

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; College Scenario 2 end
JoyfulFollowers.AddAffection(2)

CompleteAllObjectives()
Stop()
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

JoyfulFollowers.AddAffection(2)

CompleteAllObjectives()
Stop()
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
; player collapses after talking to the follower
; only ending dialogue

PassOut.Start()
JoyfulFollowers.AddAffection(2)
GameDaysPassed.Value += 2
GameDay.Value += 2
CompleteAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property EscortScene  Auto  

GlobalVariable Property GameDaysPassed  Auto

GlobalVariable Property GameDay  Auto

Scene Property PassOut  Auto  

Actor Property JoyFol  Auto Hidden 

ObjectReference[] Property AtronachSpawns  Auto  

ActorBase Property AtronachAny  Auto  
