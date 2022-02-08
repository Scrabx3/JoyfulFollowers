Scriptname JFGlassCannon extends ReferenceAlias  

Keyword Property LocTypeDungeon Auto
Weapon Property Axe Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  If(!akNewLoc.IsSameLocation(akOldLoc, LocTypeDungeon) && GetOwningQuest().GetStage() < 100)
    GetOwningQuest().Stop()
  Else
    GetOwningQuest().SetStage(200)
  EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  Weapon wpn = akBaseObject as Weapon
  Armor amr = akBaseObject as Armor
  If(wpn && wpn != Axe)
    GetOwningQuest().SetStage(200)
  ElseIf(amr)
    Keyword DD = Keyword.GetKeyword("zad_Lockable")
    Keyword DD2 = Keyword.GetKeyword("zad_inventorydevice")
    Keyword T = Keyword.GetKeyword("ToysToy")
    If(!amr.HasKeyword(T) && !amr.HasKeyword(DD) && !amr.HasKeyword(DD2) && amr.GetName() != "")
      GetOwningQuest().SetStage(200)
    EndIf
  EndIf
EndEvent
