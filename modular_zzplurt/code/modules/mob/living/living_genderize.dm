var/static/list/should_be_genderized = typecacheof(list(
	// anything goes here
))

/datum/component/interactable/Initialize(...)
	if(is_type_in_typecache(parent, should_be_genderized))
		var/mob/living/mob = parent
		if(pick("male", "female") == "male")
			mob.simulated_genitals[ORGAN_SLOT_PENIS] = TRUE
		else
			mob.simulated_genitals[ORGAN_SLOT_VAGINA] = TRUE
			mob.simulated_genitals[ORGAN_SLOT_BREASTS] = TRUE
	. = ..()
