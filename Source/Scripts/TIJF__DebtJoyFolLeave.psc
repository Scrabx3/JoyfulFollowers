;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIJF__DebtJoyFolLeave Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Util.Dismiss(akSpeaker)
int GoldAmount = PlayerRef.GetItemCount(Gold001)
PlayerRef.RemoveItem(Gold001, GoldAmount, false, akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

JFDismiss Property Util  Auto

MiscObject Property Gold001 Auto
Actor Property PlayerRef Auto
