Scriptname JFEventStorage extends Quest Conditional
{Script to store some variables for Events. Those can be some very small events that arent worth the work of building an entire quest around them or some dialogue choices which can affect future events}

; =========================================================
; ====================== Preferences ======================
; =========================================================
;/Preferences (primarily Fetishes) you admit to your Follower, either directly, in form of a "confession" or through a Player driven choice (you might say the Follower is allowed to trick you into confessing a flag without the Player noticing)
/;
; ---------------------- Public Humiliation
bool Property FPublicHumiliation = true Auto Hidden Conditional

; ---------------------- Pet Play
bool Property FBestiality = true Auto Hidden Conditional

; ---------------------- Pet Play
bool Property FPetPlay = true Auto Hidden Conditional

; ---------------------- Chain Rape
bool Property FChainRape = true Auto Hidden Conditional

; ---------------------- Gangbang
bool Property FGangbang = true Auto Hidden Conditional

; ---------------------- Torture
bool Property FTorture = true Auto Hidden Conditional

; ---------------------- Bondage Lover
bool Property FBondageLover = true Auto Hidden Conditional


; ---------------------- Cruelty
; Player is considered kind if false, cruel if true
bool Property FIsCruel = false Auto Hidden Conditional

; ---------------------- Greedy
; Player is considered generous if false, greedy if true
bool Property FIsGreedy = false Auto Hidden Conditional

; =========================================================
; =======================   Tokens  =======================
; =========================================================
;/Tokens are integers that stack up to a certain number first before they do anything. Its essentially a flag that needs to "level up" first before its considered true
/;
; ---------------------- Leave Tokens
; Collect more than 7 of them to unlock the Follower Leave Event
; Lose 1 Token every 127 Ticks (1 inGame Month)
; INTERNAL ONLY
int Property TLeaveToken = 0 Auto Hidden Conditional

; ---------------------- Marry Tokens
; Collect 5 to unlock a Follower iniated Marriage Request at Lv5
int Property TMarryToken = 0 Auto Hidden Conditional

; ---------------------- Chastity
; int Property TChasteToken = 0 Auto Hidden Conditional

; ---------------------- Breeder
; int Property TBreederToken = 0 Auto Hidden Conditional

; ---------------------- Milkmaid
; int Property TMilkmadeToken = 0 Auto Hidden Conditional

; ---------------------- Amputation
int Property TAmputation = 0 Auto Hidden Conditional

; =========================================================
; =======================   Known   =======================
; =========================================================
;/Known Flag to allow the mod to dynamically interact with previous interactions & Events/;
; ---------------------- Dog Collar
; KDogCollarCrawling: Set true on 1st equipment
; KDogCollarNude: Set true when the DogCollar specific Event also enforces nudity
bool Property KDogCollarCrawling = false Auto Hidden Conditional
bool Property KDogCollarNude = false Auto Hidden Conditional

; ---------------------- Dog Collar
bool Property KCollegeRitual = false Auto Hidden Conditional
; =========================================================
; ==================   Devious Devices  ===================
; =========================================================
; Flags preventing the Follower from Unequipping the specified Device through the KeyHolder Dialogue
; Those flags are set automatically when Punishments are initiated through the Core, if you do not use the Punishment Function inside JFDDCore and want to ensure that the Follower doesnt unequip one of the Following devices, make sure to set the here flag manually
; They are reset automatically once the Player is no longer wearing the specified Device
; ---------------------- Blindfold Punishment
Bool Property DBlindfoldPunishment = false Auto Hidden Conditional
; ---------------------- Gag Punishment (Simple)
Bool Property DGagPunishment = false Auto Hidden Conditional
; ---------------------- Heavy Bondage Punishment
Bool Property DHeavyBondagePunishment = false Auto Hidden Conditional
; ---------------------- Heavy Bondage Punishment
Bool Property DGlovesPunishment = false Auto Hidden Conditional
; ---------------------- Heavy Bondage Punishment
Bool Property DBootsPunishment = false Auto Hidden Conditional

; =========================================================
; =======================   Events  =======================
; =========================================================
; Set after the Player begged in SitW to get to the Satchel and the Follower didnt ask for anything in return
bool Property ESitWJustLikeThat = false Auto Hidden Conditional

; Set after the Follower explained the rules in the present System once
; Variable does not reset, QoL n stuff
bool Property EPresentExplained = false Auto Hidden Conditional

; Set after the Player guessed the correct Gem
bool Property EPresentGuessedGem = false Auto Hidden Conditional

; =========================================================
; =======================   Reset  ========================
; =========================================================
Function ResetMe()
  ;Flags
  FPublicHumiliation = true
  FPetPlay = true
  FBestiality = true
  FBondageLover = true
  FChainRape = true
  FGangbang = true
  FTorture = true
  FIsCruel = false
  FIsGreedy = false
  ;Tokens
  TLeaveToken = 0
  TMarryToken = 0
  ; TChasteToken = 0
  ; TBreederToken = 0
  ; TMilkmadeToken = 0
  TAmputation = 0
  ;Known
  KDogCollarCrawling = false
  KDogCollarNude = false
  ;Devious Devices
  DBlindfoldPunishment = false
  DGagPunishment = false
  DHeavyBondagePunishment = false
  DGlovesPunishment = false
  DBootsPunishment = false
  ;Events
  ESitWJustLikeThat = false
  ; EPresentExplained = false
  EPresentGuessedGem = false
endFunction
