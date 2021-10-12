Scriptname JFPrankUndressed extends Quest

; --------------------------------------- Property
JFMCM Property MCM Auto
Actor Property PlayerRef Auto

Event OnUpdateGameTime()
  MCM.Cooldown(true)
  Stop()
EndEvent
