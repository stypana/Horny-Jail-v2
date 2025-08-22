/datum/crafting_recipe/primitive_billow
	name = "Primitive Forging Billow"
	result = /obj/item/forging/billow/primitive
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	category = CAT_TOOLS

/datum/crafting_recipe/primitive_tong
	name = "Primitive Forging Tong"
	result = /obj/item/forging/tongs/primitive
	reqs = list(/obj/item/stack/sheet/iron = 5)
	category = CAT_TOOLS

/datum/crafting_recipe/primitive_hammer
	name = "Primitive Forging Hammer"
	result = /obj/item/forging/hammer/primitive
	reqs = list(/obj/item/stack/sheet/iron = 5)
	category = CAT_TOOLS

//cargo supply pack for items
/datum/supply_pack/service/forging_items
	name = "Forging Starter Item Pack"
	desc = "Featuring: Forging. This pack is full of three items necessary to start your forging career: tongs, hammer, and billow."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/forging/tongs, /obj/item/forging/hammer, /obj/item/forging/billow)
	crate_name = "forging start items"
	crate_type = /obj/structure/closet/crate/forging_items

/obj/structure/closet/crate/forging_items
	name = "forging starter items"
	desc = "A crate filled with the items necessary to start forging (billow, hammer, and tongs)."

// Export datum for forged items

/// Export forged items based on their material worth
/datum/export/forged_item
	export_types = list(/obj/item)
	include_subtypes = TRUE
	message = "forged item"

/// Only applies to items produced via forging that carry the ANVIL_REPAIR flag
/datum/export/forged_item/applies_to(obj/exported_item, apply_elastic = TRUE, export_market)
	if(!(exported_item.skyrat_obj_flags & ANVIL_REPAIR))
		return FALSE
	if(!length(exported_item.custom_materials))
		return FALSE
	return ..()

/// Calculates the export value using the materials used to forge the item
/datum/export/forged_item/get_cost(obj/exported_item, apply_elastic = TRUE)
	var/total_value = 0
	for(var/datum/material/material as anything in exported_item.custom_materials)
		var/material_price = SSstock_market.materials_prices[material.type]
		if(!material_price)
			continue
		total_value += (material_price * exported_item.custom_materials[material]) / SHEET_MATERIAL_AMOUNT
	return round(total_value * 2)
