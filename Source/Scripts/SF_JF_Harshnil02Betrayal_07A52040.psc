;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 15
Scriptname SF_JF_Harshnil02Betrayal_07A52040 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
StabHoldImod.PopTo(StabFadeOutImod)
Utility.Wait(1)
StabFadeOutImod.PopTo(FadeToBlackHoldImod)
getowningquest().setstage(200)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
GetOwningQuest().setstage(110)
StabImod.Apply()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
;WARNING: Unable to load fragment source from function Fragment_7 in script SF_JF_Harshnil02Betrayal_07A52040
;Source NOT loaded
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
;WARNING: Unable to load fragment source from function Fragment_10 in script SF_JF_Harshnil02Betrayal_07A52040
;Source NOT loaded
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
Game.GetPlayer().RemoveItem(Payment.GetReference())
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ReferenceAlias akAlias)
;BEGIN CODE
StabImod.PopTo(StabHoldImod)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ImageSpaceModifier Property BackStabImod  Auto  

ImageSpaceModifier Property FadeToBlackHoldImod  Auto  

ReferenceAlias Property Payment  Auto  

ImageSpaceModifier Property StabImod  Auto  

ImageSpaceModifier Property StabHoldImod  Auto  

ImageSpaceModifier Property StabFadeOutImod  Auto  
