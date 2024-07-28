/datum/hud
	var/atom/movable/screen/focus_toggle

/datum/hud/human/New(mob/living/carbon/human/owner)
	. = ..()
	focus_toggle = new /atom/movable/screen/focus_toggle(null, src)
	focus_toggle.icon = ui_style
	focus_toggle.update_appearance()
	static_inventory += focus_toggle

