Scriptname JFCore extends Quest Conditional

; ------------------------------------- Property
SexLabFramework Property SL Auto
JFMCM Property MCM Auto
JFEventStorage Property Util Auto
JFPlayerScr Property PlayerScr Auto
Actor Property PlayerRef Auto
ReferenceAlias Property JoyFolRef Auto
GlobalVariable Property Affection Auto
GlobalVariable Property Stress Auto
GlobalVariable Property Fatigue Auto
;	Event Sources
Keyword Property TickEventKW Auto
Keyword Property LocEventKW Auto
Keyword Property SleepEventKW Auto
Keyword Property GameEventKW Auto
; -------- Quests
Quest Property JF_ManualScript Auto
Quest Property JF_ChainEvents Auto
; -------- Misc
MiscObject Property Gold001 Auto
Faction Property JF_NeverJoyFol_Faction Auto
Armor Property JF_Util_DogCollar_Inv Auto
;	Sleep Debuff
Perk Property JF_Core_FatigueDebuff_Perk_Lv1 Auto
Perk Property JF_Core_FatigueDebuff_Perk_Lv2 Auto
Perk Property JF_Core_FatigueDebuff_Perk_Lv3 Auto
;	Debt
GlobalVariable Property JF_Debt Auto
;	FadeToBlack
ImageSpaceModifier Property JFFadeToBlackImod  Auto
ImageSpaceModifier Property FadeToBlackHoldImod  Auto
ImageSpaceModifier Property FadeToBlackBackImod  Auto
; ------------------------------------- Variables
Actor Property JoyFol Auto Hidden ;Actor Property for the current JF
int Property FavoriteGem Auto Hidden Conditional
; 0 - Diamond | 1 - Emerald | 2 - Sapphire | 3 - Ruby | 4 - Amethyst
bool Property bFollowerCanLeave Auto Hidden Conditional
; See "Lock Out"
bool Property lockOut = false Auto Hidden Conditional
float lockOutDur = 0.0

int Property affectionBoost = 0 Auto Hidden
; Affection Gain is increased for this many Gains
int Property affectionBoostAmount = 1 Auto Hidden
; Affection gain is multiplied by this while affectionBoost > 0

; ------------------------------------- Code
; =========================================================
; ========================	Public	=======================
; =========================================================

;/ ------------------------ SendStoryEvent
- 	 Source		+			Tick		+			Loc		  +		 Sleep		 +		Game
1.  Location	-								Current Player Location
2. 	 akRef1		-										JoyFol Reference
3. 	 akRef2		- 												none
4.  aiValue1	-					Is location Wilderness? 1 - Yes | 0 - No*
5.  aiValue2 	- 			0			-				0			-		Sleep Dur		-				0

;/	------------------------ Affection
Affection is divided in 5 Ranks:
-   LEVEL 	- AFFECTION	-	QUEST STAGE -  		E V E N T S			-
1. Level 1	-		 0 			-	    100			- 				None				-
2. Level 2	-		 50			-	    200			-					SFW 				-
3. Level 3	-		2300		-	    400			-		Borderline NSFW 	-
4. Level 4	-		4900		-	    600			-					NSFW				-
5. Level 5	-		10000	 	-	    800			-			State Events		-
/;
; *-*-*-*-*-*-* Parameters *-*-*-*-*-*-*
;	more: Wether or not to increase the amount of Affection gained
; silent: If the notification is allowed to be displayed (if enabled)
Function GainAffection(bool more = false, bool silent = false)
	float LesPoints = Affection.Value
	float toGain
	If(more == false)
		toGain = (5 * PersonalityMultiplier * Utility.RandomFloat(0.5, 1.5))
	Else
		toGain = (10 * PersonalityMultiplier * Utility.RandomFloat(0.5, 1.5))
	EndIf
	; Multiplier
	If(affectionBoost > 0)
		toGain *= affectionBoostAmount
		affectionBoost -= 1
	else
		affectionBoostAmount = 1
	EndIf
	; Quest Stage
	LesPoints += toGain
	If(LesPoints >= 10000) ;"Extreme things"
		SetStage(800)
	ElseIf(LesPoints >= 4900) ;NSFW content
		SetStage(600)
	ElseIf(LesPoints >= 2300) ;"Questionable" Content
		SetStage(400)
	ElseIf(LesPoints >= 100) ;SFW Content
		SetStage(200)
	EndIf
	; Setting Global & Notify
	Affection.SetValue(LesPoints)
	If(MCM.bDeNo == true)
		Debug.Notification("Affection gain: " + toGain)
	ElseIf(MCM.bShowAffectionChange == true && !silent)
		Debug.Notification(JoyFol.GetLeveledActorBase().GetName() + " liked that")
	EndIf
EndFunction

Function LoseAffection(bool more = false, bool silent = false)
	float LesPoints = Affection.Value
	float AffectionToLose
	If(more == false)
		AffectionToLose -= (10 * PersonalityMultiplier * Utility.RandomFloat(0.5, 1.5))
	Else
		AffectionToLose -= (30 * PersonalityMultiplier * Utility.RandomFloat(0.5, 1.5))
	EndIf
	LesPoints -= AffectionToLose
	Affection.SetValue(LesPoints)
	If(MCM.bDeNo == true)
		Debug.Notification("Affection loss: " + AffectionToLose)
	ElseIf(MCM.bShowAffectionChange == true && !silent)
		Debug.Notification(JoyFol.GetLeveledActorBase().GetName() + " disliked that")
	EndIf
EndFunction

; Increase Affection Gain for a specific Amount of time.
; Stacks with previous calls
; *-*-*-*-*-*-* Parameters *-*-*-*-*-*-*
; Duration => Amount of ticks Affection is increased
; increase => Affection gain increase as multiplicator
Function ManipulateAffection(int duration, int increase)
	affectionBoost += duration
	affectionBoostAmount *= increase
endFunction

; ------------------------ Mental (Stress)
;/Followers mental state. How stressed out/annoyed they are
Changes the way some Dialogue behaves and which Events can start. The Keypoint here is that high Mental should reduce the amount of Events that can play, not increase it

Mental caps out at 40
0 - Calm
18 - Annoyed
32 - Angry
/;
Function Mental(bool more = false, bool less = false)
	int LesPoints = 0
	If(GetStage() < 100)
		Return ;Dont change mental if theres no follower with you
	EndIf
	If(more == false)
		LesPoints += 4
	elseIf(less)
		LesPoints += 2
	else
		LesPoints += 8
	EndIf
	Stress.value += LesPoints
	If(Stress.value > 40)
    Stress.value = 40
	EndIf
EndFunction

Function Relax(bool more = false)
	float LesPoints = Stress.value
	If(more)
		LesPoints -= 6
	else
		LesPoints -= 3
	EndIf
	If(LesPoints < 0)
		LesPoints = 0
	EndIf
	Stress.value = LesPoints
EndFunction

; ------------------------ Tiredness (Fatigue)
;/ How tired the player is. "The higher this is, the easier it is for the Follower to take advantage of the player"

Fatigue caps out at 46, full recovery after 13h sleep, assuming yorue not bound
0 - Wake
16 - Sleepy
28 - Tired
37 - Wasted
/;
Function Tired(bool sex = false, bool less = false)
	int LesPoints = 0
  If(Sex == true)
  	LesPoints += 2
	Else
  	LesPoints += 5
	EndIf
	If(less)
		LesPoints = Math.Ceiling(LesPoints / 3)
	EndIf
	Fatigue.Value += LesPoints
	If(Fatigue.Value >= 46)
		Fatigue.Value = 46
	EndIf
	;Applying debuf perks..
	GetSleepStage()
EndFunction

; ------------------------------------- LockOut
;/Lock Out disabls all Dialogue with the Follower with the Exception of Dismissing & Traiding and will completely mute the Follower. Dismissing a Follower while Lock Out is active will completely disable them as a Follower permanently (until a Caching System is in palce)
Lock Out lasts a specified amount of Ticks, Default Lockout Period should be considered 2 Ticks (12 hours)/;
Function LockOut(int howLong = 2)
	lockOut = true
	lockOutDur += howLong
	LoseAffection(true)
	MCM.bCooldown = false
endFunction

; ------------------------------------- StartUp
;	Function to assign a new Joyful Follower
; --------- Param
;	newJF: The Actor to assign as a JF.
;	Lv: At which Affection Stage to start. Maybe the Follower already knows the player? 1 for Lv1, 2 for Lv2, 3 for Lv3, 4 for Lv4 and 5 for Lv5
;	favGem: The favoriteGem of the Follower, used in the Present Feature. See Variables at the top to know which Number is assigned which Gem
Bool Function AssignNewJoyFol(Actor newJF, int Lv = 1, int favGem = 77)
	;Cleanup previous JF if there was one
	If(JoyFolRef.GetReference())
		DismissJoyFol()
		Utility.WaitMenuMode(1)
	EndIf
	;Reference
	If(NewJF.IsInFaction(JF_NeverJoyFol_Faction))
		NewJf.RemoveFromFaction(JF_NeverJoyFol_Faction)
	EndIf
  JoyFolRef.ForceRefTo(newJF)
	JoyFol = JoyFolRef.GetReference() as Actor
	;Affection
	SetAffection(Lv)
	;Domination
	; If(Relation == 0)
	; 	SDP.Value = Utility.RandomInt(-3, 3)
	; else
	; 	SDP.Value = Relation
	; EndIf
	;Define favorite Gem
	If(favGem > 4)
		FavoriteGem = Utility.RandomInt(0, 4)
	else
		FavoriteGem = favGem
	EndIf
	Stress.SetValue(Utility.RandomInt(0, 6))
	PersonalityMultiplier = Utility.RandomFloat(0.8, 1.5)
	;	ManualScript: A Collection of Miniquests that can be started by the Player through Dialogue or by the Mod through random Script Events
	;	Chain Events: Small Events that other Events may hook into
	JF_ManualScript.Start()
	JF_ChainEvents.Start()
	MCM.bCooldown = true
EndFunction

; --------------------------------------- Events
;	Use this Function to request a Punishment Game to start
Function SendGameEvent()
	If(GameEventKW.SendStoryEventAndWait(PlayerRef.GetCurrentLocation(), JoyFol, none, PlayerScr.isWilderness, 0))
		JoyFol.EvaluatePackage()
	endIf
endFunction


Function DogCollar(Actor Pet, bool starting = true)
	If(Starting == true)
		Util.KDogCollarCrawling = true
		Pet.AddItem(JF_Util_DogCollar_Inv, 1, true)
		Pet.EquipItem(JF_Util_DogCollar_Inv, true)
	Else
		Pet.UnequipItem(JF_Util_DogCollar_Inv)
		Pet.RemoveItem(JF_Util_DogCollar_Inv, 1, true)
	EndIf
EndFunction

;	------------------------------------- Utility
;	Stole this from the Vanilla Game :)
Function FadeBlack()
	JFFadeToBlackImod.Apply()
	Utility.Wait(0.5)
	JFFadeToBlackImod.PopTo(FadeToBlackHoldImod)
endFunction

Function FadeBlackBack()
	Utility.Wait(0.5)
	FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
	FadeToBlackHoldImod.Remove()
endFunction


Function StealClothes()
	int Current = 4
	Armor ThisSlot
	While(Current > 0)
		If(Current == 4) ;Body
			ThisSlot = PlayerRef.GetWornForm(0x00000004) as armor
		ElseIf(Current == 3) ;Hands
			ThisSlot = PlayerRef.GetWornForm(0x00000008) as armor
		ElseIf(Current == 2) ;Boots
			ThisSlot = PlayerRef.GetWornForm(0x00000080) as armor
		ElseIf(Current == 1) ;Bottom Piece
			ThisSlot = PlayerRef.GetWornForm(0x00400000) as armor
		EndIf
		If(!ThisSlot.HasKeyWordString("zad_Lockable"))
			PlayerRef.RemoveItem(ThisSlot, 7, true, JoyFol)
		EndIf
		Current -= 1
	EndWhile
endFunction

; =========================================================
; =====================   Internals  ======================
; =========================================================
;	------------------------------------- Variables
; Internal Pollings
int TLeaveTokenTicks = 0
int SleepStart
string FatigueStage = "Stage 0"
string DebtStage = "Debt 0"
float PersonalityMultiplier
;	FNIS
int Property StoredCRC Auto Hidden
int Property FnisModID Auto hidden
int Property JFFB0 Auto Hidden ;Idle
int Property JFFB1 Auto Hidden ;Movement1
int Property JFFB2 Auto Hidden ;Movement2
int Property JFFB3 Auto Hidden ;Sneak1
int Property JFFB4 Auto Hidden ;Sneak2
int Property JFFB5 Auto Hidden ;1Handed,

; ------------------------------------- Update Cycle & Sleep
Function SendEvent(Keyword Source, Location Loc = none, ObjectReference Ref2 = none, int Val2 = 0)
	If(MCM.bCooldown && GetStage() >= 100)
		If(Utility.RandomInt(1, 100) <= MCM.iEvent)
			If(!Loc)
				Loc = PlayerRef.GetCurrentLocation()
			EndIf
			If(MCM.bDeNo)
				Debug.Notification("Event called: " + Source.GetString() + ", Loc: " + Loc.GetName())
				If(Source.SendStoryEventAndWait(Loc, JoyFol, Ref2, PlayerScr.isWilderness, Val2))
					Debug.Notification("Event started")
					JoyFol.EvaluatePackage()
				else
					Debug.Notification("Nothing....")
				endif
			elseIf(Source.SendStoryEventAndWait(Loc, JoyFol, Ref2, PlayerScr.isWilderness, Val2))
				JoyFol.EvaluatePackage()
			EndIf
		EndIf
	EndIf
endFunction

; ------------------------ Circles
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
  SleepStart = Game.QueryStat("Hours Slept")
EndEvent

Event OnSleepStop(bool abInterrupted)
	int TimeSlept = (Game.QueryStat("Hours Slept") - SleepStart)
	;Send Story Event before regenerating Fatigue
	SendEvent(SleepEventKW, Val2 = TimeSlept)
	;debug
	If(MCM.bDeNo == true)
		Debug.Notification("Time Slept: " + TimeSlept)
	EndIf
	;Follower Stuff
	ReduceMental(TimeSlept * 2)
	If(TimeSlept >= MCM.iTick)
		(JoyFolRef as JFJoyFolScr).ReduceHits()
	EndIf
	;Player Fatigue
	If(!abInterrupted)
		Sleep(TimeSlept)
	else
		Sleep(TimeSlept - 1)
	EndIf
EndEvent

Event OnUpdateGameTime()
	If(MCM.bDeNo == true)
		Debug.Notification("Ticking..")
	EndIf
	If(GetStage() < 100)
		Tired(less = true)
		return
	EndIf
	;Debt
	If(MCM.bDebtEnabled == true)
		int Debt = JF_Debt.value as int
		GainDebt()
		If(Debt < 0)
			DebtStage = "Debt 0"
			GainAffection(true, true)
			If(PlayerScr.LocType != "Town")
	    	Mental(less = true)
	  	EndIf
	  	Tired(less = true)
			;Handling Credit decay here as it can only fire when Debt < 0
			Debt *= 1 - MCM.iCreditDecay
			RegisterForSingleUpdateGameTime(MCM.iTick)
			; ------------------------------------------------------------
		ElseIf(Debt < MCM.iDebtSeg1)
			DebtStage = "Debt 1"
			If(PlayerScr.LocType != "Town")
				Mental(less = true)
			endIf
			Tired(less = true)
			GainAffection(silent = true)
			RegisterForSingleUpdateGameTime(MCM.iTick)
			; ------------------------------------------------------------
		ElseIf(Debt < MCM.iDebtSeg2) ; Past Segment 1
			DebtStage = "Debt 2"
			If(PlayerScr.LocType != "Town")
				Mental()
			endIf
			Tired(less = true)
			GainAffection(silent = true)
			RegisterForSingleUpdateGameTime(MCM.iTick)
			If(MCM.bDebtLockOut && MCM.iDebtLockoutSeg == 1)
				LockOut(1)
			EndIf
			; ------------------------------------------------------------
		ElseIf(Debt < MCM.iDebtSeg3) ; Past Segment 2
			DebtStage = "Debt 3"
			Mental()
			Tired(less = true)
			If(MCM.bDebtLockOut && MCM.iDebtLockoutSeg == 2)
				LockOut(1)
			EndIf
			RegisterForSingleUpdateGameTime(MCM.iTick)
			; ------------------------------------------------------------
		Else ; Past Segment 3
			DebtStage = "Debt 4"
			Mental()
			Tired(less = true)
			LoseAffection()
			If(Stress.Value > 32 && MCM.bDebtBadEnd == true && (Utility.RandomInt(0, 100) < 45))
				bFollowerCanLeave = true
			Else
				bFollowerCanLeave = false
			EndIf
			If(MCM.bDebtLockOut && MCM.iDebtLockoutSeg == 3)
				LockOut(1)
			EndIf
			RegisterForSingleUpdateGameTime(MCM.iTick)
		EndIf
	Else
		;Default Mental, Fatigue, Affection
		If(PlayerScr.LocType != "Town")
    	Mental(less = true)
  	endIf
  	Tired(less = true)
		GainAffection(silent = true)
		RegisterForSingleUpdateGameTime(MCM.iTick)
	EndIf
	;leave Tokens
	If(Util.TLeaveToken > 0)
		If(TLeaveTokenTicks < 254)
			TLeaveTokenTicks += 1
		Else
			TLeaveTokenTicks = 0
			Util.TLeaveToken -= 1
		EndIf
	EndIf
	;	LockOut Check
	If(lockOut)
		lockOutDur -= 0.5
		If(lockOutDur <= 0)
			lockOut = false
			lockOutDur = 0
			MCM.Cooldown(true)
		EndIf
	EndIf
	; Tick Event Call
	SendEvent(TickEventKW)
EndEvent

; ------------------------------------- StartUp
Function Maintenance(bool OnInit = false)
	Utility.Wait(1.3)
	RegisterForModEvent("HookAnimationStart", "OnAnimStart")
  RegisterForSingleUpdateGameTime(MCM.iTick)
  RegisterForSleep()
	;Mod Checks
	MCM.CheckMods()
	;FNIS
	int CurrentCRC = FNIS_aa.GetInstallationCRC()
	If(CurrentCRC != StoredCRC || OnInit == true)
		FnisModID = FNIS_aa.GetAAmodID("JFF", "JoyFulFollowers")
		;JFFB = Joyful Followers Fnis Base
		JFFB0 = FNIS_aa.GetGroupBaseValue(FnisModID, FNIS_aa._mtidle(), "JoyfulFollowers", True)
		JFFB1 = FNIS_aa.GetGroupBaseValue(FnisModID, FNIS_aa._mt(), "JoyfulFollowers", True)
		JFFB2 = FNIS_aa.GetGroupBaseValue(FnisModID, FNIS_aa._mtx(), "JoyfulFollowers", True)
		JFFB3 = FNIS_aa.GetGroupBaseValue(FnisModID, FNIS_aa._sneakidle(), "JoyfulFollowers", True)
		JFFB4 = FNIS_aa.GetGroupBaseValue(FnisModID, FNIS_aa._sneakmt(), "JoyfulFollowers", True)
		JFFB5 = FNIS_aa.GetGroupBaseValue(FnisModID, FNIS_aa._1hmatk(), "JoyfulFollowers", True)
		CurrentCRC = StoredCRC
	EndIf
	If(MCM.bDeNo || OnInit)
		Debug.Notification("JF: Initialized")
	EndIf
EndFunction

int Function SetAffection(int Level)
	If(Level == 1)
		SetStage(100)
		Affection.Value = 0
	ElseIf(Level == 2)
		SetStage(200)
		Affection.Value = 400
	ElseIf(Level == 3)
		SetStage(400)
		Affection.Value = 2900
	ElseIf(Level == 4)
		SetStage(600)
		Affection.Value = 5500
	ElseIf(Level == 5)
		SetStage(800)
		Affection.Value = 10000
	else
		Debug.Notification("Invalid Call on SetAffection, using Default")
		SetAffection(1)
	endIf
endFunction

Function DismissJoyFol()
	ReduceDebt(JF_Debt.GetValue() as int)
	MCM.Cooldown(true)
	JoyFolRef.TryToClear()
	JoyFol = none
	;Stopping Quests
	JF_ManualScript.Stop()
	JF_ChainEvents.Stop()
	;Resetting Core
	Util.ResetMe()
	Reset()
EndFunction

; ------------------------------------- System
; ------------------------ Affection
;	Only used in JFPResents
Function AddAffection(int howmuch)
	Affection.value += howmuch
	If(MCM.bDeNo == true)
		Debug.Notification("Affection gain: " + howmuch)
	ElseIf(MCM.bShowAffectionChange == true)
		Debug.Notification(JoyFol.GetActorBase().GetName() + "liked that")
	EndIf
EndFunction

; ------------------------ Mental
; This should only be called through Sleeping
Function ReduceMental(int howmuch)
	float LesPoints = Stress.value
	LesPoints -= howmuch
	If(LesPoints < 0)
		LesPoints = 0
	EndIf
	Stress.value = LesPoints
EndFunction

; ------------------------ Fatigue
; Below Functions should only be called through Sleeping
Function Sleep(int TimeSlept)
	float LesPoints = Fatigue.value
	LesPoints -= (-1.0+(1.3*(Math.pow(2, (0.4*TimeSlept))))) ; Math \o/
  If(LesPoints < 0)
    LesPoints = 0
  EndIf
	Fatigue.SetValue(LesPoints)
	;Applying debuf perks..
	GetSleepStage()
EndFunction

Function GetSleepStage()
	float LesPoints = Fatigue.value
	If(LesPoints < 16 && FatigueStage != "Stage 0")
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv1)
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv2)
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv3)
		FatigueStage = "Stage 0"
	ElseIf(LesPoints < 28 && FatigueStage != "Stage 1")
		PlayerRef.AddPerk(JF_Core_FatigueDebuff_Perk_Lv1)
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv2)
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv3)
		FatigueStage = "Stage 1"
	ElseIf(LesPoints < 37 && FatigueStage != "Stage 2")
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv1)
		PlayerRef.AddPerk(JF_Core_FatigueDebuff_Perk_Lv2)
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv3)
		FatigueStage = "Stage 2"
	ElseIf(LesPoints >= 37 && FatigueStage != "Stage 3")
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv1)
		PlayerRef.RemovePerk(JF_Core_FatigueDebuff_Perk_Lv2)
		PlayerRef.AddPerk(JF_Core_FatigueDebuff_Perk_Lv3)
		FatigueStage = "Stage 3"
	EndIf
EndFunction

; ------------------------ Debt
;/ Optional debt system, divided into 5 segments:
Lv0: Has Credit - Affection gain increased
Lv1: No Debt ---- No special treatment!
Lv2: Low debt --- Increased stress gain
Lv3: High debt -- Debt 2 + No Affecion Gain, Stress increases in town
Lv4: Excs. Debt - Debt 3 + Lose affection instead, Follower can leave
/;
Function GainDebt()
	If(MCM.bDebtComplex == false)
		JF_Debt.Value += Math.Floor(Utility.RandomFloat(0.8, 1.2) * MCM.iDebtGain / 3)
	Else
		;Affection & Stress affects payment
		;Affection
		float DebtGain
		If(GetStage() < 200)
			DebtGain = PlayerScr.fStoredGain * MCM.fDebtBasePay
		ElseIf(GetStage() < 400)
			DebtGain = PlayerScr.fStoredGain * (MCM.fDebtBasePay*0.9)
		ElseIf(GetStage() < 600)
			DebtGain = PlayerScr.fStoredGain * (MCM.fDebtBasePay*0.76)
		ElseIf(GetStage() < 800)
			DebtGain = PlayerScr.fStoredGain * (MCM.fDebtBasePay*0.61)
		Else ;Stage Lv8
			DebtGain = PlayerScr.fStoredGain * (MCM.fDebtBasePay*0.45)
		EndIf
		PlayerScr.fStoredGain = 0
		;Stress
		float fStress = Stress.Value
		If(fStress >= 18 && fStress < 32)
			Debtgain *= 1.1
		ElseIf(fStress >= 32 && fStress < 41)
			Debtgain *= 1.3
		EndIf
		JF_Debt.Value += DebtGain
	EndIf
	UpdateCurrentInstanceGlobal(JF_Debt)
EndFunction

Function ReduceDebt(int Payment)
	PlayerRef.RemoveItem(Gold001, Payment)
	JF_Debt.Value -= Payment
	If(!MCM.bCreditEnable && JF_Debt.Value < 0)
		JF_Debt.Value = 0
	EndIf
	If(Jf_Debt.Value < MCM.iDebtSeg3 || Stress.Value <= 18)
		bFollowerCanLeave = false
	EndIf
	If(lockOut && MCM.bDebtLockOut)
		If(StringUtil.GetNthChar(DebtStage, 5) < MCM.iDebtLockoutSeg + 1)
			lockOutDur -= 1
			If(lockOutDur <= 0)
				lockOut = false
				lockOutDur = 0
				MCM.Cooldown(true)
			EndIf
		EndIf
	EndIf
	UpdateCurrentInstanceGlobal(JF_Debt)
EndFunction

; --------------------------------------- SexLab
; --------- SL Events
Event OnAnimStart(int tid, bool HasPlayer)
  sslThreadController Thread = SL.GetController(tid)
	If(HasPlayer)
		Tired(true)
	EndIf
	If(Thread.IsVictim(JoyFol)) ;Anyone rapes JF
		; SDP(false)
		Mental()
		(JoyFolRef as JFJoyFolScr).LoseKeys()
	EndIf
	; If(Thread.IsVictim(PlayerRef) && Thread.IsAggressor(JoyFol)) ;JF rapes Player
	; 	SDP(true, true)
	; 	Tired()
	; 	Relax()
	; ElseIf(Thread.IsVictim(PlayerRef)) ;Anyone rapes Player
	; 	SDP(true)
	; 	Tired()
	; ElseIf(Thread.IsVictim(JoyFol) && Thread.IsAggressor(PlayerRef)) ;Player rapes JF
	; 	SDP(false, false)
	; 	Mental(true)
	; 	(JoyFolRef as JFJoyFolScr).LoseKeys()
	; 	Util.TLeaveToken += 1
EndEvent

; --------- SL StartSex Follower / Player
; Consensual
Function StartSexPF(string tags)
  bool aggressive = false
  Actor[] JP = new Actor[2]
  If(SL.GetGender(PlayerRef) == 1)
    JP[0] = PlayerRef
    JP[1] = JoyFol
  Else
    JP[0] = JoyFol
    JP[1] = PlayerRef
  EndIf
	If (SL.GetGender(PlayerRef) == 1) && (SL.GetGender(JoyFol) == 1)
    sslBaseAnimation[] PFAnims = SL.GetAnimationsByTags(2, "ff")
    SL.StartSex(JP, PFAnims)
  Else
    sslBaseAnimation[] PFAnims = SL.PickAnimationsByActors(JP)
    SL.StartSex(JP, PFAnims)
  EndIf
EndFunction

; Function to start Oral animations only
Function StartOralPF(bool PlayerIsTaker, actor victim = none)
  Actor[] JP = new Actor[2]
	If(PlayerIsTaker == true)
    JP[0] = PlayerRef
    JP[1] = JoyFol
  Else
    JP[0] = JoyFol
    JP[1] = PlayerRef
  EndIf
  If (SL.GetGender(PlayerRef) == 1) && (SL.GetGender(JoyFol) == 1)
    sslBaseAnimation[] PFAnims = SL.GetAnimationsByTags(2, "oral, ff", "anal, vaginal")

    SL.StartSex(JP, PFAnims, Victim = Victim)
  Else
    sslBaseAnimation[] PFAnims = SL.GetAnimationsBytags(2, "oral", "anal, vaginal")

    SL.StartSex(JP, PFAnims, Victim = Victim)
  EndIf
EndFunction

; True = Player  // Start Rape between Follower & player
Function StartSexForcedPF(bool PlayerVic, string Tags = "")
  Actor[] JP = new Actor[2]
  Actor Victim
  If(PlayerVic == true)
    JP[0] = PlayerRef
    JP[1] = JoyFol
    Victim = PlayerRef
  Else
    JP[0] = JoyFol
    JP[1] = PlayerRef
    Victim = JoyFol
  EndIf
  sslBaseAnimation[] PFAnim = SL.PickAnimationsByActors(JP, 64, true)

  SL.StartSex(JP, PFAnim, Victim = Victim)
EndFunction

; ---------- Searching in the Wild
Function StartSexStolen(Actor Partner, string Tags = "")
	Actor[] JP = New Actor[2]
	JP[0] = PlayerRef
	JP[1] = Partner
	sslBaseAnimation[] PFAnim = SL.GetAnimationsByTags(2, Tags)
	SL.StartSex(JP, PFAnim, Victim = none, CenterOn = none, AllowBed = true, Hook = "StolenSex")
EndFunction

; ---------- Traitor!
int Function StartSexTraitor(Actor[] Partners, bool necro = false)
	int partnerCount = Utility.RandomInt(1, Partners.Length)
	Actor[] JP = PapyrusUtil.ActorArray(partnerCount)
	JP[0] = PlayerRef
	int Count = 1
	While(partnerCount)
		partnerCount -= 1
		JP[Count] = Partners[partnerCount]
		Count += 1
	endWhile
	string tags
	If(necro)
		tags = "necro, necrophilia"
	else
		tags = "Rough, Aggressive"
	EndIf
	sslBaseAnimation[] PFAnim = SL.GetAnimationsByTags(Partners.Length, tags, "", false)
	return SL.StartSex(JP, PFAnim, PlayerRef, Hook = "Traitor")
endFunction

; ---------- Below the College
int Function StartSexBelowCollege(Actor Partner)
	Actor[] JP = new Actor[2]
	JP[0] = PlayerRef
	JP[1] = Partner
	sslBaseAnimation[] PFAnim = SL.PickAnimationsByActors(JP)
 	return SL.StartSex(JP, PFAnim, Hook = "BelowCollege")
endFunction

; ----------- Redundant
;/ ---------- Giant Quest, Tree Sap
Function GiantRape(actor[] Giants, actor Victim)
	If(GiantRepeats == 0 && Victim == PlayerRef)
		JF_Giant.SetStage(250)
		JoyFol.EvaluatePackage()
	EndIf
	int Rapists = Giants.Length
	int Yep = 1
	Actor[] JP = New Actor[4]
	JP[0] = Victim
	While(Rapists)
		JP[Yep] = Giants[Rapists]
		Yep += 1
		Rapists -= 1
	EndWhile
	sslBaseAnimation[] PFAnim = SL.PickAnimationsByActors(JP)

	SL.StartSex(JP, PFAnim, Victim = Victim, CenterOn = none, AllowBed = true, Hook = "GiantChainRape")
	RegisterForModEvent("HookAnimationEnding_GiantChainRape", "ChaininUp")
EndFunction

Event ChaininUp(int tid, bool HasPlayer)
	If(MCM.iGiantChainRapes < GiantRepeats || (Utility.RandomInt(1, 100) > 20))
		sslThreadController Thread = SL.GetController(tid)
		Actor[] Acteurs = Thread.Positions
		int Clowns = Acteurs.Length
		int Yep = 1
		int Nop = 0
		Actor Victim = Acteurs[0]
		Actor[] Giants = new Actor[4]
		;Acteurs[0] is previous Victim, Acteurs[1~x] are the Giants
		While(Yep < Clowns)
			Giants[Nop] = Acteurs[Yep]
			Nop += 1
			Yep += 1
		EndWhile
		GiantRape(Giants, Victim)
		GiantRepeats += 1
	Else
		GiantRepeats = 0
		Util.GiantRapeDone = true
		UnregisterForModEvent("HookAnimationEnding_GiantChainRape")
	EndIf
EndEvent/;

; ------------------------ Sub-Dom-Points (SDP)
; GlobalVariable Property SDP Auto
;/Variable to express Domination
Used to alter Quests or make Quests exclusive depending on who is currently on top - "one on top" isnt a slaver and the one on the botom isnt a slave, its more about who has the last word

A value between -2 and 2 is considered neutral
The higher the value, the more submissive the Player - The lower the more dominating
/;
; bool SDPLimitBreak = false
; ; --------- Parameter
; ;	gain: if true, increase player submission otherwise increase domination
; ;	more: Wether or not to increase the SDP gain/loss
; Function SDP(bool gain, bool more = false)
; 	float LesPoints = SDP.value
; 	If(gain == true && more == true)
; 		LesPoints += 2
; 	ElseIf(gain == true)
; 		LesPoints += 1
; 	ElseIf(gain == false && more == true)
; 		LesPoints -= 2
; 	Else
; 		LesPoints -= 1
; 	EndIf
; 	If(LesPoints >= 10 && SDPLimitBreak == false) ;Limit Break Sub
; 		LesPoints = 20
; 		SDPLimitBreak = true
; 	ElseIf(LesPoints <= -10 && SDPLimitBreak == false) ;Limit Break Dom
; 		LesPoints = -20
; 		SDPLimitBreak = true
; 	ElseIf(LesPoints > 25) ;Currently in bad or good end
; 		;Just making sure you dont go too far away from 0...
; 		LesPoints = 25
; 	ElseIf(LesPoints < -25)
; 		LesPoints = -25
; 	Else ;Escaped Bad/Good End or isnt in there to begin with
; 		SDPLimitBreak == false
; 	EndIf
; 	SDP.value = LesPoints
; EndFunction
