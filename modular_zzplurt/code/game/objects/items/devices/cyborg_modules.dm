/obj/item/robot_module/proc/dogborg_equip()
	has_snowflake_deadsprite = TRUE
	cyborg_pixel_offset = -16
	hat_offset = INFINITY
	basic_modules += new /obj/item/dogborg_nose(src)
	basic_modules += new /obj/item/dogborg_tongue(src)

	var/obj/item/dogborg/sleeper/I = /obj/item/dogborg/sleeper

	var/mechanics = CONFIG_GET(flag/enable_dogborg_sleepers)
	if (mechanics)
		// Normal sleepers
		if(istype(src, /obj/item/robot_module/security))
			I = new /obj/item/dogborg/sleeper/K9(src)

		if(istype(src, /obj/item/robot_module/medical))
			I = new /obj/item/dogborg/sleeper(src)

		// "Unimplemented sleepers"
		if(istype(src, /obj/item/robot_module/engineering))
			I = new /obj/item/dogborg/sleeper/compactor(src)
			I.icon_state = "decompiler"
		if(istype(src, /obj/item/robot_module/butler))
			I = new /obj/item/dogborg/sleeper/compactor(src)
			I.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				I.icon_state = "compactor"
	else
		I = new /obj/item/dogborg/sleeper/K9/flavour(src) //If mechanics is a no-no, revert to flavour
		// Recreational sleepers
		if(istype(src, /obj/item/robot_module/security))
			I.icon_state = "sleeperb"
		if(istype(src, /obj/item/robot_module/medical))
			I.icon_state = "sleeper"

		// Unimplemented sleepers
		if(istype(src, /obj/item/robot_module/engineering))
			I.icon_state = "decompiler"
		if(istype(src, /obj/item/robot_module/butler))
			I.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				I.icon_state = "compactor"

	basic_modules += I
	rebuild_modules()
