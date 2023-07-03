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
; --- Event
bool Property bStolenSteal = true Auto Hidden
bool Property bStolenBadEnd = false Auto Hidden
float Property fPuppyDur = 9.5 Auto Hidden
GlobalVariable Property PuppyDurGlobal Auto
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

; --------------------- Add On System

String Property PageKey = "__JFMCMPages" AutoReadOnly
int Property _MAXPAGES = 100 AutoReadOnly
int Property _ActivePageID = -1 Auto Hidden

JFMCMPage Function GetActivePage()
	If(_ActivePageID == -1 || _ActivePageID > NumberAddOns())
		return none
	EndIf
	return StorageUtil.FormListGet(self, PageKey, _ActivePageID) as JFMCMPage
EndFunction

JFMCMPage Function FindPage(String asPage)
	Form[] mypages = StorageUtil.FormListToArray(self, PageKey)
  int i = 0
  While(i < mypages.Length)
		JFMCMPage page = mypages[i] as JFMCMPage
    If(page._PageName == asPage)
			_ActivePageID = i
      return page
    ElseIf(page._PageName == "")
      return none
    EndIf
    i += 1
  EndWhile
  return none
EndFunction

int Function NumberAddOns()
	return StorageUtil.FormListCount(self, PageKey)
EndFunction

bool Function AddNewPage(JFMCMPage akNewPage)
	If(NumberAddOns() >= _MAXPAGES)
		Debug.Trace("[JF] Cannot add more Pages. Page " + akNewPage + " will not be added")
		return false
	ElseIf(StorageUtil.FormListAdd(self, PageKey, akNewPage, false) == -1)
		Debug.Trace("[JF] Unable to add Page " + akNewPage)
		return false
	EndIf
	SetPages()
	return true
EndFunction

Function SetPages()
	int _OffsetFirst = 2
	int _OffsetLast = 1
  int _NumAddons = NumberAddOns()
	Pages = Utility.CreateStringArray(_OffsetFirst + _OffsetLast + _NumAddons)
  ; -- Create Pages pre-Addon
	Pages[0] = "$JF_General"
	Pages[1] = "$JF_Events"
  ; --
	int i = _OffsetFirst
	While(i < Pages.Length - _OffsetLast)
		JFMCMPage tmp = StorageUtil.FormListGet(self, PageKey, i - _OffsetFirst) as JFMCMPage
		Pages[i] = tmp._PageName
		i += 1
	EndWhile
  ; -- Create Pages post-Addon
	Pages[i] = "$JF_Debug"
  ; --
EndFunction

; ---------------------------- Menu
int Function GetVersion()
	return 1
EndFunction

Event OnConfigInit()
	SetPages()

	debtmodels = new String[2]
	debtmodels[0] = "$JF_DebtSimple" ; Simple
	debtmodels[1] = "$JF_DebtDynamic" ; Dynamic
EndEvent

Event OnPageReset(String page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	If(page == "")
		page = "$JF_General"
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
	ElseIf(page == "$JF_Events")
		AddHeaderOption("$JF_Stolen")
		AddToggleOptionST("stolenStealing", "$JF_StolenStealing", bStolenSteal)
		AddToggleOptionST("stolenBadEnd", "$JF_StolenBadEnd", bStolenBadEnd, getFlag(bStolenSteal))
		AddHeaderOption("$JF_Puppy")
		AddSliderOptionST("puppydur", "$JF_PuppyDur", fPuppyDur, "{1}h")
		AddHeaderOption("$JF_Traitor")
		AddSliderOptionST("traitorscale", "$JF_TraitorScale", iTraitorScale, "{0}")
		SetCursorPosition(1)
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
	Else
		Debug.Trace("[JF] Looking for Page > " + page)
		JFMCMPage mcmpage = FindPage(page)
		If(mcmpage)
			mcmpage.OnPageReset()
		EndIf
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

; ----------------- Event States

Event OnSelectST()
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnSelectST()
		return
	EndIf
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
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnSliderOpenST()
		return
	EndIf
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
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnSliderAcceptST(afValue)
		return
	EndIf
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
	ElseIf(op[0] == "puppydur")
		fPuppyDur = afValue
		SetSliderOptionValueST(fPuppyDur, "{1}h")
		PuppyDurGlobal.Value = fPuppyDur
	ElseIf(op[0] == "traitorscale")
		iTraitorScale = afValue as int
		SetSliderOptionValueST(iTraitorScale, "{0}")
	EndIf
EndEvent

Event OnMenuOpenST()
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnMenuOpenST()
		return
	EndIf
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "debtmodel")
		SetMenuDialogStartIndex(debtmodelindex)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(debtmodels)
		ForcePageReset()
	EndIf
EndEvent

Event OnMenuAcceptST(Int aiIndex)
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnMenuAcceptST(aiIndex)
		return
	EndIf
	String[] op = PapyrusUtil.StringSplit(GetState(), "_")
	If(op[0] == "debtmodel")
		debtmodelindex = aiIndex
		SetMenuOptionValueST(debtmodels[debtmodelindex])
	EndIf
EndEvent

Event OnDefaultST()
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnDefaultST()
	EndIf
EndEvent

Event OnColorOpenST()
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnColorOpenST()
	EndIf
EndEvent

Event OnColorAcceptST(int aiColor)
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnColorAcceptST(aiColor)
	EndIf
EndEvent

Event OnKeyMapChangeST(int aiKeyCode, string asConflictControl, string asConflictName)
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnKeyMapChangeST(aiKeyCode, asConflictControl, asConflictName)
	EndIf
EndEvent

Event OnInputOpenST()
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnInputOpenST()
	EndIf
EndEvent

Event OnInputAcceptST(string asInput)
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnInputAcceptST(asInput)
	EndIf
EndEvent

Event OnHighlightST()
	JFMCMPage page = GetActivePage()
	If(page)
		page.GoToState(GetState())
		page.OnHighlightST()
	EndIf
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

; ----------------- Legacy Events

Event OnOptionSelect(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionSelect(aiOption)
	EndIf
EndEvent

Event OnOptionDefault(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionDefault(aiOption)
	EndIf
EndEvent

Event OnOptionSliderOpen(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionSliderOpen(aiOption)
	EndIf
EndEvent

Event OnOptionSliderAccept(int aiOption, float afValue)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionSliderAccept(aiOption, afValue)
	EndIf
EndEvent

Event OnOptionMenuOpen(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionMenuOpen(aiOption)
	EndIf
EndEvent

Event OnOptionMenuAccept(int aiOption, int aiIndex)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionMenuAccept(aiOption, aiIndex)
	EndIf
EndEvent

Event OnOptionColorOpen(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionColorOpen(aiOption)
	EndIf
EndEvent

Event OnOptionColorAccept(int aiOption, int aiColor)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionColorAccept(aiOption, aiColor)
	EndIf
EndEvent

Event OnOptionKeyMapChange(int aiOption, int aiKeyCode, string asConflictControl, string asConflictName)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionKeyMapChange(aiOption, aiKeyCode, asConflictControl, asConflictName)
	EndIf
EndEvent

Event OnOptionInputOpen(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionInputOpen(aiOption)
	EndIf
EndEvent

Event OnOptionInputAccept(int aiOption, string asInput)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionInputAccept(aiOption, asInput)
	EndIf
EndEvent

Event OnOptionHighlight(int aiOption)
	JFMCMPage page = GetActivePage()
	If(page)
		page.OnOptionHighlight(aiOption)
	EndIf
EndEvent
