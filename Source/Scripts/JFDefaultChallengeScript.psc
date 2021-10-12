Scriptname JFDefaultChallengeScript extends ReferenceAlias
{Script with some Utility Functions to set the owning Quest to a specific Stage on specific Actions. Should be attached to the Player}

Keyword Property LocTypeDungeon Auto
{Autofill me}

int Property challengeStart = 10 Auto
{Stage at which the challenge is considered active, must be lower than 100; Default: 10}

int Property challengeLost = 200 Auto
{Stage to set when a rule is being broken & the challenge Lost; Default: 200}

bool Property leaveArea = true Auto
{If leaving the Challenges starting loc is considered a rulebreak; Default: true}

bool Property equipArmor = false Auto
{If equipping Armor is considered a rulebreak; Default: false}

Armor[] Property equipArmorExceptions Auto
{An Array of Armors that can be equipped when the equipArmor rule is active}

Keyword[] Property equipArmorExceptionKW Auto
{Armors that have one of the Keywords in this Array can still be equipped when the equipArmor rule is active}

bool Property equipWeapon = false Auto
{If equipping a Weapon is considered a rulebreak; Default: false}

Weapon[] Property equipWeaponExceptions Auto
{An Array of Weapons that can be equipped when the equipWeapon rule is active}

Keyword[] Property equipWeaponsExceptionKW Auto
{Weapons that have one of the Keywords in this Array can still be equipped when the equipWeapon rule is active}

Event OnLocationChange(Location akOldLoc, Location aknewLoc)
	Quest myQuest = GetOwningQuest()
	If(!akOldLoc.IsSameLocation(aknewLoc, LocTypeDungeon) && myQuest.GetStage() < 100)
		If(myQuest.GetStage() >= challengeStart)
			If(leaveArea)
				myQuest.Stop()
			EndIf
		else
			myQuest.SetStage(challengeLost)
		EndIf
	EndIf
EndEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Quest myQuest = GetOwningQuest()
	If(myQuest.GetStage() < challengeStart)
		return
	EndIf
	If(!UI.IsMenuOpen("InventoryMenu") && !UI.IsMenuOpen("FavoritesMenu"))
		return
	ElseIf(akBaseObject as Weapon && equipWeapon)
		If(equipWeaponExceptions.Find(akBaseObject as Weapon) < 0)
			myQuest.SetStage(challengeLost)
		Else
			int Count = equipWeaponsExceptionKW.Length
			While(Count)
				Count -= 1
				If(akReference.HasKeyword(equipWeaponsExceptionKW[Count]))
					return
				EndIf
			EndWhile
		EndIf
	ElseIf(akBaseObject as Armor && equipArmor)
		If(equipArmorExceptions.Find(akBaseObject as Armor) < 0)
			myQuest.SetStage(challengeLost)
		Else
			int Count = equipArmorExceptionKW.Length
			While(Count)
				Count -= 1
				If(akReference.HasKeyword(equipArmorExceptionKW[Count]))
					return
				EndIf
			EndWhile
		EndIf
	EndIf
EndEvent
