Scriptname JFBelowCollege extends Quest Conditional

; ------------------------------------- Property
ReferenceAlias Property RewardAlias Auto
Scene Property PassedOut Auto
Actor Property PlayerRef Auto
ActorBase Property FlameAtronachNH Auto ;NonHostile
ActorBase Property FrostAtrnoachNH Auto
ActorBase Property StormAtronachNH Auto
Weapon Property RewardFlameStaff Auto
Weapon Property RewardFrostStaff Auto
Weapon Property RewardStormStaff Auto
ObjectReference[] Property RitualWalls Auto
;Ingredients for Ritual
Ingredient Property FireSalts Auto
Ingredient Property FrostSalts Auto
Ingredient Property VoidSalts Auto
MiscObject Property GemDiamond Auto
MiscObject Property GemDiamondFlawless Auto
Soulgem Property SoulgemGreaterFilled Auto
Soulgem Property SoulgemGrandFilled Auto
;Atronach Forge Stuff
ObjectReference Property summonFXpoint Auto
{Where we place the summoning FX cloud}
Activator Property summonFX Auto
{Point to a fake summoning cloud activator}
GlobalVariable Property AtroKills Auto
; ------------------------------------- Variables
; store whatever we summoned last time to help clean up dead references
ActorBase[] partners
Actor[] ritualactors
;Reward
Weapon RewardStaff
int timesUsed = 0
; ------------------------------------- Code
; IDEA: Add Support for 2~5p animations(?)
; TODO: Dialogue for final act of Below College

; =============================
; ========== Stage 0 ==========
; =============================
Function TakeItems()
  ; Get Number Salts for Reward
  bool[] invsalt = new bool[3]
  invsalt[0] = PlayerRef.GetItemCount(FireSalts) >= 3 ; FireSalts
  invsalt[1] = PlayerRef.GetItemCount(FrostSalts) >= 3 ; FrostSalts
  invsalt[2] = PlayerRef.GetItemCount(VoidSalts) >= 3 ; VoidSalts
  int n = Utility.RandomInt(0, 2)
  While(invsalt[n] == false) ; At least one of them is true, otherwise the Event cant start
    n = Utility.RandomInt(0, 2)
  EndWhile
  ritualactors = new Actor[2]
  partners = new ActorBase[3]
  If(n == 0)
    PlayerRef.RemoveItem(FireSalts, 3)
    RewardStaff = RewardFlameStaff
    partners[0] = FlameAtronachNH
    partners[1] = StormAtronachNH
    partners[2] = FrostAtrnoachNH
  ElseIf(n == 1)
    PlayerRef.RemoveItem(FrostSalts, 3)
    RewardStaff = RewardFrostStaff
    partners[0] = FrostAtrnoachNH
    partners[1] = FlameAtronachNH
    partners[2] = StormAtronachNH
  Else
    PlayerRef.RemoveItem(VoidSalts, 3)
    RewardStaff = RewardStormStaff
    partners[0] = StormAtronachNH
    partners[1] = FrostAtrnoachNH
    partners[2] = FlameAtronachNH
  EndIf
  If(PlayerRef.GetItemCount(SoulgemGrandFilled) > 0)
    PlayerRef.RemoveItem(SoulgemGrandFilled)
  Else
    PlayerRef.RemoveItem(SoulgemGreaterFilled)
  EndIf
  If(PlayerRef.GetItemCount(GemDiamondFlawless) > 0)
    PlayerRef.RemoveItem(GemDiamondFlawless)
  Else
    PlayerRef.RemoveItem(GemDiamond)
  EndIf
  SetStage(30)
EndFunction

; ==============================
; ========== Stage 30 ==========
; ==============================
Function SleepReady()
  RegisterForSleep()
endFunction

Event OnSleepStop(bool abInterrupted)
  ;/ Below College has 3 Event paths:
    1. Player used by Atroonachs
    2. Follower used by Atroonachs
    3. Atronachs go Berserk

    I assume the Player will prefer 1 over 2 over 3
    65 over 25 over 10?
  /;
  If(GetStage() >= 50)
    return
  EndIf
  int scn = Utility.RandomInt(0, 99)
  If(scn < 65)
    ritualactors[0] = PlayerRef
    SetStage(50)
  ElseIf(scn < 80)
    Actor fol = JoyfulFollowers.GetFollower()
    RegisterForSingleLOSGain(PlayerRef, fol)
    ritualactors[0] = fol
    SetStage(200)
    fol.MoveTo(summonFXpoint)
    ActivateForge()
  Else
    AtroKills.Value = 0
    UpdateCurrentInstanceGlobal(AtroKills)
    SetStage(400)
  EndIf
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
  Utility.Wait(1.5)
  SetStage(210)
EndEvent

Function UpdateAtroKills()
  AtroKills.Value += 1
  UpdateCurrentInstanceGlobal(AtroKills)
  SetObjectiveDisplayed(400, true, true)
  If(AtroKills.Value == 8)
    SetStage(410)
  EndIf
EndFunction

; ==============================
; ========== Stage 60 ==========
; ==============================
Function ActivateForge()
  RitualWalls[0].EnableNoWait(true)
  RitualWalls[1].EnableNoWait(true)
  RitualWalls[2].Enable(true)
  Utility.Wait(5)
  RegisterForModEvent("HookAnimationEnd_JFBelowCollege", "NextSummon")
  timesUsed = 0
  SummonNextCreature()
EndFunction

Event NextSummon(int tid, bool hasPlayer)
  timesUsed += 1
  Utility.Wait(0.4)
  Debug.SendAnimationEvent(ritualactors[0], "bleedoutstart")
  ; Cleanup the previous partners
  ritualactors[1].kill()
  Utility.Wait(1.5)
  ritualactors[1].disable()
  ritualactors[1].delete()
  Utility.Wait(Utility.RandomFloat(1, 3.5))
  ; Check for another round or quit
  If(Utility.RandomFloat(0, 99) < (137 - 12 * timesUsed)) ; Min 3, max 11 (5%)
    SummonNextCreature()
  Else
    UnregisterForModEvent("HookAnimationEnd_JFBelowCollege")
    EndRitual()
    Utility.Wait(2)
    Debug.SendAnimationEvent(ritualactors[0], "bleedoutstop")
  EndIf
endEvent

; roll a new atronach partner & start a Scene
Function SummonNextCreature()
  summonFXpoint.placeatme(summonFX)
  Utility.Wait(0.33)
  int c = Utility.RandomInt(0, 99)
  If(c < 60)
    ritualactors[1] = summonFXpoint.PlaceAtMe(partners[0]) as Actor
  ElseIf(c < 80)
    ritualactors[1] = summonFXpoint.PlaceAtMe(partners[1]) as Actor
  Else
    ritualactors[1] = summonFXpoint.PlaceAtMe(partners[2]) as Actor
  EndIf
  If(JFAnimStarter.StartScene(ritualactors, hook = "JFBelowCollege") == -1)
    Debug.Notification("<JF BC> Failed to start Scene.. skipping")
    Utility.Wait(3)
    NextSummon(0, ritualactors[0] == PlayerRef)
  EndIf
EndFunction

Function EndRitual()
  RitualWalls[0].DisableNoWait(true)
  RitualWalls[1].DisableNoWait(true)
  RitualWalls[2].Disable(true)
  Utility.Wait(1)
  summonFXpoint.placeatme(summonFX)
  Utility.Wait(0.33)
  RewardAlias.ForceRefTo(summonFXpoint.placeatme(RewardStaff))
  If(GetStage() == 210)
    SetStage(220)
  Else
    SetStage(80)
  EndIf
endFunction
