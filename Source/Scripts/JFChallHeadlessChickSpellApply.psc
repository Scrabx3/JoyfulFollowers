Scriptname JFChallHeadlessChickSpellApply extends ActiveMagicEffect

Actor Property PlayerRef Auto
Idle Property BoundHands Auto
Quest Property HeadlessChick  Auto

float  mySpeed

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akCaster.EvaluatePackage()
	Game.DisablePlayerControls(abMovement = false, abFighting = true, abCamSwitch = true, abLooking = false, abSneaking = false, abMenu = false, abActivate = false, abJournalTabs = false)
	Game.ForceFirstPerson()

	int righty = PlayerRef.GetEquippedItemType(1)
	If(righty)
		If(righty == 12 || righty < 9)
			PlayerRef.UnequipItem(PlayerRef.GetEquippedWeapon())
		ElseIf(righty == 10)
			PlayerRef.UnequipItem(PlayerRef.GetEquippedShield())
		ElseIf(righty == 11)
			PlayerRef.UnequipSpell(PlayerRef.GetEquippedSpell(1), 1)
		EndIf
	EndIf

	int lefty = PlayerRef.GetEquippedItemType(0)
	If(lefty)
		If(lefty== 12 || righty < 9)
			PlayerRef.UnequipItem(PlayerRef.GetEquippedWeapon(true))
		ElseIf(lefty== 10)
			PlayerRef.UnequipItem(PlayerRef.GetEquippedShield())
		ElseIf(lefty== 11)
			PlayerRef.UnequipSpell(PlayerRef.GetEquippedSpell(0), 0)
		EndIf
	EndIf

	mySpeed = PlayerRef.GetAV("Speedmult")
	PlayerRef.SetAV("Speedmult", 600)
	PlayerRef.ModAV("CarryWeight", 1)
	Utility.Wait(0.5)
	PlayerRef.ModAV("CarryWeight", -1)
	HeadlessChick.SetStage(10)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	PlayerRef.SetAV("Speedmult", mySpeed)
	PlayerRef.ModAV("CarryWeight", 1)
	Utility.Wait(0.5)
	PlayerRef.ModAV("CarryWeight", -1)
EndEvent
