scriptname sb_ss_modchecks


Function CheckMods()
	If(Game.GetModByName("BSHeartland.esm") != 255)
		; Start Bruma Checks.
	EndIf
	
	If(Game.GetModByName("Campfire.esm") != 255)
		; Camping Mod Check
	EndIf
	
	If(Game.GetModByName("yumcheese.esp") != 255)
		; Start Cheese Collecting Checks.
	EndIf
	
	If(Game.GetModByName("Apocalypse - Magic of Skyrim.esp") != 255)
		; Apocalypse Magic Items.
	EndIf
	
	If(Game.GetModByName("Wet and Cold.esp") != 255)
		; Wet and Cold Items.
	EndIf
	
	If(Game.GetModByName("Immersive Jewelry.esp") != 255)
		; Immersive Jewelry added items.
	EndIf
	
	; Chocolate
	; Faalksar
	; Forgotten City
	; iNeed
	; Keep It Clean
	; Lanterns
	; Hunterborn
	; Additional Herarthfire Dolls
	; Of course, LOTD
EndFunction