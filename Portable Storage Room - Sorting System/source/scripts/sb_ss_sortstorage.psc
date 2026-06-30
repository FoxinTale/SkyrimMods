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
Keyword Property VendorItemDaedricArtifact Auto
Keyword Property VendorItemStaff Auto
Keyword Property VendorItemJewelry Auto
Keyword Property VendorItemFirewood Auto
Keyword Property VendorItemScroll Auto
Keyword Property VendorItemPoison Auto
Keyword Property VendorItemClutter Auto


;========================================================================================================================================
;---------- FORMLISTS ----------
; Patch file mods can be further used to expand these lists with other, large mods if needed. 
;---------- Smithing Stuff Lists ----------
Formlist Property SB_OresList Auto
Formlist Property SB_IngotsList Auto
Formlist Property SB_GemsList Auto
Formlist Property SB_PeltsList Auto
Formlist Property SB_LinensLeathersList Auto


;---------- Enchanting Stuff Lists ----------
Formlist Property SB_FilledSoulGemsList Auto
Formlist Property SB_EmptySoulGemsList Auto

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
Formlist Property SB_HousePartsList Auto
Formlist Property SB_ToolsList Auto

;---------- Book Lists ----------
Formlist Property SB_NotesList Auto
Formlist Property SB_SpellTomesList Auto

;---------- Alchemy Lists ----------
Formlist Property SB_SaltsList Auto
Formlist Property SB_PoisonsList Auto
Formlist Property SB_AlchPlantsList Auto
Formlist Property SB_AlchAnimalList Auto

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

;---------- Armour Storage Boxes ----------
ObjectReference Property SB_HeavyArmourBox Auto
ObjectReference Property SB_LightArmourBox Auto
ObjectReference Property SB_ClothingBox Auto
ObjectReference Property SB_ShieldsBox Auto
ObjectReference Property SB_JewelryBox Auto

;---------- Smithing Storage Boxes ----------
ObjectReference Property SB_OresBox Auto
ObjectReference Property SB_IngotsBox Auto
ObjectReference Property SB_GemsBox Auto
ObjectReference Property SB_ScrapBox Auto
ObjectReference Property SB_PeltsBox Auto
ObjectReference Property SB_LinenLeathersBox Auto

;---------- Enchanting Storage Boxes ----------
ObjectReference Property SB_ScrollsBox Auto
ObjectReference Property SB_FilledSoulGemsBox Auto
ObjectReference Property SB_EmptySoulGemsBox Auto

;---------- Alchemy Storage Boxes ----------
ObjectReference Property SB_AlchemyIngredientsBox Auto
ObjectReference Property SB_PotionsBox Auto
ObjectReference Property SB_PoisonsBox Auto
ObjectReference Property SB_RecipeBox Auto

;---------- Foodstuffs Storage Boxes ----------
ObjectReference Property SB_RawMeatBox Auto
ObjectReference Property SB_FruitsVeggiesBox Auto
ObjectReference Property SB_CheeseBox Auto
ObjectReference Property SB_CookedFoodsBox Auto
ObjectReference Property SB_BoozeBox Auto
ObjectReference Property SB_DrinksBox Auto
ObjectReference Property SB_BakedGoodsBox Auto
ObjectReference Property SB_SweetsBox Auto
ObjectReference Property SB_OtherFoodsBox Auto

;---------- Book Storage ----------
ObjectReference Property SB_SpellTomesCase Auto
ObjectReference Property SB_NormalBooksCase Auto
ObjectReference Property SB_NotesBox Auto

;---------- Misc Items Storage Boxes ----------
ObjectReference Property SB_CutleryBox Auto
ObjectReference Property SB_DishesBox Auto
ObjectReference Property SB_BucketsBox Auto
ObjectReference Property SB_HousePartsBox Auto
ObjectReference Property SB_ToolsBox Auto
ObjectReference Property SB_MiscBox Auto
ObjectReference Property SB_WoodBox Auto

;---------- Modded Items Storage Boxes ----------
ObjectReference Property SB_FirstAidBox Auto
ObjectReference Property SB_CampingGearBox Auto
ObjectReference Property SB_SurvivalGearBox  Auto

;---------- General catch all box of sh*t ----------
ObjectReference Property SB_UnsortedBox Auto


Event OnPlayerLoadGame()


EndEvent



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
;			SortStaves()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeStaff))
			SortBox(SB_StavesBox)
;			SortStaves()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemJewelry))
			SortBox(SB_JewelryBox)
;			SortJewelry()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorJewelry))
			SortBox(SB_JewelryBox)
;			SortJewelry()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemOreIngot))
			SortOres()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorShield))
			SortBox(SB_ShieldsBox)
;			SortShields()
		EndIf	

		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorHeavy))
			SortBox(SB_HeavyArmourBox)
;			LgtHvyArmorSort()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(ArmorLight))
			SortBox(SB_LightArmourBox)
;			LgtHvyArmorSort()
		EndIf	

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemArrow))
			SortBox(SB_AmmoBox)
;			SortAmmo()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeBow))
			SortBox(SB_RangedBox)
;			SortRanged()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeWarhammer))
			SortBox(SB_TwoHandedBox)
;			SortWarhammers()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeBattleaxe))
			SortBox(SB_TwoHandedBox)
;			SortBattleaxes()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeGreatsword))
			SortBox(SB_TwoHandedBox)
;			SortGreatswords()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeWarAxe))
			SortBox(SB_OneHandedBox)
;			SortWaraxes()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeMace))
			SortBox(SB_OneHandedBox)
;			SortMaces()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeSword))
			SortBox(SB_OneHandedBox)
;			SortSwords()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(WeapTypeDagger))
			SortBox(SB_OneHandedBox)
;			SortDaggers()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemClothing))
			SortBox(SB_ClothingBox)
;			SortClothing()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemIngredient))
			SortBox(SB_AlchemyIngredientsBox)
;			IngredientSort()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemSoulGem))
			SortSoulGems()
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemGem))
			SortGems()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemFoodRaw))
			SortRawFood()
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemFood)) 
			SortFood()
		EndIf	

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemScroll))
			SortScrolls()
		EndIf

		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemSpellTome))
			SortSpellbooks()
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemRecipe))
			SortBox(SB_RecipeBox)
;			RecipeSort()
		EndIf
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemBook))
			SortBooks()
		EndIf	
		
		If ItemDone == 0 && (ItmForm.HasKeyword(VendorItemFirewood))
			SortFirewood()
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


		
		ItemDone = 0
	EndWhile

	Self.SetDestroyed(False)
	CrapOffLine = False

	Debug.Notification ( "Finished processing items. Further manual sorting may be needed." )

EndFunction



Function SortStaves()
	RemoveItem (ItmForm, ItemCount, True, SB_StavesBox)
	ItemDone = 1
	Return
EndFunction


Function SortScrolls()
	RemoveItem(ItmForm, ItemCount, True, SB_ScrollsBox)
	ItemDone = 1
	Return		
EndFunction


Function SortJewelry()
	RemoveItem(ItmForm, ItemCount, True, SB_JewelryBox)
	ItemDone = 1
	Return
EndFunction


Function SortOres()
	If SB_OresList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_OresBox)
		ItemDone = 1
		Return
	EndIf
	
	If SB_IngotsList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_IngotsBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortShields()
	If ItmForm.HasKeyword(ArmorShield)
		RemoveItem(ItmForm, ItemCount, True, SB_ShieldsBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortRawFood()
	If SB_RawMeatList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_RawMeatBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortAmmo()	
	If ItmForm.HasKeyword(VendorItemArrow)
		RemoveItem(ItmForm, ItemCount, True, SB_AmmoBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortRanged()
	If ItmForm.HasKeyword(WeapTypeBow)
		RemoveItem(ItmForm, ItemCount, True, SB_RangedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction



Function SortSoulGems()
	If SB_FilledSoulGemsList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_FilledSoulGemsBox)
		ItemDone = 1
		Return
	EndIf
	
	If SB_EmptySoulGemsList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_EmptySoulGemsBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortArmours()
	If ItmForm.HasKeyword(ArmorLight)
		RemoveItem(ItmForm, ItemCount, True, SB_LightArmourBox)
		ItemDone = 1
		Return
	EndIf

	If ItmForm.HasKeyword(ArmorHeavy)
		RemoveItem(ItmForm, ItemCount, True, SB_HeavyArmourBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortGems()
	If SB_GemsList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_GemsBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortFirewood()
	RemoveItem(ItmForm, ItemCount, True, SB_WoodBox)
	ItemDone = 1
	Return
EndFunction


Function SortFood()
	If SB_FruitsVeggiesList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_FruitsVeggiesBox)
		ItemDone = 1
		Return
	EndIf

	If SB_CheeseList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_CheeseBox)
		ItemDone = 1
		Return
	EndIf

	If SB_CookedFoodsList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_CookedFoodsBox)
		ItemDone = 1
		Return
	EndIf	

	If SB_BoozeList.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_BoozeBox)
		ItemDone = 1
		Return
	EndIf
	
	If SB_DrinksList.HasForm(ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_DrinksBox)
		ItemDone = 1
		Return
	EndIf
	
	If SB_BakedGoodsList.HasForm(ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_BakedGoodsBox)
		ItemDone = 1
		Return
	EndIf
	
	If SB_SweetsList.HasForm(ItmForm)
		RemoveItem (ItmForm, ItemCount, True, SB_SweetsBox)
		ItemDone = 1
		Return
	EndIf
	
	RemoveItem (ItmForm, ItemCount, True, SB_OtherFoodsBox)
	ItemDone = 1
	Return
EndFunction


Function SortWarhammers()
	If ItmForm.HasKeyword(WeapTypeWarhammer)
		RemoveItem(ItmForm, ItemCount, True, SB_TwoHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortBattleaxes()
	If ItmForm.HasKeyword(WeapTypeBattleaxe)
		RemoveItem(ItmForm, ItemCount, True, SB_TwoHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortGreatswords()
	If ItmForm.HasKeyword(WeapTypeGreatsword)
		RemoveItem(ItmForm, ItemCount, True, SB_TwoHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortWaraxes()
	If ItmForm.HasKeyword(WeapTypeWarAxe)
		RemoveItem(ItmForm, ItemCount, True, SB_OneHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortMaces()
	If ItmForm.HasKeyword(WeapTypeMace)
		RemoveItem(ItmForm, ItemCount, True, SB_OneHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortSwords()
	If ItmForm.HasKeyword(WeapTypeSword)
		RemoveItem(ItmForm, ItemCount, True, SB_OneHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortDaggers()
	If ItmForm.HasKeyword(WeapTypeDagger)
		RemoveItem(ItmForm, ItemCount, True, SB_OneHandedBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortSpellbooks()
	If ItmForm.HasKeyword(VendorItemSpellTome)
		RemoveItem(ItmForm, ItemCount, True, SB_SpellTomesCase)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortClothing()
	RemoveItem (ItmForm, ItemCount, True, SB_ClothingBox)
	ItemDone = 1
	Return
EndFunction


Function SortHouseParts()
	If  SB_HousePartsList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_HousePartsBox)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortIngredients()
	RemoveItem (ItmForm, ItemCount, True, SB_AlchemyIngredientsBox)
	ItemDone = 1
	Return
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
	If  SB_CutleryList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_CutleryBox)
		ItemDone = 1
		Return
	EndIf
	
	If  SB_DishesList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_DishesBox)
		ItemDone = 1
		Return
	EndIf
	
	If  SB_BucketsList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_BucketsBox)
		ItemDone = 1
		Return
	EndIf
	
	If  SB_ToolsList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_ToolsBox)
		ItemDone = 1
		Return
	EndIf
	
	If  SB_HousePartsList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_HousePartsBox)
		ItemDone = 1
		Return
	EndIf
	
	RemoveItem (ItmForm, ItemCount, True, SB_MiscBox)
	ItemDone = 1
EndFunction



Function SortPotions()
	If  SB_PoisonsList.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, SB_PoisonsBox)
		ItemDone = 1
		Return
	EndIf	
	
	RemoveItem (ItmForm, ItemCount, True, SB_PotionsBox)
	ItemDone = 1
EndFunction



Function SortBox(ObjectReference akOtherContainer)
	RemoveItem(itmForm, ItemCount, True, akOtherContainer)
	ItemDone = 1
	Return
EndFunction


Function SortBoxWithList(FormList list, ObjectReference akOtherContainer)
	If list.HasForm (ItmForm)
		RemoveItem (ItmForm, ItemCount, True, akOtherContainer)
		ItemDone = 1
		Return
	EndIf
EndFunction


Function SortBoxWithListAndKeyword(FormList list, Keyword word, ObjectReference akOtherContainer)
	If  list.HasForm(ItmForm)
		RemoveItem(ItmForm, ItemCount, True, akOtherContainer)
		ItemDone = 1
		Return
	EndIf
	
	If ItmForm.HasKeyword(word)
		RemoveItem(ItmForm, ItemCount, True, akOtherContainer)
		ItemDone = 1
		Return
	EndIf
EndFunction