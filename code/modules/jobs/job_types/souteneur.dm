/datum/job/souteneur
	title = JOB_SOUTENEUR
	description = "Oversee the station's nightlife operations."
	department_head = list()
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOP
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "SOUTENEUR"

	outfit = /datum/outfit/job/souteneur
	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
       display_order = JOB_DISPLAY_ORDER_SOUTENEUR
       department_for_prefs = /datum/job_department/entertainment
       departments_list = list(
               /datum/job_department/entertainment,
       )

       job_flags = STATION_JOB_FLAGS
       job_flags |= JOB_NEW_PLAYER_JOINABLE

/datum/outfit/job/souteneur
	name = "Souteneur"
	jobtype = /datum/job/souteneur

	id_trim = /datum/id_trim/job/souteneur
	head = /obj/item/clothing/head/hats/pimp
	uniform = /obj/item/clothing/under/suit/pimp
	suit = /obj/item/clothing/suit/jacket/pimp
	gloves = /obj/item/clothing/gloves/silk
	r_hand = /obj/item/cane/golden
	belt = /obj/item/modular_computer/pda
	ears = /obj/item/radio/headset/headset_srv
	shoes = /obj/item/clothing/shoes/laceup

/datum/outfit/job/souteneur/pre_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	if(H.gender == FEMALE)
		head = null
		uniform = /obj/item/clothing/under/dress/midnight
		suit = null
		gloves = /obj/item/clothing/gloves/silk
		shoes = /obj/item/clothing/shoes/highheels
		r_hand = /obj/item/cane/luminous
	else
		head = /obj/item/clothing/head/hats/pimp
		uniform = /obj/item/clothing/under/suit/pimp
		suit = /obj/item/clothing/suit/jacket/pimp
		gloves = /obj/item/clothing/gloves/silk
		shoes = /obj/item/clothing/shoes/laceup
		r_hand = /obj/item/cane/golden
	. = ..()
