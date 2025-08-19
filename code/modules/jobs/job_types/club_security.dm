/datum/job/club_security
	title = JOB_CLUB_SECURITY
	description = "Maintain order within the entertainment venues."
	department_head = list(JOB_SOUTENEUR)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Souteneur"
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "CLUBSEC"

	outfit = /datum/outfit/job/club_security
	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_CLUB_SECURITY
	department_for_prefs = /datum/job_department/entertainment
	departments_list = list(
	/datum/job_department/entertainment,
	)

	job_flags = STATION_JOB_FLAGS|JOB_NEW_PLAYER_JOINABLE

/datum/outfit/job/club_security
	name = "Club Security"
	jobtype = /datum/job/club_security

	id_trim = /datum/id_trim/job/club_security
	uniform = /obj/item/clothing/under/pants/jeans
	suit = /obj/item/clothing/suit/jacket/leather
	head = /obj/item/clothing/head/beanie/black
	ears = /obj/item/radio/headset/headset_srv
	shoes = /obj/item/clothing/shoes/jackboots
