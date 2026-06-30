scriptname sb_ss_bruma

;---------- Smithing Stuff Lists ----------
Formlist Property SB_OresList Auto
Formlist Property SB_IngotsList Auto
Formlist Property SB_GemsList Auto
Formlist Property SB_PeltsList Auto
Formlist Property SB_LinensLeathersList Auto

;---------- Foodstuffs Lists ----------
Formlist Property SB_RawMeatList Auto
Formlist Property SB_FruitsVeggiesList Auto
Formlist Property SB_CheeseList Auto
Formlist Property SB_BoozeList Auto
Formlist Property SB_CookedFoodsList Auto
Formlist Property SB_BakedGoodsList Auto
Formlist Property SB_DrinksList Auto
Formlist Property SB_SweetsList Auto
Formlist Property SB_FoodIngredientsList Auto

;---------- Misc Stuff Lists ----------
Formlist Property SB_CutleryList Auto
Formlist Property SB_DishesList Auto
Formlist Property SB_BucketsList Auto
Formlist Property SB_ToolsList Auto


Function AddBrumaItems()
	AddBrumaPelts()
	AddBrumaIngots()
	
	AddBrumaBooze()
	AddBrumaCookedFood()
	AddBrumaFruitsVeggies()
;	AddBrumaRawMeat()
	AddBrumaDrinks()
	AddBrumaBakedGoods()
	
	AddBrumaAnimalIngredients()
	AddBrumaPlantIngredients()
	
	AddBrumaCutlery()
	AddBrumaDishes()
	
	Debug.Trace("Finsihed filling lists for Bruma.")
EndFunction

; ========================================================================================================================================
; ---------- Smithing section ----------

Function AddBrumaPelts()
	SB_PeltsList.AddForm(Game.GetFormFromFile(0x6018AD, "BSAssets.esm")) ; Timber Wolf Pelt
	SB_PeltsList.AddForm(Game.GetFormFromFile(0x601B09, "BSAssets.esm")) ; Rhino Hide
	Debug.trace("Added Bruma Pelts.")
EndFunction


Function AddBrumaIngots()
	Debug.trace("Added Bruma Ingots.")
EndFunction


Function AddBrumaOres()
	Debug.trace("Added Bruma Ores.")
EndFunction

; ========================================================================================================================================
; ---------- Foods section ----------
; These are unknown IDs. As in, I'm not sure what category they go in.

; From BSAssets.esm
; 0x6028E9 - Varla Stone
; 0x6028EA - Welkynd Stone
; 0x602943 - Cabbage Roll
; 0x602945 - Eyebread
; 0x602B1B - Sack of Flour
; 0x602B1C - Butter


Function AddBrumaBooze()
	SB_BoozeList.AddForm(Game.GetFormFromFile(0x602B19, "BSAssets.esm")) ; Argonian Bloodwine
	SB_BoozeList.AddForm(Game.GetFormFromFile(0x602B1A, "BSAssets.esm")) ; Surilie Brothers Wine
	
	Debug.trace("Added Bruma Booze.")
EndFunction

Function AddBrumaCookedFood()
	SB_CookedFoodsList.AddForm(Game.GetFormFromFile(0x60202D, "BSAssets.esm")) ; Steamed Rice
	SB_CookedFoodsList.AddForm(Game.GetFormFromFile(0x6020AF, "BSAssets.esm")) ; Cooked Boar Meat
	SB_CookedFoodsList.AddForm(Game.GetFormFromFile(0x60280E, "BSAssets.esm")) ; Boiled Egg
	SB_CookedFoodsList.AddForm(Game.GetFormFromFile(0x6028B8, "BSAssets.esm")) ; Mutton Roast
	SB_CookedFoodsList.AddForm(Game.GetFormFromFile(0x6028C6, "BSAssets.esm")) ; Roast Lamb
	
	Debug.trace("Added Bruma Cooked Food.")
EndFunction


Function AddBrumaFruitsVeggies()
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x601421, "BSAssets.esm")) ; Red Cabbage
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x601911, "BSAssets.esm")) ; Watermelon
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x601FB8, "BSAssets.esm")) ; Parsnip
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x601FC8, "BSAssets.esm")) ; Pumpkin
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x601FCA, "BSAssets.esm")) ; Grapes
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602078, "BSAssets.esm")) ; Pear
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602079, "BSAssets.esm")) ; Peach
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x6020AC, "BSAssets.esm")) ; Lettuce
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602564, "BSAssets.esm")) ; Scrib Cabbage
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x60280B, "BSAssets.esm")) ; Orange
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602812, "BSAssets.esm")) ; Radish
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602839, "BSAssets.esm")) ; Strawberry
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x60283A, "BSAssets.esm")) ; Banana
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x60283C, "BSAssets.esm")) ; Corn
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602991, "BSAssets.esm")) ; Cherry
	SB_FruitsVeggiesList.AddForm(Game.GetFormFromFile(0x602B07, "BSAssets.esm")) ; Beet
	
	Debug.trace("Added Bruma Fruits and Veggies.")
EndFunction


Function AddBrumaRawMeat()
	SB_RawMeatList.AddForm(Game.GetFormFromFile(0x6020AE, "BSAssets.esm")) ; Boar Meat
	SB_RawMeatList.AddForm(Game.GetFormFromFile(0x6028B7, "BSAssets.esm")) ; Mutton Leg
	SB_RawMeatList.AddForm(Game.GetFormFromFile(0x6028D8, "BSAssets.esm")) ; Lamb Leg
	SB_RawMeatList.AddForm(Game.GetFormFromFile(0x6020AD, "BSAssets.esm")) ; Mudcrab Legs
	
	Debug.trace("Added Bruma Raw Meat.")
EndFunction


Function AddBrumaDrinks()
	SB_DrinksList.AddForm(Game.GetFormFromFile(0x60280A, "BSAssets.esm")) ; Jug of Cream 01
	SB_DrinksList.AddForm(Game.GetFormFromFile(0x602810, "BSAssets.esm")) ; Jug of Cream 02
	SB_DrinksList.AddForm(Game.GetFormFromFile(0x60298B, "BSAssets.esm")) ; Coffee
	SB_DrinksList.AddForm(Game.GetFormFromFile(0x60298C, "BSAssets.esm")) ; Coffee Tankard
	SB_DrinksList.AddForm(Game.GetFormFromFile(0x60298D, "BSAssets.esm")) ; Green Coffee
	SB_DrinksList.AddForm(Game.GetFormFromFile(0x602B18, "BSAssets.esm")) ; Jug of Milk
	
	Debug.trace("Added Bruma Drinks.")
EndFunction


Function AddBrumaBakedGoods()
	SB_BakedGoodsList.AddForm(Game.GetFormFromFile(0x60280F, "BSAssets.esm")) ; Flapjack
	
	Debug.trace("Added Bruma Baked Goods.")
EndFunction


; ========================================================================================================================================
; ---------- Alchemy section ----------

Function AddBrumaPlantIngredients()

EndFunction


Function AddBrumaAnimalIngredients()

EndFunction


; ========================================================================================================================================
; ---------- Other Stuff section ----------

Function AddBrumaCutlery()
	Debug.trace("Added Bruma Cutlery.")
EndFunction


Function AddBrumaDishes()
	Debug.trace("Added Bruma Dishes.")
EndFunction


Function AddBrumaHouseParts()
	Debug.trace("Added Bruma House Parts.")
EndFunction