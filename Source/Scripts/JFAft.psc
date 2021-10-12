Scriptname JFAft Hidden

Function AFTDismiss(Actor akSpeaker, ObjectReference akSpeakerRef) Global
	TweakDFScript DFScript = Game.GetForm(0x000750BA) as TweakDFScript
	If(DFScript)
		DFScript.DialogueRef = akSpeakerRef
		DFScript.DismissFollower(0, 0)
	Else
		Debug.Notification("Called wrong function..?")
		return
	EndIf
EndFunction
