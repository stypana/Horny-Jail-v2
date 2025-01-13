#define CLIMAX_ON_FLOOR "On the floor"
#define CLIMAX_IN_OR_ON "Climax in or on someone"

/mob/living
	var/pleasure = 0
	var/arousal = 0
	var/pain = 0
	var/satisfaction = 0

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

	var/last_climax = 0
	var/climax_cooldown = 0
	var/obj/item/organ/external/genital/last_climax_source = null
	COOLDOWN_DECLARE(refractory_period)

	// Add variables for slots
	var/obj/item/vagina = null
	var/obj/item/anus = null
	var/obj/item/nipples = null
	var/obj/item/penis = null

/mob/living/proc/adjust_pleasure(amount, mob/living/partner, datum/interaction/interaction, position)
	if(stat >= DEAD || !client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return

	pleasure = clamp(pleasure + amount, AROUSAL_MINIMUM, AROUSAL_LIMIT)

	if(pleasure >= AROUSAL_AUTO_CLIMAX_THRESHOLD)
		climax(manual = FALSE, partner = partner, climax_interaction = interaction, interaction_position = position)

/mob/living/proc/set_pleasure(amount)
	pleasure = clamp(amount, 0, 100)
	update_pleasure_hud()

/mob/living/proc/handle_climax(manual = FALSE, datum/interaction/climax_interaction = null, interaction_position = null, mob/living/partner = null)
	if (CONFIG_GET(flag/disable_erp_preferences))
		return

	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp/autocum) && !manual)
		return
	if(world.time < last_climax + climax_cooldown)
		return FALSE
	last_climax = world.time
	if(has_status_effect(/datum/status_effect/climax_cooldown) || !client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		return

	if(HAS_TRAIT(src, TRAIT_NEVERBONER) || has_status_effect(/datum/status_effect/climax_cooldown) || (!has_vagina() && !has_penis()))
		visible_message(span_purple("[src] twitches, trying to cum, but with no result."), \
			span_purple("You can't have an orgasm!"))
		return TRUE

	// Reduce pop-ups and make it slightly more frictionless (lewd).
	var/climax_choice = has_penis() ? CLIMAX_PENIS : CLIMAX_VAGINA

	if(manual)
		var/list/genitals = list()
		if(has_vagina())
			genitals.Add(CLIMAX_VAGINA)
			if(has_penis())
				genitals.Add(CLIMAX_PENIS)
				genitals.Add(CLIMAX_BOTH)
		else if(has_penis())
			genitals.Add(CLIMAX_PENIS)
		climax_choice = tgui_alert(src, "You are climaxing, choose which genitalia to climax with.", "Genitalia Preference!", genitals)
	else if(istype(climax_interaction, /datum/interaction) && climax_interaction.cum_genital?.len && climax_interaction.cum_genital[interaction_position])
		climax_choice = climax_interaction.cum_genital[interaction_position]

	switch(gender)
		if(MALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
		if(FEMALE)
			conditional_pref_sound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
										'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)

	var/self_orgasm = FALSE
	var/self_their = p_their()

	if(climax_choice == CLIMAX_PENIS || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/external/genital/penis/penis = get_organ_slot(ORGAN_SLOT_PENIS)
		if(!get_organ_slot(ORGAN_SLOT_TESTICLES))
			visible_message(span_userlove("[src] orgasms, but nothing comes out of [self_their] penis!"), \
				span_userlove("You orgasm, it feels great, but nothing comes out of your penis!"))

		else if(is_wearing_condom())
			var/obj/item/clothing/sextoy/condom/condom = get_item_by_slot(LEWD_SLOT_PENIS)
			condom.condom_use()
			visible_message(span_userlove("[src] shoots [self_their] load into the [condom], filling it up!"), \
				span_userlove("You shoot your thick load into the [condom] and it catches it all!"))

		else if(!is_bottomless() && penis.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove("[src] cums inside [self_their] clothes!"), \
				span_userlove("You shoot your load, but you weren't naked, so you mess up your clothes!"))
			self_orgasm = TRUE

		else
			var/list/interactable_inrange_humans = list()
			var/target_choice

			for(var/mob/living/carbon/human/iterating_human in (view(1, src) - src))
				interactable_inrange_humans[iterating_human.name] = iterating_human

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_humans.len)
				buttons += CLIMAX_IN_OR_ON

			var/penis_climax_choice = climax_interaction && !manual ? CLIMAX_IN_OR_ON : tgui_alert(src, "Choose where to shoot your load.", "Load preference!", buttons)

			var/create_cum_decal = FALSE

			if(!penis_climax_choice || penis_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove("[src] shoots [self_their] sticky load onto the floor!"), \
					span_userlove("You shoot string after string of hot cum, hitting the floor!"))

			else
				target_choice = climax_interaction && !manual ? partner?.name : tgui_input_list(src, "Choose a person to cum in or on.", "Choose target!", interactable_inrange_humans)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove("[src] shoots [self_their] sticky load onto the floor!"), \
						span_userlove("You shoot string after string of hot cum, hitting the floor!"))
				else
					var/mob/living/carbon/human/target_human = climax_interaction && !manual ? partner : interactable_inrange_humans[target_choice]
					var/target_human_them = target_human.p_them()

					var/list/target_buttons = list()

					if(!target_human.wear_mask)
						target_buttons += "mouth"
					if(target_human.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_human.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_ANUS
					if(target_human.has_penis(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_PENIS
						var/obj/item/organ/external/genital/penis/other_penis = target_human.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis.sheath != "None")
							target_buttons += "sheath"
					target_buttons += "On [target_human_them]"

					var/climax_into_choice
					var/interaction_inside = partner?.get_organ_slot(climax_interaction?.cum_target[interaction_position]) || target_buttons.Find(climax_interaction?.cum_target[interaction_position])

					if(climax_interaction && !manual && interaction_inside)
						climax_into_choice = climax_interaction.cum_target[interaction_position]
					else if(manual)
						climax_into_choice = tgui_input_list(src, "Where on or in [target_human] do you wish to cum?", "Final frontier!", target_buttons)
					else
						climax_into_choice = "On [target_human_them]"

					if(climax_interaction && !manual && climax_interaction.show_climax(src, target_human, interaction_position))
						create_cum_decal = !interaction_inside
					else if(!climax_into_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] shoots their sticky load onto the floor!"), \
							span_userlove("You shoot string after string of hot cum, hitting the floor!"))
					else if(climax_into_choice == "On [target_human_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] shoots their sticky load onto [target_human]!"), \
							span_userlove("You shoot string after string of hot cum onto [target_human]!"))
					else
						visible_message(span_userlove("[src] hilts [self_their] cock into [target_human]'s [climax_into_choice], shooting cum into [target_human_them]!"), \
							span_userlove("You hilt your cock into [target_human]'s [climax_into_choice], shooting cum into [target_human_them]!"))
						to_chat(target_human, span_userlove("Your [climax_into_choice] fills with warm cum as [src] shoots [self_their] load into it."))

			var/obj/item/organ/external/genital/testicles/testicles = get_organ_slot(ORGAN_SLOT_TESTICLES)
			if(!(climax_interaction?.interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER))
				if(create_cum_decal)
					if(HAS_TRAIT(src, TRAIT_MESSY))
						var/datum/reagents/R = new(testicles.internal_fluid_maximum)
						testicles.transfer_internal_fluid(R, testicles.internal_fluid_count * 0.6)
						if(partner && partner != src)
							var/turf/T = get_turf(partner)
							T.add_liquid_from_reagents(R, FALSE, 1, get_turf(src), partner)
						else
							var/turf/T = get_turf(src)
							T.add_liquid_from_reagents(R, FALSE, 1)
						qdel(R)
					else
						testicles.transfer_internal_fluid(null, testicles.internal_fluid_count * 0.6)
						add_cum_splatter_floor(get_turf(src))
				else if(partner || interactable_inrange_humans[target_choice])
					var/mob/living/carbon/human/target_human = partner || interactable_inrange_humans[target_choice]

					var/datum/reagent/original_fluid_datum = testicles.internal_fluid_datum
					if(!target_human.client?.prefs?.read_preference(/datum/preference/toggle/erp/custom_genital_fluids))
						testicles.internal_fluid_datum = initial(testicles.internal_fluid_datum)

					var/datum/reagents/R = new(testicles.internal_fluid_maximum)
					testicles.transfer_internal_fluid(R, testicles.internal_fluid_count * 0.6)
					R.trans_to(target_human, R.total_volume)

					testicles.internal_fluid_datum = original_fluid_datum
					qdel(R)
				else
					testicles.transfer_internal_fluid(null, testicles.internal_fluid_count * 0.6)

		try_lewd_autoemote("moan")
		if(climax_choice == CLIMAX_PENIS)
			apply_status_effect(/datum/status_effect/climax)
			apply_status_effect(/datum/status_effect/climax_cooldown)
			if(self_orgasm)
				add_mood_event("orgasm", /datum/mood_event/climaxself)
			return TRUE

	if(climax_choice == CLIMAX_VAGINA || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/external/genital/vagina/vagina = get_organ_slot(ORGAN_SLOT_VAGINA)
		if(!is_bottomless() && vagina.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove("[src] cums in [self_their] underwear from [self_their] vagina!"), \
					span_userlove("You cum in your underwear from your vagina! Eww."))
			self_orgasm = TRUE
		else
			var/list/interactable_inrange_humans = list()
			var/target_choice

			for(var/mob/living/carbon/human/iterating_human in (view(1, src) - src))
				interactable_inrange_humans[iterating_human.name] = iterating_human

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_humans.len)
				buttons += CLIMAX_IN_OR_ON

			var/vagina_climax_choice = climax_interaction && !manual ? CLIMAX_IN_OR_ON : tgui_alert(src, "Choose where to squirt.", "Squirt preference!", buttons)

			var/create_cum_decal = FALSE

			if(!vagina_climax_choice || vagina_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove("[src] twitches and moans as [p_they()] squirt on the floor!"), \
					span_userlove("You twitch and moan as you squirt on the floor!"))

			else
				target_choice = climax_interaction && !manual ? partner.name : tgui_input_list(src, "Choose who to squirt on.", "Choose target!", interactable_inrange_humans)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove("[src] twitches and moans as [p_they()] squirt on the floor!"), \
						span_userlove("You twitch and moan as you squirt on the floor!"))
				else
					var/mob/living/carbon/human/target_human = climax_interaction && !manual ? partner : interactable_inrange_humans[target_choice]
					var/target_human_them = target_human.p_them()

					var/list/target_buttons = list()

					if(!target_human.wear_mask)
						target_buttons += "mouth"
					if(target_human.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_human.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_ANUS
					if(target_human.has_penis(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_PENIS
						var/obj/item/organ/external/genital/penis/other_penis = target_human.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis.sheath != "None")
							target_buttons += "sheath"
					target_buttons += "On [target_human_them]"

					var/climax_into_choice
					var/interaction_inside = partner?.get_organ_slot(climax_interaction?.cum_target[interaction_position]) || target_buttons.Find(climax_interaction?.cum_target[interaction_position])

					if(climax_interaction && !manual && interaction_inside)
						climax_into_choice = climax_interaction.cum_target[interaction_position]
					else if(manual)
						climax_into_choice = tgui_input_list(src, "Where on or in [target_human] do you wish to squirt?", "Final frontier!", target_buttons)
					else
						climax_into_choice = "On [target_human_them]"

					if(climax_interaction && !manual && climax_interaction.show_climax(src, target_human, interaction_position))
						create_cum_decal = !interaction_inside
					else if(!climax_into_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] squirts on the floor!"), \
							span_userlove("You squirt on the floor!"))
					else if(climax_into_choice == "On [target_human_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] squirts all over [target_human]!"), \
							span_userlove("You squirt all over [target_human]!"))
					else
						visible_message(span_userlove("[src] squirts into [target_human]'s [climax_into_choice]!"), \
							span_userlove("You squirt into [target_human]'s [climax_into_choice]!"))
						to_chat(target_human, span_userlove("Your [climax_into_choice] fills with [src]'s fluids."))

			if(!(climax_interaction?.interaction_modifier_flags & INTERACTION_OVERRIDE_FLUID_TRANSFER))
				if(create_cum_decal)
					if(HAS_TRAIT(src, TRAIT_MESSY))
						var/datum/reagents/R = new(vagina.internal_fluid_maximum)
						vagina.transfer_internal_fluid(R, vagina.internal_fluid_count)
						if(partner && partner != src)
							var/turf/T = get_turf(partner)
							T.add_liquid_from_reagents(R, FALSE, 1, get_turf(src), partner)
						else
							var/turf/T = get_turf(src)
							T.add_liquid_from_reagents(R, FALSE, 1)
						qdel(R)
					else
						vagina.transfer_internal_fluid(null, vagina.internal_fluid_count)
						add_cum_splatter_floor(get_turf(src), female = TRUE)
				else if(partner || interactable_inrange_humans[target_choice])
					var/mob/living/carbon/human/target_human = partner || interactable_inrange_humans[target_choice]

					var/datum/reagent/original_fluid_datum = vagina.internal_fluid_datum
					if(!target_human.client?.prefs?.read_preference(/datum/preference/toggle/erp/custom_genital_fluids))
						vagina.internal_fluid_datum = initial(vagina.internal_fluid_datum)

					var/datum/reagents/R = new(vagina.internal_fluid_maximum)
					vagina.transfer_internal_fluid(R, vagina.internal_fluid_count)
					R.trans_to(target_human, R.total_volume)

					vagina.internal_fluid_datum = original_fluid_datum
					qdel(R)
				else
					vagina.transfer_internal_fluid(null, vagina.internal_fluid_count)

	apply_status_effect(/datum/status_effect/climax)
	apply_status_effect(/datum/status_effect/climax_cooldown)
	if(self_orgasm)
		add_mood_event("orgasm", /datum/mood_event/climaxself)

	if(climax_interaction && !manual)
		climax_interaction.post_climax(src, partner, interaction_position)
	return TRUE

/// Returns true if the mob has an accessible penis for the parameter
/mob/living/proc/has_penis(required_state = REQUIRE_GENITAL_ANY)
	var/obj/item/organ/external/genital/genital = get_organ_slot(ORGAN_SLOT_PENIS)
	if(!genital)
		return FALSE

	switch(required_state)
		if(REQUIRE_GENITAL_ANY)
			return TRUE
		if(REQUIRE_GENITAL_EXPOSED)
			return genital.visibility_preference == GENITAL_ALWAYS_SHOW || is_bottomless()
		if(REQUIRE_GENITAL_UNEXPOSED)
			return genital.visibility_preference != GENITAL_ALWAYS_SHOW && !is_bottomless()
		else
			return TRUE

/// Returns true if the mob has an accessible vagina for the parameter
/mob/living/proc/has_vagina(required_state = REQUIRE_GENITAL_ANY)
	var/obj/item/organ/external/genital/genital = get_organ_slot(ORGAN_SLOT_VAGINA)
	if(!genital)
		return FALSE

	switch(required_state)
		if(REQUIRE_GENITAL_ANY)
			return TRUE
		if(REQUIRE_GENITAL_EXPOSED)
			return genital.visibility_preference == GENITAL_ALWAYS_SHOW || is_bottomless()
		if(REQUIRE_GENITAL_UNEXPOSED)
			return genital.visibility_preference != GENITAL_ALWAYS_SHOW && !is_bottomless()
		else
			return TRUE

/// Returns true if the mob has accessible breasts for the parameter
/mob/living/proc/has_breasts(required_state = REQUIRE_GENITAL_ANY)
	var/obj/item/organ/external/genital/genital = get_organ_slot(ORGAN_SLOT_BREASTS)
	if(!genital)
		return FALSE

	switch(required_state)
		if(REQUIRE_GENITAL_ANY)
			return TRUE
		if(REQUIRE_GENITAL_EXPOSED)
			return genital.visibility_preference == GENITAL_ALWAYS_SHOW || is_topless()
		if(REQUIRE_GENITAL_UNEXPOSED)
			return genital.visibility_preference != GENITAL_ALWAYS_SHOW && !is_topless()
		else
			return TRUE

/// Returns true if the mob has an accessible anus for the parameter
/mob/living/proc/has_anus(required_state = REQUIRE_GENITAL_ANY)
	if(issilicon(src))
		return TRUE
	var/obj/item/organ/external/genital/genital = get_organ_slot(ORGAN_SLOT_ANUS)
	if(!genital)
		return FALSE

	switch(required_state)
		if(REQUIRE_GENITAL_ANY)
			return TRUE
		if(REQUIRE_GENITAL_EXPOSED)
			return genital.visibility_preference == GENITAL_ALWAYS_SHOW || is_bottomless()
		if(REQUIRE_GENITAL_UNEXPOSED)
			return genital.visibility_preference != GENITAL_ALWAYS_SHOW && !is_bottomless()
		else
			return TRUE

/// These are stub procs that should be overridden by human
/mob/living/proc/is_topless()
	return TRUE

/mob/living/proc/is_bottomless()
	return TRUE

/mob/living/proc/is_barefoot()
	return TRUE

/mob/living/proc/climax(manual = TRUE, mob/living/partner = null, datum/interaction/climax_interaction = null, interaction_position = null)
	handle_climax(manual, climax_interaction, interaction_position, partner)

/mob/living/proc/update_pleasure_hud()
	return // Stub proc that should be overridden by human

/mob/living/proc/set_arousal(amount)
	arousal = clamp(amount, AROUSAL_MINIMUM, AROUSAL_LIMIT)
	update_arousal_hud()

/mob/living/proc/update_arousal_hud()
	return // Stub proc that should be overridden by human

/mob/living/proc/update_pain_hud()
	return // Stub proc that should be overridden by human

/mob/living/proc/is_wearing_condom()
	return FALSE // Stub proc that should be overridden by human

// I'm unsure if mobs should get checked for these, but I'm adding them for now

/mob/living/proc/has_feet(required_state = REQUIRE_GENITAL_ANY)
	return FALSE

/mob/living/proc/has_balls(required_state = REQUIRE_GENITAL_ANY)
	return FALSE

/mob/living/proc/has_belly(required_state = REQUIRE_GENITAL_ANY)
	return FALSE

/mob/living/proc/get_num_feet()
	return 0

#undef CLIMAX_VAGINA
#undef CLIMAX_PENIS
#undef CLIMAX_BOTH
#undef CLIMAX_ON_FLOOR
#undef CLIMAX_IN_OR_ON
