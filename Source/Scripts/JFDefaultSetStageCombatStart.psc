Scriptname JFDefaultSetStageCombatStart extends ReferenceAlias  

Actor Property target Auto
{Target this Actor should enter combat with}

int Property prereqStage = -1 Auto
{OPTIONAL | Stage that should be set to set this stage}

int Property targetStage Auto
{stage to be set}

bool Property onlyonce = true Auto
{Only set the stage once | DEFAULT = true}

Auto State Waiting
  Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    If(aeCombatState > 0 && akTarget == target)
      If(prereqStage == -1 || GetOwningQuest().GetStageDone(prereqStage))
        GetOwningQuest().SetStage(targetStage)
        If(onlyonce)
          GoToState("Done")
        EndIf
      EndIf
    EndIf
  EndEvent
EndState

State Done
  Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
  EndEvent
EndState
