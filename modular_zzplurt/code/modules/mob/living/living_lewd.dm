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

	// Add variables for slots
	var/obj/item/vagina = null
	var/obj/item/anus = null
	var/obj/item/nipples = null
	var/obj/item/penis = null

	var/refractory_period

/mob/living/proc/adjust_pleasure(amount = 0, mob/living/partner, datum/interaction/interaction, position)
	if(stat >= DEAD || !client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return

	pleasure = clamp(pleasure + amount, AROUSAL_MINIMUM, AROUSAL_LIMIT)

	if(pleasure >= AROUSAL_AUTO_CLIMAX_THRESHOLD)
		climax(manual = FALSE, partner = partner, climax_interaction = interaction, interaction_position = position)

/mob/living/proc/set_pleasure(amount)
	pleasure = clamp(amount, 0, 100)
	update_pleasure_hud()

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
