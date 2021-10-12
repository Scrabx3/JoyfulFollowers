Scriptname JFStealClothes extends ObjectReference

; ------------------------------------- Property
JFMCM Property MCM Auto
JFCore Property Core Auto
Quest Property JF_Stolen Auto
Actor Property PlayerRef Auto
ReferenceAlias Property JoyFolRef Auto
FormList Property JF_Stolen_Plants Auto
FormList Property JF_Stolen_Daedrics Auto
Keyword Property DaedricArtifact Auto
MiscObject Property Gold001 Auto
; ------------------------------------- Variables
int BaseChance
bool bLostItems = false
; ------------------------------------- Functions
bool Function StripPlayer()
  ;Find Location to store the players clothes
  ObjectReference Tree = Game.FindRandomReferenceOfAnyTypeInListFromRef(JF_Stolen_Plants, PlayerRef, 4096.0)
  If(Tree == None)
    ;if we dont find a location, abandon
    If(MCM.bDeNo == true)
      Debug.Notification("Stolen: No Location found")
    EndIf
    return false
  EndIf
  Core.FadeBlack()
  ;Getting the Satchel ready
  PlayerRef.RemoveAllItems(Self, true)
  ;Move the JoyFol to the storing Location cause Skyrim has no "SnapToNavmesh" Function. Maybe I really should just mod FO4
  Core.JoyFol.MoveTo(Tree, 15.0, 5.0, 100.0)
  ;Let game physics do physic things. 1 second to have the JoyFol hit the ground. Cant think of any other way to ensure the satchel isnt floating (or worse, below the ground)
  Utility.Wait(1)
  ;Now move the satchel and wait real quick before moving the JoyFol back to PLayer location. Just to be sure the satchel is placed properly. Then enable the satchel and let the Quest start .. Yay (essays)
  MoveTo(Core.JoyFol, 0.0, 0.0, 0.0, false)
  Utility.Wait(0.25)
  Enable()
  Core.JoyFol.MoveTo(PlayerRef, -20.0, -20.0)
  bLostItems = false
  ;Polling for clothes getting stolen
  If(MCM.bSCSteal == true)
    RegisterForSingleUpdateGameTime(1)
    BaseChance = 1
  EndIf
  return true
EndFunction

;Throw everything that isnt armor/weaponry(?) back into the players inventory
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If(akBaseItem as armor || akBaseItem as weapon)
    If(akBaseItem.HasKeyword(DaedricArtifact))
      JF_Stolen_Daedrics.AddForm(akBaseItem)
    EndIf
    Return
  EndIf
  Utility.Wait(0.05)
  RemoveItem(akBaseItem, aiItemCount, true, PlayerRef)
EndEvent

;Every ingame hour theres a chance the players armors & weapons are stolen
Event OnUpdateGameTime()
  ;Base Chance: 1 -> 2 -> 4 -> 8 -> 16 -> 32 -> 64 -> 128
  int Chance = Utility.RandomInt(1,100)
  If(BaseChance >= Chance)
    RemoveAllItems()
    Utility.Wait(0.25)
    ;Put Daedric Items back into satchel
    int ItemCount = 0
    While(JF_Stolen_Daedrics.GetSize() >= ItemCount)
      AddItem(JF_Stolen_Daedrics.GetAt(ItemCount), 1, true)
      ItemCount += 1
    EndWhile
    ;Quest now effectively ended but I give the player another 3 real time minutes to figure that out themselves
    bLostItems = true
    RegisterForSingleUpdate(180)
    If(MCM.bDeNo == true)
      Debug.Notification("Clothes were stolen")
    EndIf
    Return
  EndIf
  BaseChance *= 2
  RegisterForSingleUpdateGameTime(1)
EndEvent

;This closes the Quest unless this event is called through polling and the player has Daedrics in his pockets and "Worse End" disabled, in which case the Player gets another 5 Minutes to recover their Artefacts
Event OnUpdate()
  ;bLostItems can only ever be true if the Bad End is enabled and the clothes were stolen. Not sure why I checked for Quest Stages here. Im stupid
  If(bLostItems == true && MCM.bSCWorse == true || JF_Stolen_Daedrics.GetSize() == 0)
    Debug.MessageBox("You suddenly feel a shiver running down your spine. Its like something just told you that your lost gear is gone for good.")
    JF_Stolen.SetStage(400)
    bLostItems = false
  ElseIf(bLostItems == true)
    Debug.MessageBox("You suddenly feel a shiver running down your spine. Its like something just told you that your lost gear is gone for good. \n Altough you're sure no one would be foolish enough to touch a Daedric Artefact. Still, you should probably hurry.")
    JF_Stolen.SetStage(400)
    RegisterForSingleUpdate(500)
    bLostItems = false
    Return
  EndIf
  Disable()
EndEvent

Function RegisterForSl()
  RegisterForModEvent("HookAnimationEnding_StolenSex", "StolenAfterSex")
EndFunction

Event StolenAfterSex(int tid, bool HasPlayer)
	sslThreadController Thread = Core.SL.GetController(tid)
	Actor[] Acteurs = Thread.Positions
	If(Acteurs[1] == Core.JoyFol || Acteurs[0] == Core.JoyFol)
    ;Agreeing to serve the JF, roleplaying a doggo
		If(JF_Stolen.GetStage() == 40)
      ;Initial proposal
	    JF_Stolen.SetStage(100)
      Core.Util.FPetPlay = true
			; SDP(true)
	  Else
      ;After denying "I changed my mind". Dog Collar Ending
	    JF_Stolen.SetStage(115)
	    JF_Stolen.SetObjectiveDisplayed(100)
	    ; SDP(true, true)
	  EndIf
  ElseIf(Core.JoyFol.HasLoS(PlayerRef) == true)
  	;Pet Dog Serving while Follower is watching
		JF_Stolen.SetStage(210)
		; SDP(true)
    Core.Util.FBestiality = true
	Else
    ;Pet Dog Serving while Follower isnt watching
		JF_Stolen.SetStage(210)
	EndIf
	UnregisterForModEvent("HookAnimationEnding_StolenSex")
EndEvent

Event OnActivate(ObjectReference akActionRef)
  If(akActionRef != PlayerRef)
    Return
  ElseIf(bLostItems == true)
    ;Player finds the Chest after theyve been stolen but before OnUpdate fires
    JF_Stolen.SetStage(400)
  ElseIf(JF_Stolen.GetStage() == 100)
    ;Player is lead to the Satchel by the Follower after Begging/Persuation
    JF_Stolen.SetStage(500)
    Core.GainAffection(true)
ElseIf(Core.JoyFol.GetActorValue("WaitingForPlayer") == 1)
  ;Player tells the player to wait before opening the satchel
    JF_Stolen.SetStage(700)
    ; Core.SDP(false, true)
    Core.LoseAffection()
; ====================================================================
  ElseIf(JF_Stolen.GetStage() == 115)
    ;Dog Collar Aftermath. Find the chest in exchange for wearing a collar
    JF_Stolen.SetStage(900)
  ElseIf(JF_Stolen.GetStage() == 120)
    ;Punishment Game Aftermath. This Stage mimics 600 but leads into a Punishment Game after
    JF_Stolen.SetStage(950)
; ======================================================================
  Else
    ;Default Ending. If none of the above apply, this should. Find chest while follower is near
    JF_Stolen.SetStage(600)
    Core.GainAffection()
  EndIf
  ;Start a timer to disable the Satchel after 2min
  bLostItems = false
  RegisterForSingleUpdate(120)
EndEvent

;/Notes for JF_Stolen Queststages
Options:
- Have them stay behind
>> Telling your follower to search on your own makes them wait behind. This doesnt lockout any other Options (Stage 20)
- Random chance in chit-chat dialogue (Bandit/Stop making fun/Search myself)
>> Bandit/Stop making fun: 1 answer is Intimidation. If its valid and chosen the follower gives tips (Stage 30 / Stage 70)
>> Search Myself: When chosing this option the first time and youre not in Submission2, theres a 20% Chance that your follower follows and gives you tips instead (Stage 30 / Stage 70)
- Persudae them
>> This is a very hard persuation check that if it succeeds has your follower show you the way (Stage 100)
- Beg them to help you
>> You can only enter this dialogue once (Stage 40)
>> There are multiple things that can be asked of you, following orders rewards you with the solution (Stage 100)
>> Dog Event offers a Dog Collar Post Event when disagreeing, allowing for additional interaction (Stage 110)
- Hurt them! Gwahaha
>> This only triggers while Stage < 30
>> There can be different outcomes which are mostly random:
>>>> Lead you (Stage 100)
>>>> Help you (Stage 39)
>>>> Lock Out from Begging and Chit Chat (Stage 80)

Stages:
- 20 <Search by myself> Only enables a sandbox package. Nothing meaningful
- 30: Follower gives you tips (Random Persuade/Intimidation)
- 40: Disables Begging
- 70: Same as 30
- 80: Lock Out from the above, through OnHit
- 90: Lock Out from the above, enables Dog Scenes Post

- 100: Default Scenario: Follower shows the way
- 115: Dog Collar Event: Follower shows the way
- 120: Punishment Game Entry: Follower shows the way
- 200: Your pet dog leads you the way (Without sex)
- 210: Your pet dog leads you the way (with sex)
Endings:
- 400: Bad Ending (Lose clothes)
- 500: Neutral End (Follower shows you clothes)
- 600: Default ending
- 700: Good End (Find clothes while follower isnt around)
- 900~925: Dog Collar Aftermath
- 950~960: Punishment Game Aftermath
/;
