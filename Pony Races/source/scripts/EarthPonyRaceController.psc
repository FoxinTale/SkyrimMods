Scriptname EarthPonyRaceController extends Quest  

FormList Property PonyRaces  Auto  

FormList Property PonyRacesVampire  Auto  

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
	raceController.NewKhajiit = PonyRaces
	raceController.NewKhajiitVampire = PonyRacesVampire
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