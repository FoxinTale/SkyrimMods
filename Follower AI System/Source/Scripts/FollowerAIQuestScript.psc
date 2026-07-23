scriptName FollowerAIQuestScript extends Quest conditional

;-- Properties --------------------------------------
spell property _spellConjureBear auto
Bool property _isEnableSpellsSummon auto
globalvariable property _varIsEnableSpellsMiscIllusion auto
Int property _spellPoison auto conditional
Bool property _isCommand auto conditional
globalvariable property _varIsEnableSpellsMiscRestoration auto
tpcelestineactivitiesscript property _tpCelestineActivitiesRef auto
Int property _spellMiscRestoration auto conditional
globalvariable property _varIsEnableSpellsMiscAlteration auto
formlist property _flSpellsSummon auto
globalvariable property _varIsEnableSpellsHeal auto
globalvariable property _varIsEnableSpellsInfuriate auto
globalvariable property _varIsEnableAutoTeleport auto
globalvariable property _varIsEnableSpellsBuff auto
globalvariable property _varIsEnableSpellsMiscConjuration auto
Int property FearSpellValue auto conditional
Int property _spellHeal auto conditional
Bool property _isEnableAutoTeleport auto
globalvariable property _varIsEnableSpellsPoison auto
spell property _spellConjureSabreCat auto
globalvariable property _varIsEnableSpellsFear auto
spell property _spellConjureWolf auto
Int property _spellCalm auto conditional
Int property _spellMiscIllusion auto conditional
globalvariable property _varIsEnableSpellsSummon auto
globalvariable property _varIsEnableSpellsCalm auto
Int property _spellMiscAlteration auto conditional
formlist property _flSpellsArmor auto
Int property _spellBuff auto conditional
tpcelestineaiscript property _tpCelestineAIRef auto
Int property _spellMiscConjuration auto conditional
Int property _spellInfuriate auto conditional
Int property _keycodeCommandMenu auto

;-- Variables ---------------------------------------
Actor _celestineRef

;-- Functions ---------------------------------------

function RegisterCommandMenuKey(Int keyCode)

    self.RegisterForKey(keyCode)
endFunction

function RemoveSpellsDynamic(String spellType)

    if spellType == "Alteration"
        _celestineRef.RemoveSpell(_flSpellsArmor.GetAt(3) as spell)
        _celestineRef.RemoveSpell(_flSpellsArmor.GetAt(2) as spell)
        _celestineRef.RemoveSpell(_flSpellsArmor.GetAt(1) as spell)
        _celestineRef.RemoveSpell(_flSpellsArmor.GetAt(0) as spell)
    elseIf spellType == "Conjuration"
        _celestineRef.RemoveSpell(_flSpellsSummon.GetAt(2) as spell)
        _celestineRef.RemoveSpell(_flSpellsSummon.GetAt(1) as spell)
        _celestineRef.RemoveSpell(_flSpellsSummon.GetAt(0) as spell)
    endIf
endFunction

; Skipped compiler generated GetState

function OnKeyDown(Int keyCode)

    if keyCode == _keycodeCommandMenu
        _tpCelestineAIRef.ShowCommandMenu()
    endIf
endFunction

function InitializeAllScripts()

    self.Initialize()
    _tpCelestineAIRef.Initialize()
    _tpCelestineActivitiesRef.Initialize()
endFunction

function OnUpdateGameTime()

    self.AddRemoveSpellsDynamic()
    self.RegisterForSingleUpdateGameTime(24.0000)
endFunction

function AddSpellsDynamic(String spellType)

    if spellType == "Alteration"
        Float avAlteration = _celestineRef.GetActorValue("Alteration")
        if avAlteration >= 75 as Float
            _celestineRef.AddSpell(_flSpellsArmor.GetAt(3) as spell, true)
        elseIf avAlteration >= 50 as Float
            _celestineRef.AddSpell(_flSpellsArmor.GetAt(2) as spell, true)
        elseIf avAlteration >= 25 as Float
            _celestineRef.AddSpell(_flSpellsArmor.GetAt(1) as spell, true)
        elseIf avAlteration > 0 as Float
            _celestineRef.AddSpell(_flSpellsArmor.GetAt(0) as spell, true)
        endIf
    elseIf spellType == "Conjuration"
        Float avConjuration = _celestineRef.GetActorValue("Conjuration")
        if avConjuration >= 75 as Float
            _celestineRef.AddSpell(_flSpellsSummon.GetAt(2) as spell, true)
        elseIf avConjuration >= 50 as Float
            _celestineRef.AddSpell(_flSpellsSummon.GetAt(1) as spell, true)
        elseIf avConjuration > 25 as Float
            _celestineRef.AddSpell(_flSpellsSummon.GetAt(0) as spell, true)
        endIf
    endIf
endFunction

function AddRemoveSpellsDynamic()

    self.RemoveSpellsDynamic("Alteration")
    self.RemoveSpellsDynamic("Conjuration")
    self.AddSpellsDynamic("Alteration")
    if _isEnableSpellsSummon == true
        self.AddSpellsDynamic("Conjuration")
    endIf
endFunction

function Initialize()

    _celestineRef = _tpCelestineAIRef.GetActorReference()
    self.LoadDefaultValues()
    self.AddRemoveSpellsDynamic()
    self.RegisterForSingleUpdateGameTime(24.0000)
endFunction

; Skipped compiler generated GotoState

function LoadDefaultValues()

    _isEnableAutoTeleport = _varIsEnableAutoTeleport.GetValue() as Bool
    _isEnableSpellsSummon = _varIsEnableSpellsSummon.GetValue() as Bool
    _keycodeCommandMenu = -1
    if _varIsEnableSpellsBuff.GetValue() == 1 as Float
        _spellBuff = 0
    else
        _spellBuff = -1
    endIf
    if _varIsEnableSpellsCalm.GetValue() == 1 as Float
        _spellCalm = 0
    else
        _spellCalm = -1
    endIf
    if _varIsEnableSpellsFear.GetValue() == 1 as Float
        FearSpellValue = 0
    else
        FearSpellValue = -1
    endIf
    if _varIsEnableSpellsHeal.GetValue() == 1 as Float
        _spellHeal = 0
    else
        _spellHeal = -1
    endIf
    if _varIsEnableSpellsInfuriate.GetValue() == 1 as Float
        _spellInfuriate = 0
    else
        _spellInfuriate = -1
    endIf
    if _varIsEnableSpellsPoison.GetValue() == 1 as Float
        _spellPoison = 0
    else
        _spellPoison = -1
    endIf
    if _varIsEnableSpellsMiscAlteration.GetValue() == 1 as Float
        _spellMiscAlteration = 0
    else
        _spellMiscAlteration = -1
    endIf
    if _varIsEnableSpellsMiscConjuration.GetValue() == 1 as Float
        _spellMiscConjuration = 0
    else
        _spellMiscConjuration = -1
    endIf
    if _varIsEnableSpellsMiscIllusion.GetValue() == 1 as Float
        _spellMiscIllusion = 0
    else
        _spellMiscIllusion = -1
    endIf
    if _varIsEnableSpellsMiscRestoration.GetValue() == 1 as Float
        _spellMiscRestoration = 0
    else
        _spellMiscRestoration = -1
    endIf
endFunction
