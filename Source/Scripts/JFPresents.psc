Scriptname JFPresents extends ObjectReference

; ------------------------------------- Property
JFCore Property Core Auto

Actor Property PlayerRef Auto
Keyword Property ArmorJewelry Auto
Keyword Property JFQuestArmor Auto
MiscObject Property Gold001 Auto

MiscObject Property GemDiamond Auto ; 0
MiscObject Property GemDiamondFlawless Auto
MiscObject Property GemEmerald Auto ; 1
MiscObject Property GemEmeraldFlawless Auto
MiscObject Property GemSapphire Auto ; 2
MiscObject Property GemSapphireFlawless Auto
MiscObject Property GemRuby Auto     ; 3
MiscObject Property GemRubyFlawless Auto
MiscObject Property GemAmethyst Auto ; 4
MiscObject Property GemAmethystFlawless Auto
Formlist Property JF_FlawlessGems Auto

; ------------------------------------- Events
;Gain Affection based on value of the item + Affection(more) if favorite gem + additional affection is flawless gem
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If(akBaseItem as armor || akBaseItem as weapon)
    If(akBaseItem.HasKeyword(JFQuestArmor))
      RemoveItem(akBaseItem, aiItemCount, false, PlayerRef)
      Utility.Wait(0.1)
      PlayerRef.EquipItem(akBaseItem, true, true)
      Debug.Notification("You're supposed to wear that, silly!")
      return
    ElseIf(!akBaseItem.HasKeyword(ArmorJewelry))
      Debug.Notification("\"So generous! ...not. I mean, dont you think thats a bit.. tasteless?\"")
      RemoveItem(akBaseItem, aiItemCount, false, PlayerRef)
      return
    EndIf
  EndIf
  If(akBaseItem.GetGoldValue() > 40 || akBaseItem == Gold001)
    float value = (akBaseItem.GetGoldValue() * aiItemCount) as float
    Core.AddAffection(Math.Ceiling(value/24))
  Else
    Core.LoseAffection()
    Debug.Notification("\"Im no trashbin you know. Sell that junk if you dont need it, dont make me carry it.\"")
    RemoveItem(akBaseItem, aiItemCount, false, PlayerRef)
    return
  EndIf
  If(JF_FlawlessGems.HasForm(akBaseItem) == true)
    Core.GainAffection()
  EndIf
  If(Core.FavoriteGem == 0 && akBaseItem == GemDiamond || akBaseItem == GemDiamondFlawless)
    Core.GainAffection(true)
  ElseIf(Core.FavoriteGem == 1 && akBaseItem == GemEmerald || akBaseItem == GemEmeraldFlawless)
    Core.GainAffection(true)
  ElseIf(Core.FavoriteGem == 2 && akBaseItem == GemSapphire || akBaseItem == GemSapphireFlawless)
    Core.GainAffection(true)
  ElseIf(Core.FavoriteGem == 3 && akBaseItem == GemRuby || akBaseItem == GemRubyFlawless)
    Core.GainAffection(true)
  ElseIf(Core.FavoriteGem == 4 && akBaseItem == GemAmethyst || akBaseItem == GemAmethystFlawless)
    Core.GainAffection(true)
  EndIf
  RemoveItem(akBaseItem, aiItemCount, true)
EndEvent

Event OnClose(ObjectReference akActionRef)
  Reset()
EndEvent
