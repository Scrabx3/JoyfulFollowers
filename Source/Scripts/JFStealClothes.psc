Scriptname JFStealClothes extends ReferenceAlias

Keyword Property DaedricArtifact Auto
Message Property BadEnd Auto  ; Cold shiver runs down spine...
Message Property BadEndWarn Auto  ; .. hoping its not to late

int Property MAX_INT = 2147483647 AutoReadOnly
int LoseItemChance

; -----------------

Function PrepSatchel(JFMCM MCM)
  Game.GetPlayer().RemoveAllItems(GetReference(), true)
  If(MCM.bStolenSteal == true)
    GoToState("ItemsThere")
  Else
    GoToState("")
  EndIf
EndFunction

State ItemsThere
  ; Main update Loop, will remove all items soonish
  Event OnBeginState()
    RegisterForSingleUpdateGameTime(2)
    LoseItemChance = 1
  EndEvent

  Event OnUpdateGameTime()
    ; Base Chance: 1 -> 2 -> 4 -> 8 -> 16 -> 32 -> 64 -> 128
    If(Utility.RandomInt(0, 99) < LoseItemChance)
      ObjectReference myref = GetReference()
      Form[] items = myref.GetContainerForms()
      int i = 0
      While(i < items.Length)
        If(!items[i].HasKeyword(DaedricArtifact))
          myref.RemoveItem(items[i], MAX_INT)
        EndIf
        i += 1
      EndWhile
      GoToState("ItemsLost")
      return
    EndIf
    LoseItemChance *= 2
    RegisterForSingleUpdateGameTime(1)
  EndEvent

  Event OnActivate(ObjectReference akActionRef)
    If(akActionRef != Game.GetPlayer())
      return
    EndIf
    int stage = GetOwningQuest().GetStage()
    If(stage == 100 || stage == 130)  ; Begged or Persuaded
      GetOwningQuest().SetStage(500)
    ElseIf(stage == 120)  ; Begged & agreed to game
      GetOwningQuest().SetStage(950)
    ElseIf(JoyfulFollowers.GetFollower().GetActorValue("WaitingForPlayer") == 1)
      GetOwningQuest().SetStage(700)
    Else  ; Find satchel while follower is near
      GetOwningQuest().SetStage(600)
    EndIf
    GoToState("ItemsFound")
  EndEvent
EndState

State ItemsLost
  Event OnBeginState()
    ; All items have been removed, only artifacts remain if any were carried
    If(GetReference().GetNumItems() > 0)
      BadEndWarn.Show()
    Else
      BadEnd.Show()
    EndIf
    RegisterForSingleUpdate(180)
  EndEvent
  
  Event OnActivate(ObjectReference akActionRef)
    If(akActionRef == Game.GetPlayer())
      GetOwningQuest().SetStage(400)
      GoToState("ItemsFound")
    EndIf
  EndEvent

  Event OnUpdate()
    GetOwningQuest().SetStage(400)
    GetReference().Disable()
  EndEvent
EndState

State ItemsFound
  Event OnBeginState()
    RegisterForSingleUpdate(120)
  EndEvent
  
  Event OnActivate(ObjectReference akActionRef)
  EndEvent

  Event OnUpdate()
    GetReference().Disable()
  EndEvent
EndState
