scriptname PonyTailColourFix extends ReferenceAlias

Actor Property PlayerRef Auto
ActorBase PB ; PlayerBase, but it is stinky and won't let me call it that. >:(
ColorForm PlayerHairColour

; There is a bug that on the player loading the game, the tail colour resets to the original light grey. 
; This little script fixes that.
Event OnPlayerLoadGame()
	PB = PlayerRef.GetActorBase()
	PlayerHairColour = PB.GetHairColor()
	PB.SetHairColor(PlayerHairColour)	
	Game.UpdateHairColor()
EndEvent
