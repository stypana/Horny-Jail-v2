/obj/item/highfrequencyblade
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	var/slice_hitsound = 'sound/items/weapons/zapbang.ogg'

/obj/item/highfrequencyblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(..())
		var/owner_turf = get_turf(owner)
		new block_effect(owner_turf, COLOR_WHITE)
		playsound(src, block_sound, BLOCK_SOUND_VOLUME, vary = TRUE)
		return TRUE
	return FALSE

/obj/item/highfrequencyblade/slash(atom/target, mob/living/user, list/modifiers) // The sound playing code is embedded deep in this proc, so I have to override it.
	animate_attack(user, target, ATTACK_ANIMATION_SLASH)
	user.do_attack_animation(target, "nothing")
	var/damage_mod = 1
	var/x_slashed = text2num(modifiers[ICON_X]) || ICON_SIZE_X/2
	var/y_slashed = text2num(modifiers[ICON_Y]) || ICON_SIZE_Y/2
	new /obj/effect/temp_visual/slash(get_turf(target), target, x_slashed, y_slashed, slash_color)
	if(target == previous_target?.resolve())
		var/x_mod = previous_x - x_slashed
		var/y_mod = previous_y - y_slashed
		damage_mod = max(1, round((sqrt(x_mod ** 2 + y_mod ** 2) / 10), 0.1))
	previous_target = WEAKREF(target)
	previous_x = x_slashed
	previous_y = y_slashed
	playsound(src, hitsound, 100, vary = TRUE)
	playsound(src, slice_hitsound, 50, vary = TRUE)
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_damage(force*damage_mod, BRUTE, sharpness = SHARP_EDGED, wound_bonus = wound_bonus, exposed_wound_bonus = exposed_wound_bonus, def_zone = user.zone_selected)
		log_combat(user, living_target, "slashed", src)
		if(living_target.stat == DEAD && prob(force*damage_mod*0.5))
			living_target.visible_message(span_danger("[living_target] explodes in a shower of gore!"), blind_message = span_hear("You hear organic matter ripping and tearing!"))
			living_target.investigate_log("has been gibbed by [src].", INVESTIGATE_DEATHS)
			living_target.gib(DROP_ALL_REMAINS)
			log_combat(user, living_target, "gibbed", src)
		return TRUE
	else if(target.uses_integrity)
		target.take_damage(force*damage_mod*3, BRUTE, MELEE, FALSE, null, 50)
		return TRUE
	else if(iswallturf(target) && prob(force*damage_mod*0.5))
		var/turf/closed/wall/wall_target = target
		wall_target.dismantle_wall()
		return TRUE
	else if(ismineralturf(target) && prob(force*damage_mod))
		var/turf/closed/mineral/mineral_target = target
		mineral_target.gets_drilled()
		return TRUE
	return FALSE
