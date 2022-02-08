Scriptname JFDrinking extends Quest Conditional

Actor Property PlayerRef Auto
ImageSpaceModifier Property JF_Drinking_DrunkShader Auto
Potion Property NordMead Auto

float Property E1DrinkingStage Auto Hidden Conditional

; ------------------------------------- Code
;0 > 0.14 > 0.31 > 0.48 > 0.65 > 0.82 > 0.99 > 1.16
Function E1FirstDrink()
  JFMainEvents.Singleton().EDrinkingOutcome = 0
  E1DrinkingStage = 0.14
  PlayerRef.EquipItem(NordMead, false, true)
  JF_Drinking_DrunkShader.Apply(E1DrinkingStage)

  RegisterForSingleUpdateGameTime(E1DrinkingStage*20)
EndFunction

Function E1Seconds()
  E1DrinkingStage += 0.17
  PlayerRef.EquipItem(NordMead, false, true)
  JF_Drinking_DrunkShader.Apply(E1DrinkingStage)

  UnregisterForUpdateGameTime()
  RegisterForSingleUpdateGameTime(E1DrinkingStage*20)
EndFunction

Event OnUpdateGameTime()
  JF_Drinking_DrunkShader.Remove()
EndEvent
