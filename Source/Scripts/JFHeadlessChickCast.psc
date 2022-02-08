Scriptname JFHeadlessChickCast extends ActiveMagicEffect  

Quest Property HeadlessChick Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akCaster.EvaluatePackage()
	Game.DisablePlayerControls(abMovement = false, abFighting = false, abCamSwitch = true, abLooking = false, abSneaking = true, abMenu = false, abActivate = false, abJournalTabs = false)
	Game.ForceFirstPerson()

	int righty = akTarget.GetEquippedItemType(1)
	If(righty)
		If(righty == 12 || righty < 9)
			akTarget.UnequipItem(akTarget.GetEquippedWeapon())
		ElseIf(righty == 10)
			akTarget.UnequipItem(akTarget.GetEquippedShield())
		ElseIf(righty == 11)
			akTarget.UnequipSpell(akTarget.GetEquippedSpell(1), 1)
		EndIf
	EndIf

	int lefty = akTarget.GetEquippedItemType(0)
	If(lefty)
		If(lefty== 12 || righty < 9)
			akTarget.UnequipItem(akTarget.GetEquippedWeapon(true))
		ElseIf(lefty== 10)
			akTarget.UnequipItem(akTarget.GetEquippedShield())
		ElseIf(lefty== 11)
			akTarget.UnequipSpell(akTarget.GetEquippedSpell(0), 0)
		EndIf
	EndIf

	HeadlessChick.SetStage(10)
EndEvent
