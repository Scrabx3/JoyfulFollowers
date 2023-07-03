Scriptname JFHarshnil03 extends Quest  

ReferenceAlias Property Follower Auto
ReferenceAlias Property GearChest Auto
ReferenceAlias Property Bandit01R01 Auto
ReferenceAlias Property Bandit02R01 Auto

ObjectReference Property WallShackles Auto
ObjectReference Property playerCell  Auto  
ObjectReference Property FollowerItems Auto
ObjectReference Property FollowerWaitLoc Auto

ObjectReference Property Rug Auto
ObjectReference Property RugRolled Auto
ObjectReference Property BasementLadder Auto

Outfit FollowerOutfit

Function Setup()  ; Stage 0
  Rug.Disable()
  RugRolled.Enable()
  BasementLadder.Enable()

  Actor player = Game.GetPlayer()
  ; IDEA: shackle player to the wallshackle
  ; Game.SetPlayerAIDriven()
  player.MoveTo(playerCell)
  Debug.SendAnimationEvent(player, "BleedoutStop")
  player.RemoveAllItems(GearChest.GetReference())
  Game.SetPlayerAIDriven(false)

  Actor FollowerREF = Follower.GetActorReference()
  FollowerOutfit = FollowerREF.GetActorBase().GetOutfit()
  FollowerREF.SetOutfit(none)
  FollowerREF.RemoveAllItems(FollowerItems)
  FollowerREF.SetActorValue("WaitingForPlayer", 1)
  FollowerREF.MoveTo(FollowerWaitLoc)
EndFunction

Event OnUpdate()  ; Stage 0 - 30 Second post quest start
  SetStage(5)
EndEvent

Function FirstSeduction(Actor akPlayerTarget, String asTags = "") ; Stage 34
  Actor Bandit01 = Bandit01R01.GetActorReference()
  Actor Bandit02 = Bandit02R01.GetActorReference()
  Actor[] p = new Actor[2]
  p[0] = Game.GetPlayer()
  Actor[] f = new Actor[2]
  f[0] = Follower.GetActorReference()
  If(akPlayerTarget == Bandit01)
    p[1] = Bandit01
    f[1] = Bandit02
  Else
    p[1] = Bandit02
    f[1] = Bandit01
  EndIf
  RegisterForModEvent("OrgasmStart_Harshnil03Player", "AfterSexPlayer")
  RegisterForModEvent("HookAnimationEnding_Harshnil03Player", "AfterSexPlayer")
  RegisterForModEvent("HookAnimationEnd_Harshnil03Follower", "AfterSexFollower")
  If(JFAnimStarter.StartScene(p, asTags, hook = "Harshnil03Player") == -1)
    Debug.Notification("Scene failed to start. Skipping ahead..")
    AfterSexPlayer(0, true)
  EndIf
  JFAnimStarter.StartScene(f, hook = "Harshnil03Follower")
EndFunction

Event AfterSexPlayer(int tid, bool hasplayer)
  UnregisterForAllModEvents()
  JFMain.Get().FadeToBlack()
  JFAnimStarter.EndScene(Follower.GetActorReference())
  Game.SetPlayerAIDriven()
  Utility.Wait(4)
  SetStage(37)  
EndEvent
Event AfterSexFollower(int tid, bool hasplayer)
  JFAnimStarter.StartScene(JFAnimStarter.GetSceneActors(tid), hook = "Harshnil03Follower")
EndEvent

Function KnockoutBandits() ; Stage 37
  Actor Bandit01 = Bandit01R01.GetActorReference()
  Actor Bandit02 = Bandit02R01.GetActorReference()
  Bandit01.KillSilent(Game.GetPlayer())
  Bandit02.KillSilent(Game.GetPlayer())
  Game.SetPlayerAIDriven(false)
  Utility.Wait(3)
  JFMain.Get().FadeBack()
EndFunction

Function RestoreFollower() ; Stage 50/51
  FollowerItems.RemoveAllItems(Follower.GetReference())
  Follower.GetActorReference().SetOutfit(FollowerOutfit)
EndFunction

