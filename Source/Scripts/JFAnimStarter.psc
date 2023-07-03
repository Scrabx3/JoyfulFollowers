ScriptName JFAnimStarter Hidden
{Utility Script to remotely start SL Animations}

bool Function SLThere() global
  return Game.GetModByName("SexLab.esm") != 255
EndFunction

; returns -1 if all Actors are valid for animating or 0+, reporting the first invalid Actor
int Function ValidateArray(Actor[] array) global
  SexLabFramework SL = SexLabUtil.GetAPI()
  Keyword ActorTypeNPC = Keyword.GetKeyword("ActorTypeNPC")
  String racetag = ""
  int i = 0
  While(i < array.Length)
    If(SL.IsValidActor(array[i]) == false)
      return i
    ElseIf(array[i].HasKeyword(ActorTypeNPC) == false)
      String raceID = MiscUtil.GetActorRaceEditorID(array[i])
      If(racetag == "")
        racetag = sslCreatureAnimationSlots.GetRaceKeyByID(raceID)
      ElseIf(sslCreatureAnimationSlots.GetRaceKeyByID(raceID) != racetag)
        return i
      EndIf
    EndIf
    i += 1
  EndWhile
  return -1
EndFunction

; QoL cause Im too lazy making Actor Arrays in a Script Fragment
Actor[] Function ActorArray(Actor a1, Actor a2 = none, Actor a3 = none, Actor a4 = none, Actor a5 = none) global
  Actor[] ret = PapyrusUtil.ActorArray(5)
  If(a1 != none)
    ret[0] = a1
  EndIf
  If(a2 != none)
    ret[1] = a2
  EndIf
  If(a3 != none)
    ret[2] = a3
  EndIf
  If(a4 != none)
    ret[3] = a4
  EndIf
  If(a5 != none)
    ret[4] = a5
  EndIf
  return ret
EndFunction

; returns -1 on failure, 0+ when a SL Scene started
int Function StartScene(Actor[] array, String tags = "", String tagsexclude = "", bool requirealltags = true, Actor victim = none, String hook = "") global
  Debug.Trace("[JF] Scene called with Actors " + array + " >> hook = " + hook)
  int v = ValidateArray(array)
  If(v > -1)
    Debug.Trace("[JF] Actor at " + v + "(" + array[v] + ") is invalid, aborting", 2)
    return -1
  EndIf
  SexLabFramework SL = SexLabUtil.GetAPI()
  If(!SL.Enabled)
    Debug.Trace("[JF] Cannot start Animation. SexLab is currently disabled")
    return -1
  EndIf
  If(array.Length == 2)
    ; add ff tag if a consent lesbian animation
    If(victim == none && SL.GetGender(array[0]) == 1 && SL.GetGender(array[1]) == 1)
      tags += "ff"
    EndIf
  EndIf
  sslBaseAnimation[] anims = SL.GetAnimationsByTags(array.Length, tags, tagsexclude)
  While(anims.Length == 0)
    If(array.Length < 2)
      Debug.Trace("[JF] Cant remove any more Actors to find a valid Animation", 1)
      return -1
    EndIf
    int l = array.Length - 1
    Debug.Trace("[JF] Can't find Animations for Scene, removing last Actor = " + array[l], 1)
    If(array.find(victim) == l)
      l -= 1
    EndIf
    array = PapyrusUtil.RemoveActor(array, array[l])
    anims = SL.GetAnimationsByTags(array.Length, tags, tagsexclude, false)
  EndWhile
  return SL.StartSex(array, anims, victim, victim, true, hook)
EndFunction

Actor[] Function GetSceneActors(int tid) global
  SexLabFramework SL = SexLabUtil.GetAPI()
	sslThreadController Thread = SL.GetController(tid)
  return Thread.Positions
EndFunction

float Function GetArousal(Actor that) global
  return (Quest.GetQuest("sla_Framework") as slaFrameworkScr).GetActorArousal(that)
EndFunction

bool Function EndScene(Actor akRef) global
  SexLabFramework SL = SexLabUtil.GetAPI()
  int tid = SL.FindActorController(akRef)
  if (tid == -1)
    Debug.Trace("[Kudasai] Actor = " + akRef + " is not part of any SL Animation.")
    return false
  endif
  sslThreadController controller = SL.GetController(tid)
  if (!controller)
    Debug.Trace("[Kudasai] Actor = " + akRef + " is not part of any SL Animation.")
    return false
  endif
  controller.EndAnimation()
  return true
EndFunction
