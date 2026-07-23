Scriptname FollowerAISpellSelection extends ObjectReference

Actor Property Follower Auto

Spell Property LesserDragonhide Auto
Spell Property LesserEbonyflesh Auto
Spell Property LesserIronflesh Auto
Spell Property LesserStoneflesh Auto
Spell Property LesserOakflesh Auto

Spell Property CallToArms Auto
Spell Property Rally Auto
Spell Property Courage Auto

Spell Property Harmony Auto
Spell Property Pacify Auto
Spell Property Calm Auto

Spell Property Hysteria Auto
Spell Property Rout Auto
Spell Property Fear Auto

Spell Property Muffle Auto
Spell Property Invisibility Auto

Spell Property Mayhem Auto
Spell Property Frenzy Auto
Spell Property Fury Auto

Spell Property LesserPoison auto
Spell Property Poison Auto
Spell Property GreaterPoison Auto

Float followerMagicka = 0.0
Float spellCost = 0.0

Bool Function CanAffordSpell(Spell akSpell, Float afReserveMultiplier)
    Float effectiveCost = akSpell.GetEffectiveMagickaCost(Follower) as Float
    spellCost = effectiveCost

    Return followerMagicka >= (effectiveCost * afReserveMultiplier)
EndFunction

;---------------------------------------------------------------------------------------------------------------------
; The main function that handles spell selection. I split a lot of the work off as the original one is incredibly messy.
Int Function GetAvailableSpell(String spellCategory, Int selectedSpell)
	Int returnedSpellValue = 0
	If(spellCategory == "BuffAlteration")
		returnedSpellValue = GetAvailableAlterationBuff()
		
	ElseIf(spellCategory == "BuffIllusion")
		returnedSpellValue = GetAvailableIllusionBuff()
	
	ElseIf(spellCategory == "Calm")
		returnedSpellValue = GetAvailableCalmingSpell(selectedSpell)
		
	ElseIf(spellCategory == "Fear")
		returnedSpellValue = GetAvailableFearSpell(selectedSpell)
		
	ElseIf(spellCategory == "Heal")
			
			
	ElseIf(spellCategory == "Infuriate")
		returnedSpellValue == GetAvailableInfuriate(selectedSpell)
	
	ElseIf(spellCategory == "Poison")
		returnedSpellValue = GetAvailablePoison()
	
	ElseIf(spellCategory == "MiscAlteration")
	
	ElseIf(spellCategory == "MiscIllusion")
		returnedSpellValue = GetMiscIllusion(selectedSpell)
		
	ElseIf(spellCategory == "MiscRestoration")
	
	EndIf
	
	return returnedSpellValue
EndFunction



Int Function GetAvailableAlterationBuff()
    Float alterationAV = Follower.GetActorValue("Alteration")
	If(alterationAV >= 100.0)
		If(CanAffordSpell(LesserDragonhide, 1.0))
			return 15
		EndIf
			
		If(CanAffordSpell(LesserEbonyflesh, 2.0))
			return 14
		EndIf
			
		If(CanAffordSpell(LesserIronflesh, 2.0))
			return 13
		EndIf
			
		If(CanAffordSpell(LesserStoneflesh, 2.0))
			return 12
		EndIf
			
		If(CanAffordSpell(LesserOakflesh, 2.0))
			return 11
		EndIf
		
	ElseIf (alterationAV >= 75.0)
		If(CanAffordSpell(LesserEbonyflesh, 2.0))
			return 14
		EndIf
		
		If(CanAffordSpell(LesserIronflesh, 2.0))
			return 13
		EndIf
		
		If(CanAffordSpell(LesserStoneflesh, 2.0))
			return 12
		EndIf
		
		If(CanAffordSpell(LesserOakflesh, 2.0))
			return 11
		EndIf
		
	ElseIf(alterationAV >= 50.0)
		If(CanAffordSpell(LesserIronflesh, 2.0))
			return 13
		EndIf
		
		If(CanAffordSpell(LesserStoneflesh, 2.0))
			return 12
		EndIf
		
		If(CanAffordSpell(LesserOakflesh, 2.0))
			return 11
		EndIf
		
	ElseIf(alterationAV >= 25.0)
		If(CanAffordSpell(LesserStoneflesh, 2.0))
			return 12
		EndIf
		
		If(CanAffordSpell(LesserOakflesh, 2.0))
			return 11
		EndIf
		
	ElseIf(alterationAV >= 0.0)
		If(CanAffordSpell(LesserOakflesh, 2.0))
			return 11
		EndIf
	EndIf
	return 0
EndFunction



Int Function GetAvailableIllusionBuff()
	Float illusionAV = Follower.GetActorValue("Illusion")
	
	If(illusionAV >= 100.0)
		If(CanAffordSpell(CallToArms, 2.0))
			return 3
		EndIf
		
		If(CanAffordSpell(Rally, 2.0))
			return 2
		EndIf
		
		If(CanAffordSpell(Courage, 2.0))
			return 1
		EndIf
		
	ElseIf(illusionAV >= 50.0)
		If(CanAffordSpell(Rally, 2.0))
			return 2
		EndIf
		
		If(CanAffordSpell(Courage, 2.0))
			return 1
		EndIf
		
	ElseIf(illusionAV > 0.0)
		If(CanAffordSpell(Courage, 2.0))
			return 1
		EndIf
	EndIf
	return 0
EndFunction



Int GetAvailableCalmingSpell(Int selectedSpell)
	Float illusionAV = Follower.GetActorValue("Illusion")
	
	If(illusionAV >= 100.0)
		If(selectedSpell == 5)
			If(CanAffordSpell(Harmony, 1.0))
				return 5
			EndIf
			
		ElseIf(selectedSpell == 4)
			If(CanAffordSpell(Pacify, 2.8))
				return 4
			EndIf
			
		ElseIf(selectedSpell == 3)
			If(CanAffordSpell(Pacify, 1.0))
				return 3
			EndIf
			
		ElseIf(selectedSpell == 2)
			If(CanAffordSpell(Calm, 2.8))
				return 2
			EndIf
			
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Calm, 1.0))
				return 1
			EndIf
		EndIf
	
	ElseIf(illusionAV ?= 75.0)
		If(selectedSpell == 4)
			If(CanAffordSpell(Pacify, 2.8))
				return 4
			EndIf
			
		ElseIf(selectedSpell == 3)
			If(CanAffordSpell(Pacify, 1.0))
				return 3
			EndIf
			
		ElseIf(selectedSpell == 2)
			If(CanAffordSpell(Calm, 2.8))
				return 2
			EndIf
			
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Calm, 1.0))
				return 1
			EndIf
		EndIf

	ElseIf(illusionAV >= 25.0)
		If(selectedSpell == 3 || selectedSpell == 2)
			If(CanAffordSpell(Calm, 2.8))
				return 2
			EndIf
			
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Calm, 1.0))
				return 1
			EndIf
		EndIf
	EndIf
	return 0
EndFunction



Int Function GetAvailableFearSpell(Int selectedSpell)
	Float illusionAV = Follower.GetActorValue("Illusion")
	If(illusionAV >= 100.0)
		If(selectedSpell == 5)
			If(CanAffordSpell(Hysteria, 1.0))
				return 5
			EndIf
		ElseIf(selectedSpell == 4)
			If(CanAffordSpell(Rout, 2.8))
				return 4
			EndIf
		ElseIf(selectedSpell == 3)
			If(CanAffordSpell(Rout, 1.0))
				return 3
			EndIf
		ElseIf(selectedSpell == 2)
			If(CanAffordSpell(Fear, 2.8))
				return 2
			EndIf
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Fear, 1.0))
				return 1
			EndIf
		EndIf
	ElseIf (illusionAV >= 75.0)
		If(selectedSpell == 4)
			If(CanAffordSpell(Rout, 2.8))
				return 4
			EndIf
		ElseIf(selectedSpell == 3)
			If(CanAffordSpell(Rout, 1.0))
				return 3
			EndIf
		ElseIf(selectedSpell == 2)
			If(CanAffordSpell(Fear, 2.8))
				return 2
			EndIf
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Fear, 1.0))
				return 1
			EndIf
		EndIf
	ElseIf (illusionAV >= 25.0)
		If(selectedSpell == 3 || selectedSpell == 2)
			If(CanAffordSpell(Rout, 2.8))
				return 2
			EndIf
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Fear, 1.0))
				return 1
			EndIf
		EndIf
	EndIf
	return 0
EndFunction


Int Function GetAvailableInfuriate(Int selectedSpell)
	Float illusionAV = Follower.GetActorValue("Illusion")
	
	If(illusionAV >= 100.0)
		If(selectedSpell == 5)
			If(CanAffordSpell(Mayhem, 1.0))
				return 5
			EndIf
			
		ElseIf(selectedSpell == 4)
			If(CanAffordSpell(Frenzy, 2.8))
				return 4
			EndIf
			
		ElseIf(selectedSpell == 3)
			If(CanAffordSpell(Frenzy, 1.0))
				return 3
			EndIf
			
		ElseIf(selectedSpell == 2)
			If(CanAffordSpell(Fury, 2.8))
				return 2
			EndIf
			
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Fury, 1.0))
				return 1
			EndIf
		EndIf
		
	ElseIf(illusionAV >= 50.0)
		If(selectedSpell == 4)
			If(CanAffordSpell(Frenzy, 2.8))
				return 4
			EndIf
			
		ElseIf(selectedSpell == 3)
			If(CanAffordSpell(Frenzy, 1.0))
				return 3
			EndIf
			
		ElseIf(selectedSpell == 2)
			If(CanAffordSpell(Fury, 2.8))
				return 2
			EndIf
		
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Fury, 1.0))
				return 1
			ElseIf
		EndIf
		
	ElseIf(illusionAV > 0.0)
		If(selectedSpell == 3 || selectedSpell == 2)
			If(CanAffordSpell(Fury, 2.8))
				return 2
			EndIf
			
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Fury, 1.0))
				return 1
			EndIf
		EndIf
	EndIf
	return 0
EndFunction


Int Function GetAvailablePoison()
	Float restorationAV = Follower.GetActorValue("Restoration")
	
	If(restorationAV >= 75.0)
		If(CanAffordSpell(LesserPoison, 1.0))
			return 3
		EndIf
		
		If(CanAffordSpell(Poison, 1.0))
			return 2
		EndIf
		
		If(CanAffordSpell(GreaterPoison, 1.0))
			return 1
		EndIf
		
	ElseIf(restorationAV >= 50.0)
		If(CanAffordSpell(Poison, 1.0))
			return 2
		EndIf
		
		If(CanAffordSpell(GreaterPoison, 1.0))
			return 1
		EndIf
		
	ElseIf(restorationAV >= 25.0)
		If(CanAffordSpell(GreaterPoison, 1.0))
			return 1
		EndIf
	EndIf
	return 0
EndFunction

Int Function GetAvailableHealingSpell(Int selectedSpell)
	return 0
EndFunction




Int Function GetMiscIllusion(Int selectedSpell)
	Float illusionAV = Follower.GetActorValue("Illusion")
	
	If(illusionAV >= 75.0)
		If(selectedSpell == 2)
			If(CanAffordSpell(Invisibility, 2.8))
				return 2
			EndIf
		
		ElseIf(selectedSpell == 1)
			If(CanAffordSpell(Muffle, 2.8))
				return 1
			EndIf
		EndIf
	ElseIf(illusionAV >= 25.0)
		If(selectedSpell == 1)
			If(CanAffordSpell(Muffle, 2.8))
				return 1
			EndIf
		EndIf
	EndIf
	return 0
EndFunction