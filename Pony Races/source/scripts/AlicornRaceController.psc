Scriptname AlicornRaceController extends Quest  

FormList Property HeadPartsAlicornRace  Auto  
FormList Property HeadPartsAlicornRaceVampire  Auto  
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
	raceController.NewKhajiit = HeadPartsAlicornRace
	raceController.NewKhajiitVampire = HeadPartsAlicornRaceVampire
	raceController.NewNord = none
	raceController.NewNordVampire = none
	raceController.NewOrc = none
	raceController.NewOrcVampire = none
	raceController.NewRedguard = none
	raceController.NewRedguardVampire = none
	raceController.NewWoodElf = none
	raceController.NewWoodElfVampire = none
	raceController.proxyRaces()
EndEvent