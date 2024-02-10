Scriptname JFMCMPage extends Quest

JFMCM Property _ParentMCM Auto
{Fill with JFs MCM in JF_Main}

String Property _PageName = "_UNDEFINED" Auto
{Fill with the Name for your Page}

Event OnInit()
  If(!_ParentMCM)
    Debug.MessageBox("[JF Addon] Parent MCM Property not filled for " + self)
    Debug.Trace("[JF Addon] Parent MCM Property not filled for " + self)
    return
  EndIf
  If(!_ParentMCM.AddNewPage(self))
    Debug.Trace("[JF Addon] Failed to add page " + self)
    return
  EndIf
  InitializePage()
EndEvent

; Overwrite this Function to initialize your variables, equivalent to "OnConfigInit()"
Function InitializePage()
EndFunction

; Overwrite and create your page here
; When your option is selected, the MCM will callback into this Script with default SkyUI Events (see below)
Function OnPageReset()
  _ParentMCM.AddTextOption("I am", self)
  _ParentMCM.AddTextOption("I forgot to overwrite", "OnPageCalled()")
EndFunction

; ----------------- Constants

int Property OPTION_FLAG_NONE		    = 0x00 AutoReadOnly
int Property OPTION_FLAG_DISABLED	  = 0x01 AutoReadOnly
int Property OPTION_FLAG_HIDDEN		  = 0x02 AutoReadOnly			; @since 3
int Property OPTION_FLAG_WITH_UNMAP	= 0x04 AutoReadOnly			; @since 3

int Property LEFT_TO_RIGHT	= 1	AutoReadOnly
int Property TOP_TO_BOTTOM	= 2 AutoReadOnly

; ----------------- Functions

Function ForcePageReset()
	_ParentMCM.ForcePageReset()
EndFunction

Function SetInfoText(String asText)
	_ParentMCM.SetInfoText(asText)
EndFunction

Function SetCursorPosition(int aiPosition)
	_ParentMCM.SetCursorPosition(aiPosition)
EndFunction

Function SetCursorFillMode(int aiFillMode)
	_ParentMCM.SetCursorFillMode(aiFillMode)
EndFunction

int Function AddEmptyOption()
	return _ParentMCM.AddEmptyOption()
EndFunction

int Function AddHeaderOption(String asText, int aiFlags = 0)
	return _ParentMCM.AddHeaderOption(asText, aiFlags)
EndFunction

int Function AddTextOption(String asText, String asValue, int aiFlags = 0)
	return _ParentMCM.AddTextOption(asText, asValue, aiFlags)
EndFunction

int Function AddToggleOption(String asText, bool abChecked, int aiFlags = 0)
	return _ParentMCM.AddToggleOption(asText, abChecked, aiFlags)
EndFunction

int Function AddSliderOption(String asText, float afValue, String asFormatString = "{0}", int aiFlags = 0)
	return _ParentMCM.AddSliderOption(asText, afValue, asFormatString, aiFlags)
EndFunction

int Function AddMenuOption(String asText, String asValue, int aiFlags = 0)
	return _ParentMCM.AddMenuOption(asText, asValue, aiFlags)
EndFunction

int Function AddColorOption(String asText, int aiColor, int aiFlags = 0)
	return _ParentMCM.AddColorOption(asText, aiColor, aiFlags)
EndFunction

int Function AddKeyMapOption(String asText, int aiKeyCode, int aiFlags = 0)
	return _ParentMCM.AddKeyMapOption(asText, aiKeyCode, aiFlags)
EndFunction

; @since 4
int Function AddInputOption(String asText, String asValue, int aiFlags = 0)
	return _ParentMCM.AddInputOption(asText, asValue, aiFlags)
EndFunction

; @since 2
Function AddTextOptionST(String asStateName, String asText, String asValue, int aiFlags = 0)
	_ParentMCM.AddTextOptionST(asStateName, asText, asValue, aiFlags)
EndFunction

; @since 2
Function AddToggleOptionST(String asStateName, String asText, bool abChecked, int aiFlags = 0)
	_ParentMCM.AddToggleOptionST(asStateName, asText, abChecked, aiFlags)
EndFunction

; @since 2
Function AddSliderOptionST(String asStateName, String asText, float afValue, String asFormatString = "{0}", int aiFlags = 0)
	_ParentMCM.AddSliderOptionST(asStateName, asText, afValue, asFormatString, aiFlags)
EndFunction

; @since 2
Function AddMenuOptionST(String asStateName, String asText, String asValue, int aiFlags = 0)
	_ParentMCM.AddMenuOptionST(asStateName, asText, asValue, aiFlags)
EndFunction

; @since 2
Function AddColorOptionST(String asStateName, String asText, int aiColor, int aiFlags = 0)
	_ParentMCM.AddColorOptionST(asStateName, asText, aiColor, aiFlags)
EndFunction

; @since 2
Function AddKeyMapOptionST(String asStateName, String asText, int aiKeyCode, int aiFlags = 0)
	_ParentMCM.AddKeyMapOptionST(asStateName, asText, aiKeyCode, aiFlags)
EndFunction

; @since 4
Function AddInputOptionST(String asStateName, String asText, String asValue, int aiFlags = 0)
	_ParentMCM.AddInputOptionST(asStateName, asText, asValue, aiFlags)
EndFunction

Function SetOptionFlags(int aiOption, int aiFlags, bool abNoUpdate = false)
	_ParentMCM.SetOptionFlags(aiOption, aiFlags, abNoUpdate)
EndFunction

Function SetTextOptionValue(int aiOption, String asValue, bool abNoUpdate = false)
	_ParentMCM.SetTextOptionValue(aioption, asValue, abNoUpdate)
EndFunction

Function SetToggleOptionValue(int aiOption, bool abChecked, bool abNoUpdate = false)
	_ParentMCM.SetToggleOptionValue(aiOption, abChecked, abNoUpdate)
EndFunction

Function SetSliderOptionValue(int aiOption, float afValue, String asFormatString = "{0}", bool abNoUpdate = false)
	_ParentMCM.SetSliderOptionValue(aiOption, afValue, asFormatString, abNoUpdate)
EndFunction

Function SetMenuOptionValue(int aiOption, String asValue, bool abNoUpdate = false)
	_ParentMCM.SetMenuOptionValue(aiOption, asValue, abNoUpdate)
EndFunction

Function SetColorOptionValue(int aiOption, int aiColor, bool abNoUpdate = false)
	_ParentMCM.SetColorOptionValue(aiOption, aiColor, abNoUpdate)
EndFunction

Function SetKeyMapOptionValue(int aiOption, int aiKeyCode, bool abNoUpdate = false)
	_ParentMCM.SetKeyMapOptionValue(aiOption, aiKeyCode, abNoUpdate)
EndFunction

; @since 4
Function SetInputOptionValue(int aiOption, String asValue, bool abNoUpdate = false)
	_ParentMCM.SetInputOptionValue(aiOption, asValue, abNoUpdate)
EndFunction

; @since 2
Function SetOptionFlagsST(int aiFlags, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetOptionFlagsST(aiFlags, abNoUpdate, asStateName)
EndFunction

; @since 2
Function SetTextOptionValueST(String asValue, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetTextOptionValueST(asValue, abNoUpdate, asStateName)
EndFunction

; @since 2
Function SetToggleOptionValueST(bool abChecked, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetToggleOptionValueST(abChecked, abNoUpdate, asStateName)
EndFunction

; @since 2
Function SetSliderOptionValueST(float afValue, String asFormatString = "{0}", bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetSliderOptionValueST(afValue, asFormatString, abNoUpdate, asStateName)
EndFunction

; @since 2
Function SetMenuOptionValueST(String asValue, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetMenuOptionValueST(asValue, abNoUpdate, asStateName)
EndFunction

; @since 2
Function SetColorOptionValueST(int aiColor, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetColorOptionValueST(aiColor, abNoUpdate, asStateName)
EndFunction

; @since 2
Function SetKeyMapOptionValueST(int aiKeyCode, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetKeyMapOptionValueST(aiKeyCode, abNoUpdate, asStateName)
EndFunction

; @since 4
Function SetInputOptionValueST(String asValue, bool abNoUpdate = false, String asStateName = "")
	_ParentMCM.SetInputOptionValueST(asValue, abNoUpdate, asStateName)
EndFunction

Function SetSliderDialogStartValue(float afValue)
	_ParentMCM.SetSliderDialogStartValue(afValue)
EndFunction

Function SetSliderDialogDefaultValue(float afValue)
	_ParentMCM.SetSliderDialogDefaultValue(afValue)
EndFunction

Function SetSliderDialogRange(float afMinValue, float afMaxValue)
	_ParentMCM.SetSliderDialogRange(afMinValue, afMaxValue)
EndFunction

Function SetSliderDialogInterval(float afValue)
	_ParentMCM.SetSliderDialogInterval(afValue)
EndFunction

Function SetMenuDialogStartIndex(int aiValue)
	_ParentMCM.SetMenuDialogStartIndex(aiValue)
EndFunction

Function SetMenuDialogDefaultIndex(int aiValue)
	_ParentMCM.SetMenuDialogDefaultIndex(aiValue)
EndFunction

Function SetMenuDialogOptions(String[] asOptions)
	_ParentMCM.SetMenuDialogOptions(asOptions)
EndFunction

Function SetColorDialogStartColor(int aiColor)
	_ParentMCM.SetColorDialogStartColor(aiColor)
EndFunction

Function SetColorDialogDefaultColor(int aiColor)
	_ParentMCM.SetColorDialogDefaultColor(aiColor)
EndFunction

; @since 4
Function SetInputDialogStartText(String asText)
  _ParentMCM.SetInputDialogStartText(asText)
EndFunction

bool Function ShowMessage(String asMessage, bool abWithCancel = true, String asAcceptLabel = "$Accept", String asCancelLabel = "$Cancel")
	return _ParentMCM.ShowMessage(asMessage, abWithCancel, asAcceptLabel, asCancelLabel)
EndFunction

; ----------------- Events

Event OnOptionHighlight(int aiOption)
EndEvent

Event OnOptionSelect(int aiOption)
EndEvent

Event OnOptionDefault(int aiOption)
EndEvent

Event OnOptionSliderOpen(int aiOption)
EndEvent

Event OnOptionSliderAccept(int aiOption, float afValue)
EndEvent

Event OnOptionMenuOpen(int aiOption)
EndEvent

Event OnOptionMenuAccept(int aiOption, int aiIndex)
EndEvent

Event OnOptionColorOpen(int aiOption)
EndEvent

Event OnOptionColorAccept(int aiOption, int aiColor)
EndEvent

Event OnOptionKeyMapChange(int aiOption, int aiKeyCode, string asConflictControl, string asConflictName)
EndEvent

Event OnOptionInputOpen(int aiOption)
EndEvent

Event OnOptionInputAccept(int aiOption, string asInput)
EndEvent

Event OnHighlightST()
EndEvent

Event OnSelectST()
EndEvent

Event OnDefaultST()
EndEvent

Event OnSliderOpenST()
EndEvent

Event OnSliderAcceptST(float afValue)
EndEvent

Event OnMenuOpenST()
EndEvent

Event OnMenuAcceptST(int aiIndex)
EndEvent

Event OnColorOpenST()
EndEvent

Event OnColorAcceptST(int aiColor)
EndEvent

Event OnKeyMapChangeST(int aiKeyCode, string asConflictControl, string asConflictName)
EndEvent

Event OnInputOpenST()
EndEvent

Event OnInputAcceptST(string asInput)
EndEvent
