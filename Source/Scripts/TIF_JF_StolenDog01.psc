;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF_JF_StolenDog01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; <Pleasure him>
If(JF_Stolen_HornyDog.Show() == 0)
  Actor[] act = new Actor[2]
  act[0] = Game.GetPlayer()
  act[1] = akSpeaker
  JFAnimStarter.StartScene(act, "doggy", hook = "JFStolen")
  Steal.RegisterForSl()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property JF_Stolen_HornyDog  Auto  

JFStealClothes  Property Steal  Auto  
