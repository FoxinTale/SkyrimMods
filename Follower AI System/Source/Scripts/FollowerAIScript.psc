scriptname FollowerAIScript extends ReferenceAlias


ReferenceAlias Property FollowerTarget Auto 
Actor Property PlayerRef Auto
Actor Property Follower Auto

Keyword Property ActorTypeDwarven Auto
Keyword Property ActorTypeDaedra Auto
Keyword Property ActorTypeDragon Auto
Keyword Property NoSoulTrap Auto


Int Property fearValue Auto Conditional
Int Property buffValue Auto Conditional
Int Property calmValue Auto Conditional
Int Property poisonValue Auto Conditional
Int Property restorationValue Auto Conditional
Int Property miscRestorationValue Auto Conditional
Int Property miscIllusionValue Auto Conditional

Scene Property RestorationScene Auto
Scene Property FearScene Auto
Scene Property MiscIllusionScene Auto

FollowerAISpellSelection Property Selection Auto
;/
Buff Scene Values: 1, 2, 3, 11, 12, 13, 14, 15
	This one does have combat/no combat variants.
	1: Courage Dual Cast, 2: Rally Dual Cast, 3: Call To Arms Dual Cast, 11: Lesser Oakflesh Dual Cast, 12: Lesser Stoneflesh Dual Cast, 13: Lesser Ironflesh Dual Cast, 14: Lesser Ebonyflesh Dual Cast, 15: Lesser Dragonhide Dual Cast

Calm Scene values: 1-5
	1: Calm, 2: Calm Dual Cast, 3: Pacify, 4: Pacify Dual Cast, 5: Harmony Dual Cast

Fear Scene Values: 1-5
	1: Fear, 2: Fear Dual Cast, 3: Rout, 4: Rout Dual Cast, 5:  Hysteria Dual Cast

Heal Scene Values: 1-5
	1: Healing Hands, 2: Heal Others, 3: Heal Others Dual Cast, 4: Grand Healing, 5: Grand Healing Dual Cast
	
Infuriate Scene Values: 1-5
	1: Fury, 2: Fury Dual Cast, 3: Frenzy, 4: Frenzy Dual Cast, 5: Mayhem Dual Cast
	
The misc scenes are almost like... Why?
	Misc Alteration has magelight, transumation , waterbreathing and magelight no condition.
	Misc Conjuration has just soul trap. Nothing else.
	Misc Illusion has Muffle and Invisibility.
	Misc Restoration has Cure disease and resurrection.
	
Poison Scene Values: 1-3
	1: Lesser Poison, 2: Poison, 3: Greater Poison
	
Each number is linked to a package. A phase --> Action, which in the action is a specific package to each action.

 Each package has the following information: 
	Package type - package. Interrupt Override - Combat, Package Template - UseMagic
	No: Flags, Conditions, Schedule, Begin/End/Change, Idles
	Name (Type): Description
	Location (Location): Reference Alias "Target Ref", Radius 500.
	Spell (TargetSelector): The individual spell that is why each one has their own package.
	Target (SingleRef): Reference Alias "Target Ref".
	HoldWhenBlocked (Bool): Name explains itself.
	CastTimeMin (Float): x.xx
	CastTimeMax (Float): x.xx
	CooldownTimeMin (Float): x.xx
	CooldownTimeMax (Float): x.xx
	NumToCastMin (Int): 1
	NumToCastMax (Int): 1
	DualCast (Bool): True/False
	
/;
;---------------------------------------------------------------------------------------------------------------------
; Internal Variables.

Bool isInCombat = false
Bool isCommanded = false
Float followerMagicka = 0.00
Float spellCost = 0.0
Float maxTeleportDistance = 2000.0
Float maxTargetDistance = 800.0
Float normalUpdateInterval = 10.0
Float combatUpdateInterval = 0.5

; Internal arrays.
Int[] SpellThresholds





;---------------------------------------------------------------------------------------------------------------------
; Initialising the main values.
Function InitialiseValues()
	SpellThresholds = new Int[4]
	
	SpellThresholds[0] = 30
	SpellThresholds[1] = 40
	SpellThresholds[2] = 66
	SpellThresholds[3] = 88
	SpellThresholds[4] = 150
	
    normalUpdateInterval = 10.0000
    combatUpdateInterval = 0.500000
    RegisterForSingleLOSGain(Follower, PlayerRef)
EndFunction


;---------------------------------------------------------------------------------------------------------------------
; Things I'm pretty sure are supposed to be events.

Function OnGainLOS(Actor akViewer, objectreference akTarget)
    RegisterForSingleUpdate(normalUpdateInterval)
EndFunction


Function OnCombatStateChanged(Actor akTarget, Int aeCombatState)
    If(Follower.GetFactionRank(CurrentFollowerFaction) > -1)
        If (Follower.IsInCombat() && !isInCombat)
            isInCombat = true
            UnregisterForUpdate()
            If(PlayerRef.IsWeaponDrawn() == true)
                Utility.Wait(3.0)
                If(buffValue != -1)
                    BuffAllies(false)
                EndIf
            ElseIf(calmValue != -1)
                If(Follower.HasLOS(akTarget) && Follower.GetDistance(akTarget) < maxTargetDistance)
                    CalmTargets(akTarget)
                EndIf
            EndIf
            
		RegisterForSingleUpdate(combatUpdateInterval)
        ElseIf(!Follower.IsInCombat() && isInCombat)
            isInCombat = false
            UnregisterForUpdate()
            If (restorationValue != 1)
                DispelHarmfulEffects()
            EndIf
            RegisterForSingleUpdate(combatUpdateInterval)
        EndIf
    EndIf
EndFunction


Function RegisterForUpdate(Bool enableUpdate)
    If(enableUpdate)
        RegisterForSingleLOSGain(Follower, PlayerRef)
    Else
        UnregisterForUpdate()
    EndIf
endFunction

;---------------------------------------------------------------------------------------------------------------------
; Helper functions.

Bool Function IsValidSpellTarget(Actor akTarget)
	If(akTarget == none)
		return false
	EndIf
	
	If(akTarget.IsDead())
		return false
	EndIf
	
	If(akTarget.HasKeyword(ActorTypeDragon))
		return false
	EndIf
	
	If(akTarget.GetActorValue("Aggression") != 3.0)
		return false
	EndIf
	
	If(akTarget.GetActorValue("Confidence") != 0.0)
		return false
	EndIf
	
	return true
EndFunction


Float Function GetHealthPercentage(Actor akTarget, Float percent)
	ActorValueInfo healthInfo = ActorValueInfo.GetActorValueInfoByName("Health") ; We do it this way to account for buffs, and scaling across any level. As opposed to GetActorValue().
	float currentHealth = healthInfo.GetCurrentValue(akTarget)
	float maxHealth = healthInfo.GetMaximumValue(akTarget)
	float healthDiff = maxHealth - currentHealth
	float healthPercentage = maxHealth * percent
	
	return healthPercentage
EndFunction 


Function TradeStaminaForMagicka()
	Float currentStamina = Follower.GetActorValue("Stamina")
	
	If(Follower.GetActorValue("Magicka") < currentStamina)
		Follower.RestoreActorValue("Magicka", currentStamina)
		Follower.DamageActorValue("Stamina", currentStamina)		
	EndIf
EndFunction


Function UnequipBothSpells()
	Spell leftHandSpell = Follower.GetEquippedSpell(0)
	Spell rightHandSpell = Follower.GetEquippedSpell(1)
	
	If(leftHandSpell)
		Follower.UnequipSpell(leftHandSpell, 0)
	EndIf
	
	If(rightHandSpell)
		Follower.UnequipSpell(rightHandSpell, 1)
	EndIf
EndFunction

;---------------------------------------------------------------------------------------------------------------------
; Main magic thingy functions.

Function SoulTrapTarget(Actor akTarget)
	If(!akTarget.HasKeyword(NoSoulTrap) && !akTarget.IsEssential() && !akTarget.IsCommandedActor())
	
	EndIf
EndFunction



Function Invisibility()
    miscIllusionValue = Selection.GetAvailableSpell("MiscIllusion", 2)
	
    If (miscIllusionValue > 0)
        FollowerTarget.ForceRefTo(PlayerRef)
        MiscIllusionScene.Start()
		
		While(MiscIllusionScene.IsPlaying())
            Utility.Wait(0.5)
       EndWhile
    EndIf
EndFunction


Function Muffle()
	miscIllusionValue = Selection.GetAvailableSpell("MiscIllusion", 1)
	
	If(miscIllusionValue > 0)
        MiscIllusionScene.Start()
		While(MiscIllusionScene.IsPlaying())
            Utility.Wait(0.5)
       EndWhile
    endIf
EndFunction


Function FearTargets(Actor akTarget)
	If(IsValidSpellTarget(akTarget))
		Int targetLevel = akTarget.GetLevel()
		
        If (targetLevel <= SpellThresholds[0])
			fearValue = Selection.GetAvailableSpell("Fear", 1)
			
        ElseIf(targetLevel <= SpellThresholds[1])
			fearValue = Selection.GetAvailableSpell("Fear", 3)
			
        ElseIf(targetLevel <= SpellThresholds[2])
            fearValue = Selection.GetAvailableSpell("Fear", 2)
				
        ElseIf (currentTargetLevel <= SpellThresholds[3])
            fearValue = Selection.GetAvailableSpell("Fear", 4)
				
        ElseIf (targetLevel <= SpellThresholds[4])
            fearValue = Selection.GetAvailableSpell("Fear", 5)
				
        Else
            fearValue = 0
        EndIf
	EndIf
	
	If(fearValue > 0)
		FollowerTarget.ForceRefTo(akTarget)
        FearScene.Start()
		
		While (FearScene.IsPlaying())
			If(!akTarget.IsDead())
				Utility.Wait(0.5)
			Else
				FearScene.Stop()
			EndIf
		EndWhile
				 

		UnequipBothSpells()
    EndIf        
EndFunction



Function PoisonTarget(Actor akTarget)
    poisonValue = Selection.GetAvailableSpell("Poison", 0)
    If (poisonValue > 0)
        FollowerTarget.ForceRefTo(akTarget)
        PoisonScene.Start()
		
        While (PoisonScene.IsPlaying())
            If (!akTarget.IsDead())
                Utility.Wait(0.500000)
            Else
                PoisonScene.Stop()
            EndIf
        EndWhile
    EndIf
EndFunction



Function DispelHarmfulEffects()
    miscRestorationValue = Selection.GetAvailableSpell("MiscRestoration", 1)
    If(miscRestorationValue > 0)
        FollowerTarget.ForceRefTo(PlayerRef)
        RestorationScene.Start()
        While(RestorationScene.IsPlaying())
            utility.Wait(0.500000)
        EndWhile
    EndIf
EndFunction



Function BuffAllies(Bool isCommand)
    buffValue = Selection.GetAvailableSpell("BuffAlteration", 0)
    if (buffValue > 0)
        isCommanded = isCommand
        FollowerTarget.ForceRefTo(PlayerRef)
        BuffScene.Start()
  
		While(BuffScene.IsPlaying())
			Utility.Wait(0.5)
		EndWhile
    EndIf
    
	buffValue = Selection.GetAvailableSpell("BuffIllusion", 0)
    If (buffValue > 0)
        isCommanded = isCommand
        FollowerTarget.ForceRefTo(PlayerRef)
        BuffScene.Start()
  
		While(BuffScene.IsPlaying())
			Utility.Wait(0.5)
		EndWhile
    EndIf
	
	UnequipBothSpells()
EndFunction