Scriptname JFSetStageBleedoutEnter extends ReferenceAlias  
{Script to set a Stage when the Actor this Script is attached to falls into Bleedout}

int Property stageToSet = 200 Auto
{Stage to set when Actor falls into Bleedout; Default: 200}


Event OnEnterBleedout()
	GetOwningQuest().SetStage(StageToSet)
EndEvent
