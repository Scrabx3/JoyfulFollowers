Scriptname JFMain extends Quest  

Actor CurrentFollower_var
Actor Property CurrentFollower
  Actor Function Get()
    return CurrentFollower_var
  EndFunction
  Function Set(Actor aValue)
		RecruitFollower(aValue)
  EndFunction
EndProperty

; =================================== Util Stuff
JFMain Function Get() global
	return Quest.GetQuest("JF_Main") as JFMain
EndFunction

Function FadeToBlack()
	FadeToBlackImod.Apply()
	Utility.Wait(2.0)
	FadeToBlackImod.PopTo(FadeToBlackHoldImod)
EndFunction
Function FadeBack()
	FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
EndFunction

; ===================================
JFMCM Property MCM Auto
JFPlayerScr Property PlScr Auto
Faction Property LockoutFaction Auto
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property Debt Auto
GlobalVariable Property FavGem Auto
{0 Diamond | 1 Emeralds | 2 Sapphire| | 3 Ruby | 4 Amethyst}
Keyword Property EventTick Auto
Keyword PRoperty EventSleep Auto
MiscObject Property Gold001 Auto
ImageSpaceModifier Property FadeToBlackImod Auto
ImageSpaceModifier Property FadeToBlackHoldImod Auto
ImageSpaceModifier Property FadeToBlackBackImod Auto
; ===================================
; ===================================
Function Maintenance()
	Utility.Wait(1.3)
  RegisterForSleep()
	RegisterForUpdateGameTime(3.0)
EndFunction

Event OnUpdateGameTime()
	If(CurrentFollower == none)
		return
	ElseIf(MCM.bDebug)
		Debug.Notification("<JF> Ticking")
	EndIf
	If(MCM.bDebtEnabled)
		float d = Debt.Value
		If(MCM.debtmodelindex == 0)
			d += Math.Floor(Utility.RandomFloat(0.8, 1.2) * MCM.fDebtSimple / 8)
		Else
			; Debt is reduced based on affection lv: 1 - 0.13 * AffectionLv
			d += PlScr.fStoredGain * (1 - 0.13 * GetAffectionGlobal().GetValue()) * (MCM.fDebtDynamic/100)
		EndIf
		If(d < 500)
			AddAffection(0, true)
			d *= 1 - (MCM.fCreditDecay / 100)
		ElseIf(d > MCM.iDebtThresh)
			DamageAffection(true, true)
		EndIf
		UpdateCurrentInstanceGlobal(Debt)
	EndIf
	AddAffection(0, true)
	SendEvent(EventTick, none, 0, 0)
EndEvent

int sleepstart
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
  sleepstart = Game.QueryStat("Hours Slept")
EndEvent
Event OnSleepStop(bool abInterrupted)
	int slept = (Game.QueryStat("Hours Slept") - sleepstart)
	If(MCM.bDebug)
		Debug.Notification("Time Slept: " + slept)
	EndIf
	SendEvent(EventSleep, none, slept, 0)
EndEvent

bool Function SendEvent(Keyword kywd, ObjectReference akRef2, int aiValue1, int aiValue2)
	Location loc = Game.GetPlayer().GetCurrentLocation()
	bool ret = kywd.SendStoryEventAndWait(loc, CurrentFollower_var, akRef2, aiValue1, aiValue2)
	If(MCM.bDebug)
		Debug.Notification("<JF> Event Started = " + ret)
		Debug.Trace("[JF] Event Call with Keyword = " + kywd + " >> Started = " + ret)
	EndIf
	return ret
EndFunction

Function PayDebt(int pay)
	Game.GetPlayer().RemoveItem(Gold001, pay)
	float d = Debt.GetValue() - pay
	If(!MCM.bCreditEnable && d < 0)
		Debt.Value = 0
	EndIf
	Debt.SetValue(d)
	UpdateCurrentInstanceGlobal(Debt)
EndFunction

; ======================================================
; ================================= API Implementation
; ======================================================
;/
New Affection Scaling assumes to hit Affection Lv4 after 70 days
As for Event Gain, I assume 1 type 2 affection gain per day
Lv4 will requires roughly 1.000 affection
will use a square function to calculate the level, allowing for a quick Lv2, slowing down steadily until Lv4
to reach this through passive gain in 70 days, a gain of ~14.5 per day is sufficient, with 8 ticks per day this is ~1.8 affection per tick, 
hence using +2 affection on a lv1 tick, doubling with each type creates 8 affection for Lv2
assuming 8 additional affection per day, Lv4 is reached after 45 days

f:AffectionLevel(affection) = sqrt(affection + 64)/8
g:AddAffection(type) = 2 << type
h:DamageAffection(severe) = 4 << severe
/;

; Validate this npc as a Follower and assign them a Joyful Follower
bool Function RecruitFollower(Actor npc)
  ReferenceAlias JF = GetNthAlias(1) as ReferenceAlias
	; Dismiss previous Follower
	If(JF.GetReference() != none)
		If(!DismissFollower(true, false))
			return false
		EndIf
	EndIf
	; If a new Follower, validate & recruit them
	If(npc != none)
		If(!ValidRecruit(npc))
			return false
		ElseIf(npc.IsInFaction(LockoutFaction))
			npc.RemoveFromFaction(LockoutFaction)
		EndIf
		CurrentFollower_var = npc
		; Affection, Affectionlevel, Gem, Severity, JFMainEvents data
		If(GetAffection(npc) < 0.0)
			StorageUtil.SetFloatValue(npc, "jfaffection", 0.0)
		EndIf
		UpdateLevel()
		int gem = StorageUtil.GetIntValue(npc, "jffavgem", -1)
		If(gem == -1)
			gem = Utility.RandomInt(0, 4)
			StorageUtil.SetIntValue(npc, "jffavgem", gem)
		EndIf
		FavGem.SetValue(gem)
		GetSeverityGlobal().SetValue(StorageUtil.GetIntValue(CurrentFollower, "jfseverity", 0))
		JFMainEvents.Singleton().LoadData(npc)
		JF.ForceRefTo(npc)
	EndIf
	return true
EndFunction
bool Function ValidRecruit(Actor npc)
	If(!npc.GetLeveledActorBase().IsUnique() || npc.IsChild())
		Debug.Messagebox("<JF Recruit Validation>\nFATAL: An Actor can only be assigned as Joyful Follower if they are Unique and NOT a child.")
		Debug.Trace("[JF] FATAL: Attempted to recruit an unique Actor or Child into >> " + npc, 2)
		return false
	ElseIf(StorageUtil.GetIntValue(CurrentFollower, "jflockout", 0) == 1)
		Debug.Notification(npc.GetLeveledActorBase().GetName() + " doesn't want to get to know you any better.")
		Debug.Trace("[JF] This Follower can no longer be assigned to become a Joyful Follower >> " + npc)
		CurrentFollower.AddToFaction(LockoutFaction)
		return false
	EndIf
	return true
EndFunction
; NOTE: needed? Stopping Quests
; JF_ManualScript.Stop()

; Dismiss the current Follower
bool Function DismissFollower(bool force, bool severe)
  If(CurrentFollower == none)
    Debug.Trace("[JF] WARNING: Can't dismiss a none reference", 1)
		return false
	EndIf
	ReferenceAlias folAlias = GetNthAlias(1) as ReferenceAlias
	If(!force)
		If(Debt.Value > 0)
			return false
		EndIf
	EndIf
	If(severe)
		CurrentFollower.SetRelationshipRank(Game.GetPlayer(), -2)
		CurrentFollower.AddToFaction(LockoutFaction)
		StorageUtil.SetIntValue(CurrentFollower, "jflockout", 1)
		StorageUtil.SetFloatValue(CurrentFollower, "jfAffection", 0)
		StorageUtil.SetFloatValue(CurrentFollower, "jfAffectionLv", 0)
	Else
		StorageUtil.SetFloatValue(CurrentFollower, "jfAffection", GetAffection(CurrentFollower))
		StorageUtil.SetFloatValue(CurrentFollower, "jfAffectionLv", GetAffectionGlobal().GetValue())
	EndIf
	StorageUtil.SetIntValue(CurrentFollower, "jfseverity", GetSeverityGlobal().GetValueInt())
	Debt.Value = 0
	JFMainEvents.Singleton().StoreData(CurrentFollower)
	(GetNthAlias(1) as ReferenceAlias).Clear()
	CurrentFollower.SendModEvent("JFDismissFollowerComplete", "", 0)
	CurrentFollower = none
	return true
EndFunction

; Add Affection based on type:
; 0 - Flattering
; 1 - Minor Interaction
; 2 - Event
; 3 - Unique Interactions & Questlines
Function AddAffection(int type, bool forcesilent)
	float affection = GetAffection(CurrentFollower)
  If(affection == -2)
    Debug.MessageBox("[JF] FATAL: Can't increase Affection while no Follower is with you")
    Debug.Trace("[JF] FATAL: <AddAffection> but no Follower found", 2)
    return
  EndIf
	affection += Math.LeftShift(2, type)
	StorageUtil.SetFloatValue(CurrentFollower, "jfaffection", affection)
	If(!forcesilent && type == 0)
		Debug.Notification(CurrentFollower.GetLeveledActorBase().GetName() + " liked that.")
	EndIf
	UpdateLevel()
EndFunction

; Math for the damage of Affection
Function DamageAffection(bool severe, bool forcesilent)
  float affection = GetAffection(CurrentFollower)
  If(affection == -2)
    Debug.MessageBox("[JF] FATAL: Can't damage Affection while no Follower is with you")
    Debug.Trace("[JF] FATAL: <DamageAffection> but no Follower found", 2)
    return
  EndIf
	affection -= Math.LeftShift(4, severe as int)
	StorageUtil.SetFloatValue(CurrentFollower, "jfaffection", affection)
	If(!forcesilent)
		Debug.Notification(CurrentFollower.GetLeveledActorBase().GetName() + " disliked that.")
	EndIf
	UpdateLevel()
EndFunction

; Update affection level for the current Follower
Function UpdateLevel()
	If(CurrentFollower == none)
		GetAffectionGlobal().Value = 0
	EndIf
	float affection = GetAffection(CurrentFollower)
  GetAffectionGlobal().Value = math.floor(math.sqrt(affection + 64)/8)
EndFunction

; Return the current Affection for a given NPC
float Function GetAffection(Actor npc) global
	If(!npc)
		return -2
	EndIf
  return StorageUtil.GetFloatValue(npc, "jfaffection", -1.0)
EndFunction

; Return the Global stating Affection Level for the Current Follower
GlobalVariable Function GetAffectionGlobal() global
  return Game.GetFormFromFile(0x005738, "JoyfulFollowers.esp") as GlobalVariable
EndFunction

; Return the Global stating Severity Level for the Current Follower
GlobalVariable Function GetSeverityGlobal() global
  return Game.GetFormFromFile(0x8EF8D3, "JoyfulFollowers.esp") as GlobalVariable
EndFunction