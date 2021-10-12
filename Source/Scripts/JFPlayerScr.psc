Scriptname JFPlayerScr extends ReferenceAlias

; ----------------------------------- Property
JFCore Property Core Auto
JFMCM Property MCM Auto

Keyword Property LocTypeDungeon Auto
Keyword Property LocTypeCity Auto
Keyword Property LocTypeTown Auto
Keyword Property LocTypeDwelling Auto
Keyword Property LocTypeInn Auto
Keyword Property LocTypePlayerHouse Auto
Faction Property CurrentFollowerFaction Auto

ObjectReference Property JF_Misc_HomeMarkerX Auto
Actor Property PlayerRef Auto
MiscObject Property Gold001 Auto
; ----------------------------------- Variables
float Property fStoredGain Auto Hidden
int Property isWilderness Auto Hidden

string StoredLoc = "Nowhere"
string Property LocType Auto Hidden
;Loctypes: Dungeon | Town | Settlements | Wilderness | Inn | Player Home
; ----------------------------------- Events
; ---------- Startup
Event OnPlayerLoadGame()
  Core.Maintenance()
  AddInventoryEventFilter(Gold001)
EndEvent

Event OnInit()
  Core.Maintenance(OnInit = true)
EndEvent

; ---------- Change Location Event
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
  If(akNewLoc == none) ;Wilderness isnt considered a location
    LocType = "Wilderness"
    isWilderness = 1
  else
    isWilderness = 0
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
  endIf
  ;Event Call
  Core.SendEvent(Core.LocEventKW, akNewLoc)
  ;Location notification
  If((StoredLoc != LocType) && (MCM.bLocNo == true))
    StoredLoc = LocType
    If(StoredLoc != "Inn" && StoredLoc != "Player Home")
      Debug.Notification("Location: " + StoredLoc)
    EndIf
  EndIf
EndEvent

; ---------- Debt
;Added gold only filter
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If(MCM.bDebtComplex == false)
    Return
  ElseIf(akSourceContainer as Actor)
    If((akSourceContainer as Actor).IsInFaction(CurrentFollowerFaction))
      ; Gold gained from a Follower is most likely already owned by the player and just stored there
      return
    endIf
  ElseIf(LocType == "Player Home")
    ; If were in a playerhome, we can assume that all Gold inside is already owned by the Player
    return
  EndIf
  fStoredGain += aiItemCount as float
EndEvent
