;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF_JF_StolenBegDog01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor[] act = new Actor[2]
act[0] = Game.GetPlayer()
act[1] = akSpeaker
JFAnimStarter.StartScene(act, "doggy", hook = "JFStolen")

Steal.RegisterForSl()
JFMainEvents.Singleton().petplay = true
JFMainEvents.Singleton().humiliation = true
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JFStealClothes Property Steal Auto
