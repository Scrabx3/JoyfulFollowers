;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_JF_MyCut_Start_073F374A Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
RegisterForSingleUpdate(120)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
If(GetOwningQuest().GetStage() < 10)
	GetOwningQuest().Stop()
Else
	Actor JF = JoyFol.GetReference() as Actor

	; Disable the Follower & Register for Update in the Mainscript to start the respawn Scene
	JoyFol.GetActorRef().Disable()
	JFMyCut Cut = GetOwningQuest() as JFMyCut
	Cut.RegisterForSingleUpdateGameTime(Utility.RandomInt(6, Cut.MCM.iMaxTimeOut))
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property JoyFol  Auto  

Actor Property PlayerRef  Auto  

Event OnUpdate()
	If(JoyFol.GetReference().IsInDialogueWithPlayer())
		; if Follower is currently talking with Player we check again a while later as that may be the Cut Dialogue ..
		RegisterForSingleUpdate(10)
		return
	ElseIf(GetOwningQuest().GetStage() < 10)
		; If the Player isnt talking to the Follower && MyCuts Starting Dialogue didnt SetStage to 10 (Player gave no money to follower), close the Quest
		GetOwningQuest().Stop()
	EndIf
EndEvent
