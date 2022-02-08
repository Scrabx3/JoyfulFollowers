Scriptname JFHeadlessChick extends ReferenceAlias  

Keyword Property LocTypeDungeon Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  If(!akNewLoc.IsSameLocation(akOldLoc, LocTypeDungeon) && GetOwningQuest().GetStage() < 100)
    GetOwningQuest().Stop()
  Else
    GetOwningQuest().SetStage(200)
  EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
  Weapon wpn = akBaseObject as Weapon
  If(wpn)
    GetOwningQuest().SetStage(200)
  EndIf
EndEvent
