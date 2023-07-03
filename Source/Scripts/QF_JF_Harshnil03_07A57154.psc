;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 20
Scriptname QF_JF_Harshnil03_07A57154 Extends Quest Hidden

;BEGIN ALIAS PROPERTY HarshnilBoss
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HarshnilBoss Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit01R02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit01R02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BanditBoss03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BanditBoss03 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GearChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_GearChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit01R01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit01R01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit02R01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit02R01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit03R02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit03R02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Bandit02R02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Bandit02R02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BanditBoss01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BanditBoss01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BanditBoss02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BanditBoss02 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
; player gets near chest
FollowerChestScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Follower reached player cell
FollowerEscapeScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
; fight against harshnil starts
Actor Harshnil = Alias_HarshnilBoss.GetActorReference()
Harshnil.RemoveFromFaction(tmpfriendsfac)
Harshnil.StartCombat(Game.GetPlayer())
Alias_BanditBoss01.GetActorReference().RemoveFromFaction(TmpFriendsFac)
Alias_BanditBoss02.GetActorReference().RemoveFromFaction(TmpFriendsFac)
Alias_BanditBoss03.GetActorReference().RemoveFromFaction(TmpFriendsFac)

SetObjectiveDisplayed(180)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; times up, let follower help player
Alias_Follower.GetActorReference().EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
; Finishing sentences with Follower and leaving harbor arrea
JoyfulFollowers.AddAffection(3, true)

Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
; player approaches harshnil
HarshnilScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE JFHarshnil03
Quest __temp = self as Quest
JFHarshnil03 kmyQuest = __temp as JFHarshnil03
;END AUTOCAST
;BEGIN CODE
; Follower gets gear back, either through their own Scene or by player opening chest
kmyQuest.RestoreFollower()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE JFHarshnil03
Quest __temp = self as Quest
JFHarshnil03 kmyQuest = __temp as JFHarshnil03
;END AUTOCAST
;BEGIN CODE
; Screen is currently blacked out. Move into position & strip
SetObjectiveDisplayed(0)
kmyQuest.SetUp()
; PlayerScene.Start()

Utility.Wait(9)
FadeToBlackHoldImod.PopTo(WoozyImod)

; Time until follower rescues player
RegisterForSingleUpdate(36)

Alias_Bandit01R01.GetActorReference().AddToFaction(TmpFriendsFac)
Alias_Bandit02R01.GetActorReference().AddToFaction(TmpFriendsFac)

Alias_Bandit01R02.GetActorReference().AddToFaction(TmpFriendsFac)
Alias_Bandit02R02.GetActorReference().AddToFaction(TmpFriendsFac)
Alias_Bandit03R02.GetActorReference().AddToFaction(TmpFriendsFac)

Alias_HarshnilBoss.GetActorReference().AddToFaction(TmpFriendsFac)
Alias_BanditBoss01.GetActorReference().AddToFaction(TmpFriendsFac)
Alias_BanditBoss02.GetActorReference().AddToFaction(TmpFriendsFac)
Alias_BanditBoss03.GetActorReference().AddToFaction(TmpFriendsFac)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
; negotiation with bandits failed for w/e reason

Alias_Bandit01R01.GetActorRef().RemoveFromFaction(TmpFriendsFac)
Alias_Bandit02R01.GetActorRef().RemoveFromFaction(TmpFriendsFac)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; player notified about belongings
SetObjectiveCompleted(0)
SetObjectiveDisplayed(12)
SetObjectiveDisplayed(13)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN AUTOCAST TYPE JFHarshnil03
Quest __temp = self as Quest
JFHarshnil03 kmyQuest = __temp as JFHarshnil03
;END AUTOCAST
;BEGIN CODE
; Post Scene, remove blackout and kill bandits so player can loot em and move on
kmyQuest.KnockoutBandits()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
; Make Bandits in Room2 hostile
Alias_Bandit01R02.GetActorReference().RemoveFromFaction(TmpFriendsFac)
Alias_Bandit02R02.GetActorReference().RemoveFromFaction(TmpFriendsFac)
Alias_Bandit03R02.GetActorReference().RemoveFromFaction(TmpFriendsFac)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; follower freed player
; PlayerScene.Stop()
Game.SetPlayerAIDriven(0)
Alias_Follower.GetActorReference().SetAV("WaitingForPlayer", 0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
; player about to enter first room
SeduceScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; begin of seduction adult scenes
SeduceScene.Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
; player opened chest
SetObjectiveCompleted(13)
LOSCollision.Disable() ; Wall stopping bandits from seeing the player on the way to gear chest

SetStage(51)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Harshnil died
CompleteAllObjectives()

Utility.Wait(3)
FollowerScene03.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


ImageSpaceModifier Property FadeToBlackHoldImod Auto

ImageSpaceModifier Property WoozyImod Auto

Scene Property FollowerEscapeScene  Auto  

Scene Property UnlockRoom01Scene  Auto  

Scene Property SeduceScene  Auto  

Faction Property TmpFriendsFac  Auto  

ObjectReference Property LOSCollision  Auto  

Scene Property HarshnilScene  Auto  

Scene Property FollowerChestScene  Auto  

ObjectReference Property HarshnilCollision  Auto  

Scene Property FollowerScene03  Auto  

Scene Property PlayerScene  Auto  

ObjectReference Property EntranceCellDoor  Auto  
