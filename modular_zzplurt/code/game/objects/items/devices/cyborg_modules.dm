// Dorborg specific modules

/obj/item/dogborg/dogborg_tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	item_flags = NOBLUDGEON

/obj/item/dogborg/dogborg_tongue/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !isliving(target))
		return
	var/mob/living/silicon/robot/this_robot = user
	var/mob/living/living_target = target
	if(living_target.ckey && !(living_target.client?.prefs.vore_flags & LICKABLE))
		to_chat(this_robot, "<span class='danger'>ERROR ERROR: Target not lickable. Aborting display-of-affection subroutine.</span>")
		return

	if(check_zone(this_robot.zone_selected) == "head")
		R.visible_message("<span class='warning'>\the [this_robot] affectionally licks \the [living_target]'s face!</span>", "<span class='notice'>You affectionally lick \the [living_target]'s face!</span>")
		playsound(this_robot, 'sound/effects/attackblob.ogg', 50, 1)
	else
		R.visible_message("<span class='warning'>\the [this_robot] affectionally licks \the [living_target]!</span>", "<span class='notice'>You affectionally lick \the [living_target]!</span>")
		playsound(this_robot, 'sound/effects/attackblob.ogg', 50, 1)

/obj/item/dogborg/dogborg_nose
	name = "BOOP module"
	desc = "The Bionic Olfactory Observation Processor module. Warm and squishy."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "nose"
	flags_1 = CONDUCT_1|NOBLUDGEON
	force = 0

/obj/item/dogborg/dogborg_nose/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	do_attack_animation(target, null, src)
	user.visible_message("<span class='notice'>[user] [pick("nuzzles", "pushes", "boops")] \the [target.name] with their nose!</span>")

// Equipping dogborg modules (gets called during transformation)

/obj/item/robot_model/proc/dogborg_equip()
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16
	hat_offset = INFINITY
	basic_modules += new /obj/item/dogborg/dogborg_nose(src)
	basic_modules += new /obj/item/dogborg/dogborg_tongue(src)

	var/obj/item/dogborg/sleeper/I = /obj/item/dogborg/sleeper

	var/mechanics = CONFIG_GET(flag/enable_dogborg_sleepers)
	if (mechanics)
		// Normal sleepers
		if(istype(src, /obj/item/robot_model/security))
			I = new /obj/item/dogborg/sleeper/K9(src)

		if(istype(src, /obj/item/robot_model/medical))
			I = new /obj/item/dogborg/sleeper(src)

		// "Unimplemented sleepers"
		if(istype(src, /obj/item/robot_model/engineering))
			I = new /obj/item/dogborg/sleeper/compactor(src)
			I.icon_state = "decompiler"
		if(istype(src, /obj/item/robot_model/butler))
			I = new /obj/item/dogborg/sleeper/compactor(src)
			I.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				I.icon_state = "compactor"
	else
		I = new /obj/item/dogborg/sleeper/K9/flavour(src) //If mechanics is a no-no, revert to flavour
		// Recreational sleepers
		if(istype(src, /obj/item/robot_model/security))
			I.icon_state = "sleeperb"
		if(istype(src, /obj/item/robot_model/medical))
			I.icon_state = "sleeper"

		// Unimplemented sleepers
		if(istype(src, /obj/item/robot_model/engineering))
			I.icon_state = "decompiler"
		if(istype(src, /obj/item/robot_model/butler))
			I.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				I.icon_state = "compactor"

	basic_modules += I
	rebuild_modules()
