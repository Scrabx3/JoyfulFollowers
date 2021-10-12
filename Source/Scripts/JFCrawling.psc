Scriptname JFCrawling extends activemagiceffect

; ------------------------------------- Property
JFCore Property Core  Auto

; ------------------------------------- Functions
Event OnEffectStart(Actor akTarget, Actor akCaster)
  FNIS_aa.SetAnimGroup(akTarget, "_mtidle", Core.JFFB0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mt", Core.JFFB1, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mtx", Core.JFFB2, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakidle", Core.JFFB3, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakmt", Core.JFFB4, 0, "JoyfulFollowers", true)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  FNIS_aa.SetAnimGroup(akTarget, "_mtidle", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mt", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_mtx", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakidle", 0, 0, "JoyfulFollowers", true)
  FNIS_aa.SetAnimGroup(akTarget, "_sneakmt", 0, 0, "JoyfulFollowers", true)
EndEvent
