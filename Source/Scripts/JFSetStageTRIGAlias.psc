Scriptname JFSetStageTRIGAlias extends ObjectReference
{ this is a generic script for one-shot quest stage updates}

quest property myQuest auto
{ quest to call SetStage on}

ReferenceAlias Property triggerAlias Auto
{ the alias to listen for }

int property stage auto
{ stage to set}

bool property doOnce = True auto
{Set the stage only once.}

int property prereqStageOPT = -1 auto
{ OPTIONAL: stage that must be set for this trigger to fire }

bool property disableWhenDone = true auto
{ disable myself after I've been triggered. Defaults to true }

auto STATE waiting
	EVENT onTriggerEnter(objectReference triggerRef)
		if triggerRef == triggerAlias.GetReference()
			if prereqStageOPT == -1 || MyQuest.getStageDone(prereqStageOPT) == 1
				myQuest.setStage(stage)
				if doOnce
					gotoState("hasBeenTriggered")
				endif
				if disableWhenDone
					Disable()
				endif
			endif
		endif
	endEVENT
endSTATE

STATE hasBeenTriggered
	; this is an empty state.
endSTATE
