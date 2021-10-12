Scriptname JFBelowCollegeMiddenTrigger extends ReferenceAlias Hidden

Actor Property PlayerRef Auto
Scene Property RitualIntro Auto

Event OnTriggerEnter(ObjectReference akActionRef)
  ; If(akActionRef == JoyFol.GetReference())
  If(akActionRef == PlayerRef)
    GetOwningQuest().SetObjectiveCompleted(0)
    GetOwningQuest().SetObjectiveDisplayed(10)
    RitualIntro.Start()
  EndIf
EndEvent
