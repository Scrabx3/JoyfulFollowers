Scriptname JFChallHeadlessChickCloak extends ActiveMagicEffect  


Explosion Property FireballExplosion  Auto  

Event OnEffectStart(Actor Target, Actor Caster)

	Target.PlaceAtMe(FireballExplosion, 1, False, False)

EndEvent
