;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIJF__Harsh01PotionGift Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If akSpeaker.ShowGiftMenu(True, PotionList) > 0
	Quest myQ = GetOwningQuest()
	If(myQ.GetStage() == 23)
		myQ.SetStage(35)
	else
		myQ.SetStage(30)
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

FormList Property PotionList  Auto  
