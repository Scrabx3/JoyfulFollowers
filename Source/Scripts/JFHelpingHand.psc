Scriptname JFHelpingHand extends ReferenceAlias  

Keyword Property LocTypeDungeon Auto
Weapon Property HealStaff Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  If(!akNewLoc.IsSameLocation(akOldLoc, LocTypeDungeon) && GetOwningQuest().GetStage() < 100)
    GetOwningQuest().Stop()
  Else
    GetOwningQuest().SetStage(210)
  EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  Weapon wpn = akBaseObject as Weapon
  If(wpn && wpn != HealStaff)
    GetOwningQuest().SetStage(210)
  EndIf
EndEvent
