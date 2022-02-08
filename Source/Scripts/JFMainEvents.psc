ScriptName JFMainEvents extends Quest Hidden Conditional
{Script stores Info about the current Follower knows about the Player. 
On dismissal, the Scripts Values will be stored through PapyrusUtil for usage in case of re-requiretmenet}

; Return the object holding the below data. You will have to call this before you try to acces any of the below variables
JFMainEvents Function Singleton() global
  return Quest.GetQuest("JF_Main") as JFMainEvents
EndFunction

;/ =======================================================================
  ============================== TIMEOUT ===============================
======================================================================= /;
GlobalVariable Property GameDaysPassed Auto
JFMCM Property MCM Auto
float Property FLOAT_MAX_VAL
  float Function Get()
    return 3.4 * Math.pow(10, 38)
  EndFunction
EndProperty

float Property _Timeout Auto Hidden Conditional
bool Property _TimeoutLock Auto Hidden Conditional
bool Property _GameTimeout Auto Hidden Conditional
Function SetTimeout()
  If(_Timeout == FLOAT_MAX_VAL)
    Debug.Trace("[JF] WARN: Attempted to Set Timeout but ")
    return
  EndIf
  _Timeout = GameDaysPassed.Value + MCM.fTimeoutTime
  Debug.Trace("[JF] Setting Timeout >> GameDaysPassed = " + GameDaysPassed.Value + " >> Timeout = " + _Timeout)
EndFunction

Function LockTimeout()
  Debug.Trace("[JF] Locking Timeout")
  _Timeout = FLOAT_MAX_VAL
  _TimeoutLock = true
EndFunction

Function UnlockTimeout(bool initialize)
  Debug.Trace("[JF] Unlocking Timeout >> initalize = " + initialize)
  If(initialize)
    _Timeout = GameDaysPassed.Value + MCM.fTimeoutTime
  Else
    _Timeout = GameDaysPassed.Value
  EndIf
  _TimeoutLock = false
EndFunction

Function GameEnd(bool initialize) global
  Debug.Trace("[JF] Game Ent >> initalize = " + initialize)
  JFMainEvents singleton = Singleton()
  singleton._GameTimeout = false
  singleton.UnlockTimeout(initialize)
EndFunction

;/ =======================================================================
  ============================= EVENT DATA =============================
  This stores Information the Follower collects about the Player. Characteristics, preferences, interestes, etcpp. An important aspect not to ignore is that those flags are by the follower interpretation. That means that to set one of those flags, the player doesnt have to specifically state so (altough thats certainly an option), its enough to imply that "it might be" or make the follower interesting
  If you need a new value here notify me. Dont edit this Script yourself to avoid compatibility issues and to ensure that everyone has access to the same Information for their Events
======================================================================= /;

; ---------------------- Veto
; Veto is allowed once per Follower. When the Player does reach 13 Severity and a leave Event triggers, under certain (by the author defined) conditions they may be  able to make the follower change their mind. To ensure this cant be abused and stays consistent, the Veto variable is demanded to be one of those conditions. If this variable is false, the Player already got themselves in this predicament before and the Follower will not pull back
; When the player uses their veto, call "JFMainEvents.Singleton()._Veto = false" in a Script
bool Property _Veto = true Auto Hidden Conditional

; ---------------------- Submission
; Submission scaling, reaches from -5 to 5. Use Helper Function below to manipulate
; Submissive: -5 ~ -2
; Neutral:    -1 ~  1
; Dominant:    2 ~  5
float Property Submission Auto Hidden Conditional
; submit: If the Player submitted to the Follower (false will decrease submission)
Function Submit(bool submit) global
  JFMainEvents me = Singleton()
  If(submit && me.Submission > -5)
    me.Submission -= 1
  ElseIf(me.Submission < 5)
    me.Submission += 1
  EndIf
EndFunction

; ---------------------- Cruelty
; Player is considered kind if false, cruel if true
bool Property FIsCruel = false Auto Hidden Conditional

; ---------------------- Greedy
; Player is considered generous if false, greedy if true
bool Property FIsGreedy = false Auto Hidden Conditional

; ---------------------- Violating
; interested in being violated
bool Property Violated = false Auto Hidden Conditional

; ---------------------- Groupsex
; Player is interested in groupsex
bool Property Groupsex = false Auto Hidden Conditional

; ---------------------- Bestiality
; Creatures of all kinds, obvsly
bool Property Bestiality = false Auto Hidden Conditional

; ---------------------- Masochism
; As in physical and/or erotic torture
bool Property Masochism = false Auto Hidden Conditional

; ---------------------- Bondage
; being tied in any way. Ropes, Devices, Furniture
bool Property Bondage = false Auto Hidden Conditional

; ---------------------- humiliation
; humilation, e.g. in public, on parties, etcpp
bool Property Humiliation = false Auto Hidden Conditional

; ---------------------- Pet Play
; generic petplay, not necessarily in a humiliating or bdsm context 
bool Property PetPlay = true Auto Hidden Conditional


;/ =======================================================================
  ============================= EVENT CACHE =============================
  Information about previous Event desicions & outcomes. Those will be dynamically adjusted based the most recent instance of a Event
  As before, dont edit this Script. If you want to add a new value here, notify me. It might also be beneficial to just create your own Script with your own cache depending on how important this feature is to you. (Its really just a data storage I use for specific Events, nothing special)
======================================================================= /;

; ---------------------- Drinking
; Drinking Event outcome; 0 >> Player lost, 1 >> Player won, (-1 >> no event played yet)
int Property EDrinkingOutcome = -1 Auto Hidden Conditional

; ---------------------- Puppy Collar
; player knows about the effects of the collar
bool Property kPuppyEffect = false Auto Hidden Conditional
; player also got stripped during the dog collar event
bool Property KDogCollarNude = false Auto Hidden Conditional

; ---------------------- Below College
; If the Event is allowed to start. The Player can use this to completely disable the Event for the current Follower
bool Property BelowCollege = true Auto Hidden Conditional
; Follower explained the Ritual once, used to skip some dialogue after the first encounter
bool Property KCollegeRitual = false Auto Hidden Conditional

; ---------------------- Present System
; Set after the Player guessed the correct Gem
bool Property EPresentGuessedGem = false Auto Hidden Conditional




;/ =======================================================================
  =============================== STORAGE ===============================
  Below Methods are utility to manage follower dismissal. Don't call this yourself
======================================================================= /;
; TODO: implement
Function StoreData(Form object)
EndFunction

; TODO: implement
Function LoadData(Form object)
EndFunction