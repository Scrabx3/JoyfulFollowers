Scriptname JFBelowCollege extends Quest Conditional

; ------------------------------------- Property
JFCore Property Core Auto
JFMCM Property MCM Auto
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
MiscObject Property GemDiamond Auto
MiscObject Property GemDiamondFlawless Auto
Soulgem Property SoulgemGreaterFilled Auto
Soulgem Property SoulgemGrandFilled Auto
Ingredient Property FireSalts Auto
Ingredient Property FrostSalts Auto
Ingredient Property VoidSalts Auto
;Atronach Forge Stuff
ObjectReference Property summonFXpoint Auto
{Where we place the summoning FX cloud}
Activator Property summonFX Auto
{Point to a fake summoning cloud activator}
objectReference  property createPoint auto
{Marker where we place created items}

; ------------------------------------- Variables
; store whatever we summoned last time to help clean up dead references
Actor lastSummonedCreature = none
;Reward
Weapon RewardStaff
;0 - lightning, 1 - fire, 2 - frost
int staffChoice
int timesUsed = 0

bool Property canListenPassedOut = false Auto Hidden Conditional ;Used in "Passed Out" Scene
; ------------------------------------- Code
; =============================
; ========== Stage 0 ==========
; =============================
Function TakeItems()
  ; Variables to build up String
  string DiamondName
  string SoulGemName
  int VoidSaltsTaken
  int FireSaltsTaken
  int FrostSaltsTaken
  ; Get Number Salts for Reward
  int voidSalt = PlayerRef.GetItemCount(VoidSalts)
  int fireSalt = PlayerRef.GetItemCount(FireSalts)
  int frostSalt = PlayerRef.GetItemCount(FrostSalts)
  If(voidSalt > 5 && fireSalt > 5 && frostSalt > 5)
    staffChoice = Utility.RandomInt(0, 2)
  ElseIf(voidSalt > 5 && fireSalt > 5)
    staffChoice = Utility.RandomInt(0, 1)
  ElseIf(fireSalt > 5 && frostSalt > 5)
    staffChoice = Utility.RandomInt(1, 2)
  ElseIf(voidSalt > 5 && frostSalt > 5)
    If(Utility.RandomInt(0, 1) == 0)
      staffChoice = 0
    else
      staffChoice = 2
    EndIf
  ElseIf(voidSalt > 5)
    staffChoice = 0
  ElseIf(fireSalt > 5)
    staffChoice = 1
  Else
    staffChoice = 2
  EndIf
  ; Remove Items & Identify Reward Weapon
  If(staffChoice == 0)
    VoidSaltsTaken = 7
    playerRef.RemoveItem(VoidSalts, 7)
    FireSaltsTaken = Utility.RandomInt(1, 3)
    playerRef.RemoveItem(FireSalts, FireSaltsTaken)
    FrostSaltsTaken = Utility.RandomInt(1, 3)
    playerRef.RemoveItem(FrostSalts, FrostSaltsTaken)
    int WeaponChoice = Utility.RandomInt(0, 99)
    If(WeaponChoice < 20)
      RewardStaff = RewardFrostStaff
    ElseIf(WeaponChoice >= 80)
      RewardStaff = RewardFlameStaff
    else
      RewardStaff = RewardStormStaff
    EndIf
  ElseIf(staffChoice == 1)
    FireSaltsTaken = 7
    playerRef.RemoveItem(FireSalts, 7)
    VoidSaltsTaken = Utility.RandomInt(1, 3)
    playerRef.RemoveItem(VoidSalts, VoidSaltsTaken)
    FrostSaltsTaken = Utility.RandomInt(1, 3)
    playerRef.RemoveItem(FrostSalts, FrostSaltsTaken)
    int WeaponChoice = Utility.RandomInt(0, 99)
    If(WeaponChoice < 20)
      RewardStaff = RewardFrostStaff
    ElseIf(WeaponChoice >= 80)
      RewardStaff = RewardStormStaff
    else
      RewardStaff = RewardFlameStaff
    EndIf
  else
    FrostSaltsTaken = 7
    playerRef.RemoveItem(FrostSalts, 7)
    VoidSaltsTaken = Utility.RandomInt(1, 3)
    playerRef.RemoveItem(VoidSalts, VoidSaltsTaken)
    FireSaltsTaken = Utility.RandomInt(1, 3)
    playerRef.RemoveItem(FireSalts, FireSaltsTaken)
    int WeaponChoice = Utility.RandomInt(0, 99)
    If(WeaponChoice < 20)
      RewardStaff = RewardFrostStaff
    ElseIf(WeaponChoice >= 80)
      RewardStaff = RewardFlameStaff
    else
      RewardStaff = RewardStormStaff
    EndIf
  EndIf
  If(PlayerRef.GetItemCount(SoulgemGrandFilled) > 0)
    SoulGemName = SoulgemGrandFilled.GetName()
    PlayerRef.RemoveItem(SoulgemGrandFilled)
  else
    SoulGemName = SoulgemGreaterFilled.GetName()
    PlayerRef.RemoveItem(SoulgemGreaterFilled)
  EndIf
  If(PlayerRef.GetItemCount(GemDiamondFlawless) > 0)
    DiamondName = GemDiamondFlawless.GetName()
    PlayerRef.RemoveItem(GemDiamondFlawless)
  else
    DiamondName = GemDiamond.GetName()
    PlayerRef.RemoveItem(GemDiamond)
  EndIf
  If(MCM.bBCShowTaken)
    Debug.MessageBox("Items Taken:\nFire Salts: " + FireSaltsTaken + "\nFrost Salts: " + FrostSaltsTaken + "\nVoid Salts: " + VoidSaltsTaken + "\n" + SoulGemName + ": 1\n" + DiamondName + ": 1")
  EndIf
  SetStage(30)
EndFunction

; ==============================
; ========== Stage 30 ==========
; ==============================
Function SleepReady()
  RegisterForSleep()
  MCM.bCooldown = false
endFunction

int sleepStart
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
  sleepStart = Game.QueryStat("Hours Slept")
EndEvent

Event OnSleepStop(bool abInterrupted)
  int sleepTime = (Game.QueryStat("Hours Slept") - sleepStart)
  If(sleepTime >= 6)
    SetStage(50)
  EndIf
EndEvent

; ==============================
; ========== Stage 60 ==========
; ==============================
Function ActivateForge()
  RitualWalls[0].EnableNoWait(true)
  RitualWalls[1].EnableNoWait(true)
  RitualWalls[2].Enable(true)
  Utility.Wait(5)
  RegisterForModEvent("HookAnimationEnding_BelowCollege", "NextSummon")
  timesUsed = 0
  SummonNextCreature()
EndFunction

Event NextSummon(int tid, bool hasPlayer)
  timesUsed += 1
  If(timesUsed < 3)
    Utility.Wait(Utility.RandomInt(1, 4))
    SummonNextCreature()
  ElseIf(timesUsed == 3 && Utility.RandomInt(1, 100) <= 80)
    Utility.Wait(Utility.RandomInt(1, 4))
    SummonNextCreature()
  ElseIf(timesUsed == 4 && Utility.RandomInt(1, 100) <= 50)
    Utility.Wait(Utility.RandomInt(1, 4))
    SummonNextCreature()
  ; ElseIf(timesUsed == 5 && Utility.RandomInt(1, 100) <= 40)
  ;   Utility.Wait(Utility.RandomInt(1, 4))
  ;   SummonNextCreature()
  ElseIf(timesUsed == 6 && Utility.RandomInt(1, 100) <= 20)
    Utility.Wait(Utility.RandomInt(1, 4))
    SummonNextCreature()
  else
    UnregisterForModEvent("HookAnimationEnding_BelowCollege")
    lastSummonedCreature.kill()
    Utility.Wait(1.5)
    lastSummonedCreature.disable()
    lastSummonedCreature.delete()
    EndRitual()
  EndIf
endEvent

Function SummonNextCreature()
  If(MCM.bDeNo)
    Debug.Notification("Summoning creature..")
  EndIf
  ;Clean up the previously summoned Creature before summoning a new one
  If(lastSummonedCreature)
    lastSummonedCreature.kill()
    Utility.Wait(1.5)
    lastSummonedCreature.disable()
    lastSummonedCreature.delete()
  EndIf
  ;Figure out what Creature to summon based on the Staff that is going to be the reward
  int CreatureToSummon = Utility.RandomInt(0, 99)
  summonFXpoint.placeatme(summonFX)
  objectReference newRef
  Utility.Wait(0.33)
  If(staffChoice == 0) ;0 - lightning, 1 - fire, 2 - frost
    If(CreatureToSummon < 20)
      newRef = createPoint.PlaceAtMe(FlameAtronachNH)
    ElseIf(CreatureToSummon >= 80)
      newRef = createPoint.PlaceAtMe(FrostAtrnoachNH)
    else
      newRef = createPoint.PlaceAtMe(StormAtronachNH)
    EndIf
  ElseIf(staffChoice == 1)
    If(CreatureToSummon < 30)
      newRef = createPoint.PlaceAtMe(StormAtronachNH)
    ElseIf(CreatureToSummon >= 70)
      newRef = createPoint.PlaceAtMe(FrostAtrnoachNH)
    else
      newRef = createPoint.PlaceAtMe(FlameAtronachNH)
    EndIf
  else
    If(CreatureToSummon < 30)
      newRef = createPoint.PlaceAtMe(StormAtronachNH)
    ElseIf(CreatureToSummon >= 70)
      newRef = createPoint.PlaceAtMe(FlameAtronachNH)
    else
      newRef = createPoint.PlaceAtMe(FrostAtrnoachNH)
    EndIf
  EndIf
  lastSummonedCreature = newRef as Actor
  If(Core.StartSexBelowCollege(lastSummonedCreature) == -1)
    Debug.Notification("Failed to start Scene.. skipping")
    Utility.Wait(3)
    NextSummon(777, true)
  endIf
endFunction

Function EndRitual()
  Utility.Wait(Utility.RandomInt(3, 5))
  RitualWalls[0].DisableNoWait(true)
  RitualWalls[1].DisableNoWait(true)
  RitualWalls[2].Disable(true)
  Utility.Wait(1)
  summonFXpoint.placeatme(summonFX)
  Utility.Wait(0.33)
  RewardAlias.ForceRefTo(summonFXpoint.placeatme(RewardStaff))
  SetStage(80)
endFunction
