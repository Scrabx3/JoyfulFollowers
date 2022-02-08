Scriptname JFHarshnil01Harshnil extends ReferenceAlias  

bool breakloop
; Harshnil loads in when the Player enters the Prison Area
Event OnLoad()
  Quest q = GetOwningQuest()
  q.SetStage(15)
  
  Actor me = GetReference() as Actor
  me.SetRestrained(true)
	me.DamageAV("Health", me.GetAV("Health") - 20)

	breakloop = false
  While(q.GetStage() < 30 && !breakloop)
		If (me.GetActorValue("Health") > 20)
			q.SetStage(30)
		EndIf
		Utility.Wait(1)
	EndWhile
EndEvent

Event OnUnload()
  breakloop = true
EndEvent

Event OnDeath(Actor akKiller)
  breakloop = true
  GetOwningQuest().SetStage(999)
EndEvent
