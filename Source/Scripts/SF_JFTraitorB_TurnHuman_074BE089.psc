;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 11
Scriptname SF_JFTraitorB_TurnHuman_074BE089 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
;If Rising at Dawn is running, leave curing to that Quest & close it. Otherwise let Traitor handle it
If(VC01.IsRunning())
 VC01.SetStage(200)
else
  (PlayerVampireQuest as PlayerVampireQuestScript).VampireCure(Game.Getplayer())
  DLC1VampireLordDisallow.Value = 0
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
PrisonDoor.SetOpen(true)
Game.EnablePlayerControls(abFighting = false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7(ReferenceAlias akAlias)
;BEGIN CODE
Imod_VC01RitualBlackOut.Apply()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
DLC1VampireLordDisallow.Value = 1
Game.GetPlayer().RemoveSpell(DLC1VampireChange)
Game.DisablePlayerControls()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property VC01  Auto  

ObjectReference Property PrisonDoor  Auto  

GlobalVariable Property DLC1VampireLordDisallow  Auto  

SPELL Property DLC1VampireChange  Auto  

Quest Property PlayerVampireQuest  Auto  

ImageSpaceModifier Property Imod_VC01RitualBlackout  Auto  
