;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIJF__MyCutGiveMoney100V2 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Core.Relax()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Core.FadeBlack()
JF_MyCut_Give100_V2.Show()
Misc.GiveMoney(1.0)
akSpeaker.DropObject(Gold001, Utility.RandomInt(13, 42))
akSpeaker.Disable()
Core.FadeBlackBack()
Core.GainAffection(true)
Core.ManipulateAffection(7, 3)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property JF_MyCut_Give100_V2  Auto

JFCore Property Core  Auto

Scene Property JF_Misc_Shopping  Auto

JFMyCut  Property MISC  Auto

Actor Property PlayerRef  Auto

MiscObject Property Gold001  Auto
