// Variables
/datum/species
	var/exotic_blood_color = BLOOD_COLOR_STANDART
	var/exotic_blood_blend_mode = BLEND_MULTIPLY

// Greyscale Icons
/obj/effect/decal/cleanable/blood
	icon = 'modular_zzplurt/icons/effects/blood.dmi'

/obj/effect/decal/cleanable/trail_holder
	icon = 'modular_zzplurt/icons/effects/blood.dmi'

/obj/effect/decal/cleanable/blood/gibs
	icon = 'modular_zzplurt/icons/effects/blood.dmi'

/obj/effect/decal/cleanable/blood/footprints
	icon = 'modular_zzplurt/icons/effects/footprints.dmi'

// Procs
/atom/proc/blood_DNA_to_color()
	if(forensics)
		return(forensics.blood_DNA && forensics.blood_DNA["color"]) || BLOOD_COLOR_STANDART
	return BLOOD_COLOR_STANDART

/atom/proc/blood_DNA_to_blend()
	if(forensics)
		if(forensics.blood_DNA && !isnull(forensics.blood_DNA["blendmode"]))
			return forensics.blood_DNA["blendmode"]
	return BLEND_MULTIPLY

// Reforcing the master-code procs and other stuff - Changes are commented //
//
/datum/element/decal/blood/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _smoothing, source)
	var/obj/item/I = source
	ADD_KEEP_TOGETHER(I, type)
	var/icon = I.icon
	var/icon_state = I.icon_state
	if(!icon || !icon_state)
		icon = I.icon
		icon_state = I.icon_state
	var/icon/icon_for_size = icon(icon, icon_state)
	var/scale_factor_x = icon_for_size.Width()/ICON_SIZE_X
	var/scale_factor_y = icon_for_size.Height()/ICON_SIZE_Y
	var/mutable_appearance/blood_splatter = mutable_appearance('modular_zzplurt/icons/effects/blood.dmi', "itemblood", appearance_flags = RESET_COLOR) // Here (Icon)
	blood_splatter.transform = blood_splatter.transform.Scale(scale_factor_x, scale_factor_y)
	blood_splatter.blend_mode = BLEND_INSET_OVERLAY
	blood_splatter.color = I.blood_DNA_to_color() // And here ('_color' to 'I.blood_DNA_to_color()')
	pic = blood_splatter
	return TRUE

//
// Тут впадлу было комментить изменения, сами найдете UwU
/datum/wound/blunt/bone/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(!victim || wounding_dmg < WOUND_MINIMUM_DAMAGE)
		return
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(HAS_TRAIT(human_victim, TRAIT_NOBLOOD))
			return

	if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume && prob(internal_bleeding_chance + wounding_dmg))
		var/blood_bled = rand(1, wounding_dmg * (severity == WOUND_SEVERITY_CRITICAL ? 2 : 1.5))
		switch(blood_bled)
			if(1 to 6)
				victim.bleed(blood_bled, TRUE)
			if(7 to 13)
				victim.visible_message(
					span_smalldanger("A thin stream of blood drips from [victim]'s mouth from the blow to [victim.p_their()] chest."),
					span_danger("You cough up a bit of blood from the blow to your chest."),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				victim.bleed(blood_bled, TRUE)
			if(14 to 19)
				victim.visible_message(
					span_smalldanger("Blood spews out of [victim]'s mouth from the blow to [victim.p_their()] chest!"),
					span_danger("You spit out a string of blood from the blow to your chest!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				if(ishuman(victim))
					var/mob/living/carbon/human/H = victim
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir, H.dna.species.exotic_blood_color)
				else
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
			if(20 to INFINITY)
				victim.visible_message(
					span_danger("Blood spurts out of [victim]'s mouth from the blow to [victim.p_their()] chest!"),
					span_bolddanger("You choke up on a spray of blood from the blow to your chest!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
				)
				victim.bleed(blood_bled)
				if(ishuman(victim))
					var/mob/living/carbon/human/H = victim
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir, H.dna.species.exotic_blood_color)
				else
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))

//
// Тут тоже OwO
/datum/wound/pierce/bleed/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(victim.stat == DEAD || (wounding_dmg < 5) || !limb.can_bleed() || !victim.blood_volume || !prob(internal_bleeding_chance + wounding_dmg))
		return
	if(limb.current_gauze?.splint_factor)
		wounding_dmg *= (1 - limb.current_gauze.splint_factor)
	var/blood_bled = rand(1, wounding_dmg * internal_bleeding_coefficient)
	switch(blood_bled)
		if(1 to 6)
			victim.bleed(blood_bled, TRUE)
		if(7 to 13)
			victim.visible_message(
				span_smalldanger("Blood droplets fly from the hole in [victim]'s [limb.plaintext_zone]."),
				span_danger("You cough up a bit of blood from the blow to your [limb.plaintext_zone]."),
				vision_distance = COMBAT_MESSAGE_RANGE,
			)
			victim.bleed(blood_bled, TRUE)
		if(14 to 19)
			victim.visible_message(
				span_smalldanger("A small stream of blood spurts from the hole in [victim]'s [limb.plaintext_zone]!"),
				span_danger("You spit out a string of blood from the blow to your [limb.plaintext_zone]!"),
				vision_distance = COMBAT_MESSAGE_RANGE,
			)
			if(ishuman(victim))
				var/mob/living/carbon/human/H = victim
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir, H.dna.species.exotic_blood_color)
			else
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
			victim.bleed(blood_bled)
		if(20 to INFINITY)
			victim.visible_message(
				span_danger("A spray of blood streams from the gash in [victim]'s [limb.plaintext_zone]!"),
				span_bolddanger("You choke up on a spray of blood from the blow to your [limb.plaintext_zone]!"),
				vision_distance = COMBAT_MESSAGE_RANGE,
			)
			victim.bleed(blood_bled)
			if(ishuman(victim))
				var/mob/living/carbon/human/H = victim
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir, H.dna.species.exotic_blood_color)
			else
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
			victim.add_splatter_floor(get_step(victim.loc, victim.dir))

//
// Changed return (Color + Blendmode)
/mob/living/get_blood_dna_list()
	if(get_blood_id() != /datum/reagent/blood)
		return
	return list("color" = BLOOD_COLOR_STANDART, "blendmode" = BLEND_MULTIPLY, "ANIMAL DNA" = "Y-")

/mob/living/carbon/get_blood_dna_list()
	if(get_blood_id() != /datum/reagent/blood)
		return
	var/list/blood_dna = list()
	if(dna)
		blood_dna["color"] = dna.species.exotic_blood_color
		blood_dna["blendmode"] = dna.species.exotic_blood_blend_mode
		blood_dna[dna.unique_enzymes] = dna.blood_type
	else
		blood_dna["color"] = BLOOD_COLOR_STANDART
		blood_dna["blendmode"] = BLEND_MULTIPLY
		blood_dna["UNKNOWN DNA"] = "X*"
	return blood_dna

/atom/transfer_mob_blood_dna(mob/living/injected_mob)
	var/new_blood_dna = injected_mob.get_blood_dna_list()
	if(!new_blood_dna)
		return FALSE
	var/old_length = GET_ATOM_BLOOD_DNA_LENGTH(src)
	add_blood_DNA(new_blood_dna)
	forensics.blood_DNA["color"] = new_blood_dna["color"]
	forensics.blood_DNA["blendmode"] = new_blood_dna["blendmode"]
	if(GET_ATOM_BLOOD_DNA_LENGTH(src) == old_length)
		return FALSE
	return TRUE

//
//
/obj/effect/decal/cleanable/blood/dry()
	if(bloodiness > 20)
		bloodiness -= BLOOD_AMOUNT_PER_DECAL
		get_timer()
		return FALSE
	else
		name = dryname
		desc = drydesc
		bloodiness = 0
		color = blood_DNA_to_color() // Changed Color from COLOR_GRAY
		STOP_PROCESSING(SSobj, src)
		return TRUE

//
//
/datum/forensics/add_blood_DNA(list/blood_DNA)
	if(!length(blood_DNA))
		return
	LAZYINITLIST(src.blood_DNA)
	for(var/gene in blood_DNA)
		src.blood_DNA[gene] = blood_DNA[gene]
	for(var/color in blood_DNA) // Added this
		src.blood_DNA[color] = blood_DNA[color] // And this
	check_blood()
	return TRUE

//
//
/turf/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	var/obj/effect/decal/cleanable/blood/splatter/blood_splatter = locate() in src
	if(!blood_splatter)
		blood_splatter = new /obj/effect/decal/cleanable/blood/splatter(src, diseases)
	if(!QDELETED(blood_splatter))
		blood_splatter.add_blood_DNA(blood_dna)
		blood_splatter.color = blood_splatter.blood_DNA_to_color() // Added this
		return TRUE
	return FALSE
