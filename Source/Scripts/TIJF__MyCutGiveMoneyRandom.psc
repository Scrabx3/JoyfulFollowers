;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIJF__MyCutGiveMoneyRandom Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Msic.GiveMoney(Utility.RandomFloat(0.3, 0.95))
Core.GainAffection()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JFMyCut  Property Msic  Auto

JFCore Property Core  Auto

Scene Property JF_Misc_Shopping  Auto
