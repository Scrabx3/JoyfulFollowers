Scriptname JFJoyFolScr extends ReferenceAlias

; ------------------------------------- Property
Keyword Property SourceHit Auto

; ------------------------------------- Variables
int Property maxhitcount = 8 Autoreadonly Hidden
int hitcount = 0

; ------------------------------------- Events
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
  If(akAggressor != Game.GetPlayer())
    return
  ElseIf(akSource as Weapon && (akSource as Weapon).GetBaseDamage() < 3)
    return
  EndIf
  Spell sp = akSource as Spell
  Enchantment ench = akSource as Enchantment
  If(sp && sp.IsHostile() || ench && ench.IsHostile())
    hitcount += 1 + (abPowerAttack as int)
    If(hitcount > maxhitcount)
      hitcount = 0
      JoyfulFollowers.DamageAffection(true)
      ObjectReference me = GetReference()
      SourceHit.SendStoryEvent(me.GetCurrentLocation(), me, none, JoyfulFollowers.GetSeverity(), 0)
    EndIf
  EndIf
EndEvent

Function lowerhitcount(int aiNum)
  If(hitcount > aiNum)
    hitcount -= aiNum
  Else
    hitcount = 0
  EndIf
EndFunction
