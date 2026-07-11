Scriptname sb_ss_sortstorage extends ObjectReference
; this script is attached to the chest you want to use as the big ol dumper.
; This is adapted from the auto sort script for the Tardis mod.


Bool Property CrapOffLine = False Auto
Form ItmForm ; Used to store the Item Form in question for use in other local functions
int ItemCount ; Used to store the number of items of an Item Form for use in other local functions
Int ItemDone = 0 ; Used to flag if an item has been sorted.


;========================================================================================================================================
;---------- KEYWORDS ----------
;---------- Armour Keywords ----------
Keyword property ArmorHeavy Auto
Keyword Property ArmorLight Auto
Keyword Property ArmorJewelry Auto
Keyword Property ArmorShield Auto

;---------- Weapon Keywords ----------
Keyword Property WeapTypeBow Auto
Keyword Property WeapTypeWarhammer Auto
Keyword Property WeapTypeBattleaxe Auto
Keyword Property WeapTypeGreatsword Auto
Keyword Property WeapTypeWarAxe Auto
Keyword Property WeapTypeMace Auto
Keyword Property WeapTypeSword Auto
Keyword Property WeapTypeDagger Auto
Keyword Property WeapTypeStaff Auto

;---------- Everything Else ----------
Keyword Property VendorItemArrow Auto
Keyword Property VendorItemOreIngot Auto
Keyword Property VendorItemPotion Auto
Keyword Property VendorItemIngredient Auto
Keyword Property VendorItemFood Auto
Keyword Property VendorItemFoodRaw Auto
Keyword Property VendorItemRecipe Auto
Keyword Property VendorItemBook Auto
Keyword Property VendorItemSpellTome Auto
Keyword Property VendorItemSoulGem Auto
Keyword Property VendorItemGem Auto
Keyword Property VendorItemClothing Auto
Keyword Property VendorItemStaff Auto
Keyword Property VendorItemJewelry Auto
Keyword Property VendorItemScroll Auto
Keyword Property VendorItemPoison Auto
Keyword Property VendorItemClutter Auto
Keyword Property VendorItemKey Auto

;========================================================================================================================================
;---------- FORMLISTS ----------
; Patch file mods can be further used to expand these lists with other, large mods if needed. 
;---------- Smithing Stuff Lists ----------
Formlist Property SB_Smithing_OresList Auto
Formlist Property SB_Smithing_IngotsList Auto
Formlist Property SB_Smithing_GemsList Auto
Formlist Property SB_Smithing_PeltsList Auto
Formlist Property SB_Smithing_LinensLeathersList Auto
Formlist Property SB_Smithing_RemainsList Auto


;---------- Enchanting Stuff Lists ----------
Formlist Property SB_Ench_FilledSoulGemsList Auto
Formlist Property SB_Ench_EmptySoulGemsList Auto

;---------- Foodstuffs Lists ----------
Formlist Property SB_Food_RawMeatList Auto
Formlist Property SB_Food_FruitsVeggiesList Auto
Formlist Property SB_Food_CheeseList Auto
Formlist Property SB_Food_BoozeList Auto
Formlist Property SB_Food_CookedFoodsList Auto
Formlist Property SB_Food_BakedGoodsList Auto
Formlist Property SB_Food_DrinksList Auto
Formlist Property SB_Food_SoupStewsList Auto
Formlist Property SB_Food_SweetsList Auto
Formlist Property SB_Food_IngredientsList Auto

;---------- Misc Stuff Lists ----------
Formlist Property SB_Other_CutleryList Auto
Formlist Property SB_Other_DishesList Auto
Formlist Property SB_Other_BucketsList Auto
Formlist Property SB_Other_HousePartsList Auto
Formlist Property SB_Other_ToolsList Auto
Formlist Property SB_Other_WoodList Auto

;---------- Book Lists ----------
Formlist Property SB_NotesList Auto
Formlist Property SB_SpellTomesList Auto

;---------- Alchemy Lists ----------
Formlist Property SB_Alchemy_SaltsList Auto
Formlist Property SB_Alchemy_PoisonsList Auto
Formlist Property SB_Alchemy_PlantsList Auto
Formlist Property SB_Alchemy_AnimalList Auto

;---------- Mod Item Lists ----------
Formlist Property SB_FirstAidItemsList Auto
Formlist Property SB_CampingItemsList Auto
Formlist Property SB_SurvivalGearList Auto

;========================================================================================================================================
;---------- STORAGE BOXES ----------
;---------- Weapon Storage Boxes ----------
ObjectReference Property SB_StavesBox Auto
ObjectReference Property SB_OneHandedBox Auto
ObjectReference Property SB_TwoHandedBox Auto
ObjectReference Property SB_RangedBox Auto
ObjectReference Property SB_AmmoBox Auto
ObjectReference Property SB_EnchWeaponsBox Auto
ObjectReference Property SB_EnchArmourBox Auto

;---------- Armour Storage Boxes ----------
ObjectReference Property SB_HeavyArmourBox Auto
ObjectReference Property SB_LightArmourBox Auto
ObjectReference Property SB_ClothingBox Auto
ObjectReference Property SB_ShieldsBox Auto
ObjectReference Property SB_JewelryBox Auto

;---------- Smithing Storage Boxes ----------
ObjectReference Property SB_Smithing_Ores Auto
ObjectReference Property SB_Smithing_Ingots Auto
ObjectReference Property SB_Smithing_Gems Auto
ObjectReference Property SB_Smithing_Scrap Auto
ObjectReference Property SB_Smithing_Pelts Auto
ObjectReference Property SB_Smithing_LinenLeathers Auto
ObjectReference Property SB_Smithing_Remains Auto

;---------- Enchanting Storage Boxes ----------
ObjectReference Property SB_Ench_Scrolls Auto
ObjectReference Property SB_Ench_FilledSoulGems Auto
ObjectReference Property SB_Ench_EmptySoulGems Auto

;---------- Alchemy Storage Boxes ----------
ObjectReference Property SB_Alchemy_AnimalIngredients Auto
ObjectReference Property SB_Alchemy_PlantIngredients Auto
ObjectReference Property SB_Alchemy_Ingredients Auto
ObjectReference Property SB_Alchemy_Potions Auto
ObjectReference Property SB_Alchemy_Poisons Auto
ObjectReference Property SB_Alchemy_Recipes Auto

;---------- Foodstuffs Storage Boxes ----------
ObjectReference Property SB_Food_RawMeat Auto
ObjectReference Property SB_Food_FruitsVeggies Auto
ObjectReference Property SB_Food_Cheese Auto
ObjectReference Property SB_Food_CookedFoods Auto
ObjectReference Property SB_Food_Booze Auto
ObjectReference Property SB_Food_Drinks Auto
ObjectReference Property SB_Food_BakedGoods Auto
ObjectReference Property SB_Food_Sweets Auto
ObjectReference Property SB_Food_SoupStews Auto
ObjectReference Property SB_Food_OtherFoods Auto

;---------- Book Storage ----------
ObjectReference Property SB_SpellTomesCase Auto
ObjectReference Property SB_NormalBooksCase Auto
ObjectReference Property SB_NotesBox Auto

;---------- Misc Items Storage Boxes ----------
ObjectReference Property SB_Other_Cutlery Auto
ObjectReference Property SB_Other_Dishes Auto
ObjectReference Property SB_Other_Buckets Auto
ObjectReference Property SB_Other_HouseParts Auto
ObjectReference Property SB_Other_Tools Auto
ObjectReference Property SB_Other_Misc Auto
ObjectReference Property SB_Other_Wood Auto
ObjectReference Property SB_Other_Keys Auto

;---------- Modded Items Storage Boxes ----------
ObjectReference Property SB_Mods_FirstAidBox Auto
ObjectReference Property SB_Mods_CampingGearBox Auto
ObjectReference Property SB_Mods_SurvivalGearBox  Auto

;---------- General catch all box of sh*t ----------
ObjectReference Property SB_Unsorted Auto


Event OnPlayerLoadGame()


EndEvent

; Missing: Pelts, Leather/Linens, Bones

Function ProcessStuff()

	Int numForms = self.GetNumItems()

	If numForms == 0
		
		Self.SetDestroyed(False)
		CrapOffLine = False
		Debug.Notification ("Dump chest empty.")
		Return ; Nothing in the container to process
	EndIf

	;XXXXXXX BEGIN SEARCH PROCESSING XXXXXXX

	Self.SetDestroyed(True)
	CrapOffLine = True

	Debug.Notification ("Processing Items.")


	While numForms > 0

		numForms -= 1

		ItmForm = self.GetNthForm(numForms)
		ItemCount = Self.GetItemCount(ItmForm)
		

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemStaff))
			SortBox(SB_StavesBox)
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeStaff))
			SortBox(SB_StavesBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemJewelry))
			SortBox(SB_JewelryBox)
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorJewelry))
			SortBox(SB_JewelryBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemOreIngot))
			SortOres()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorShield))
			SortBoxWithEnchantment(SB_ShieldsBox, SB_EnchArmourBox)
		EndIf	

		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorHeavy))
			SortBoxWithEnchantment(SB_HeavyArmourBox, SB_EnchArmourBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorLight))
			SortBoxWithEnchantment(SB_LightArmourBox, SB_EnchArmourBox)
		EndIf	

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemArrow))
			SortBox(SB_AmmoBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeBow))
			SortBoxWithEnchantment(SB_RangedBox, SB_EnchWeaponsBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeWarhammer))
			SortBox(SB_TwoHandedBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeBattleaxe))
			SortBox(SB_TwoHandedBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeGreatsword))
			SortBox(SB_TwoHandedBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeWarAxe))
			SortBox(SB_OneHandedBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeMace))
			SortBox(SB_OneHandedBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeSword))
			SortBox(SB_OneHandedBox)
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeDagger))
			SortBox(SB_OneHandedBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemClothing))
			SortBox(SB_ClothingBox)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemIngredient))
			SortIngredients()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemSoulGem))
			SortSoulGems()
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemGem))
			SortBoxWithList(SB_Smithing_GemsList, SB_Smithing_Gems)
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemFoodRaw))
			SortBoxWithList(SB_Food_RawMeatList, SB_Food_RawMeat)
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemFood)) 
			SortFood()
		EndIf	

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemScroll))
			SortBox(SB_Ench_Scrolls)
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemSpellTome))
			SortBox(SB_SpellTomesCase)
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemRecipe))
			SortBox(SB_Alchemy_Recipes)
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemBook))
			SortBooks()
		EndIf	
	
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemClutter))
			SortClutter()
		EndIf	
		
		If ItemDone == 0 && ( ItmForm.HasKeyword(VendorItemPotion))
			SortPotions()
		EndIf

		If ItemDone == 0 && ( ItmForm.HasKeyword(VendorItemPoison))
			SortPotions()
		EndIf
	;XXXXXXXXXXXXXXX CABOOSE CHECK XXXXXXXXXXXXXXXXXXXXXXXXXX
		
		SortBoxWithList(SB_Smithing_RemainsList, SB_Smithing_Remains)
		SortBoxWithList(SB_Smithing_PeltsList, SB_Smithing_Pelts)
		SortBoxWithList(SB_Smithing_LinensLeathersList, SB_Smithing_LinenLeathers)
		
		SortBox(SB_UnsortedBox)
		ItemDone = 0
	EndWhile

	Self.SetDestroyed(False)
	CrapOffLine = False

	Debug.Notification ( "Finished processing items. Further manual sorting may be needed." )
EndFunction


Function SortOres()
	SortBoxWithList(SB_Smithing_OresList, SB_Smithing_Ores)
	SortBoxWithList(SB_Smithing_IngotsList, SB_Smithing_Ingots)
EndFunction


Function SortSoulGems()
	SortBoxWithList(SB_Ench_FilledSoulGemsList, SB_Ench_FilledSoulGems)
	SortBoxWithList(SB_Ench_EmptySoulGemsList, SB_Ench_EmptySoulGems)
EndFunction


Function SortFood()
	SortBoxWithList(SB_Food_FruitsVeggiesList, SB_Food_FruitsVeggies)
	SortBoxWithList(SB_Food_CheeseList, SB_Food_Cheese)
	SortBoxWithList(SB_Food_CookedFoodsList, SB_Food_CookedFoods)
	SortBoxWithList(SB_Food_BoozeList, SB_Food_Booze)
	SortBoxWithList(SB_Food_DrinksList, SB_Food_Drinks)
	SortBoxWithList(SB_Food_BakedGoodsList, SB_Food_BakedGoods)
	SortBoxWithList(SB_Food_SoupStewsList, SB_Food_SoupStews)
	SortBoxWithList(SB_Food_SweetsList, SB_Food_Sweets)
	SortBox(SB_Food_OtherFoods)
EndFunction


Function SortIngredients()
	SortBoxWithList(SB_Alchemy_AnimalList, SB_Alchemy_AnimalIngredients)
	SortBoxWithList(SB_Alchemy_PlantsList, SB_Alchemy_PlantIngredients)
	SortBox(SB_Alchemy_Ingredients)
EndFunction


Function SortBooks()
	If  SB_NotesList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_NotesBox)
		ItemDone = 1
		Return
	EndIf
	
	If  SB_SpellTomesList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_SpellTomesCase)
		ItemDone = 1
		Return
	EndIf	

	If ItmForm.HasKeyword(VendorItemBook)
		RemoveItem(ItmForm, ItemCount, True, SB_NormalBooksCase)
		ItemDone = 1
		Return
	EndIf	
EndFunction


Function SortClutter()
	SortBoxWithList(SB_Other_CutleryList, SB_Other_Cutlery)
	SortBoxWithList(SB_Other_DishesList, SB_Other_Dishes)
	SortBoxWithList(SB_Other_BucketsList, SB_Other_Buckets)
	SortBoxWithList(SB_Other_ToolsList, SB_Other_Tools)
	SortBoxWithList(SB_Other_WoodList, SB_Other_Wood)
	SortBoxWithList(SB_Other_HousePartsList, SB_Other_HouseParts)
	SortBox(SB_Other_Misc)
EndFunction


Function SortPotions()
	SortBoxWithList(SB_Alchemy_PoisonsList, SB_Alchemy_Poisons)
	SortBox(SB_Alchemy_Potions)
EndFunction




Function SortBox(ObjectReference akOtherContainer)
	RemoveItem(itmForm, ItemCount, True, akOtherContainer)
	ItemDone = 1
	Return
EndFunction


Function SortBoxWithEnchantment(ObjectReference akContainer, ObjectReference akOtherContainer)
	Enchantment e = None

    Weapon w = ItmForm as Weapon
    Armor a = ItmForm as Armor

    If w
        e = w.GetEnchantment()
    ElseIf a
        e = a.GetEnchantment()
    EndIf
	
    If (e == None)
        SortBox(akContainer)
    Else
        SortBox(akOtherContainer)
    EndIf
EndFunction


Function SortBoxWithList(FormList list, ObjectReference akOtherContainer)
	If list.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, akOtherContainer)
		ItemDone = 1
		Return
	EndIf
EndFunction
