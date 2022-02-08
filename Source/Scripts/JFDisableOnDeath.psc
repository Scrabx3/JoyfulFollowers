Scriptname JFDisableOnDeath extends Actor  

Event OnDying(Actor akKiller)
  Utility.Wait(1.5)
  disable()
  delete()
EndEvent