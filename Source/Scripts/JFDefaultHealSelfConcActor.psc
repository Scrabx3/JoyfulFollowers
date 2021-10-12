Scriptname JFDefaultHealSelfConcActor extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akCaster.RestoreAV("Health", 1)
EndEvent