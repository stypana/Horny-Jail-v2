/obj/structure/medieval/stone_arch
	name = "stone arch"
	desc = "A large decorative arch."
	icon = 'modular_zzplurt/icons/obj/medieval/stone_arch.dmi'
	icon_state = "stone_arch"
	density = FALSE
	max_integrity = 150
	pixel_x = 0
	layer = FLY_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/medieval/stone_arch/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_SHIPPING_CONTAINER)

/obj/structure/medieval/wine_barrel
	name = "wine barrel"
	desc = "A decorative barrel laying on its side, with supposedly wine inside."
	icon = 'modular_zzplurt/icons/obj/medieval/structures.dmi'
	icon_state = "wine_barrel"
	density = TRUE
	max_integrity = 150
	pixel_x = 0
