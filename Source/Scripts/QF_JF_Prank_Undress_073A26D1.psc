;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_JF_Prank_Undress_073A26D1 Extends Quest Hidden

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
JoyfulFollowers.AddAffection(2)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
JoyfulFollowers.SetTimeout()
RegisterForSingleUpdateGameTime(3)

arousal.Value = JFAnimStarter.GetArousal(Game.GetPlayer())

;Stealing Body to Boots Armor Pieces, moving them into JF Inventory
int Current = 4
Armor ThisSlot
While(Current > 0)
	If(Current == 4) ;Body
		ThisSlot = PlayerRef.GetWornForm(0x00000004) as armor
  	ElseIf(Current == 3) ;Hands
  		ThisSlot = PlayerRef.GetWornForm(0x00000008) as armor
  	ElseIf(Current == 2) ;Boots
  		ThisSlot = PlayerRef.GetWornForm(0x00000080) as armor
  	ElseIf(Current == 1) ;Bottom Piece
  		ThisSlot = PlayerRef.GetWornForm(0x00400000) as armor
  	EndIf
	If(!ThisSlot.HasKeyWordString("zad_Lockable"))
		PlayerRef.RemoveItem(ThisSlot, 7, true, Alias_JoyFol.GetReference())
	EndIf
  	Current -= 1
EndWhile

Debug.Notification("You feel cold wind blowing around your chest..")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Event OnUpdateGameTime()
  Stop()
EndEvent

Actor Property PlayerRef  Auto  


GlobalVariable Property arousal  Auto  
