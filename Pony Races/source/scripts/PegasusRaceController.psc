Scriptname aaaHalfDragonRaceController extends Quest  

FormList Property HeadPartsHalfDragonRace  Auto  

FormList Property HeadPartsHalfDragonRaceVampire  Auto  

GenericRaceController Property raceController Auto

Event OnInit()
raceController.NewArgonian = none
raceController.NewArgonianVampire = none
raceController.NewBreton = none
raceController.NewBretonVampire = none
raceController.NewDarkElf = none
raceController.NewDarkElfVampire = none
raceController.NewHighElf = none
raceController.NewHighElfVampire = none
raceController.NewImperial = none
raceController.NewImperialVampire = none
raceController.NewKhajiit = none
raceController.NewKhajiitVampire = none
raceController.NewNord = HeadPartsHalfDragonRace
raceController.NewNordVampire = HeadPartsHalfDragonRaceVampire
raceController.NewOrc = none
raceController.NewOrcVampire = none
raceController.NewRedguard = none
raceController.NewRedguardVampire = none
raceController.NewWoodElf = none
raceController.NewWoodElfVampire = none
raceController.proxyRaces()
EndEvent