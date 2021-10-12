;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_Harsh01_EndScene_077138C3 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Quest myQ = GetOwningQuest()
If(myQ.GetStage() == 35)
	myQ.SetStage(200)
else
	myQ.SetStage(100)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Actor Harsh = Harshnil.GetActorRef()
Harsh.SetRestrained(false)
; Harsh.PlayIdle(GetUp)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Harshnil  Auto

Idle Property GetUp  Auto
