/datum/job/escort
	title = JOB_ESCORT
	description = "Provide companionship to lonely patrons."
	department_head = list(JOB_SOUTENEUR)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Souteneur"
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "ESCORT"

	outfit = /datum/outfit/job/escort
	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_ESCORT
	department_for_prefs = /datum/job_department/entertainment
	departments_list = list(
	/datum/job_department/entertainment,
	)

	job_flags = STATION_JOB_FLAGS|JOB_NEW_PLAYER_JOINABLE

/datum/outfit/job/escort
	name = "Escort"
	jobtype = /datum/job/escort

	id_trim = /datum/id_trim/job/escort
	uniform = /obj/item/clothing/under/dress/midnight
	gloves = /obj/item/clothing/gloves/silk
	ears = /obj/item/radio/headset/headset_srv
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/job/escort/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	uniform = initial(uniform)
	head = initial(head)
	gloves = initial(gloves)
	shoes = initial(shoes)
	var/choice = pick(
		"default",
		"bunny",
		"executive",
		"black_skirt",
		"buttondown",
		"pentagram",
		"strapless",
		"short_dress"
	)
	switch(choice)
		if("bunny")
			uniform = /obj/item/clothing/under/costume/bunnylewd
			head = /obj/item/clothing/head/playbunnyears
			gloves = /obj/item/clothing/gloves/evening
			shoes = /obj/item/clothing/shoes/high_heels
		if("executive")
			uniform = /obj/item/clothing/under/suit/skyrat/black_really_collared/skirt
			shoes = /obj/item/clothing/shoes/high_heels
		if("black_skirt")
			uniform = /obj/item/clothing/under/dress/skirt
			shoes = /obj/item/clothing/shoes/high_heels
		if("buttondown")
			uniform = /obj/item/clothing/under/costume/buttondown/skirt
			shoes = /obj/item/clothing/shoes/high_heels
		if("pentagram")
			uniform = /obj/item/clothing/under/dress/skyrat/pentagram
			shoes = /obj/item/clothing/shoes/high_heels
		if("strapless")
			uniform = /obj/item/clothing/under/dress/skyrat/strapless
			shoes = /obj/item/clothing/shoes/high_heels
		if("short_dress")
			uniform = /obj/item/clothing/under/dress/skyrat/short_dress
			shoes = /obj/item/clothing/shoes/high_heels

/datum/outfit/job/escort/get_types_to_preload()
	. = ..()
	. += list(
		/obj/item/clothing/under/costume/bunnylewd,
		/obj/item/clothing/head/playbunnyears,
		/obj/item/clothing/gloves/evening,
		/obj/item/clothing/shoes/high_heels,
		/obj/item/clothing/under/suit/skyrat/black_really_collared/skirt,
		// === Новые ===
		/obj/item/clothing/under/dress/skirt,
		/obj/item/clothing/under/costume/buttondown/skirt,
		/obj/item/clothing/under/dress/skyrat/pentagram,
		/obj/item/clothing/under/dress/skyrat/strapless,
		/obj/item/clothing/under/dress/skyrat/short_dress
	)
