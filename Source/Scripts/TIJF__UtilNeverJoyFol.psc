;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIJF__UtilNeverJoyFol Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If(akSpeaker.IsInFaction(JF_JoyFol_Faction))
Core.DismissJoyFol()
EndIf
Util.NeverBecomeJoyFol(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JFDismiss Property Util  Auto  

JFCore Property Core  Auto  

Faction Property JF_JoyFol_Faction  Auto  
