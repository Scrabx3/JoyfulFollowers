;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIJF__StolenCollarStayThatWay Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If(JF_Stolen.GetStage() == 900)
	JF_Stolen.SetStage(910)
Else
	JF_Stolen.SetStage(915)
EndIf
Util.FPublicHumiliation = true
Util.FPetPlay = true
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JFEventStorage Property Util  Auto

Quest Property JF_Stolen  Auto

JFCore Property Core  Auto
