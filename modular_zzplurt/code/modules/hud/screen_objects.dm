/atom/movable/screen/focus_toggle
	name = "toggle combat mode"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "combat_off"
	screen_loc = "EAST-3:24,SOUTH:5"

/atom/movable/screen/focus_toggle/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	update_appearance()

/atom/movable/screen/focus_toggle/Click()
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/owner = usr
	owner.set_combat_focus(!owner.focus_mode, FALSE)
	update_appearance()

/atom/movable/screen/focus_toggle/update_icon_state()
	var/mob/living/carbon/human/user = hud?.mymob
	if(!istype(user) || !user.client)
		return ..()

	icon_state = user.focus_mode ? "combat" : "combat_off" //Treats the combat_mode
	return ..()
