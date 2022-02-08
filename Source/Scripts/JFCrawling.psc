Scriptname JFCrawling extends activemagiceffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
  int JFFB0 = StorageUtil.GetIntValue(none, "JFFB0") ; Idle
  int JFFB1 = StorageUtil.GetIntValue(none, "JFFB1") ; Movement1
  int JFFB2 = StorageUtil.GetIntValue(none, "JFFB2") ; Movement2
  int JFFB3 = StorageUtil.GetIntValue(none, "JFFB3") ; Sneak1
  int JFFB4 = StorageUtil.GetIntValue(none, "JFFB4") ; Sneak2

  FNIS_aa.SetAnimGroup(akTarget, "_mtidle", JFFB0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mt", JFFB1, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mtx", JFFB2, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakidle", JFFB3, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakmt", JFFB4, 0, "JoyfulFollowers", true)

  If(akTarget == Game.GetPlayer())
    Game.DisablePlayerControls(false, true, false, false, true, false, false, false)
  EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  FNIS_aa.SetAnimGroup(akTarget, "_mtidle", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mt", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mtx", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakidle", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakmt", 0, 0, "JoyfulFollowers", true)

  If(akTarget == Game.GetPlayer())
    Game.EnablePlayerControls(false, true, false, false, true, false, false, false)
  EndIf
EndEvent
