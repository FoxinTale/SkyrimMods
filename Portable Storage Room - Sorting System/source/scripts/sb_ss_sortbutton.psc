Scriptname sb_ss_sortbutton extends ObjectReference  
; This script is attached to the big old button.
Actor Property PlayerRef  Auto  

ObjectReference Property SB_SortingBox Auto


Event OnActivate(ObjectReference akActionRef)
	sb_ss_sortstorage StorageSort = (SB_SortingBox as ObjectReference) as sb_ss_sortstorage
	
	Bool CrapOffLine = StorageSort.CrapOffLine

	If CrapOffLine == True
		Debug.Notification ("Storage System already processing.")
	Else
		StorageSort.ProcessStuff()
	EndIf
EndEvent