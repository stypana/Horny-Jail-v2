// Dorborg specific modules

/obj/item/dogborg/dogborg_tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/blob/attackblob.ogg'
	item_flags = NOBLUDGEON
	force = 0

/obj/item/dogborg/dogborg_tongue/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	var/mob/living/living_target = target
	do_attack_animation(target, null, src)
	if(check_zone(user.zone_selected) == "head")
		user.visible_message("<span class='warning'>\the [user] affectionally licks \the [living_target]'s face!</span>", "<span class='notice'>You affectionally lick \the [living_target]'s face!</span>")
		playsound(user, 'sound/effects/blob/attackblob.ogg', 50, 1)
	else
		user.visible_message("<span class='warning'>\the [user] affectionally licks \the [living_target]!</span>", "<span class='notice'>You affectionally lick \the [living_target]!</span>")
		playsound(user, 'sound/effects/blob/attackblob.ogg', 50, 1)




/obj/item/dogborg/dogborg_nose
	name = "BOOP module"
	desc = "The Bionic Olfactory Observation Processor module. Warm and squishy."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "nose"
	item_flags = NOBLUDGEON
	force = 0

	var/within_operational_parameters = TRUE

/obj/item/dogborg/dogborg_nose/attack_self(mob/user)
	scan_enviroment(user)

/obj/item/dogborg/dogborg_nose/proc/format_gas_concentration(concentration, standard_treshold, gas_name, check_type)
	var/format_text = "[gas_name]: [round(concentration * 100, 0.01)]%"
	var/is_alert = FALSE
	switch(check_type)
		if("less than")
			is_alert = !(abs(concentration - standard_treshold) < 20)
		if("greater than")
			is_alert = concentration > standard_treshold
	if(is_alert)
		within_operational_parameters = FALSE
	return is_alert ? span_alert(format_text) : span_info(format_text)

/obj/item/dogborg/dogborg_nose/proc/scan_enviroment(mob/user)
	user.visible_message("[user] sniffs around the air.", "<span class='info'>You sniff the air for gas traces.</span>")
	var/message = list(span_boldnotice("Results of environmental analysis:\n"))
	within_operational_parameters = TRUE

	var/datum/gas_mixture/mixture = user.loc.return_analyzable_air()
	if(!mixture)
		to_chat(user, span_warning("Module data request returned an empty string - no gas mixture provided."))
		return FALSE

	var/list/airs = islist(mixture) ? mixture : list(mixture)
	var/list/new_gasmix_data = list()
	for(var/datum/gas_mixture/air as anything in airs)
		var/mix_name = capitalize(LOWER_TEXT(user.name))
		new_gasmix_data += list(gas_mixture_parser(air, mix_name))

	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles()

	var/o2_concentration = 0
	var/n2_concentration = 0
	var/co2_concentration = 0
	var/plasma_concentration = 0


	message += abs(pressure - ONE_ATMOSPHERE) < 10 ? span_info("Pressure: [round(pressure,0.1)] kPa") : span_alert("Pressure: [round(pressure,0.1)] kPa")
	within_operational_parameters = abs(pressure - ONE_ATMOSPHERE) < 10 ? within_operational_parameters : FALSE

	message += abs(mixture.return_temperature()) > 20 ? span_info("Temperature: [round(mixture.return_temperature() - T0C)]&deg;C\n") : span_alert("Temperature: [round(mixture.return_temperature() - T0C)]&deg;C\n")
	within_operational_parameters = abs(mixture.return_temperature()) > 20 ? within_operational_parameters : FALSE

	if(total_moles)
		for(var/list/gas_data as anything in new_gasmix_data)
			for(var/list/exact_gas_data as anything in gas_data["gases"])
				switch(exact_gas_data[2])
					if("Oxygen")
						o2_concentration = exact_gas_data[3]/total_moles
					if("Nitrogen")
						n2_concentration = exact_gas_data[3]/total_moles
					if("Carbon Dioxide")
						co2_concentration = exact_gas_data[3]/total_moles
					if("Plasma")
						plasma_concentration = exact_gas_data[3]/total_moles

		message += format_gas_concentration(n2_concentration, N2STANDARD, "Nitrogen", "less than")
		message += format_gas_concentration(o2_concentration, O2STANDARD, "Oxygen", "less than")
		message += format_gas_concentration(co2_concentration, 0.01, "CO2", "greater than")
		message += format_gas_concentration(plasma_concentration, 0.005, "Plasma", "greater than")

	message += span_boldnotice("Analysis summary: [within_operational_parameters ? "enviroment within operational parameters." : "<span class='danger'>enviroment outside operational parameters!</span>"]")
	to_chat(user, examine_block(jointext(message, "\n")), type = MESSAGE_TYPE_INFO)

/obj/item/dogborg/dogborg_nose/attack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	do_attack_animation(target, null, src)
	user.visible_message("<span class='notice'>[user] [pick("nuzzles", "pushes", "boops")] \the [target.name] with their nose!</span>")

// Equipping dogborg modules (gets called during transformation)

/obj/item/robot_model/proc/dogborg_equip()
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
		if(istype(src, /obj/item/robot_model/janitor))
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
		if(istype(src, /obj/item/robot_model/janitor))
			I.icon_state = "servicer"
			if(cyborg_base_icon in list("scrubpup", "drakejanit"))
				I.icon_state = "compactor"

	basic_modules += I
	rebuild_modules()

/obj/item/dogborg/jaws
	name = "Dogborg jaws"
	desc = "The jaws of the debug errors oh god."
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	flags_1 = CONDUCTS_ELECTRICITY
	force = 1
	throwforce = 0
	w_class = 3
	// hitsound = 'sound/weapons/bite.ogg'
	sharpness = SHARP_EDGED

/obj/item/dogborg/jaws/big
	name = "combat jaws"
	desc = "The jaws of the law. Very sharp."
	icon_state = "jaws_2"
	force = 10 //Lowered to match secborg. No reason it should be more than a secborg's baton.
	attack_verb_simple = list("chomped", "bit", "ripped", "mauled", "enforced")

/obj/item/dogborg/jaws/small
	name = "puppy jaws"
	desc = "Rubberized teeth designed to protect accidental harm. Sharp enough for specialized tasks however."
	icon_state = "jaws_2"
	force = 6
	attack_verb_simple = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	var/status = 0

/obj/item/dogborg/jaws/attack(atom/A, mob/living/silicon/robot/user)
	..()
	user.do_attack_animation(A, ATTACK_EFFECT_BITE)

/obj/item/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.cell && R.cell.charge > 100)
		if(R.emagged && status == 0)
			name = "combat jaws"
			icon_state = "jaws"
			desc = "The jaws of the law."
			force = 12
			attack_verb_simple = list("chomped", "bit", "ripped", "mauled", "enforced")
			status = 1
			to_chat(user, "<span class='notice'>Your jaws are now [status ? "Combat" : "Pup'd"].</span>")
		else
			name = "puppy jaws"
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			force = 5
			attack_verb_simple = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			status = 0
			if(R.emagged)
				to_chat(user, "<span class='notice'>Your jaws are now [status ? "Combat" : "Pup'd"].</span>")
	update_icon()

/obj/item/analyzer/nose/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	do_attack_animation(target, null, src)
	user.visible_message("<span class='notice'>[user] [pick(attack_verb_simple)] \the [target.name] with their nose!</span>")

//Delivery
/obj/item/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
	icon_state = "dbag"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/bag/borgdelivery/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage= WEIGHT_CLASS_BULKY
	atom_storage.max_total_storage = 30
	atom_storage.max_slots = 1
	atom_storage.set_holdable(list(/obj/item/disk/nuclear))

//Tongue stuff
// /obj/item/soap/tongue
// 	name = "synthetic tongue"
// 	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
// 	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
// 	icon_state = "synthtongue"
// 	hitsound = 'sound/effects/attackblob.ogg'
// 	cleanspeed = 80
// 	var/status = 0

// /obj/item/soap/tongue/scrubpup
// 	cleanspeed = 25 //slightly faster than a mop.

// /obj/item/soap/tongue/New()
// 	..()
// 	item_flags |= NOBLUDGEON //No more attack messages

// /obj/item/soap/tongue/attack_self(mob/user)
// 	var/mob/living/silicon/robot/R = user
// 	if(R.cell && R.cell.charge > 100)
// 		if(R.emagged && status == 0)
// 			status = !status
// 			name = "energized tongue"
// 			desc = "Your tongue is energized for dangerously maximum efficency."
// 			icon_state = "syndietongue"
// 			to_chat(user, "<span class='notice'>Your tongue is now [status ? "Energized" : "Normal"].</span>")
// 			cleanspeed = 10 //(nerf'd)tator soap stat
// 		else
// 			status = 0
// 			name = "synthetic tongue"
// 			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
// 			icon_state = "synthtongue"
// 			cleanspeed = initial(cleanspeed)
// 			if(R.emagged)
// 				to_chat(user, "<span class='notice'>Your tongue is now [status ? "Energized" : "Normal"].</span>")
// 	update_icon()

// /obj/item/soap/tongue/afterattack(atom/target, mob/user, proximity)
// 	var/mob/living/silicon/robot/R = user
// 	if(!proximity || !check_allowed_items(target))
// 		return
// 	if(R.client && (target in R.client.screen))
// 		to_chat(R, "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>")
// 	else if(is_cleanable(target))
// 		R.visible_message("[R] begins to lick off \the [target.name].", "<span class='warning'>You begin to lick off \the [target.name]...</span>")
// 		if(do_after(R, src.cleanspeed, target = target))
// 			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
// 				return //If they moved away, you can't eat them.
// 			to_chat(R, "<span class='notice'>You finish licking off \the [target.name].</span>")
// 			qdel(target)
// 			R.cell.give(50)
// 	else if(isobj(target)) //hoo boy. danger zone man
// 		if(istype(target,/obj/item/trash))
// 			R.visible_message("[R] nibbles away at \the [target.name].", "<span class='warning'>You begin to nibble away at \the [target.name]...</span>")
// 			if(!do_after(R, src.cleanspeed, target = target))
// 				return //If they moved away, you can't eat them.
// 			to_chat(R, "<span class='notice'>You finish off \the [target.name].</span>")
// 			qdel(target)
// 			R.cell.give(250)
// 			return
// 		if(istype(target,/obj/item/stock_parts/cell))
// 			R.visible_message("[R] begins cramming \the [target.name] down its throat.", "<span class='warning'>You begin cramming \the [target.name] down your throat...</span>")
// 			if(!do_after(R, 50, target = target))
// 				return //If they moved away, you can't eat them.
// 			to_chat(R, "<span class='notice'>You finish off \the [target.name].</span>")
// 			var/obj/item/stock_parts/cell/C = target
// 			R.cell.charge = R.cell.charge + (C.charge / 3) //Instant full cell upgrades op idgaf
// 			qdel(target)
// 			return
// 		var/obj/item/I = target //HAHA FUCK IT, NOT LIKE WE ALREADY HAVE A SHITTON OF WAYS TO REMOVE SHIT
// 		if(!I.anchored && R.emagged)
// 			R.visible_message("[R] begins chewing up \the [target.name]. Looks like it's trying to loophole around its diet restriction!", "<span class='warning'>You begin chewing up \the [target.name]...</span>")
// 			if(!do_after(R, 100, target = I)) //Nerf dat time yo
// 				return //If they moved away, you can't eat them.
// 			visible_message("<span class='warning'>[R] chews up \the [target.name] and cleans off the debris!</span>")
// 			to_chat(R, "<span class='notice'>You finish off \the [target.name].</span>")
// 			qdel(I)
// 			R.cell.give(500)
// 			return
// 		R.visible_message("[R] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
// 	else if(ishuman(target))
// 		var/mob/living/L = target
// 		if(status == 0 && check_zone(R.zone_selected) == "head")
// 			R.visible_message("<span class='warning'>\the [R] affectionally licks \the [L]'s face!</span>", "<span class='notice'>You affectionally lick \the [L]'s face!</span>")
// 			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
// 			if(istype(L) && L.fire_stacks > 0)
// 				L.adjust_fire_stacks(-10)
// 			return
// 		else if(status == 0)
// 			R.visible_message("<span class='warning'>\the [R] affectionally licks \the [L]!</span>", "<span class='notice'>You affectionally lick \the [L]!</span>")
// 			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
// 			if(istype(L) && L.fire_stacks > 0)
// 				L.adjust_fire_stacks(-10)
// 			return
// 		else
// 			if(R.cell.charge <= 800)
// 				to_chat(R, "Insufficent Power!")
// 				return
// 			L.Stun(4) // normal stunbaton is force 7 gimme a break good sir!
// 			L.Knockdown(80)
// 			L.apply_effect(EFFECT_STUTTER, 4)
// 			L.visible_message("<span class='danger'>[R] has shocked [L] with its tongue!</span>", \
// 								"<span class='userdanger'>[R] has shocked you with its tongue!</span>")
// 			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
// 			R.cell.use(666)
// 			log_combat(R, L, "tongue stunned")

// 	else if(istype(target, /obj/structure/window))
// 		R.visible_message("[R] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
// 		if(do_after(user, src.cleanspeed, target = target))
// 			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
// 			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
// 			target.set_opacity(initial(target.opacity))
// 	else
// 		R.visible_message("[R] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
// 		if(do_after(user, src.cleanspeed, target = target))
// 			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
// 			var/obj/effect/decal/cleanable/C = locate() in target
// 			qdel(C)
// 			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
// 			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
// 			target.wash_cream()
// 			target.wash_cum()
// 	return

// /obj/item/shockpaddles/cyborg/hound
// 	name = "Paws of Life"
// 	desc = "MediHound specific shock paws."
// 	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
// 	icon_state = "defibpaddles0"
// 	item_state = "defibpaddles0"

// /obj/item/shockpaddles/cyborg/hound/ComponentInitialize()
// 	. = ..()
// 	AddComponent(/datum/component/two_handed)

// // Pounce stuff for K-9

// /obj/item/dogborg/pounce
// 	name = "pounce"
// 	icon = 'modular_zzplurt/icons/mob/robot/robot_items.dmi'
// 	icon_state = "pounce"
// 	desc = "Leap at your target to momentarily stun them."
// 	force = 0
// 	throwforce = 0

// /obj/item/dogborg/pounce/New()
// 	..()
// 	item_flags |= NOBLUDGEON

// /mob/living/silicon/robot
// 	var/leaping = 0
// 	var/pounce_cooldown = 0
// 	var/pounce_cooldown_time = 20 //Buffed to counter balance changes
// 	var/pounce_spoolup = 1
// 	var/leap_at

// #define MAX_K9_LEAP_DIST 4 //because something's definitely borked the pounce functioning from a distance.

// /obj/item/dogborg/pounce/afterattack(atom/A, mob/user)
// 	var/mob/living/silicon/robot/R = user
// 	if(R && !R.pounce_cooldown)
// 		R.pounce_cooldown = !R.pounce_cooldown
// 		to_chat(R, "<span class ='warning'>Your targeting systems lock on to [A]...</span>")
// 		addtimer(CALLBACK(R, TYPE_PROC_REF(/mob/living/silicon/robot, leap_at), A), R.pounce_spoolup)
// 		spawn(R.pounce_cooldown_time)
// 			R.pounce_cooldown = !R.pounce_cooldown
// 	else if(R && R.pounce_cooldown)
// 		to_chat(R, "<span class='danger'>Your leg actuators are still recharging!</span>")

// /mob/living/silicon/robot/proc/leap_at(atom/A)
// 	if(leaping || stat || buckled || lying)
// 		return

// 	if(!has_gravity(src) || !has_gravity(A))
// 		to_chat(src,"<span class='danger'>It is unsafe to leap without gravity!</span>")
// 		//It's also extremely buggy visually, so it's balance+bugfix
// 		return

// 	if(cell.charge <= 750)
// 		to_chat(src,"<span class='danger'>Insufficent reserves for jump actuators!</span>")
// 		return

// 	else
// 		leaping = 1
// 		//weather_immunities += "lava"
// 		pixel_y = 10
// 		update_icons()
// 		throw_at(A, MAX_K9_LEAP_DIST, 1, spin=0, diagonals_first = 1)
// 		cell.use(750) //Less than a stunbaton since stunbatons hit everytime.
// 		//weather_immunities -= "lava"

// /mob/living/silicon/robot/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)

// 	if(!leaping)
// 		return ..()

// 	if(hit_atom)
// 		if(isliving(hit_atom))
// 			var/mob/living/L = hit_atom
// 			var/list/block_return = list()
// 			//if(!L.check_shields(0, "the [name]", src, attack_type = LEAP_ATTACK))
// 			if(!(L.mob_run_block(src, 0, "the [name]", ATTACK_TYPE_TACKLE, 0, src, hit_atom, block_return) & BLOCK_SUCCESS))
// 				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
// 				L.DefaultCombatKnockdown(50, override_stamdmg = 0)
// 				playsound(src, 'sound/weapons/Egloves.ogg', 50, 1)
// 				sleep(2)//Runtime prevention (infinite bump() calls on hulks)
// 				step_towards(src,L)
// 				log_combat(src, L, "borg pounced")
// 			else
// 				Knockdown(15, 1, 1)

// 			pounce_cooldown = !pounce_cooldown
// 			spawn(pounce_cooldown_time) //3s by default
// 				pounce_cooldown = !pounce_cooldown
// 		else if(hit_atom.density && !hit_atom.CanPass(src))
// 			visible_message("<span class ='danger'>[src] smashes into [hit_atom]!</span>", "<span class ='userdanger'>You smash into [hit_atom]!</span>")
// 			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
// 			Knockdown(15, 1, 1)

// 		if(leaping)
// 			leaping = 0
// 			pixel_y = initial(pixel_y)
// 			update_icons()
// 			update_mobility()

