Scriptname JFHarsh01HealthMonitor extends ReferenceAlias

; (Code mostly copied from Actor "Valdr")
Actor mySelf
Quest ownedQ
bool breakLoop = false
int damagedHealth

; When the Alias is initalized, damage their health so we'll know if it improves (eg. if the player just walks up and casts a heal spell on them)
Function PrepareWound()
	mySelf = GetReference() as Actor
	ownedQ = GetOwningQuest()
	mySelf.SetRestrained(true)
	mySelf.DamageAV("Health", mySelf.GetAV("Health") - 1)
	damagedHealth = mySelf.GetAV("Health") As Int
	RegisterForSingleUpdate(1)
EndFunction

Event OnUnload()
	breakLoop = True
EndEvent

;Periodically check to see if the player has healed Valdr.
Event OnUpdate()
  int timeOut = 0
	While(ownedQ.GetStage() < 30 && !mySelf.IsDead() && !breakLoop)
		If (mySelf.GetAV("Health") > damagedHealth)
			If(ownedQ.GetStage() == 23)
				ownedQ.Setstage(35)
			else
				ownedQ.SetStage(30)
			EndIf
		EndIf
		Utility.Wait(1)
	EndWhile
	breakLoop = False
EndEvent
