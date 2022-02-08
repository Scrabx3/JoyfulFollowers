Scriptname JFTraitor extends Quest Conditional

; -------------------------- Properties
JFMCM Property MCM Auto

Faction Property JF_Traitor_RebelFaction Auto
Actor[] Property Thralls Auto ; 0 is player, everyone after are potential partners
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
bool Property doAddultStuff = false Auto Hidden Conditional ; enable/disable adult content
bool Property ignoredJF = true Auto Hidden Conditional ; how often the Player denied the JF & waited additional time
bool Property cycling = false Auto Hidden ; player ignored the JF at least once
int Property ScenarioToPlay = 0 Auto Hidden Conditional ; Actor to turn the Player (0 > Harkon // 1 > Serana // 2 > Follower)
int timesUsed = 0
bool stillWaiting = false
String tags = "aggressive, rough"

; -------------------------- Code
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  JoyfulFollowers.LockTimeout()
  If(akLocation == DLC1VampireCastleGuildhallLocation)
    ScenarioToPlay = GetScenarioVolkihar()
  else
    ; If Event Loc is Dawnguard HQ, only play adult scenes when bestiality is allowed
    doAddultStuff = MCM.bCreatureContent
  EndIf
  ; Lock the Door so the player cant leave
  PrisonDoor.SetLockLevel(255)
  PrisonDoor.SetFactionOwner(JF_Traitor_RebelFaction)
  ; Disabling Doors so the Player cant run away mwahaha
  int Count = ExitDoors.Length
  While(Count)
    Count -= 1
    ExitDoors[Count].SetLockLevel(255)
    ExitDoors[Count].Lock(true)
  EndWhile
EndEvent

int Function GetScenarioVolkihar()
  If(!DLC1VQ06.IsCompleted() && Harkon != none)
    return 0 ; Harkon is alive and not yet betrayed, turn back Sequence will address him as the solution
  elseIf(Serana != none && JoyfulFollowers.GetFollower() != Serana.GetReference())
    return 1 ; Serana is in the castle but is not the Follower
  else
    return 2 ; Serana is in the castle
  EndIf
EndFunction

Function EndQuest()
  JoyfulFollowers.GetFollower().SetAV("WaitingForPlayer", 0)
  PrisonDoor.SetLockLevel(0)
  PrisonDoor.SetFactionOwner(none)
  int Count = ExitDoors.Length
  While(Count)
    Count -= 1
    ExitDoors[Count].SetLockLevel(0)
    ExitDoors[Count].Lock(false)
  EndWhile
  SetStage(10)
  JoyfulFollowers.UnlockTimeout(true)
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
  else  ; if looping, cut down waiting time in half
    stillWaiting = true
    TimeScale.Value = MCM.iTraitorScale
    RegisterForSingleUpdateGameTime(Utility.RandomInt(3, 7))
    If(doAddultStuff)
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
  If(JFAnimStarter.StartScene(thralls, tags, "loving", false, thralls[0], "JFTraitor") > -1)
    RegisterForModEvent("HookAnimationEnding_JFTraitor", "TraitorAfterSex")
  Else
    Debug.MessageBox("<JF Traitor Event>\nAn Error occured while starting the Animation. Scenes will be disabled for the remaining duration of the Quest.")
    doAddultStuff = false
  EndIf
endFunction

Event TraitorAfterSex(int tid, bool hasPlayer)
  timesUsed += 1
	If(stillWaiting)
    Utility.Wait(10)
    If(timesUsed == 7)
      tags = "necro, necrophilia, aggressive"
    EndIf
    If(JFAnimStarter.StartScene(thralls, tags, "loving", false, thralls[0], "JFTraitor") == -1)
      Debug.MessageBox("<JF Traitor Event>\nAn Error occured while starting the Animation. Scenes will be disabled for the remaining duration of the Quest.")
    EndIf
  else
    If(!cycling)
      EndScene.Start()
    else
      EndSceneCycle.Start()
    EndIf
  EndIf
EndEvent
