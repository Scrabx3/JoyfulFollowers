Scriptname JFTraitorBloodwaterPotion extends ActiveMagicEffect  

DLC1dunRedwaterDenBloodspringScript Property BloodwaterScript Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	BloodwaterScript.ProcessInfection(akCaster)
endEvent