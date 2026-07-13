Scriptname PonyTailRaceMenu extends RaceMenuBase

import NiOverride ; No touchie touch. 

Int Property RM_PONYTAIL_VERSION = 1 AutoReadOnly
Int Property Version = 0 Auto
String Property CATEGORY_KEY = "racemenu_ponytails" AutoReadOnly

Actor Property PlayerRef Auto


FormList Property PonyTailList Auto ; The list of tails. 

Float PonyTailType = 0.0


Float PonyTailCount = PonyTailList.GetSize() as Float ; aaaaaa


Int TailType = 1 ; Default 1


;---------------------------------------------------------------------------------------------------------------------
; Events.


String BodyString = ""

; Runs when the script initialises for the very first time.
Event OnInit()
	Parent.OnInit()
	Version = RM_PONYTAIL_VERSION
	RegisterForMenu("RaceSex Menu") ; RaceMenu, or the character creation menu name.
	
	If(!PlayerRef) ; Null check. It can happen sometimes when Papyrus loses its goddamn mind.
		PlayerRef = Game.GetPlayer()
	EndIf
EndEvent


; When RaceMenu is loaded and the category is requested, create the new "" category.
Event OnCategoryRequest()
	AddCategory(CATEGORY_KEY, "Pony Tails", -750)
EndEvent


Event OnMenuOpen(String MenuName)
	If(MenuName == "RaceSex Menu")
		RaceCheck()
	EndIf
EndEvent

; When a UI menu is closed.
Event OnMenuClose(String MenuName)
	If(MenuName == "RaceSex Menu")
		RaceCheck()
	EndIf
EndEvent


; When it is time for slider creations, create them and set their appropriate values.
Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, bool isFemale)
	AddSliderEx("Tail Type", CATEGORY_KEY, "pony_tail_type", 0.0, PonyTailCount, 1.0, PonyTailType) 
EndEvent


; when the RaceMenu slider is changed...
Event OnSliderChanged(string callback, float value)
	If(callback == "pony_tailtype")
		If(value <= PonyTailCount)
			PonyTailType = value
			TailType = value as Int
			SetTailType()
		EndIf
	EndIf
EndEvent


Function SetTailType()
	Armor CurrentTail = PlayerRef.GetEquippedArmorInSlot(40) ; Tail will always be slot 40. This is safe to use.
	Armor NewTail = PonyTailList.GetAt(TailType) as Armor
	PlayerRef.RemoveItem(CurrentTail, 1, true, None)

	PlayerRef.AddItem(NewTail, 1, true)
	PlayerRef.EquipItem(NewTail, true, true)
	PlayerRef.QueueNiNodeUpdate()
EndFunction
