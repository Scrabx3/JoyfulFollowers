Scriptname JFDefaultHealthMonitor extends ReferenceAlias
{Script to monitor an Actors health, setting a Queststage when healed or killing them after some time}

Quest Property myQuest Auto
{The Quest whichs Stage to set}

int Property stageToSet Auto
{The Quest Stage to set upon being healed}

bool Property canKill = false Auto
{Optional: Kill the Actor if too much time passed; Default: false}

int Property timeTillKill = 300 Auto
{Used with canKill: The amount of seconds until the Actor dies; Default: 300}

; ---------------------- Code mostly copied from Actor "Valdr"
Actor mySelf
bool breakLoop = false
bool doOnce = false
int damagedHealth

; When the Alias is initalized, damage their health so we'll know if it improves (eg. if the player just walks up and casts a heal spell on them)
Event OnInit()
	if (!doOnce)
    mySelf = GetReference() as Actor
		mySelf.DamageAV("Health", mySelf.GetAV("Health") - 1)
		damagedHealth = mySelf.GetAV("Health") As Int
		doOnce = True
	EndIf
	UpdateLoop()
EndEvent

Event OnUnload()
	breakLoop = True
EndEvent

;Periodically check to see if the player has healed Valdr.
Function UpdateLoop()
  int timeOut = 0
	While(myQuest.GetStage() < stageToSet && !mySelf.IsDead() && !breakLoop)
		If (mySelf.GetAV("Health") > damagedHealth)
			myQuest.Setstage(stageToSet)
		EndIf
		; If player took too long to heal them, kill them
		If(canKill)
			If(timeOut >= timeTillKill)
				mySelf.Kill()
			EndIf
			timeOut += 1
		EndIf
		Utility.Wait(1)
	EndWhile
	breakLoop = False
EndFunction
