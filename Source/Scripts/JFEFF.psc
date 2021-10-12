Scriptname JFEFF Hidden

Function EFFDismiss(Actor akSpeaker) Global
	EFFCore EFFCoreScr = Game.GetFormFromFile(0x00000EFF, "EFFCore.esm") as EFFCore

	if (EFFCoreScr)
		EFFCoreScr.XFL_RemoveFollower(akspeaker, 0, 0)
	else
		debug.notification("Called wrong function..?")
		return
	endIf
EndFunction
