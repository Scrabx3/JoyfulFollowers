;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname TIF_JF_DisallowFollower01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If(JoyfulFollowers.GetFollower() == akSpeaker)
  JoyfulFollowers.DismissFollower(true, false)
EndIf
akSpeaker.AddToFaction(LockoutFaction)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction Property LockoutFaction  Auto  
