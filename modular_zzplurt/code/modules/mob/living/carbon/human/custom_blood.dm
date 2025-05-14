// Variables
/datum/species
	var/exotic_blood_color = BLOOD_COLOR_STANDARD
	var/exotic_blood_blend_mode = BLEND_MULTIPLY

/mob/living/carbon/get_blood_dna_list()
	. = ..()

	if(get_blood_id() != /datum/reagent/blood)
		return

	var/list/extra_blood_data = list(
		"exotic_blood_color" = dna?.species?.exotic_blood_color || BLOOD_COLOR_STANDARD,
		"exotic_blood_blend_mode" = dna?.species?.exotic_blood_blend_mode || BLEND_MULTIPLY
	)

	. = extra_blood_data + . //hacky but the blood stuff must be at the end of the list

/mob/living/carbon/get_blood_data(blood_id)
	. = ..()
	if(blood_id != /datum/reagent/blood)
		return
	.["bloodcolor"] = dna.species.exotic_blood_color || BLOOD_COLOR_STANDARD
	.["bloodblend"] = dna.species.exotic_blood_blend_mode || BLEND_MULTIPLY
