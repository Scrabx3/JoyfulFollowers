;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIJF__StolenHornyDogMsg Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;Serve him
If(JF_Stolen_HornyDog.Show() == 0)
  Core.StartSexStolen(akSpeaker, "vaginal, doggy")
  Steal.RegisterForSl()
EndIf
;/This dialogue tree is one time only no need
 for a "lockout stage" that may conflict with
 other choices/;
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property JF_Stolen_HornyDog  Auto  

JFCore Property Core  Auto  

JFStealClothes  Property Steal  Auto  
