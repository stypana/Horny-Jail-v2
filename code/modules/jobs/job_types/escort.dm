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
	departments_list = list(
		/datum/job_department/entertainment,
	)

	job_flags = STATION_JOB_FLAGS

/datum/outfit/job/escort
	name = "Escort"
	jobtype = /datum/job/escort

	id_trim = /datum/id_trim/job/escort
	uniform = /obj/item/clothing/under/dress/midnight
	gloves = /obj/item/clothing/gloves/silk
	ears = /obj/item/radio/headset/headset_srv
	shoes = /obj/item/clothing/shoes/sneakers/black
