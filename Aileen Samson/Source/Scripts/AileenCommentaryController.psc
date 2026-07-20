Scriptname AileenCommentaryController extends Quest  

; (GetOwningQuest() as AileenCommentaryController).StartCommentCooldown()
GlobalVariable Property AileenCanComment Auto

; We do it this way for now so I can adjust it in game if it's too much, too little or whatever. I don't feel like configuring an MCM right now.
GlobalVariable Property AileenMinCommentDelay Auto
GlobalVariable Property AileenMaxCommentDelay Auto


Function StartCommentCooldown()
	AileenCanComment.SetValue(0.0)
	

	Float minCommentDelay = AileenMinCommentDelay.GetValue()
	Float maxCommentDelay = AileenMaxCommentDelay.GetValue()
	
	; Sanity checks. >:(
	If (minCommentDelay < 0.0)
        minCommentDelay = 0.0
    EndIf

    If (maxCommentDelay < 0.0)
        maxCommentDelay = 0.0
    EndIf
	
	If (maxCommentDelay < minCommentDelay)
        Float temporaryDelay = minCommentDelay
        minCommentDelay = maxCommentDelay
        maxCommentDelay = temporaryDelay
    EndIf

	
	UnregisterForUpdate()
    Float commentaryDelay = Utility.RandomFloat(minCommentDelay, maxCommentDelay)
    RegisterForSingleUpdate(commentaryDelay)
EndFunction


Event OnUpdate()
    AileenCanComment.SetValue(1.0)
EndEvent

