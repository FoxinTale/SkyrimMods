Scriptname sb_teleport extends ObjectReference  

ObjectReference Property OutMarker  Auto
ObjectReference Property InMarker  Auto
Cell Property StorageBox  Auto

Event OnEquipped(Actor akActor)
	if (akActor.GetParentCell() != StorageBox)
		OutMarker.MoveTo (akActor)
		akActor.MoveTo (InMarker)
		moveFollowers(InMarker)
	else
		akActor.Moveto (OutMarker)
		moveFollowers(OutMarker)
	endif
EndEvent


Function moveFollowers(ObjectReference marker)
    Actor[] currentFollowers = PO3_SKSEFunctions.GetPlayerFollowers() ; Get followers via Powerofthree SKSE
            
    int i
    While (i < currentFollowers.Length)
        currentFollowers[i].MoveTo(marker)
        i += 1
    EndWhile
EndFunction