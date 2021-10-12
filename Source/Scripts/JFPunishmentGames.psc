Scriptname JFPunishmentGames extends Quest Conditional
{This Script contains necessary Structure of a Punishment Game and is to be attached to every Punishment-Game Quest
Close your Game ONLY by calling "CloseQuest()" inside this Script!}
;/ ------------------------------------- Read me
About Punishments:
Punishments are supposed to be Events that keep the Player from the normal Gameplay for some time. They can be heavily invasive, do however end and have no lasting Consequences. In extreme cases, you could consider them a Taster/Trial Course for regular Stage5 Events perhaps, though they can be much less than that too. E.g. forcing the Player to pickpocket someones Pockets

Creating Punishment Games:
If you want to create a Punishment Game, the first thing you have to do is create a new Quest and attach this Script to it. Fill in the Conditions for MCM => JF_Core_MCM and Core => JF_Core. Then go into JFs Script Event Node, open the "SourceGame" branch and follow it into the Affection Recruiement Branch you want to use for your Punishment Game. If you havent already, create a new Quest Node inside this Branch (do not edit existing Branches & Quest Nodes) and add your Quest to your own mods Quest Node. Remember to set unique Conditions to your Quest (Valid Start Locations, Stress, Fatigue, etc)
Next you need something that explains the Rules to the Player. Remember that while your Quest is started, the Player will be idling in the world waiting for something to happen. I personally prefer to use a Forcegreet to officially start the Game for the player and explain the rules. To ensure that this all happens fluently, the Follower will evaluate their Package at Quest start but I dont force any rules here :)
At this point, your Quest should be properly Setup. The StoryManager is able to find & start the Quest and the Player knows the rules of this game. How exactly you go from here is up to you. If your game is based on leaving the Player in a predicament for some time, you can use the Variables below. There is but one thing that you need to remember:

ONLY close this Quest by calling "CloseQuest()" in this Script. Otherwise you break the entire mod. Thank you & have fun :)
/;
; ------------------------------------- Public Properties & Variables
int Property GameTime = -1 Auto Conditional
{Game Duration: -1 = Random Duration // 0 = No Duration // >1 = Duration equals this Number || Conditional || Default: -1}
int Property maxGameTime = 0 Auto
{maximum Time the Game lasts, only used if (GameTime == -1 && maxTimeVar == none) || Default: 0}
int Property minGameTime = 0 Auto
{minimum Time the Game lasts, only used if (GameTime == -1) || Default: 0}
GlobalVariable Property maxTimeVar = none Auto
{Global to define the max Game time externally (e.g. through MCM) || Default: none}

; Hidden Variables:
int Property timeToExtend = 0 Auto Hidden
; You can increase the GameTime while the Game is running when increasing the Value of this Variable (timeToExtend += X)
; You have to define rulebreaks yourself

bool Property GameOver = false Auto Hidden Conditional
; A conditional Variable that will be set to (true) when the Timer hits 0
; You can obviously set this yourself too if you want to

; ------------------------------------- Code
; ALWAYS END THE GAME BY CALLING THIS FUNCTION
Function CloseQuest()
  MCM.Cooldown()
  MCM.bGameRunning = false
  Core.GainAffection(silent = true)
  Stop()
endFunction

; =============================================================
;                           Internal
; =============================================================
JFCore Property Core Auto
{Fill this Variable with JF_Core}
JFMCM Property MCM Auto
{Fill this Variable with JF_Core_MCM}

; ------------------------------------- Code
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
  MCM.bCooldown = false
  MCM.bGameRunning = true
  If(GameTime == -1)
    If(maxTimeVar)
      If(MCM.bDeNo)
        Debug.Notification("JF: Global found")
      EndIf
      maxGameTime = maxTimeVar.Value as int
    elseIf(MCM.bDeNo)
      ; Debug.Notification("JF: No global found D:")
    EndIf
    GameTime = Utility.RandomInt(minGameTime, maxGameTime)
  EndIf
  If(GameTime > 0)
    RegisterForSingleUpdateGameTime(1)
  EndIf
EndEvent

Event OnUpdateGameTime()
  GameTime += timeToExtend
  If(GameTime > 0)
    GameTime -= 1
    RegisterForSingleUpdateGameTime(1)
  Else
    GameOver = true
  EndIf
  timeToExtend = 0
EndEvent

;/ ------------------- Shut Up
int Property TimesSpoken = 0 Auto Hidden
bool Property ShutUpRunning = false Auto Hidden Conditional
bool Property ShutUpTimesUp = true Auto Hidden Conditional

; ------------------- PetCollar
int Property TimesAsked = 0 Auto Hidden
bool Property PetCollarRunning = false Auto Hidden Conditional
bool Property PetCollarTimesUp = true Auto Hidden Conditional

; ------------------- Dog Collar
bool Property DogCollarRunning = false Auto Hidden Conditional
bool Property DogCollarTimesUp = true Auto Hidden Conditional

; ------------------------------------- Code
;When the Script leaves empty state a Game starts. Activate GLobal Cooldown (just remember to reset it in the Close Functions zz)
Event OnEndState()
  MCM.bCooldown = false
EndEvent

Function GameClose()
  Core.GainAffection()
  MCM.Cooldown(true)
  If(Core.JFSDP.GetValue() >= 7.0)
    Core.SDP(false)
  EndIf
EndFunction

; ------------------- Shut Up
Function ShutUpStart()
  GameTime = Utility.RandomInt(6, MCM.iTG)
  TimesSpoken = 0
  ShutUpTimesUp = false
  ShutUpRunning = true
  Util.PGRunning = true
  DD.ShutUp(True)
  GoToState("ShutUp")
EndFunction

Function ShutUpEnd()
  ShutUpTimesUp = true
EndFunction

Function ShutUpClose(bool StayGagged = false)
  ShutUpRunning = false
  Util.PGRunning = false
  If(StayGagged == false)
    DD.ShutUp(false)
  EndIf
  GameClose()
EndFunction

State ShutUp
  Event OnBeginState()
    RegisterForSingleUpdateGameTime(1)
    If(MCM.bDeNo == true)
      Debug.Notification("Game Time: " + GameTime)
    EndIf
  EndEvent

  Event OnUpdateGameTime()
    If(GameTime != 0)
      GameTime -= 1
      RegisterForSingleUpdateGameTime(1)
      If(TimesSpoken != 0 && MCM.bTG == true)
        GameTime += TimesSpoken
        TimesSpoken = 0
      EndIf
      If(MCM.bDeNo == true)
        Debug.Notification("Remaining Game Time: " + GameTime)
      EndIf
    Else
      GoToState("")
      ShutUpEnd()
    EndIf
  EndEvent
EndState

; ------------------- PetCollar
;Service: 0) Everyone 1) JoyFol only 2) No one
Function PetCollarStart(int Service)
  GameTime = Utility.RandomInt(12, MCM.iPetCollarDur)
  PetCollarTimesUp = false
  PetCollarRunning = true
  Util.PGRunning = true
  DD.PetCollar(true, PlayerRef)
  If(MCM.bPetCollarMCM == true)
    DD.PCMService(Service)
  EndIf
  GoToState("PetCollar")
EndFunction

Function PetCollarEnd()
  PetCollarTimesUp = true
EndFunction

Function PetCollarClose(bool StayCollared)
  PetCollarRunning = false
  If(MCM.bPetCollarMCM == true)
    DD.PCMReset()
  EndIf
  If(StayCollared == false)
    Util.PGRunning = false
    PetCollarTimesUp = true
    DD.PetCollar(false, PlayerRef)
  Else
    PetCollarTimesUp = false
  EndIf
  GameClose()
EndFunction

State PetCollar
  Event OnBeginState()
    RegisterForSingleUpdateGameTime(1)
    If(MCM.bDeNo == true)
      Debug.Notification("Game Time: " + GameTime)
    EndIf
  EndEvent

  Event OnUpdateGameTime()
    If(GameTime != 0)
      GameTime -= 1
      RegisterForSingleUpdateGameTime(1)
      If(TimesAsked != 0 && MCM.bTG == true)
        GameTime += TimesAsked
        TimesAsked = 0
      EndIf
      If(MCM.bDeNo == true)
        Debug.Notification("Remaining Game Time: " + GameTime)
      EndIf
    Else
      GoToState("")
      PetCollarEnd()
    EndIf
  EndEvent
EndState

; ------------------- Dog Collar

Function DogCollarStart()
  GameTime = Utility.RandomInt(12, MCM.iDogCollarDur)
  Core.PetPlayCollar(PlayerRef)
  DogCollarRunning = true
  DogCollarTimesUp = false
  Util.PGRunning = true
  GoToState("DogCollar")
EndFunction

Function DogCollarEnd()
  DogCollarTimesUp = true
EndFunction

Function DogCollarClose()
  DogCollarRunning = false
  Util.PGRunning = false
  Core.PetPlayCollar(PlayerRef, False)
  GameClose()
EndFunction

State DogCollar
  Event OnBeginState()
    RegisterForSingleUpdateGameTime(GameTime)
    If(MCM.bDeNo == true)
      Debug.Notification("Game Time: " + GameTime)
    EndIf
  EndEvent

  Event OnUpdateGameTime()
    If(GameTime != 0)
      GameTime -= 1
      RegisterForSingleUpdateGameTime(1)
      If(MCM.bDeNo == true)
        Debug.Notification("Remaining Game Time: " + GameTime)
      EndIf
    Else
      GoToState("")
      DogCollarEnd()
    EndIf
  EndEvent
EndState/;
