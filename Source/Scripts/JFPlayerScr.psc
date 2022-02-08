Scriptname JFPlayerScr extends ReferenceAlias

; ----------------------------------- Property
JFMain Property Main Auto
JFMCM Property MCM Auto

Keyword Property LocTypeDungeon Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeTown Auto
Keyword Property LocTypeDwelling Auto
Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto

ObjectReference Property JF_Misc_HomeMarkerX Auto
Actor Property PlayerRef Auto
MiscObject Property Gold001 Auto
; ----------------------------------- Variables
float Property fStoredGain Auto Hidden
int StoredCRC

; ----------------------------------- Code
Event OnInit()
  OnPlayerLoadGame()
EndEvent

int Property StoredCRC Auto Hidden
Event OnPlayerLoadGame()
  ; Registers Events
  Main.Maintenance()
  ; FNIS
  int CurrentCRC = FNIS_aa.GetInstallationCRC()
  If(StoredCRC != CurrentCRC)
    ; Update JMap storing FNIS Values
    int FNISModID = FNIS_aa.GetAAmodID("JFF", "JoyfulFollowers")
    ; StorageUtil.SetIntValue(none, "FNISModID", FNISModID)
    StorageUtil.SetIntValue(none, "JFFB0", FNIS_aa.GetGroupBaseValue(FNISModID, FNIS_aa._mtidle(), "JoyfulFollowers")) ; Idle
    StorageUtil.SetIntValue(none, "JFFB1", FNIS_aa.GetGroupBaseValue(FNISModID, FNIS_aa._mt(), "JoyfulFollowers")) ; Movement1
    StorageUtil.SetIntValue(none, "JFFB2", FNIS_aa.GetGroupBaseValue(FNISModID, FNIS_aa._mtx(), "JoyfulFollowers")) ; Movement2
    StorageUtil.SetIntValue(none, "JFFB3", FNIS_aa.GetGroupBaseValue(FNISModID, FNIS_aa._sneakidle(), "JoyfulFollowers")) ; Sneak1
    StorageUtil.SetIntValue(none, "JFFB4", FNIS_aa.GetGroupBaseValue(FNISModID, FNIS_aa._sneakmt(), "JoyfulFollowers")) ; Sneak2
    ; Update CRC 
		StoredCRC = CurrentCRC
  EndIf
  ; Debt Setup
  AddInventoryEventFilter(Gold001)
EndEvent

; ---------- Debt
;Added gold only filter
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If(MCM.debtmodelindex == 1)
    Actor akSourceActor = akSourceContainer as Actor
    If(akSourceActor && akSourceActor.IsPlayerTeammate() || PlayerRef.GetCurrentLocation().HasKeyword(LocTypePlayerHouse))
      return
    EndIf
    Debug.Trace("[JF] Player gained Gold >> " + aiItemCount)
    fStoredGain += aiItemCount as float
  EndIf
EndEvent

; ---------- Change Location Event
String StoredLoc
String LocType
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  If(akNewLoc == none) ;Wilderness isnt considered a location
    LocType = "Wilderness"
  Else
    If(akNewLoc.HasKeyword(LocTypePlayerHouse))
      LocType = "Player Home"
      JF_Misc_HomeMarkerX.MoveTo(PlayerRef)
    ElseIf(akNewLoc.HasKeyword(LocTypeInn))
      LocType = "Inn"
    ElseIf(akNewLoc.HasKeyword(LocTypeDungeon))
      LocType = "Dungeon"
    ElseIf(akNewLoc.HasKeyword(LocTypeCity))
      LocType = "Town"
    ElseIf(akNewLoc.HasKeyword(LocTypeTown))
      LocType = "Town"
    ElseIf(akNewLoc.HasKeyword(LocTypeDwelling))
      LocType = "Settlement"
    EndIf
  EndIf
  ;Location notification
  If(StoredLoc != LocType && MCM.bLocNo == true)
    StoredLoc = LocType
    If(StoredLoc != "Inn" && StoredLoc != "Player Home")
      Debug.Notification("Location: " + StoredLoc)
    EndIf
  EndIf
EndEvent
