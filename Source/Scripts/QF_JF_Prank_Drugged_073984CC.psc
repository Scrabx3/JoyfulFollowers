;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF_JF_Prank_Drugged_073984CC Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
MCM.bCooldown = false
RegisterForSingleUpdateGameTime(3)
PlayerRef.EquipItem(Skooma, false, true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
MCM.Cooldown(true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdateGameTime()
  Stop()
EndEvent

; If(!Util.IDruggedNeverAgain && Utility.RandomInt(1, 100) <= Util.DrugChance)
;
; Function Pranks()
; 	;Memory Resets
; 	Util.IUndressed = false
; 	Util.IDrugged = false
; 	Util.IPrankRunning = false
; 	Util.ESitWJustLikeThat = false
; 	;Pranks & Events
; 	If(MCM.bCooldown == false || Util.PGRunning == true) ;Checking shared conditions
; 		If(MCM.bDeNo == true)
; 			Debug.Notification("Event checks: Shared Conditions failed")
; 		EndIf
; 		Return
; 	EndIf
; 	;Prank> Some Skooma? Prank
;
; 		Util.IDruggedOnce = true
; 		Util.IDrugged = true
; 		Util.IPrankRunning = true
;
; 	;/Prank> Guards! A Criminal!
; 	ElseIf(PlayerScr.LocType == "Town" && JF_Stress.Value >= 32 && CriminalCanStart() == true)
; 		If(JF_Core_GuardScan.Start())
; 			Util.IReported = true
; 			Util.IPrankRunning = true
; 		EndIf
; 	;Cheese Bowls
; 	;/ElseIf(MCM.bCooldown == true && JF_Stress.Value < 32 && Game.FindClosestReferenceOfTypeFromRef(MammothCheese01, PlayerRef, 16384.0) != none)
; 		(JF_Giant.Start())
; 		Debug.Notification("Giant Start")/;
; 	EndIf
; EndFunction


JFMCM Property MCM  Auto  


Potion Property Skooma  Auto  

Actor Property PlayerRef  Auto  
