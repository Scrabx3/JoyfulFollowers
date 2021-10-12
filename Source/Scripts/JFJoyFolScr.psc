Scriptname JFJoyFolScr extends ReferenceAlias

; ------------------------------------- Property
JFCore Property Core Auto
JFMCM Property MCM Auto
JFEventStorage Property Util Auto
GlobalVariable Property Stress Auto

;OnHit
Quest Property JF_OnHit Auto
Actor Property PlayerRef Auto

; ------------------------------------- Variables
int Endurance = 0

; ------------------------------------- Events
; 1. Bleedout
Event OnEnterBleedout()
  LoseKeys()
  Core.Mental()
  ReduceHits()
EndEvent

Function LoseKeys()
  ; placeholder, used in JFDD
EndFunction

; 2. OnHit
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  If(!MCM.bOHenab || !(akAggressor == PlayerRef))
    return
  EndIf
  If(akSource as Weapon)
    If((akSource as Weapon).GetBaseDamage() < 3)
      return
    EndIf
  ElseIf(akSource as Spell)
    If(!(akSource as Spell).IsHostile())
      return
    EndIf
  ElseIf(akSource as Enchantment)
    If(!(akSource as Enchantment).IsHostile())
      return
    EndIf
  EndIf
  If(Endurance <= 0)
    Endurance = Utility.RandomInt(MCM.iOHmin*2, MCM.iOHmax*2)
  EndIf
  If(akProjectile != none)
    PlayerHit(2)
  ElseIf(abPowerAttack)
    PlayerHit(1)
  Else
    PlayerHit(0)
  EndIf
EndEvent

;0 - Default; 1 - Power Attack, 2 - Ranged Attack
Function PlayerHit(int Type)
  If(Type == 0)
    Endurance -= 2
  ElseIf(Type == 1)
    Endurance -= 4
  Else
    Endurance -= 1
  EndIf
  If(Endurance <= 0)
    Core.LoseAffection()
    Util.TLeaveToken += 1
    If(Util.TLeaveToken > 5)
      Core.LockOut(Util.TLeaveToken - 4)
    EndIf
    If(Utility.RandomInt(1, 100) <= 65)
      JF_OnHit.Start()
    EndIf
  EndIf
EndFunction

Function ReduceHits()
  int Mental = Stress.Value as int
  If(Endurance >= MCM.iOHmax*2)
    Return
  ElseIf(Mental <= 18)
    Endurance += 4
  ElseIf(Mental <= 32)
    Endurance += 2
  Else
    Endurance += 1
  EndIf
  If(GetOwningQuest().GetStage() == 800)
    Endurance += 2
  ElseIf(GetOwningQuest().GetStage() >= 400)
    Endurance += 1
  EndIf
EndFunction

; 3. On Death Cleanup
Event OnDeath(Actor akKiller)
  Core.DismissJoyFol()
EndEvent
