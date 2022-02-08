Scriptname JFDismiss extends Quest

; ---------------------- Property
Quest Property pDialogueFollower  Auto
Faction Property JF_JoyFol_Faction Auto
Faction Property JF_AntiJoyFol_Faction Auto
JFMCM Property MCM Auto

; ---------------------- Functions
Event OnInit()
  RegisterForModEvent("JFDismissFollowerComplete", "DismissFollower")
EndEvent

; Using Event callback to be able to compile the mainscript within the CK cause I cant/dont want to load up EFF + AFT + Vanilla all at once all the time
Event DismissFollower(string asEventName, string asStringArg, float afNumArg, form akSender)
  Actor follower = akSender as Actor
  If follower.IsInFaction(JF_JoyFol_Faction)
    If(MCM.bDebug)
      debug.notification("JoyFol dismissed")
    EndIf
  EndIf
  If(Game.GetModByName("EFFCore.esm") != 255)
    JFEFF.EFFDismiss(follower)
    If(MCM.bDebug)
      Debug.Notification("EFF Dismiss")
    EndIf
  ElseIf(Game.GetModByName("AmazingFollowerTweaks.esp") != 255)
    JFAFT.AFTDismiss(follower, follower)
    If(MCM.bDebug)
      Debug.Notification("AFT Dismiss")
    EndIf
  Else
    (pDialogueFollower as DialogueFollowerScript).DismissFollower(0, 0)
    If(MCM.bDebug)
      Debug.Notification("Vanilla Dismiss")
    EndIf
  EndIf
EndEvent
;(pDialogueFollower as DialogueFollowerScript).DismissFollower(0, 0)

Function LockOutDismiss(ObjectReference akSpeakerRef)
  JoyfulFollowers.DismissFollower(true, true)
endFunction
