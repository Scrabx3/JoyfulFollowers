Scriptname JFDismiss extends Quest

; ---------------------- Property
Quest Property pDialogueFollower  Auto
Faction Property JF_JoyFol_Faction Auto
Faction Property JF_AntiJoyFol_Faction Auto
JFCore Property Core Auto
JFMCM Property MCM Auto

; ---------------------- Functions
Function Dismiss(ObjectReference akSpeakerRef)
  Actor akSpeaker = akSpeakerRef as Actor
  If akspeaker.IsInFaction(JF_JoyFol_Faction)
    Core.DismissJoyFol()
    If MCM.bDeNo == true
      debug.notification("JoyFol dismissed")
    EndIf
  EndIf
  If(Game.GetModByName("EFFCore.esm") != 255)
    JFEFF.EFFDismiss(akSpeaker)
    If(MCM.bDeNo == true)
      Debug.Notification("EFF Dismiss")
    EndIf
  ElseIf(Game.GetModByName("AmazingFollowerTweaks.esp") != 255)
    JFAFT.AFTDismiss(akSpeaker, akSpeakerRef)
    If(MCM.bDeNo == true)
      Debug.Notification("AFT Dismiss")
    EndIf
  Else
    (pDialogueFollower as DialogueFollowerScript).DismissFollower(0, 0)
    If(MCM.bDeNo == true)
      Debug.Notification("Vanilla Dismiss")
    EndIf
  EndIf
EndFunction

;(pDialogueFollower as DialogueFollowerScript).DismissFollower(0, 0)

Function LockOutDismiss(ObjectReference akSpeakerRef)
  Core.JoyFol.SetRelationshipRank(Core.PlayerRef, -2)
  Utility.Wait(0.1)
  Dismiss(akSpeakerRef)
endFunction


; Disallow a NPC to become a JoyFol
Function NeverBecomeJoyFol(Actor NoJoyFol)
  NoJoyFol.AddToFaction(JF_AntiJoyFol_Faction)
EndFunction
