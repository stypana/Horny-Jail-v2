/obj/item/storage/backpack/sloogshell
	name = "Sloog shell"
	desc = "A large shell, belonging to probably a very large snail or slug... Wait... It can store things?"
	icon = 'modular_zzplurt/icons/obj/storage.dmi'
	icon_state = "sloog_backpack"
	worn_icon = 'modular_zzplurt/icons/mob/clothing/64_back.dmi'
	worn_x_dimension = 64
	slowdown = 4 // Slightly faster than snail shell since it's a larger creature
	obj_flags = IMMUTABLE_SLOW
	alternate_worn_layer = ABOVE_BODY_FRONT_LAYER
	max_integrity = 200
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/backpack_snail
