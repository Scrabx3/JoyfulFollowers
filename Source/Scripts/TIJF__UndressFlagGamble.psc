;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIJF__UndressFlagGamble Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
akspeaker.OpenInventory()
GetOwningQuest().Stop()

If(Utility.RandomInt(0, 99) < 60)
	If(Utility.RandomInt(0, 99) < 33)
		Util.FPublicHumiliation = false
	else
		Util.FTorture = true
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JFEventStorage Property Util  Auto  
