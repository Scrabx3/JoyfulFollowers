Scriptname JFMCMAddonPage extends Quest

JFMCM Property _JFMCM Auto
{Fill this with JFs MCM Quest}

String Property PageName = "_UNDEFINED" Auto
{Fill with the Name for your Page}

Event OnInit()
  While (!_JFMCM.Initialized)
    Utility.Wait(1)
  EndWhile
  _JFMCM.AddNewPage(self)
  InitializePage()
EndEvent

; Overwrite this Function to initialize your variables, equivalent to "OnConfigInit()"
Function InitializePage()
EndFunction

; Overwrite and create your page here
; When your option is selected, the MCM will callback into this Script with default SkyUI Events (see below)
Function OnPageCalled()
  _JFMCM.AddTextOption("I am", self)
  _JFMCM.AddTextOption("I forgot to overwrite", "OnPageCalled()")
EndFunction

; ----------------- Events

Event OnOptionHighlight(int a_option)
EndEvent

Event OnOptionSelect(int a_option)
EndEvent

Event OnOptionDefault(int a_option)
EndEvent

Event OnOptionSliderOpen(int a_option)
EndEvent

Event OnOptionSliderAccept(int a_option, float a_value)
EndEvent

Event OnOptionMenuOpen(int a_option)
EndEvent

Event OnOptionMenuAccept(int a_option, int a_index)
EndEvent

Event OnOptionColorOpen(int a_option)
EndEvent

Event OnOptionColorAccept(int a_option, int a_color)
EndEvent

Event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
EndEvent

Event OnOptionInputOpen(int a_option)
EndEvent

Event OnOptionInputAccept(int a_option, string a_input)
EndEvent

Event OnHighlightST()
EndEvent

Event OnSelectST()
EndEvent

Event OnDefaultST()
EndEvent

Event OnSliderOpenST()
EndEvent

Event OnSliderAcceptST(float a_value)
EndEvent

Event OnMenuOpenST()
EndEvent

Event OnMenuAcceptST(int a_index)
EndEvent

Event OnColorOpenST()
EndEvent

Event OnColorAcceptST(int a_color)
EndEvent

Event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
EndEvent

Event OnInputOpenST()
EndEvent

Event OnInputAcceptST(string a_input)
EndEvent
