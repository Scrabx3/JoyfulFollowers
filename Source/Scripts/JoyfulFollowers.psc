ScriptName JoyfulFollowers Hidden
{Public API and Documentation}

;/ =======================================================================
  =========================== JOYFUL FOLLOWERS ==========================
  This Script together with "JFMainEvents.psc" creates the public API & general information database for JF
======================================================================= /;

; =========================================
; @return: The current Joyful Follower or none if no Follower is with the Player
; =========================================
Actor Function GetFollower() global
  JFMain Main = Quest.GetQuest("JF_Main") as JFMain
  return Main.CurrentFollower
EndFunction

; =========================================
; @return: The gem type the Follower prefers
; =========================================
int Function GetFavGem() global
  return StorageUtil.GetIntValue(GetFollower(), "jffavgem", -1)
EndFunction

; =========================================
; Recruit a new Actor as the new Joyful Follower. An Actor can only be Joyful if they are a also a Follower. There can only ever be 1 Joyful Follower at a time,
; if by the time this is called there is already a Joyful Follower assigned, they will be dismissed normally (non severe)
; ; ---
; @npc: The npc to assign as Joyful Follower
; ; ---
; @return: If the assignment succeeded
; =========================================
bool Function RecruitFollower(Actor npc) global
  JFMain Main = Quest.GetQuest("JF_Main") as JFMain
  return Main.RecruitFollower(npc)
EndFunction

; =========================================
; Dismiss the current Joyful Follower
; ; ---
; @forced: If the dismissal should ignore any dismissal conditions (e.g. debt)
; @severe: If the dismissal is considered severe (follower initiated due to high severity)
; ; ---
; @return: If the dismiss succeeded
; =========================================
bool Function DismissFollower(bool force, bool severe) global
  JFMain Main = Quest.GetQuest("JF_Main") as JFMain
  return Main.DismissFollower(force, severe)
EndFunction

;/ =======================================================================
  =============================== TIMEOUT ================================
  Cooldown behaves slightly differently in JF compared to other mods with such a Feature. Here we do not use a Timer to put Events on hold and instead define a point in time (in GameDaysPassed) at which Events are allowed to happen again, like so:
    EventsAllowed = GameDaysPassed - LastEventTime + Cooldown_Timeout > 0
  To use this Conditions in the Creationkit, a new Variable is defined called "_Timeout" stored in "JFMainEvents.psc"
  Timeout is defined as: (LastEventTime + Cooldown_Timeout) and allows you to check for Cooldowns in CK Conditions like so:
    GetVMQuestVariable [JF_Main, _Timeout] < GameDaysPassed

  Best Practice: Depending on the complexity & size of your Event: I recommend calling LockTimeout() on Event begin and UnlockTimeout(true) on Event End, this avoids the possibility of another Event starting while your own Event is still ongoing
======================================================================= /;

; =========================================
; Create a new Cooldown Interval
; =========================================
Function SetTimeout() global
  JFMainEvents.Singleton().SetTimeout()
EndFunction

; =========================================
; Lock Cooldown. Will overwrite SetTimeout() until UnlockCooldown() is called
; Internally this will set Timeout to 3.4e38 (thats a 34 with 37 0's), making it impossible to reach without console use
; Fun Fact: The Supernova will happen in less than 7e-27% of the playtime necessary to reach this value. The supernova will happen in 7~8 billion years
; =========================================
Function LockTimeout() global
  JFMainEvents.Singleton().LockTimeout()
EndFunction

; =========================================
; Unlock Cooldown
; ---
; @initialize: Should Cooldown be initialized? If false, Timeout will be set to GameDaysPassed
; =========================================
Function UnlockTimeout(bool initialize) global
  JFMainEvents.Singleton().UnlockTimeout(initialize)
EndFunction

;/ =======================================================================
  ============================= EVENT SYSTEM =============================
  The Library Joyful Followers uses to start individual Event Quests is stored & managed in the games native Story Manager. The advantage in using SM Nodes, next to performance, is that we are able to easily expand the Library without much issue and can condition each Quest individually without passing around huge data blocks through Papyrus. You can even add "Run once" Quests or entire Quest Lines into the Library 
  We use 2 Nodes of this System primarily:  

  1. Script Events (ID: "Script Event")
  2. Location Events (ID: "Change Location Event")

  When adding Quests to the Library, you want to navigate into the appropriate SM Node and add a new Quest Node to the desired branch (its important that you create your own Node to avoid conflicts). The Events you want to add to the Library are put onto the Quest Node you created, the Mainframe together with the Story Manager will then start you Quest if the Conditions you set up for it are valid

  The Node Adresses:
  For all Adresses: 
    • An Event only enters the Node if the Event Cooldown has passed AND the mod is not paused
    • The akRef1 Parameter is always filled with the Follower
    • The Location Parameter is always filled with the Players current Location
  Script Event -> Joyful Followers_Script
    |--> SourceHit: Called when the Player hits the Follower multiple times
      *SourceHit is primarily Severity Centered
              |--> Event Data: Player Location | Follower | none | Severety | 0
    |--> SourcePriority: Called before any other Script Event (except SourceHit)
      *does not offer any differentiation. Utilizing Priority Events will have you disctinct Source and Affection Conditions yourself
              |--> Event Data: Player Location | Follower | akRef* | Severity | Sleep Duration*
                *will be none/0 if not applicatable
    |--> SourceTick: Called periodically every 6 hours. This is intended to be the primary Event Source
              |--> Event Data: Player Location | Follower | none | 0 | 0
    |--> SourceSleep: Called whenever the Player sleeps
              |--> Event Data: Player Location | Follower | none | Sleep Duration | 0
    |--> SourceGame: Manually called through StartGame()
              |--> Event Data: Player Location | Follower | akRef | aiValue | GameID
  Change Location Event -> Joyful Followers_Loc
    |--> SourceLoc: Its Change Loc Event, duh
======================================================================= /;

; =========================================
; Start a (Punishment) Game. This will ignore and will disable Events if a Game started
; It is ESSENTIAL that you call "JFMainEvents.GameEnd()" after your Game ended
; ; ---
; @GameID: A unique ID to start a specific Game (if possible, optional)
; @akRef: An ObjectReference to send with the Event (optional)
; @aiValue: An integer (positive) to send with the Event (optional)
; @source: Parameter for Debugging (optional)
; ; --- 
; @return: if a Game managed to start
; =========================================
bool Function StartGame(int GameID = 0, ObjectReference akRef = none, int aiValue = 0, Form akSource = none) global
  Keyword k = Keyword.GetKeyword("JF_EventGame")
  If(k.SendStoryEventAndWait(Game.GetPlayer().GetCurrentLocation(), GetFollower(), akRef, aiValue, GameID))
    Debug.Trace("[JF] Game Event Call >> successfuly started started a Game " + akSource)
    JFMainEvents.Singleton()._GameTimeout = true
    LockTimeout()
    return true
  Else
    Debug.Trace("[JF] Game Event Call >> Failed to start a Game " + akSource)
    Debug.MessageBox("<JF Gamecall>\nERROR: Failed to start Game")
    return false
  EndIf
EndFunction

; =========================================
; Manually call a "SourcePriority" exclusive Event. This will ignore Timeouts
; This Function will send custom porameter alongside the Event, ignoring the Default Parameters listed above
; ; ---
; @akRef: An ObjectReference to send with the Event (optional)
; @aiValue1: An integer (positive) to send with the Event (optional), !replacing Severity
; @aiValue2: An integer (positive) to send with the Event (optional), !replacing Sleep Duration
; @source: Parameter for Debugging (optional)
; ; --- 
; @return: if a Quest managed to start
; =========================================
bool Function PriorityEvent(ObjectReference akRef, int aiValue1 = 0, int aiValue2 = 0, Form akSource = none)
  Keyword k = Keyword.GetKeyword("JF_EventPriority")
  bool started = k.SendStoryEventAndWait(Game.GetPlayer().GetCurrentLocation(), GetFollower(), akRef, aiValue1, aiValue2)
  Debug.Trace("[JF] Priority Event Call >> successful = " + started + " <> " + akSource)
  return started
EndFunction


;/ =======================================================================
  ============================== AFFECTION ==============================
  Affection is the primary Progression System used in Joyful Followers. It is increased passively while the Follower is together with the Player and when Events complete
  To make sure that this System stays consistent, Authors of Add ons are asked to call the appropriate Functions listed below when the Situation allows it

  The purpose of Affection is to split the Mod into multiple sections, creating a Progression System in which the follower is at first rather shy and drawn back and as they get to know the Player attempt to create more and more extreme to Situation to experience together. Affection is thus split into 4 Levels:
  === Level 1 ===
  Keep things simple, at a basic level of Interaction. Neither knows the other

  === Level 2 ===
  The Follower assumes the Player could be a really interesting "partner" for all sorts of things but won't go all out just yet. There is interaction with the Player but not at a level to allow intimacy. The follower shows interest and the player is allowed to engage

  === Level 3 ===
  Sexuality/Perversion is a part of the relation at this point forth but the follower wont attempt to involve the player into anything extreme. Try to keep sexual encounters private and at a basic level and dont go further than "experimenting" or talking about extreme topics. Also avoid jumping straight to "Its wednesday so we do it now" environments as it would create too much a cut between Lv2 and Lv3

  === Level 4 ===
  Anything goes. I recommend that if you want to create any new regularities* you introduce them through a introduction Quest first
  *regularity as in a "relation ship rule" the player has to keep, a repeating event, e.g. an offering or a certain service, things that will permanently alter the fundamental relationship from player to follower or vice versa
======================================================================= /;

; =========================================
; Increase Affection towards the Player for the current Follower. The amount of Affection that is rewarded depends on the reason:
; 0 - Flattering or complementing >> (This can happen anywhere and multiple times in a single conversation)
; 1 - Minor interaction >> (Events that require little to no player input, e.g. single Forcegreet or playtime < 5min)
; 2 - Common Events >> (Standalone Events that require the Player to actively take part in something)
; 3 - Unique Events & Questlines >> (Unique Quests, one-time Dialogue that is easy to miss (e.g. Whiterun Balcony Cutscene) or Quest Lines)
; ; ---
; @type: The reasoning for the increase (see above)
; @forcesilent: Override MCM Settings & disable Affection Notification
; =========================================
Function AddAffection(int type, bool forcesilent = false) global
  If(type < 0 || type > 3)
    Debug.MessageBox("[JF] WARNING: Invalid Affection Increase Type")
    Debug.Trace("[JF] WARNING: Invalid Affection Increase Type", 1)
    return
  EndIf
  (Quest.GetQuest("JF_Main") as JFMain).AddAffection(type, forcesilent)
EndFunction

; =========================================
; Damage Affection towards the Player. Use this when the Player does something that would hurt or insult the Follower
; ; ---
; @severe: Should severity be increased (damage will also be higher)
; @forcesilent: Override MCM Settings & disable Affection Notification
; =========================================
Function DamageAffection(bool severe = false, bool forcesilent = false) global
  (Quest.GetQuest("JF_Main") as JFMain).DamageAffection(severe, forcesilent)
EndFunction

; =========================================
; @return: the level of Affection for the current Follower
; =========================================
float Function GetAffectionLevel() global
  return JFMain.GetAffectionGlobal().GetValue()
EndFunction

; =========================================
; Get Affection Level for any NPC
; ; ---
; @return: the level of Affection for the specified Follower:
; 0+ >> the NPCs Affection
; -1 >> the NPC has no Affection assigned
; =========================================
float Function GetAffectionLevelAny(Actor npc) global
  return StorageUtil.GetFloatValue(npc, "jfAffectionLv", -1)
EndFunction

;/ =======================================================================
  ============================== SEVERITY ==============================
  Severity describes the negative Disposition of the Follower towards the Player. The Stat is extremely punishing as a high level of Severity disables Dialogue and can even cause the Follower to leave the Player, permanently disabling them as a Follower (not just Joyful Follower)
  Severity is gained either when the Player is actively attacking the Follower or the Function "DamageAffection(severity = true)" is called 
  It is decreased when the Player is together with the Follower without progressing Severity again or by the Follower getting "revenge" through Severity Events. 

  Events to punish a high Severity are to be placed into the SourcePriority Script Event Branch. I also heavily recommend to avoid any strictly rewarding Events for high Severity. Severity is NOT intended to create an opening for Player Enslavement by the Follower or similar
  Severity is capable of creating another Layer to the Follower, making them more be perceived more "self aware" by drawing a line where - for them - the Players behavior is no longer amusing but insulting and hurting. Severity Events should be designed to be "not fun" for the Player, since they did things that are "not fun" to the Follower

  Severity is cut into 3 Segments:
  Segment 1:  0 ~  4 >> No Restrictions applied
  Segment 2:  5 ~ 12 >> Severity Events will overwrite common Events, common Events will be rarer
  Segment 3: 13 ~ ?? >> Follower may leave the Player

  When you want to create a Severity Event, attempt to sort it into the correct Segment. All Severity Events which do not cause the Follower to leave the Player should be placed in Segment 2, which is further divided into 3 sub-segments used to classify the "harshness" of the Event. Segment 3 only contains Events which cause the Follower to leave the Player in some way. Use "DismissFollower(true, true)" for this purpose
======================================================================= /;

; =========================================
; @return: the level of Severity for the current Follower
; =========================================
int Function GetSeverity() global
  return JFMain.GetSeverityGlobal().GetValueInt()
EndFunction

; =========================================
; Reduce Severity for the current Follower by 1 (should only be called through Severity Events)
; =========================================
Function ReduceSeverity() global
  GlobalVariable val = JFMain.GetSeverityGlobal()
  val.SetValue(val.Value - 1)
EndFunction

; =========================================
; Get Severity for any NPC
; ; ---
; @return: the level of Severity for the specified Follower:
; 0+ >> the NPCs Severity
; -1 >> the NPC has no Severity assigned
; -2 >> the NPC left the Player due to high Severity
; =========================================
int Function GetSeverityAny(Actor npc) global
  return StorageUtil.GetIntValue(npc, "jfSeverity", -1)
EndFunction

; =========================================
; Reduce Severity for any NPC by 1 (should only be called through Severity Events)
; =========================================
Function ReduceSeverityAny(Actor npc) global
  float sev = StorageUtil.GetFloatValue(npc, "jfSeverity", -1)
  If(sev == -1)
    Debug.Trace("[JF] WARNING: Actor " + npc + " has no Severity defined.", 1)
  Else
    StorageUtil.SetFloatValue(npc, "jfSeverity", sev - 1)
  EndIf
EndFunction
