;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_JF_FalkreathGrave_075D9A4C Extends Quest Hidden

;BEGIN ALIAS PROPERTY Grave1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Grave1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JoyFol
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JoyFol Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; Player talks about dying before JF, "Dont tempt me"
JoyfulFollowers.AddAffection(3)
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Generic Ending
JoyfulFollowers.AddAffection(3)
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Player asked JF to build a Tomb for them
JoyfulFollowers.AddAffection(3)
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Player said smth about being a Vampire and already dead
JoyfulFollowers.AddAffection(3)
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
