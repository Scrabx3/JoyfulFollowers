Scriptname JFTraitor extends Quest Conditional

; -------------------------- Properties
JFCore Property Core Auto
JFMCM Property MCM Auto

Faction Property JF_Traitor_RebelFaction Auto
Actor[] Property Thralls Auto
Scene Property EndScene Auto
Scene Property EndSceneCycle Auto

GlobalVariable Property TimeScale Auto
Location Property DLC1VampireCastleGuildhallLocation Auto
ObjectReference[] Property ExitDoors Auto
ObjectReference Property PrisonDoor Auto

Quest Property DLC1VQ06 Auto
ReferenceAlias Property Harkon = none Auto
ReferenceAlias Property Serana = none Auto

; -------------------------- Vaiables
bool Property doAddultStuff = false Auto Hidden Conditional
bool Property ignoredJF = true Auto Hidden Conditional
bool Property cycling = false Auto Hidden
int Property ScenarioToPlay = 0 Auto Hidden Conditional
; Which Actor is used to turn the Player: 0 = Harkon, 1 = Serana, 2 = JoyFol
int timesUsed = 0
bool stillWaiting = false

; -------------------------- Code
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  MCM.bCooldown = false
  If(akLocation == DLC1VampireCastleGuildhallLocation)
    doAddultStuff = MCM.bTraitorEnabAdult
    ScenarioToPlay = GetScenarioVolkihar()
  elseIf(MCM.bBestiality)
    ;If Event Loc is Dawnguard HQ, check for Bestiality before adjusting the Flag
    doAddultStuff = MCM.bTraitorEnabAdult
  EndIf
  ; Setting Door Ownership for the Player thing stuff
  ; !Doesnt work + for simplicity reasons disallowing Player to active anything instead
  PrisonDoor.SetLockLevel(255)
  PrisonDoor.SetFactionOwner(JF_Traitor_RebelFaction)
  ;Disabling Doors so the Player cant run away mwahaha
  int Count = ExitDoors.Length
  While(Count)
    Count -= 1
    ExitDoors[Count].SetLockLevel(255)
    ExitDoors[Count].Lock(true)
  EndWhile
EndEvent

int Function GetScenarioVolkihar()
  If(!DLC1VQ06.IsCompleted() && Harkon != none)
    return 0
  elseIf(Serana != none && Core.JoyFol != Serana.GetReference() as Actor)
    return 1
  else
    return 2
  EndIf
EndFunction

Function EndQuest()
  Core.JoyFol.SetAV("WaitingForPlayer", 0)
  PrisonDoor.SetLockLevel(0)
  PrisonDoor.SetFactionOwner(none)
  int Count = ExitDoors.Length
  While(Count)
    Count -= 1
    ExitDoors[Count].SetLockLevel(0)
    ExitDoors[Count].Lock(false)
  EndWhile
  SetStage(10)
  MCM.Cooldown()
endFunction

Function StartWaiting()
  If(!cycling)
    stillWaiting = true
    TimeScale.Value = MCM.iTraitorScale
    RegisterForSingleUpdateGameTime(Utility.RandomInt(5, 9))
    If(doAddultStuff)
      timesUsed = 0
      StartChainRape()
    EndIf
  else  ; If were looping this, cut down waiting time in half
    stillWaiting = true
    TimeScale.Value = MCM.iTraitorScale
    RegisterForSingleUpdateGameTime(Utility.RandomInt(3, 7))
    If(doAddultStuff)
      timesUsed = Math.Ceiling(timesUsed * 0.5)
      StartChainRape()
    EndIf
  EndIf
endFunction

Event OnUpdateGameTime()
  stillWaiting = false
  TimeScale.Value = 20
  If(!doAddultStuff)
    If(!cycling)
      EndScene.Start()
    else
      EndSceneCycle.Start()
    EndIf
  EndIf
EndEvent

Function StartChainRape()
  If(Core.StartSexTraitor(Thralls) != -1)
    RegisterForModEvent("HookAnimationEnding_Traitor", "TraitorAfterSex")
  else
    Debug.MessageBox("Something went wrong with Scene starting, falling back to Default Scenario..")
    doAddultStuff = false
  endIf
endFunction

Event TraitorAfterSex(int tid, bool hasPlayer)
	If(stillWaiting)
    timesUsed += 1
    Utility.Wait(10)
    If(timesUsed > 7)
      Core.StartSexTraitor(Thralls, true)
    else
      Core.StartSexTraitor(Thralls)
    EndIf
  else
    UnregisterForModEvent("HookAnimationEnding_Traitor")
    If(!cycling)
      EndScene.Start()
    else
      EndSceneCycle.Start()
    EndIf
  EndIf
EndEvent
