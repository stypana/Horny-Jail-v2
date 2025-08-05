SUBSYSTEM_DEF(admins)
	name = "Admins"
	flags = SS_NO_FIRE
	init_stage = INITSTAGE_EARLY
	/// Handles admin data loading

/datum/controller/subsystem/admins/Initialize()
	load_admins_from_json()
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(load_admins), FALSE, TRUE)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/admins/Start()
	return SS_INIT_SUCCESS
