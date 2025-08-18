SUBSYSTEM_DEF(vending_icon_cache)

/datum/controller/subsystem/vending_icon_cache
	name = "Vending Icon Cache"
	flags = SS_NO_FIRE
	var/list/icon_states_cache = list()

/datum/controller/subsystem/vending_icon_cache/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/vending_icon_cache/proc/get_icon_states(icon_file)
	if(isnull(icon_file))
		return list()
	var/list/cached = icon_states_cache[icon_file]
	if(isnull(cached))
		cached = icon_states(icon_file)
		icon_states_cache[icon_file] = cached
	return cached
