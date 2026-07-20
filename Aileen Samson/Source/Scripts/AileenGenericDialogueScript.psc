Scriptname AileenGenericDialogueScript extends Quest

DialogueFollowerScript Property FollowerQuest Auto

Function RecruitFollower(Actor akFollower)
    FollowerQuest.SetFollower(akFollower)
EndFunction