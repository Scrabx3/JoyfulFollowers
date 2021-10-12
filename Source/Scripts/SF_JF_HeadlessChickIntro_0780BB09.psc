;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname SF_JF_HeadlessChickIntro_0780BB09 Extends Scene Hidden

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Event onUpdate()
	Quest myQ = GetOwningQuest()
	If(myQ.GetStage() == 0)
		myQ.Stop()
	EndIf
EndEvent
