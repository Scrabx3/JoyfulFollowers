;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF_JF_MyCutGive11Special Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
FadeToBlackImod.Apply()
Utility.Wait(2)
FadeToBlackImod.PopTo(FadeToBlackHoldImod)

JF_MyCut_Give100_V2.Show()
Misc.GiveMoney(1.0)
akSpeaker.DropObject(Gold001, Utility.RandomInt(13, 42))
akSpeaker.Disable()

Utility.Wait(0.7)
FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)

JoyfulFollowers.AddAffection(3)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
JoyfulFollowers.ReduceSeverity()
JFMainEvents.Singleton().FIsGreedy = false
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property JF_MyCut_Give100_V2  Auto

Imagespacemodifier Property FadeToBlackImod Auto
Imagespacemodifier Property FadeToBlackHoldImod Auto
Imagespacemodifier Property FadeToBlackBackImod Auto


Scene Property JF_Misc_Shopping  Auto

JFMyCut  Property MISC  Auto

Actor Property PlayerRef  Auto

MiscObject Property Gold001  Auto
