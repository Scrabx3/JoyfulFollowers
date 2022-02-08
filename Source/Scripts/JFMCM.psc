Scriptname JFMCM extends SKI_ConfigBase Conditional

; ---------------------------- Vars
GlobalVariable Property GameDaysPassed Auto

; --- General
bool Property bNotifyAffection = false Auto Hidden
bool Property bDebtEnabled = false Auto Hidden Conditional
float Property iDebtThresh = 10000.0 Auto Hidden
bool Property bCreditEnable = true Auto Hidden
float Property fCreditDecay = 5.0 Auto Hidden
String[] debtmodels
int Property debtmodelindex = 0 Auto Hidden
{0 -- Simple, 1 -- Dynamic}
float Property fDebtSimple = 800.0 Auto Hidden
float Property fDebtDynamic = 15.0 Auto Hidden
float recruittime
float Property fTimeoutTime = 24.0 Auto Hidden
; float Property fEventChance Auto Hidden
; --- Event
bool Property bStolenSteal = true Auto Hidden
bool Property bStolenBadEnd = false Auto Hidden
float Property fPuppyDur = 9.5 Auto Hidden
int Property iTraitorScale = 60 Auto Hidden
bool Property bHelpingHand = true Auto Hidden Conditional
; --- Debug
bool Property bDebug = false Auto Hidden
bool Property bLocNo = false Auto Hidden
bool Property bIsFuta = false Auto Hidden Conditional
bool Property bIsFutaPl = false Auto Hidden Conditional
bool Property bCreatureContent = false Auto Hidden Conditional
bool Property bAutoRecruit = true Auto Hidden Conditional
bool Property bDebugRecruit = false Auto Hidden Conditional
; ---------------------------- Menu
int Function GetVersion()
	return 1
EndFunction

Event OnConfigInit()
	Pages = new string[3]
	Pages[0] = "$JF_General"
	Pages[1] = "$JF_Events"
	Pages[2] = "$JF_Debug"

	debtmodels = new String[2]
	debtmodels[0] = "$JF_DebtSimple" ; Simple
	debtmodels[1] = "$JF_DebtDynamic" ; Dynamic
EndEvent

Event OnVersionUpdate(int newVers)
EndEvent

Event OnPageReset(String page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	If(page == "")
		page == "$JF_General"
	EndIf
	If(page == "$JF_General")
		AddHeaderOption("$JF_Affection")
		AddToggleOptionST("AffectionChange", "$JF_NotifyAffection", bNotifyAffection)
		AddEmptyOption()
		; AddEmptyOption()
		; AddEmptyOption()
		AddHeaderOption("$JF_FairShare")
		AddToggleOptionST("DebtEnable", "$JF_Enabled", bDebtEnabled)
		AddSliderOptionST("DebtThresh", "$JF_DebtThresh", iDebtThresh, "{0}g", getFlag(bDebtEnabled))
		AddToggleOptionST("DebtCredit01", "$JF_DebtCredit01", bCreditEnable, getFlag(bDebtEnabled))
		AddSliderOptionST("DebtCredit02", "$JF_DebtCredit02", fCreditDecay, "{1}%", getFlag(bCreditEnable && bDebtEnabled))
		AddMenuOptionST("debtmodel", "$JF_DebtModel", debtmodels[debtmodelindex], getFlag(bDebtEnabled))
		If(debtmodelindex == 0)
			AddSliderOptionST("debtmodel_01", "$JF_DebtModel_01", fDebtSimple, "{0}g", getFlag(bDebtEnabled))
		Else
			AddSliderOptionST("debtmodel_02", "$JF_DebtModel_01", fDebtDynamic, "{1}%", getFlag(bDebtEnabled))
		EndIf
		SetCursorPosition(1)
		AddHeaderOption("$JF_Status")
		AddTextOption("$JF_CurFollower", GetFollowerName())
		AddTextOption("$JF_CurFolSince", GetRecruitTime())
		AddTextOption("$JF_CurAffection", JoyfulFollowers.GetAffectionLevel() as int)
		AddTextOption("$JF_CurSeverity", JoyfulFollowers.GetSeverity())
		AddEmptyOption()
		AddEmptyOption()
		; AddEmptyOption()
		; AddEmptyOption()
		AddHeaderOption("$JF_System")
		AddToggleOptionST("CreatureContent", "$JF_CreatureContent", bCreatureContent)
		AddSliderOptionST("TimeoutTime", "$JF_Timeout", fTimeoutTime, "{1}h")
		; AddSliderOptionST("EventChance", "$JF_Eventchance", fEventChance, "{1}%")
	ElseIf(page == "$JF_Events")
		AddHeaderOption("$JF_Stolen")
		AddToggleOptionST("stolenStealing", "$JF_StolenStealing", bStolenSteal)
		AddToggleOptionST("stolenBadEnd", "$JF_StolenBadEnd", bStolenBadEnd, getFlag(bStolenSteal))
		AddHeaderOption("$JF_Puppy")
		AddSliderOptionST("puppydur", "$JF_PuppyDur", fPuppyDur, "{1}h")
		AddHeaderOption("$JF_Traitor")
		AddSliderOptionST("traitorscale", "$JF_TraitorScale", iTraitorScale, "{0}")
		SetCursorPosition(1)
		; AddHeaderOption("$JF_HelpingHand")
		; AddToggleOptionST("helpinghand", "$JF_Enabled", bHelpingHand)
	ElseIf(page == "$JF_Debug")
		AddHeaderOption("$JF_Dialogue")
		AddToggleOptionST("PiF", "$JF_FutaPl", bIsFutaPl)
		AddToggleOptionST("FiF", "$JF_FutaFol", bIsFuta)
		AddHeaderOption("$JF_Development")
		AddToggleOptionST("debugnotify", "$JF_DebugNotify", bDebug)
		AddToggleOptionST("locnotify", "$JF_LocNotify", bLocNo)
		AddSliderOptionST("affectioncheat", "$JF_AffectionCheat", JoyfulFollowers.GetAffectionLevel() as int, "{0}", getFlag(JoyfulFollowers.GetAffectionLevel() > 0))
		SetCursorPosition(1)
		AddHeaderOption("$JF_Recruitment")
		AddToggleOptionST("debugrecruit", "$JF_DebugRecruit", bDebugRecruit)
		AddToggleOptionST("autorecruit", "$JF_AutoRecruit", bAutoRecruit)
	EndIf
EndEvent

String Function GetFollowerName()
	Actor fol = JoyfulFollowers.GetFollower()
	If(fol)
		return fol.GetLeveledActorBase().GetName()
	Else
		return "---"
	EndIf
EndFunction

Function SetRecruitTime()
	recruittime = GameDaysPassed.Value
EndFunction
String Function GetRecruitTime()
	Actor fol = JoyfulFollowers.GetFollower()
	If(fol)
		int dif = Math.Floor(GameDaysPassed.Value - recruittime)
		return Utility.GameTimeToString(recruittime) + " (" + dif + " days)"
	Else
		return "---"
	EndIf
EndFunction

int Function getFlag(bool option)
	If(option)
		return OPTION_FLAG_NONE
	else
		return OPTION_FLAG_DISABLED
	EndIf
endFunction

Event OnSelectST()
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "AffectionChange")
		bNotifyAffection = !bNotifyAffection
		SetToggleOptionValueST(bNotifyAffection)
	ElseIf(op[0] == "DebtEnable")
		bDebtEnabled = !bDebtEnabled
		SetToggleOptionValueST(bDebtEnabled)
		SetOptionFlagsST(getFlag(bDebtEnabled), true, "DebtThresh")
		SetOptionFlagsST(getFlag(bDebtEnabled), true, "DebtCredit01")
		SetOptionFlagsST(getFlag(bCreditEnable && bDebtEnabled), true, "DebtCredit02")
		SetOptionFlagsST(getFlag(bDebtEnabled), true, "DebtModel")
		SetOptionFlagsST(getFlag(bDebtEnabled), true, "DebtModel_01")
		SetOptionFlagsST(getFlag(bDebtEnabled), false, "DebtModel_01")
	ElseIf(op[0] == "DebtCredit01")
		bCreditEnable = !bCreditEnable
		SetToggleOptionValueST(bCreditEnable)
		SetOptionFlagsST(getFlag(bCreditEnable && bDebtEnabled), false, "DebtCredit02")
	ElseIf(op[0] == "stolenStealing")
		bStolenSteal = !bStolenSteal
		SetToggleOptionValueST(bStolenSteal)
		SetOptionFlagsST(getFlag(bStolenSteal), false, "stolenBadEnd")
	ElseIf(op[0] == "stolenBadEnd")
		bStolenBadEnd = !bStolenBadEnd
		SetToggleOptionValueST(bStolenBadEnd)
	ElseIf(op[0] == "helpinghand")
		bHelpingHand = !bHelpingHand
		SetToggleOptionValueST(bHelpingHand)
	ElseIf(op[0] == "CreatureContent")
		bCreatureContent = !bCreatureContent
		SetToggleOptionValueST(bCreatureContent)
	ElseIf(op[0] == "PiF")
		bIsFuta = !bIsFuta
		SetToggleOptionValueST(bIsFuta)
	ElseIf(op[0] == "FiF")
		bIsFutaPl = !bIsFutaPl
		SetToggleOptionValueST(bIsFutaPl)
	ElseIf(op[0] == "debugrecruit")
		bDebugRecruit = !bDebugRecruit
		SetToggleOptionValueST(bDebugRecruit)
	ElseIf(op[0] == "autorecruit")
		bAutoRecruit = !bAutoRecruit
		SetToggleOptionValueST(bAutoRecruit)
	ElseIf(op[0] == "debugnotify")
		bDebug = !bDebug
		SetToggleOptionValueST(bDebug)
	ElseIf(op[0] == "locnotify")
		bLocNo = !bLocNo
		SetToggleOptionValueST(bLocNo)
	EndIf
EndEvent

Event OnSliderOpenST()
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "DebtThresh")
		SetSliderDialogStartValue(iDebtThresh)
		SetSliderDialogDefaultValue(10000)
		SetSliderDialogRange(5000, 500000)
		SetSliderDialogInterval(1000)
	ElseIf(op[0] == "DebtCredit02")
		SetSliderDialogStartValue(fCreditDecay)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	ElseIf(op[0] == "DebtModel_01")
		SetSliderDialogStartValue(fDebtSimple)
		SetSliderDialogDefaultValue(2000)
		SetSliderDialogRange(100, 10000)
		SetSliderDialogInterval(10)
	ElseIf(op[0] == "DebtModel_01")
		SetSliderDialogStartValue(fDebtDynamic)
		SetSliderDialogDefaultValue(35)
		SetSliderDialogRange(5, 95)
		SetSliderDialogInterval(0.5)
	ElseIf(op[0] == "TimeoutTime")
		SetSliderDialogStartValue(fTimeoutTime)
		SetSliderDialogDefaultValue(18)
		SetSliderDialogRange(6, 96)
		SetSliderDialogInterval(0.5)
	; ElseIf(op[0] == "EventChance")
	; 	SetSliderDialogStartValue(fEventChance)
	; 	SetSliderDialogDefaultValue(75)
	; 	SetSliderDialogRange(0, 100)
	; 	SetSliderDialogInterval(0.5)
	ElseIf(op[0] == "puppydur")
		SetSliderDialogStartValue(fPuppyDur)
		SetSliderDialogDefaultValue(9.5)
		SetSliderDialogRange(4, 48)
		SetSliderDialogInterval(0.5)
	ElseIf(op[0] == "traitorscale")
		SetSliderDialogStartValue(iTraitorScale)
		SetSliderDialogDefaultValue(60)
		SetSliderDialogRange(20, 200)
		SetSliderDialogInterval(5)
	EndIf
EndEvent

Event OnSliderAcceptST(Float afValue)
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "DebtThresh")
		iDebtThresh = afValue
		SetSliderOptionValueST(iDebtThresh, "{0}g")
	ElseIf(op[0] == "DebtCredit02")
		fCreditDecay = afValue
		SetSliderOptionValueST(fCreditDecay, "{1}%")
	ElseIf(op[0] == "DebtModel_01")
		fDebtSimple = afValue
		SetSliderOptionValueST(fDebtSimple, "{0}g")
	ElseIf(op[0] == "DebtModel_01")
		fDebtDynamic = afValue
		SetSliderOptionValueST(fDebtDynamic, "{1}%")
	ElseIf(op[0] == "TimeoutTime")
		fTimeoutTime = afValue
		SetSliderOptionValueST(fTimeoutTime, "{1}h")
	; ElseIf(op[0] == "EventChance")
	; 	fEventChance = afValue
	; 	SetSliderOptionValueST(fEventChance, "{1}%")
	ElseIf(op[0] == "puppydur")
		fPuppyDur = afValue
		SetSliderOptionValueST(fPuppyDur, "{1}h")
	ElseIf(op[0] == "traitorscale")
		iTraitorScale = afValue as int
		SetSliderOptionValueST(iTraitorScale, "{0}")
	EndIf
EndEvent

Event OnMenuOpenST()
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "debtmodel")
		SetMenuDialogStartIndex(debtmodelindex)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(debtmodels)
		ForcePageReset()
	EndIf
EndEvent

Event OnMenuAcceptST(Int aiIndex)
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "debtmodel")
		debtmodelindex = aiIndex
		SetMenuOptionValueST(debtmodels[debtmodelindex])
	EndIf
EndEvent

Event OnHighlightST()
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "AffectionChange")
		SetInfoText("$JF_NotifyAffectionHighlight")
	ElseIf(op[0] == "DebtEnable")
		SetInfoText("$JF_DebtEnableHighlight")
	ElseIf(op[0] == "DebtThresh")
		SetInfoText("$JF_DebtThreshHighlight")
	ElseIf(op[0] == "DebtCredit01")
		SetInfoText("$JF_DebtCredit01Highlight")
	ElseIf(op[0] == "DebtCredit02")
		SetInfoText("$JF_DebtCredit02Highlight")
	ElseIf(op[0] == "DebtModel")
		SetInfoText("$JF_DebtModelhighlight")
	ElseIf(op[0] == "DebtModel_01")
		SetInfoText("$JF_DebtModel_01Highlight")
	ElseIf(op[0] == "DebtModel_02")
		SetInfoText("$JF_DebtModel_02Highlight")
	ElseIf(op[0] == "TimeoutTime")
		SetInfoText("$JF_TimeoutHighlight")
	; ElseIf(op[0] == "EventChance")
	; 	SetInfoText("$JF_EventchanceHighlight")
	ElseIf(op[0] == "stolenStealing")
		SetInfoText("$JF_StolenStealingHighlight")
	ElseIf(op[0] == "stolenBadEnd")
		SetInfoText("$JF_StolenBadEndHighlight")
	ElseIf(op[0] == "PiF")
		SetInfoText("$JF_FutaPlHighlight")
	ElseIf(op[0] == "FiF")
		SetInfoText("$JF_FutaFolHighlight")
	ElseIf(op[0] == "debugrecruit")
		SetInfoText("$JF_DebugRecruitHighlight")
	ElseIf(op[0] == "autorecruit")
		SetInfoText("$JF_AutoRecruitHighlight")
	EndIf
EndEvent

State affectioncheat
	Event OnSliderOpenST()
		SetSliderDialogStartValue(JFMain.GetAffectionGlobal().GetValue())
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 4)
		SetSliderDialogInterval(1)
	EndEvent

	Event OnSliderAcceptST(Float afValue)
		JFMain.GetAffectionGlobal().SetValue(afValue)
		SetSliderOptionValueST(afValue)
		; f: sqrt(64-x)/8) >> f-1: 64x^2-64
		float affection = 64 * Math.pow(afValue, 2) - 64
		StorageUtil.SetFloatValue(JoyfulFollowers.GetFollower(), "jfAffection", affection)
	EndEvent
EndState

;/ -------------------------- Properties
JFCore Property Core Auto
JFEventStorage Property Util Auto

GlobalVariable Property JFArousal Auto
GlobalVariable Property JF_Fatigue Auto
GlobalVariable Property JF_Stress Auto
GlobalVariable Property JF_Affection Auto
GlobalVariable Property JF_ChallengeChance Auto

GlobalVariable Property DogCollar_Var Auto
GlobalVariable Property ShutUp_Var = none Auto ; DD Specific
GlobalVariable Property PetCollar_Var = none Auto ; DD Specific

Quest Property CoreQuest Auto
; -------------------------- Values

; ------- Devious Devices
; -- Devious Devices
bool shouldPunishDisable
bool Property bPunishEnab = true Auto Hidden Conditional
string[] PunishColourOptionList
int Property PunishColourOption = 6 Auto Hidden
bool Property bCuffBoth = false Auto Hidden
int Property iBlindEnab = 50 Auto Hidden Conditional
int Property iGagEnab = 50 Auto Hidden
int Property iHeavyBonEnab = 20 Auto Hidden
int Property iCuffLegEnab = 80 Auto Hidden
int Property iCuffArmEnab = 80 Auto Hidden
int Property iAnkleShackEnab = 70 Auto Hidden
int Property iCorsetEnab = 70 Auto Hidden
int Property iRubberBootEnab = 40 Auto Hidden
int Property iRubberGlovEnab = 40 Auto Hidden
; -- Key Hunter
bool Property bKHEnab = true Auto Hidden Conditional
string[] KHColourOptionList
int Property KHColourOption = 6 Auto Hidden
; -- Games
;ShutUp
bool Property bTGEnab = true Auto Hidden Conditional
int Property iTG = 16 Auto Hidden
bool Property bTG = true Auto Hidden Conditional

;PetCollar
bool Property bPetCollarEnab = false Auto Hidden Conditional
int Property iPetCollarDur = 36 Auto Hidden
bool Property bPetCollarMCM = true Auto Hidden
; -- Key Holder
bool Property bKHFind = true Auto Hidden
float Property fKHFreq = 1.0 Auto Hidden
bool Property bKHAngr = false Auto Hidden

int Property iKHChance = 15 Auto Hidden
int Property iKHChast = 25 Auto Hidden
int iKHPierc = 15
int Property iKHRest = 60 Auto Hidden
int Property iMaxKeyAllowed = 4 Auto Hidden
int Property iLoseKeys = 100 Auto Hidden
bool Property bKHFiNo = true Auto Hidden

; ------- Mods Loaded
bool Property bJF_DD = false Auto Hidden
bool Property bDDLoaded = false Auto Hidden
bool Property bPetCollarLoaded = false Auto Hidden

; ------- Debug
bool Property bDeNo = false Auto Hidden
bool Property bLocNo = true Auto Hidden
bool Property bDebugRecruit = false Auto Hidden Conditional
; Beta only
int iMental = 0
int iTired = 0

; -------------------------- O_IDS
; ------- Challenges
int oHeadlessChick
int oHelpHand
int oGlasscannon

; ------- Key Holder
int PiercKey
; ------- Debug
int Mental
int Tired

; -------------------------- Cooldown
bool Property bGameRunning = false Auto Hidden Conditional
bool Property bCooldown = true Auto Hidden Conditional
; true = Events can start, false = Cooldown active
; Handling this here to avoid making Cooldown dependend on ticks

Function Cooldown(bool HalfDur = false)
	bCooldown = false
	If(HalfDur)
		RegisterForSingleUpdate(iCooldown/2)
	Else
		RegisterForSingleUpdateGameTime(iCooldown)
	EndIf
EndFunction

Event OnUpdateGameTime()
	bCooldown = true
EndEvent

; -------------------------- Mod Checks
Function CheckMods()
	;	DD & Devious JF
	If(Quest.GetQuest("JFDD_Core") != none)
		bJF_DD = true
		bDDLoaded = true
	ElseIf(Quest.GetQuest("zadQuest") != none)
		bDDLoaded = true
	else
		bJF_DD = false
		bDDLoaded = false
	EndIf
	; PetCollar
	If(Quest.GetQuest("PetCollarConfig") != none)
		bPetCollarLoaded = true
	else
		bPetCollarLoaded = false
		bPetCollarEnab = false
	endIf
EndFunction

; -------------------------- MCM
Function Initialize()
	Pages = new string[9]
	Pages[0] = " General"
	Pages[1] = " My Fair Share"
	Pages[2] = " Events"
	Pages[3] = " Challenges"
	Pages[4] = " Devious Devices"
	Pages[5] = " Key Holder"
	Pages[6] = " Mods Loaded"
	Pages[7] = " Flag Viewer"
	Pages[8] = " Debug"

	KHColourOptionList = new string[8]
	KHColourOptionList[0] = "Black Ebonite"
	KHColourOptionList[1] = "White Ebonite"
	KHColourOptionList[2] = "Red Ebonite"
	KHColourOptionList[3] = "Black Leather"
	KHColourOptionList[4] = "White Leather"
	KHColourOptionList[5] = "Red Leather"
	KHColourOptionList[6] = "Random, matching colour"
	KHColourOptionList[7] = "All Random"

	PunishColourOptionList = new string[7]
	PunishColourOptionList[0] = "Black Ebonite"
	PunishColourOptionList[1] = "White Ebonite"
	PunishColourOptionList[2] = "Red Ebonite"
	PunishColourOptionList[3] = "Black Leather"
	PunishColourOptionList[4] = "White Leather"
	PunishColourOptionList[5] = "Red Leather"
	PunishColourOptionList[6] = "Random"
endFunction

; ==================================
; 							MENU
; ==================================
Event OnConfigInit()
	Initialize()
EndEvent

Event OnVersionUpdate(int newVers)
	Initialize()
endEvent

Event OnPageReset(String Page)
	If(Page == "")
		Page = " General"
	EndIf
	If(Page == " General")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption(" General")
		AddToggleOptionST("AffectionChange", "Affection Change Notification", bShowAffectionChange)
		AddToggleOptionST("Bestiality", "Enable Creature Content", bCreatureContent)
		AddSliderOptionST("ArousalThresholdSt", "Arousal threshold", ArousalThreshold)
		AddHeaderOption(" On Hit")
		; AddToggleOptionST("OHEnab", "Enabled", bOHenab)
		; AddSliderOptionST("EndMin", "Endurance (Min)", iOHmin)
		; AddSliderOptionST("EndMax", "Endurance (Max)", iOHmax)
		AddHeaderOption(" Miscellaneous")
		AddToggleOptionST("FiF", "Is Futa (Follower)", bIsFuta)
		AddToggleOptionST("PiF", "Is Futa (Player)", bIsFutaPl)
		SetCursorPosition(1)
		AddHeaderOption(" Status")
		;Current Affection Stage Entry
		If(CoreQuest.GetStage() == 800)
			AddTextOptionST("Affection", "Current Affection Stage:", "Lv5/5")
		ElseIf(CoreQuest.GetStage() == 600)
			AddTextOptionST("Affection", "Current Affection Stage:", "Lv4/5")
		ElseIf(CoreQuest.GetStage() == 400)
			AddTextOptionST("Affection", "Current Affection Stage:", "Lv3/5")
		ElseIf(CoreQuest.GetStage() == 200)
			AddTextOptionST("Affection", "Current Affection Stage:", "Lv2/5")
		ElseIf(CoreQuest.GetStage() == 100)
			AddTextOptionST("Affection", "Current Affection Stage:", "Lv1/5")
		Else
			AddTextOptionST("Affection", "Current Affection Stage:", "N/A")
		EndIf
		;Affection Stage Progress Entry
		float JaJaJa = JF_Affection.Value
		If(CoreQuest.GetStage() == 800)
			AddTextOptionST("Affection2", "Affection Stage Progress:", "100%", OPTION_FLAG_DISABLED)
		ElseIf(CoreQuest.GetStage() == 600)
			AddTextOptionST("Affection2", "Current Affection Stage Progress:", (((JaJaJa - 5200)/10000)*100) + "%", OPTION_FLAG_DISABLED)
		ElseIf(CoreQuest.GetStage() == 400)
			AddTextOptionST("Affection2", "Current Affection Stage Progress:", (((JaJaJa - 2300)/4900)*100) + "%", OPTION_FLAG_DISABLED)
		ElseIf(CoreQuest.GetStage() == 200)
			AddTextOptionST("Affection2", "Current Affection Stage Progress:", (((JaJaJa - 100)/2200)*100) + "%", OPTION_FLAG_DISABLED)
		ElseIf(CoreQuest.GetStage() == 100)
			AddTextOptionST("Affection2", "Current Affection Stage Progress:", ((JaJaJa/100)*100) + "%", OPTION_FLAG_DISABLED)
		Else
			AddTextOptionST("Affection2", "Affection Stage Progress:", "N/A", OPTION_FLAG_DISABLED)
		EndIf
		;Fatigue Entry
		float NoNoNo = JF_Fatigue.Value
		If(NoNoNo < 16.0)
			AddTextOptionST("Tired", "Fatigue:", "Wake (" + NoNoNo as int + ")")
		ElseIf(NoNoNo >= 16.0 && NoNoNo < 28.0)
			AddTextOptionST("Tired", "Fatigue:", "Sleepy (" + NoNoNo as int + ")")
		ElseIf(NoNoNo >= 28.0 && NoNoNo < 37.0)
			AddTextOptionST("Tired", "Fatigue:", "Tired (" + NoNoNo as int + ")")
		ElseIf(NoNoNo >= 37)
			AddTextOptionST("Tired", "Fatigue:", "Wasted (" + NoNoNo as int + ")")
		EndIf
		;Stress Entry
		If(CoreQuest.GetStage() < 100)
			AddTextOptionST("Stress", "Stress:", "N/A")
		else
			float Ayaya = JF_Stress.GetValue()
			If Ayaya < 18.0
				AddTextOptionST("Stress", "Stress:", "Calm (" + Ayaya as int + ")")
			ElseIf(Ayaya >= 18.0 && Ayaya < 32.0)
				AddTextOptionST("Stress", "Stress:", "Annoyed (" + Ayaya as int + ")")
			ElseIf(Ayaya >= 32.0 && Ayaya < 40.0)
				AddTextOptionST("Stress", "Stress:", "Angry (" + Ayaya as int + ")")
			ElseIf(Ayaya >= 41)
				AddTextOptionST("Stress", "Stress:", "??? (" + Ayaya as int + ")")
			EndIf
		EndIf
		;LockOut
		If(CoreQuest.GetStage() < 100)
			AddTextOptionST("ExplLockOut", "Locked out?", "N/A")
		elseIf((CoreQuest as JFCore).lockOut)
			AddTextOptionST("ExplLockOut", "Locked out?", "Yes")
		else
			AddTextOptionST("ExplLockOut", "Locked out?", "No")
		EndIf
		AddHeaderOption(" System")
		AddSliderOptionST("EventChance", "Event Chance", iEvent, "{0}%")
		AddSliderOptionST("Cooldown", "Global Cooldown", iCooldown)
		; AddSliderOptionST("Ticking", "Tick interval", iTick)
	ElseIf(Page == " My Fair Share")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption(" My Fair Share")
		AddEmptyOption()
		AddHeaderOption("Thresholds")
		AddSliderOptionST("Segment1", "First Segment:", iDebtSeg1, "{0}g")
		AddSliderOptionST("Segment2", "Second Segment:", iDebtSeg2, "{0}g")
		AddSliderOptionST("Segment3", "Third Segment:", iDebtSeg3, "{0}g")
		AddEmptyOption()
		AddHeaderOption(" Credit")
		AddToggleOptionST("CreditEnable", "Allow Credit", bCreditEnable)
		AddSliderOptionST("CreditDecay", "Credit Decay", iCreditDecay, "{0}%", getFlag(bCreditEnable))
		SetCursorPosition(1)
		AddToggleOptionST("ShareEnabled", "Enabled", bDebtEnabled)
		AddEmptyOption()
		AddHeaderOption(" Consequences")
		AddToggleOptionST("DebtLockOut", "High Debt locks out", bDebtLockOut)
		AddSliderOptionST("DebtLockOutSegment", "Segment Threshold", iDebtLockoutSeg, "{0}", getFlag(bDebtLockOut))
		AddToggleOptionST("DebtBadEnd", "Follower may Leave", bDebtBadEnd)
		AddEmptyOption()
		AddHeaderOption(" Debt Model")
		AddToggleOptionST("ComplexDebt", "Complex Debt Model", bDebtComplex)
		AddSliderOptionST("FairShareSimple", "Debt increase:", iDebtGain, "{0}g", getFlagReverse(bDebtComplex))
		AddSliderOptionST("FairShareComplex", "Base Payment:", fDebtBasePay, "{0}%", getFlag(bDebtComplex))
	ElseIf(Page == " Events")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption(" Regular Events")
		AddHeaderOption(" My Cut")
		AddToggleOptionST("CutEnab", "Enabled", bCutEn)
		; AddSliderOptionST("CutTimeGone", "Maximum time away", iMaxTimeOut, "{0}h", getFlag(bCutEn))
		AddHeaderOption(" Searching in the Wild")
		AddToggleOptionST("SitWEnabled", "Enabled", bSitWEnab)
		AddToggleOptionST("SitWBadEnd", "Bad End", bSCSteal, getFlag(bSitWEnab))
		AddToggleOptionST("SitWWorseEnd", "Worse End", bSCWorse, getFlag(bSCSteal, bSitWEnab))
		AddHeaderOption(" Below the College")
		AddToggleOptionST("BelowCollEnab", "Enabled", bBCEnab)
		AddToggleOptionST("BCShowTaken", "Show Items Taken", bBCShowTaken, getFlag(bBCEnab))
		AddHeaderOption(" Traitor!")
		AddSliderOptionST("TraitorTimescale", "Set Timescale to", iTraitorScale, "{0}")
		AddToggleOptionST("TraitorAdult", "Enable Adult Content", bTraitorEnabAdult)
		SetCursorPosition(1)
		AddHeaderOption(" Punishment Games")
		AddHeaderOption(" A Dogs Collar")
		AddToggleOptionST("DogCollarEnab", "Enabled", bDogCollarEnab)
		AddSliderOptionST("DogCollarDur", "Maximum Duration", iDogCollarDur, "{0}h", getFlag(bDogCollarEnab))
		AddEmptyOption()
	ElseIf(Page == " Challenges")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddSliderOptionST("ChallChance", "Challenge Chance", ChallengeChance)
		oHeadlessChick = AddToggleOption("Headless Chicken", challHeadlessChick)
		oGlasscannon = AddToggleOption("Headless Chicken", challGlascannon)
		SetCursorPosition(1)
		AddHeaderOption("")
		oHelpHand = AddToggleOption("Helping Hand", challHelpingHand)
	ElseIf(Page == " Devious Devices")
		If(!bJF_DD)
			AddTextOption("Placeholder..", "")
		else
	    SetCursorFillMode(TOP_TO_BOTTOM)
	    AddHeaderOption(" Generic Consequences")
	    AddToggleOptionST("PunishEnable", "Enable", bPunishEnab, getFlagReverse(shouldPunishDisable))
	    AddMenuOptionST("PunishColourOptionMenu", "Device Colour", PunishColourOptionList[PunishColourOption])
	    AddToggleOptionST("BothCuffEnab", "Arm & Leg Cuffs together", bCuffBoth)
	    AddSliderOptionST("BlindfoldEnab", "Blindfold", iBlindEnab)
	    AddSliderOptionST("GagEnab", "Gag", iGagEnab)
	    AddSliderOptionST("HeavyBondageEnab", "Heavy Bondage", iHeavyBonEnab)
	    AddSliderOptionST("CorsetEnab", "Corset", iCorsetEnab)
	    AddSliderOptionST("RubberGlovesEnab", "Rubber Gloves", iRubberGlovEnab)
	    AddSliderOptionST("RubberBootsEnab", "Rubber Boots", iRubberBootEnab)
	    AddSliderOptionST("ArmCuffEnab", "Cuffs (Arm)", iCuffArmEnab)
	    AddSliderOptionST("LegCuffEnab", "Cuffs (Leg)", iCuffLegEnab)
	    AddSliderOptionST("AnkleShackEnab", "Shackles (Ankle)", iAnkleShackEnab)
	    SetCursorPosition(1)
	    AddHeaderOption(" Events")
	    AddHeaderOption(" Key Hunting")
	    AddToggleOptionST("KHEnabled", "Enabled", bKHEnab)
	    AddMenuOptionST("KHColourOptionMenu", "Device Colour", KHColourOptionList[KHColourOption], getFlag(bKHEnab))
	    AddEmptyOption()
	    AddHeaderOption(" Punishment Games (Devious)")
	    AddHeaderOption(" Shut! Up!")
	    AddToggleOptionST("ShutUpEnab", "Enabled", bTGEnab)
	    AddSliderOptionST("MaxTimeGagged", "Maximum Duration", iTG, "{0}h",  getFlag(bTGEnab))
	    AddToggleOptionST("TalkingTakesTime", "Talking takes time", bTG, getFlag(bTGEnab))
	    AddHeaderOption(" PetCollar")
	    AddToggleOptionST("PCEnab", "Enabled", bPetCollarEnab, getFlag(bPetCollarLoaded))
	    AddSliderOptionST("PCTime", "Maximum Duration", iPetCollarDur, "{0}h", getFlag(bPetCollarEnab, bPetCollarLoaded))
	    AddToggleOptionST("PCMCM", "Change PetCollar MCM", bPetCollarMCM, getFlag(bPetCollarEnab, bPetCollarLoaded))
		endIf
	ElseIf(Page == " Key Holder")
		If(!bJF_DD)
			AddTextOption("Placeholder..", "")
		else
	    SetCursorFillMode(LEFT_TO_RIGHT)
	    AddHeaderOption(" General")
	    AddHeaderOption("")
	    AddToggleOptionST("KHFind", "Follower searches for keys", bKHFind)
	    AddSliderOptionST("KHFreq", "Search frequency", fKHFreq, "{1}h")
	    AddToggleOptionST("KHAngry", "..if they are angry", bKHAngr)
	    AddEmptyOption()
	    AddHeaderOption(" Key Looting")
	    AddHeaderOption("")
	    AddSliderOptionST("KhChance", "Chance to find a Key:", iKHChance, "{0}%")
	    AddSliderOptionST("ChastKey", "Chastity Key Chance", iKHChast, "{0}%")
	    AddToggleOptionST("KHFiNo","Know when your follower finds a key", bKHFiNo)
	    AddSliderOptionST("RestKey", "Restraint Key Chance", iKHRest, "{0}%")
	    AddSliderOptionST("LoseKeys", "Chance to lose keys on Bleedout", iLoseKeys, "{0}%")
	    PiercKey = AddSliderOption("Piercing Removal Tool Chance", iKHPierc, "{0}%", OPTION_FLAG_DISABLED)
	    AddEmptyOption()
	    AddSliderOptionST("KeyMax", "Max. keys stored:", iMaxKeyAllowed)
		endIf
	ElseIf(Page == " Mods Loaded")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption(" General")
		AddToggleOption("Deviously Joyful", bJF_DD, OPTION_FLAG_DISABLED)
		SetCursorPosition(1)
		AddHeaderOption(" Devious")
		AddToggleOption("Devious Devices", bDDLoaded, OPTION_FLAG_DISABLED)
		AddToggleOption("PetCollar", bPetCollarLoaded, OPTION_FLAG_DISABLED)
	ElseIf(Page == " Flag Viewer")
		If(bJF_DD)
			AddHeaderOption(" Punishments")
			AddEmptyOption()
			AddToggleOption("Blindfold", Util.DBlindfoldPunishment, OPTION_FLAG_DISABLED)
			AddToggleOption("Gag", Util.DGagPunishment, OPTION_FLAG_DISABLED)
			AddToggleOption("Heavy Bondage", Util.DHeavyBondagePunishment, OPTION_FLAG_DISABLED)
			AddToggleOption("Bondage Gloves", Util.DGlovesPunishment, OPTION_FLAG_DISABLED)
			AddToggleOption("Bondage Boots", Util.DBootsPunishment, OPTION_FLAG_DISABLED)
			AddEmptyOption()
		EndIf
		AddHeaderOption(" Flags")
		AddEmptyOption()
		AddToggleOption("Greedy", Util.FIsGreedy, OPTION_FLAG_DISABLED)
		AddToggleOption("Cruel", Util.FIsCruel, OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddEmptyOption()
		AddToggleOption("Public Humiliation", Util.FPublicHumiliation, OPTION_FLAG_DISABLED)
		AddToggleOption("Bestiality", Util.FBestiality, OPTION_FLAG_DISABLED)
		AddToggleOption("Petplay", Util.FPetPlay, OPTION_FLAG_DISABLED)
		AddToggleOption("Chain Rape", Util.FChainRape, OPTION_FLAG_DISABLED)
		AddToggleOption("Gangbang", Util.FGangbang, OPTION_FLAG_DISABLED)
		AddToggleOption("Torture", Util.FTorture, OPTION_FLAG_DISABLED)
		AddToggleOption("Bondage Lover", Util.FBondageLover, OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		AddHeaderOption(" Tokens")
		AddEmptyOption()
		; AddTextOption("Leave", Util.TLeaveToken + "/8", OPTION_FLAG_DISABLED)
		AddTextOption("Marriage", Util.TMarryToken + "/4", OPTION_FLAG_DISABLED)
	ElseIf(Page == " Debug")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption(" Notifications")
		AddToggleOptionST("DeNo", "Debug Notifications", bDeNo)
		AddToggleOptionST("LoNo", "Location Notifications", bLocNo)
		AddEmptyOption()
		AddHeaderOption(" Debug")
		AddToggleOptionST("DebugRecruit", "Debug Dialogue", bDebugRecruit)
		SetCursorPosition(1)
		AddHeaderOption(" Cheats")
		AddTextOptionST("CheatAffection", "Increase Affection", none)
	EndIf
EndEvent

Event OnConfigClose()
	JF_ChallengeChance.Value = ChallengeChance
EndEvent

; ==================================
; 				States // General
; ==================================
State AffectionChange
	Event OnSelectST()
		bShowAffectionChange = !bShowAffectionChange
		SetToggleOptionValueST(bShowAffectionChange)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Get a small notification whenever Affection goes up or down. \n(Does nothing when Debug Notifications are enabled)")
	EndEvent
EndState

State Bestiality
	Event OnSelectST()
		bCreatureContent = !bCreatureContent
		SetToggleOptionValueST(bCreatureContent)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Toggle Bestiality Content in this mod. \nNote that this only affects forced content. Meaning events that leave you a choice or paths that let you engage with creatures manually will still occur.")
	EndEvent
EndState

State ArousalThresholdSt
	Event OnSliderOpenST()
		SetSliderDialogStartValue(ArousalThreshold)
		SetSliderDialogDefaultValue(70)
		SetSliderDialogRange(30, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		ArousalThreshold = value as int
		SetSliderOptionValueST(ArousalThreshold)
	EndEvent
	Event OnHighlightST()
		SetInfoText("How high does Arousal have to be to consider an Actor aroused?")
	EndEvent
EndState

; State OHEnab
; 	Event OnSelectST()
; 		bOHenab = !bOHenab
; 		SetToggleOptionValueST(bOHenab)
; 	EndEvent
; 	Event OnHighlightST()
; 	SetInfoText("I recommend disabling this if you arent using a Follower Framework or use another mod that has your follower react if you are attacking them.")
; 	EndEvent
; EndState

; State EndMin
; 	Event OnSliderOpenST()
; 		SetSliderDialogStartValue(iOHmin)
; 		SetSliderDialogDefaultValue(5)
; 		SetSliderDialogRange(4, iOHmax)
; 		SetSliderDialogInterval(1)
; 	EndEvent
; 	Event OnSliderAcceptST(float value)
; 		iOHmin = value as int
; 		SetSliderOptionValueST(iOHmin)
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("Minimum hits your follower takes before reacting.")
; 	EndEvent
; EndState

; State EndMax
; 	Event OnSliderOpenST()
; 		SetSliderDialogStartValue(iOHmax)
; 		SetSliderDialogDefaultValue(9)
; 		SetSliderDialogRange(iOHmin, 25)
; 		SetSliderDialogInterval(1)
; 	EndEvent
; 	Event OnSliderAcceptST(float value)
; 		iOHmax = value as int
; 		SetSliderOptionValueST(iOHmax)
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("Maximum hits your follower takes before reacting.")
; 	EndEvent
; EndState

State FiF
	Event OnSelectST()
		bIsFuta = !bIsFuta
		SetToggleOptionValueST(bIsFuta)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Dialogue setting to allow a female follower to make use of otherwise male exclusive Dialogue.")
	EndEvent
EndState

State PiF
	Event OnSelectST()
		bIsFutaPl = !bIsFutaPl
		SetToggleOptionValueST(bIsFutaPl)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Dialogue setting to allow the female player to make use of otherwise male exclusive Dialogue.")
	EndEvent
EndState

State Affection
	Event OnHighlightST()
		SetInfoText("Affection is the equivalent of Progress in this mod. \nIt increaes when spending time with your follower or when giving them Presents (*Requires Affection Lv2) and is lost when you treat them bad!")
	EndEvent
EndState

State Tired
	Event OnHighlightST()
		SetInfoText("How tired you are. \nThe higher it is, the easier your Follower can take advantage of you. It's also harder to persuade or intimidate others. \nFatigue increases over time and decreases through sleeping!")
	EndEvent
EndState

State Stress
	Event OnHighlightST()
		SetInfoText("How stressed out your follower is. \nThis influences many different things in this mod: Events, Affection, Debt (if enabled), and so on! \nStress increases over time or when your Follower enters Bleedout and decreases through sleeping!")
	EndEvent
EndState

State ExplLockOut
	Event OnHighlightST()
		SetInfoText("If you are locked out from Follower Interaction.\nWhen this is active, all Follower commentary will be disabled and no Events can start. You will however still have access to most Follower functionality and Debt. Dismissing your Follower in this State is highly punishing.")
	EndEvent
EndState

State EventChance
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iEvent)
		SetSliderDialogDefaultValue(15)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iEvent = value as int
		SetSliderOptionValueST(iEvent)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Chance of an Event being evaluated.\nThis setting is NOT equal to the Chance that an Event actually starts. It only influences how often the game looks for Events.")
	EndEvent
EndState

State Cooldown
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iCooldown)
		SetSliderDialogDefaultValue(36)
		SetSliderDialogRange(6, 96)
		SetSliderDialogInterval(3)
	EndEvent
	Event OnSliderAcceptST(float value)
		iCooldown = value as int
		SetSliderOptionValueST(iCooldown)
	EndEvent
	Event OnHighlightST()
		SetInfoText("The minimum amount of time between Events. Note that this time is halved for small Events and Events that you trigger manually dont respect this setting.")
	EndEvent
EndState

; ==================================
; 			States // My Fair Share
; ==================================
State ShareEnabled
	Event OnSelectST()
		bDebtEnabled = !bDebtEnabled
		SetToggleOptionValueST(bDebtEnabled)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Wether or not your follower expects to be payed.")
	EndEvent
EndState

State ComplexDebt
	Event OnSelectST()
		bDebtComplex = !bDebtComplex
		SetToggleOptionValueST(bDebtComplex)
		If(bDebtComplex)
			SetOptionFlagsST(OPTION_FLAG_NONE, true, "FairShareComplex")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "FairShareSimple")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, true, "FairShareComplex")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "FairShareSimple")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("Debt Calculation Model:\nSimple: Debt is added by a flat amount with each Tick.\nComplex: Debt is calculated based on the amount of Gold you gained inbetween each tick.")
	EndEvent
EndState

State FairShareSimple
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iDebtGain)
		SetSliderDialogDefaultValue(600)
		SetSliderDialogRange(10, 5000)
		SetSliderDialogInterval(10)
	EndEvent
	Event OnSliderAcceptST(float value)
		iDebtGain = value as int
		SetSliderOptionValueST(iDebtGain)
	EndEvent
	Event OnHighlightST()
		SetInfoText("The average amount of gold the follower expects with each tick. This may vary depending on your followers mood.")
	EndEvent
EndState

State FairShareComplex
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fDebtBasePay)
		SetSliderDialogDefaultValue(60)
		SetSliderDialogRange(5, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		fDebtBasePay = value
		SetSliderOptionValueST(fDebtBasePay)
	EndEvent
	Event OnHighlightST()
		SetInfoText("How much of the gold you gain with each tick is to be shared with your follower? This may vary depending on your followers mood.")
	EndEvent
EndState

State Segment1
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iDebtSeg1)
		SetSliderDialogDefaultValue(2000)
		SetSliderDialogRange(100, 5000)
		SetSliderDialogInterval(100)
	EndEvent
	Event OnSliderAcceptST(float value)
		iDebtSeg1 = value as int
		SetSliderOptionValueST(iDebtSeg1)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Low Debt from 0 to <" + iDebtSeg1 + ">")
	EndEvent
EndState

State Segment2
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iDebtSeg2)
		SetSliderDialogDefaultValue(4000)
		SetSliderDialogRange(iDebtSeg1, 10000)
		SetSliderDialogInterval(250)
	EndEvent
	Event OnSliderAcceptST(float value)
		iDebtSeg2 = value as int
		SetSliderOptionValueST(iDebtSeg2)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Low Debt from " + iDebtSeg1 + " to <" + iDebtSeg2 + ">\nHigh Debt from <" + iDebtSeg2 + "> to " + iDebtSeg3)
	EndEvent
EndState

State Segment3
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iDebtSeg3)
		SetSliderDialogDefaultValue(8000)
		SetSliderDialogRange(iDebtSeg2, 20000)
		SetSliderDialogInterval(500)
	EndEvent
	Event OnSliderAcceptST(float value)
		iDebtSeg3 = value as int
		SetSliderOptionValueST(iDebtSeg3)
	EndEvent
	Event OnHighlightST()
		SetInfoText("High Debt from " + iDebtSeg2 + " to <" + iDebtSeg3 + ">\nExcessive Debt from <" + iDebtSeg3 + "> onward")
	EndEvent
EndState

State DebtLockOut
	Event OnSelectST()
		bDebtLockOut = !bDebtLockOut
		SetToggleOptionValueST(bDebtLockOut)
		If(bDebtLockOut)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DebtLockOutSegment")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DebtLockOutSegment")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("High Debt may lock out Follower interaction.")
	EndEvent
EndState

State DebtLockOutSegment
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iDebtLockoutSeg)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(1, 3)
		SetSliderDialogInterval(5)
	EndEvent
	Event OnSliderAcceptST(float value)
		iDebtLockoutSeg = value as int
		SetSliderOptionValueST(iDebtLockoutSeg)
	EndEvent
	Event OnHighlightST()
		SetInfoText("From which Segment on will Follower interaction be locked out?")
	EndEvent
endState

State DebtBadEnd
	Event OnSelectST()
		bDebtBadEnd = !bDebtBadEnd
		SetToggleOptionValueST(bDebtBadEnd)
	EndEvent
	Event OnHighlightST()
		SetInfoText("\"Hey! If you dont wanna pay me, thats fine! Be greedy! But know youre not the only one with money in their pockets!\"")
	EndEvent
EndState

State CreditEnable
	Event OnSelectST()
		bCreditEnable = !bCreditEnable
		SetToggleOptionValueST(bCreditEnable)
		If(bCreditEnable)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "CreditDecay")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "CreditDecay")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("Debt below 0 is considered \"Credit\". If this option is disabled, Credit is lost immediately; otherwise Credit will be stored and used to pay of future Debt.")
	EndEvent
EndState

State CreditDecay
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iCreditDecay)
		SetSliderDialogDefaultValue(20)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iCreditDecay = ((value as int) / 100)
		SetSliderOptionValueST(iCreditDecay)
	EndEvent
	Event OnHighlightST()
		SetInfoText("How much % of your credit is lost with each tick.\nA setting of 0 means Credit doesnt decay.")
	EndEvent
EndState
; ==================================
; 				States // Events
; ==================================
State CutEnab
	Event OnSelectST()
		bCutEn = !bCutEn
		SetToggleOptionValueST(bCutEn)
		If(bCutEn)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "CutTimeGone")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "CutTimeGone")
		EndIf
	EndEvent
EndState

; State CutTimeGone
; 	Event OnSliderOpenST()
; 		SetSliderDialogStartValue(iMaxTimeOut)
; 		SetSliderDialogDefaultValue(12)
; 		SetSliderDialogRange(6, 72)
; 		SetSliderDialogInterval(3)
; 	EndEvent
; 	Event OnSliderAcceptST(float value)
; 		iMaxTimeOut = value as int
; 		SetSliderOptionValueST(iMaxTimeOut)
; 	EndEvent
; 	Event OnHighlightST()
; 		SetInfoText("During \"My Cut\", your Follower will leave your side for 6~[this Setting] hours.")
; 	EndEvent
; EndState

State SitWEnabled
	Event OnSelectST()
		bSitWEnab = !bSitWEnab
		SetToggleOptionValueST(bSitWEnab)
		If(bSitWEnab)
			SetOptionFlagsST(OPTION_FLAG_NONE, true, "SitWBadEnd")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "SitWWorseEnd")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, true, "SitWBadEnd")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "SitWWorseEnd")
		EndIf
	EndEvent
EndState

State SitWBadEnd
	Event OnSelectST()
		bSCSteal = !bSCSteal
		SetToggleOptionValueST(bSCSteal)
		If(bSCSteal)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "SitWWorseEnd")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "SitWWorseEnd")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("\"They say bandits are always on the hunt for valuables..\"")
	EndEvent
EndState

State SitWWorseEnd
	Event OnSelectST()
		bSCWorse = !bSCWorse
		SetToggleOptionValueST(bSCWorse)
	EndEvent
	Event OnHighlightST()
		SetInfoText("\"They say cursed items can bring in a nice price..\"")
	EndEvent
EndState

State BelowCollEnab
	Event OnSelectST()
		bBCEnab = !bBCEnab
		SetToggleOptionValueST(bBCEnab)
		If(bBCEnab)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "BCShowTaken")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "BCShowTaken")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("This requires Creature Content to be enabled!")
	EndEvent
endState

State BCShowTaken
	Event OnSelectST()
		bBCShowTaken = !bBCShowTaken
		SetToggleOptionValueST(bBCShowTaken)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Should a Messagebox be displayed, listing the Items you lost?")
	EndEvent
EndState

State TraitorTimescale
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iTraitorScale)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(20, 120)
		SetSliderDialogInterval(5)
	EndEvent
	Event OnSliderAcceptST(float value)
		iTraitorScale = value as int
		SetSliderOptionValueST(iTraitorScale)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Some parts of the Event will require you to wait a certain amount of time. You can decrease the time you have to wait during those periods by increasing this Value. Vanilla Default is 20.")
	EndEvent
EndState

State TraitorAdult
	Event OnSelectST()
		bTraitorEnabAdult = !bTraitorEnabAdult
		SetToggleOptionValueST(bTraitorEnabAdult)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Traitor! is designed as a SFW Event. Enabling this may break Immersion but it will introduce some NSFW bits.\n!If you are siding with the Dawnguard, this also requires bestiality to be enabled.")
	EndEvent
EndState

State DogCollarEnab
	Event OnSelectST()
		bDogCollarEnab = !bDogCollarEnab
		SetToggleOptionValueST(bDogCollarEnab)
		If(bDogCollarEnab)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DogCollarDur")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DogCollarDur")
		EndIf
	endEvent
EndState

State DogCollarDur
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iDogCollarDur)
		SetSliderDialogDefaultValue(36)
		SetSliderDialogRange(12, 168) ;7 Days
		SetSliderDialogInterval(3)
	EndEvent
	Event OnSliderAcceptST(float value)
		iDogCollarDur = value as int
		SetSliderOptionValueST(iDogCollarDur)
		DogCollar_Var.Value = Value
	EndEvent
	Event OnHighlightST()
		SetInfoText("The maximum initial time this Event will stay active.")
	EndEvent
EndState


; ==================================
; 				States // Challenges
; ==================================
State ChallChance
	Event OnSliderOpenST()
		SetSliderDialogStartValue(ChallengeChance)
		SetSliderDialogDefaultValue(15)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		ChallengeChance = value as int
		SetSliderOptionValueST(ChallengeChance, "{0}%")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Likeliness of your Follower suggesting a Challenge. This is mulitplied with Event Chance. Set to 0 to disable.\n*You may still ask for a Challenge manually in the first Minute after entering a Dungeon.")
	EndEvent
EndState

; ==================================
; 			States // Key Holder
; ==================================
State KHFind
	Event OnSelectST()
		bKHFind = !bKHFind
		SetToggleOptionValueST(bKHFind)
	EndEvent
EndState

State KHFreq
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fKHFreq)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.5, 12.0)
		SetSliderDialogInterval(0.5)
	EndEvent
	Event OnSliderAcceptST(float value)
		fKHFreq = value
		SetSliderOptionValueST(fKHFreq, "{0}h")
	EndEvent
	Event OnHighlightST()
		SetInfoText("How often your follower searches for keys.")
	EndEvent
EndState

State KHAngry
	Event OnSelectST()
		bKHAngr = !bKHAngr
		SetToggleOptionValueST(bKHAngr)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Does your follower search for keys when they are stressed out?")
	EndEvent
EndState

State KhChance
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iKHChance)
		SetSliderDialogDefaultValue(15)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(5)
	EndEvent
	Event OnSliderAcceptST(float value)
		iKHChance = value as int
		SetSliderOptionValueST(iKHChance, "{0}%")
	EndEvent
EndState

State ChastKey
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iKHChast)
		SetSliderDialogDefaultValue(25)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iKHChast = value as int
		SetSliderOptionValueST(iKHChast, "{0}%")
		GoToState("RestKey")
		If(iKHChast == 100)
			iKHRest = 0
			SetSliderOptionValueST(iKHRest, "{0}%")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, true, "RestKey")
		ElseIf((iKHChast + iKHRest) > 100)
			iKHRest = (100 - iKHChast)
			SetSliderOptionValueST(iKHRest, "{0}%")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "RestKey")
		EndIf
		GotoState("")
		iKHPierc = (100 - iKHchast - iKHRest)
		SetSliderOptionValue(PiercKey, iKHPierc, "{0}%")
	EndEvent
EndState

State KHFiNo
	Event OnSelectST()
		bKHFiNo = !bKHFiNo
		SetToggleOptionValueST(bKHFiNo)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Get a notification in the corner of your screen when your follower finds a key.")
	EndEvent
EndState

State RestKey
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iKHRest)
		SetSliderDialogDefaultValue(60)
		SetSliderDialogRange(0, (100 - iKHChast))
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iKHRest = value as int
		SetSliderOptionValueST(iKHRest, "{0}%")
		GoToState("")
		iKHPierc = (100 - iKHchast - iKHRest)
		SetSliderOptionValue(PiercKey, iKHPierc, "{0}%")
	EndEvent
EndState

State LoseKeys
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iLoseKeys)
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(50, 100)
		SetSliderDialogInterval(5)
	EndEvent
	Event OnSliderAcceptST(float value)
		iLoseKeys = value as int
		SetSliderOptionValueST(iLoseKeys, "{0}%")
	EndEvent
	Event OnHighlightST()
		SetInfoText("Chance that your follower loses up to 2 keys when they are victim in a SL Scene or knocked down (Bleedout).")
	EndEvent
EndState

State KeyMax
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iMaxKeyAllowed)
		SetSliderDialogDefaultValue(4)
		SetSliderDialogRange(1, 12)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iMaxKeyAllowed = value as int
		SetSliderOptionValueST(iMaxKeyAllowed)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Your follower stops searching for keys if they have more than this amount of keys in their (key holder) inventory.")
	EndEvent
EndState

; ==================================
; 		States // Devious Devices
; ==================================
State PunishEnable
	Event OnSelectST()
		bPunishEnab = !bPunishEnab
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Master Switch for all Generic Consequences.\nDoes not affect Punishment Games.")
	EndEvent
EndState

State PunishColourOptionMenu
	Event OnMenuOpenST()
			SetMenuDialogStartIndex(PunishColourOption)
			SetMenuDialogDefaultIndex(6)
			SetMenuDialogOptions(PunishColourOptionList)
	EndEvent
	Event OnMenuAcceptST(int index)
		PunishColourOption = index
		SetMenuOptionValueST(PunishColourOptionList[PunishColourOption])
	EndEvent
	Event OnDefaultST()
		PunishColourOption = 6
		SetMenuOptionValueST(PunishColourOptionList[PunishColourOption])
	EndEvent
EndState

State BothCuffEnab
	Event OnSelectST()
		bCuffBoth = !bCuffBoth
		SetToggleOptionValueST(bCuffBoth)
	EndEvent
	Event OnHighlightST()
		SetInfoText("When enabling this, getting equipped with one type of cuffs also equipps the other one. The weight sliders for cuffs will be effectively merged.\n(E.g. having a Weight 80 on Arm Cuffs and Weight 80 on Leg Cuffs will be treated as a Weight of 160 on Cuffs. If you dont want this, set Arm or Leg Cuff weight to 0.)")
	EndEvent
EndState
; ------------ Gen Punishments Start
State BlindfoldEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iBlindEnab)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iBlindEnab = value as int
		SetSliderOptionValueST(iBlindEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State GagEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iGagEnab)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iGagEnab = value as int
		SetSliderOptionValueST(iGagEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State HeavyBondageEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iHeavyBonEnab)
		SetSliderDialogDefaultValue(20)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iHeavyBonEnab = value as int
		SetSliderOptionValueST(iHeavyBonEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State CorsetEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iCorsetEnab)
		SetSliderDialogDefaultValue(70)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iCorsetEnab = value as int
		SetSliderOptionValueST(iCorsetEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State RubberGlovesEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iRubberGlovEnab)
		SetSliderDialogDefaultValue(40)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iRubberGlovEnab = value as int
		SetSliderOptionValueST(iRubberGlovEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State RubberBootsEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iRubberBootEnab)
		SetSliderDialogDefaultValue(40)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iRubberBootEnab = value as int
		SetSliderOptionValueST(iRubberBootEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State ArmCuffEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iCuffArmEnab)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iCuffArmEnab = value as int
		SetSliderOptionValueST(iCuffArmEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState

State LegCuffEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iCuffLegEnab)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iCuffLegEnab = value as int
		SetSliderOptionValueST(iCuffLegEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \nSet to 0 to disable.")
	EndEvent
EndState

State AnkleShackEnab
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iAnkleShackEnab)
		SetSliderDialogDefaultValue(70)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	EndEvent
	Event OnSliderAcceptST(float value)
		iAnkleShackEnab = value as int
		SetSliderOptionValueST(iAnkleShackEnab)
		;Disabling Master Switch when all Generic Consequences are disabled
		If(iBlindEnab == 0 && iGagEnab == 0 && iHeavyBonEnab == 0 && iCuffArmEnab == 0 && iCuffLegEnab == 0 && iAnkleShackEnab == 0 && iCorsetEnab == 0 && iRubberBootEnab == 0 && iRubberGlovEnab == 0)
			bPunishEnab = false
			shouldPunishDisable = true
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PunishEnable")
		Else
			shouldPunishDisable = false
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PunishEnable")
		EndIf
		GotoState("PunishEnable")
		SetToggleOptionValueST(bPunishEnab)
	EndEvent
	Event OnHighlightST()
		SetInfoText("This weight is relative to all other consequences. \n Set to 0 to disable.")
	EndEvent
EndState
; ------------ Gen Punishments End | Events Start
State KHEnabled
	Event OnSelectST()
		bKHEnab = !bKHEnab
		SetToggleOptionValueST(bKHEnab)
		If(bKHEnab)
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "KHColourOptionMenu")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "KHColourOptionMenu")
		EndIf
	EndEvent
EndState

State KHColourOptionMenu
	Event OnMenuOpenST()
			SetMenuDialogStartIndex(KHColourOption)
			SetMenuDialogDefaultIndex(6)
			SetMenuDialogOptions(KHColourOptionList)
	EndEvent
	Event OnMenuAcceptST(int index)
		KHColourOption = index
		SetMenuOptionValueST(KHColourOptionList[KHColourOption])
	EndEvent
	Event OnDefaultST()
		KHColourOption = 6
		SetMenuOptionValueST(KHColourOptionList[KHColourOption])
	EndEvent
EndState
; ------------ Events End | Games Start
State ShutUpEnab
	Event OnSelectST()
		bTGEnab = !bTGEnab
		SetToggleOptionValueST(bTGEnab)
		If(bTGEnab)
			SetOptionFlagsST(OPTION_FLAG_NONE, true, "MaxTimeGagged")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "TalkingTakesTime")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, true, "MaxTimeGagged")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "TalkingTakesTime")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("Make sure to have at least 1 game enabled.")
	EndEvent
EndState

State MaxTimeGagged
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iTG)
		SetSliderDialogDefaultValue(16)
		SetSliderDialogRange(6, 72) ;3 Days
		SetSliderDialogInterval(3)
	EndEvent
	Event OnSliderAcceptST(float value)
		iTG = value as int
		SetSliderOptionValueST(iTG)
		ShutUp_Var.Value = value
	EndEvent
	Event OnHighlightST()
		SetInfoText("The maximum initial time this Event will stay active.")
	EndEvent
EndState

State TalkingTakesTime
	Event OnSelectST()
		bTG = !bTG
		SetToggleOptionValueST(bTG)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Breaking the rules will be punished!")
	EndEvent
EndState

State PCEnab
	Event OnSelectST()
		bPetCollarEnab = !bPetCollarEnab
		SetToggleOptionValueST(bPetCollarEnab)
		If(bPetCollarEnab)
			SetOptionFlagsST(OPTION_FLAG_NONE, true, "PCTime")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "PCMCM")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, true, "PCTime")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "PCMCM")
		EndIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("Make sure to have at least 1 game enabled.")
	EndEvent
EndState

State PCTime
	Event OnSliderOpenST()
		SetSliderDialogStartValue(iPetCollarDur)
		SetSliderDialogDefaultValue(36)
		SetSliderDialogRange(12, 168) ;7 Days
		SetSliderDialogInterval(3)
	EndEvent
	Event OnSliderAcceptST(float value)
		iPetCollarDur = value as int
		SetSliderOptionValueST(iPetCollarDur)
		PetCollar_Var.Value = value
	EndEvent
	Event OnHighlightST()
		SetInfoText("The maximum initial time this Event will stay active.")
	EndEvent
EndState

State PCMCM
	Event OnSelectST()
		bPetCollarMCM = !bPetCollarMCM
		SetToggleOptionValueST(bPetCollarMCM)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Wether or not this mod is allowed to make changes in the PetCollar MCM Settings. Note that I designed the Event around this setting being enabled.\nChanges made will be reset once the Event closes.")
	EndEvent
EndState

; ==================================
; 				States // Debug
; ==================================
State DeNo
	Event OnSelectST()
		bDeNo = !bDeNo
		SetToggleOptionValueST(bDeNo)
	EndEvent
EndState

State LoNo
	Event OnSelectST()
		bLocNo = !bLocNo
		SetToggleOptionValueST(bLocNo)
	EndEvent
EndState

State DebugRecruit
	Event OnSelectST()
		bDebugRecruit = !bDebugRecruit
		SetToggleOptionValueST(bDebugRecruit)
	EndEvent
	Event OnHighlightST()
		SetInfoText("Enabling this option will give you access to debug dialogue options:\n * Forcefully recruit a JoyFol (incl. Animals, excl. Childs; If you already have a JF, they will become a normal follower).\n * Dismiss your current JoyFol. \n * Disallow your target to become a JoyFol (If they already are a JoyFol, they will become a normal follower; Undo with Option 1).")
	EndEvent
EndState

State CheatAffection
	Event OnSelectST()
		JF_Affection.value += 200
		SetTextOptionValueST(JF_Affection.Value as int)
		(CoreQuest as JFCore).GainAffection()
	EndEvent
	Event OnHighlightST()
		SetInfoText("Immediately increase Affection by 200.")
	EndEvent
EndState

State CheatDebt
	Event OnSelectST()
		JF_Var_Debt.Value += 500
	EndEvent
	Event OnHighlightST()
		SetInfoText("Immediately increase Affection by 500.")
	EndEvent
EndState
; /;