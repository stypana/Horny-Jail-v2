//generic roundstart armor, bare minimum stuff that's absolutely needed if your mechs wants to be effective in combat
/datum/design/general_purpose_armor
	name = "General Purpose Metal Armor"
	desc = "Special armoured ablative plate of metal, designed to increase survivability. Standard issue for military-grade exosuits."
	id = "mech_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/armor/roundstart
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*5,/datum/material/glass=SHEET_MATERIAL_AMOUNT * 2)
	construction_time = 5 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MODULES,
		RND_CATEGORY_MECHFAB_RIPLEY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_ODYSSEUS + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PADDY + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_CLARKE + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/techweb_node/mech_assembly
	design_ids = list(
		"mechapower",
		"mech_recharger",
		"ripley_chassis",
		"ripley_torso",
		"ripley_left_arm",
		"ripley_right_arm",
		"ripley_left_leg",
		"ripley_right_leg",
		"ripley_main",
		"ripley_peri",
		"mech_hydraulic_clamp",
		"mech_armor",
	)

/obj/item/mecha_parts/mecha_equipment/armor
	///how much integrity this armor have, acts as extra hp essentially.
	armor_integrity = 200
	armor_operational = TRUE

/obj/item/mecha_parts/mecha_equipment/armor/roundstart
	armor_integrity = 100
	name = "General Purpose Metal Plates"
	desc = "Special armoured ablative plate of metal, designed to increase survivability. Standard issue for military-grade exosuits"
	icon = 'modular_zzplurt/icons/obj/devices/mecha_equipment.dmi'
	icon_state = "roundstartarmor"
	iconstate_name = "melee"
	protect_name = "General Armor"

//integrity nerf to offset the armor buff
/obj/vehicle/sealed/mecha
	max_integrity = 200
	internal_damage_probability = 30

/obj/vehicle/sealed/mecha/durand
	max_integrity = 300

/obj/vehicle/sealed/mecha/gygax
	max_integrity = 150

/obj/vehicle/sealed/mecha/phazon
	max_integrity = 100
//servos buff
/obj/vehicle/sealed/mecha/proc/update_part_values()
	. = ..()
	if(servo)
		var/percentage_buff = (100 - (servo.rating * 4)) / 100
		movedelay = initial(movedelay) * percentage_buff
