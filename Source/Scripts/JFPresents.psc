Scriptname JFPresents extends ObjectReference

; ------------------------------------- Property
Actor Property PlayerRef Auto
Keyword Property ArmorJewelry Auto
Keyword Property JFQuestArmor Auto
MiscObject Property Gold001 Auto

MiscObject[] Property RegGems Auto
MiscObject[] Property FlawGems Auto
{0 Diamond >> 1 Emerald >> 2 Sapphire >> 3 Ruby >> 4 Amethyst}

; ------------------------------------- Events
; Gain Affection based on value of the item + Affection(more) if favorite gem + additional affection is flawless gem
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If(akBaseItem as armor || akBaseItem as weapon)
    If(akBaseItem.HasKeyword(JFQuestArmor))
      RemoveItem(akBaseItem, aiItemCount, false, PlayerRef)
      PlayerRef.EquipItem(akBaseItem, true, true)
      Debug.Notification("You're supposed to wear that remember? Silly!")
      return
    ElseIf(!akBaseItem.HasKeyword(ArmorJewelry))
      Debug.Notification("Dont you think thats.. tasteless?")
      RemoveItem(akBaseItem, aiItemCount, false, PlayerRef)
      return
    EndIf
  EndIf
  Form k = JoyfulFollowers.GetFollower()
  If(akBaseItem.GetGoldValue() > 40 || akBaseItem == Gold001)
    float value = (akBaseItem.GetGoldValue() * aiItemCount) as float
    float affection = Math.Ceiling(value / 24.0) + StorageUtil.GetFloatValue(k, "jfAffection", 0)
    StorageUtil.SetFloatValue(k, "jfAffection", affection)
  Else
    JoyfulFollowers.DamageAffection()
    Debug.Notification("Dont you think thats.. tasteless?")
    RemoveItem(akBaseItem, aiItemCount, false, PlayerRef)
    return
  EndIf
  MiscObject misc = akBaseItem as MiscObject
  If(misc)
    int rgem = RegGems.find(misc)
    int fgem = FlawGems.find(misc)
    int fav = JoyfulFollowers.GetFavGem()
    If(rgem == fav)
      JoyfulFollowers.AddAffection(1)
    ElseIf(fgem == fav)
      JoyfulFollowers.AddAffection(2)
    EndIf
  EndIf
  RemoveItem(akBaseItem, aiItemCount, true)
EndEvent

Event OnClose(ObjectReference akActionRef)
  Reset()
EndEvent
