/datum/preference_middleware/loadout/get_ui_static_data(mob/user)
	. = ..()

	if(!.["is_donator"])
		return

	.["SUPPORTER_TIER"] = GLOB.supporter_list[user.client.ckey]
