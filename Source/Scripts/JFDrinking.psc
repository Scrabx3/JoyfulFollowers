Scriptname JFDrinking extends Quest Conditional

; ------------------------------------- Property
Actor Property PlayerRef Auto
GlobalVariable Property JF_Var_Fatigue Auto

; ---------------- Default Drinking
ImageSpaceModifier Property JF_Drinking_DrunkShader Auto
Potion Property NordMead Auto

; ------------------------------------- Variables
; ---------------- Default Drinking
float Property E1DrinkingStage Auto Hidden Conditional
bool Property E1Win = false Auto Hidden Conditional

; ------------------------------------- Code
; ---------------- Default Drinking
;0 > 0.14 > 0.31 > 0.48 > 0.65 > 0.82 > 0.99 > 1.16
Function E1FirstDrink()
  E1Win = false
  E1DrinkingStage = 0.14
  PlayerRef.EquipItem(NordMead, false, true)
  JF_Drinking_DrunkShader.Apply(E1DrinkingStage)
  JF_Var_Fatigue.Value += 2

  RegisterForSingleUpdateGameTime(E1DrinkingStage*20)
EndFunction

Function E1Seconds()
  E1DrinkingStage += 0.17
  PlayerRef.EquipItem(NordMead, false, true)
  JF_Drinking_DrunkShader.Apply(E1DrinkingStage)
  JF_Var_Fatigue.Value += 3

  UnregisterForUpdateGameTime()
  RegisterForSingleUpdateGameTime(E1DrinkingStage*20)
EndFunction


Event OnUpdateGameTime()
  JF_Drinking_DrunkShader.Remove()
EndEvent
