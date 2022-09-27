Scriptname JFStolen extends Quest  

JFStolenSatchelAlias Property Satchel Auto
ReferenceAlias Property PetDog Auto

ImageSpaceModifier Property FadeToBlackHoldImod Auto
ImageSpaceModifier Property FadeToBlackBackImod Auto

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  ; SE exclusive: Check if there is something to strip | No point for this quest if theres nothing steal
  If(SKSE.GetVersion() > 2.0 && !Game.GetPlayer().GetEquippedArmorInSlot(0x4) || Game.GetPlayer().GetNumItems() < 5)
    Stop()
    return
  EndIf
  ; Quest starts during the blackout of the SleepEnd Event, keep the Screen blacked out until were done
  FadeToBlackHoldImod.Apply()
  Satchel.PrepSatchel()
  If(JFAnimStarter.GetArousal(PetDog.GetReference() as Actor) > 30)
    SetStage(1)
  EndIf
  ; Propertly start the quest
  JoyfulFollowers.LockTimeout()
  RegisterForModEvent("HookAnimationEnding_JFStolen", "AfterSex")
  SetStage(10)
  FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
EndEvent

Event StolenAfterSex(int tid, bool HasPlayer)
  Actor follower = JoyfulFollowers.GetFollower()
	If(JFAnimStarter.GetSceneActors(tid).find(follower) > -1)
    ; Doggy Scene with Follower | Begging
    SetStage(100)
  Else
  	; Scene with Pet
    If(follower.HasLoS(Game.GetPlayer()))
      JFMainEvents.Singleton().Bestiality = true
    EndIf
		SetStage(210)
	EndIf
EndEvent
