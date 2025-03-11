/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1
	category = EVENT_CATEGORY_SPACE
	//VENUS EDIT: Changed description to reflect that hallways are least shielded from radiation (using hallway radstorm)
	// description = "Radiation storm affects the station, forcing the crew to escape to maintenance."
	description = "Radiation storm affects the station, forcing the crew to escape away from hallways."
	min_wizard_trigger_potency = 3
	max_wizard_trigger_potency = 7

/datum/round_event/radiation_storm


/datum/round_event/radiation_storm/setup()
	start_when = 3
	end_when = start_when + 1
	announce_when = 1

/datum/round_event/radiation_storm/announce(fake)
	//VENUS EDIT: Changed announcement to reflect that hallways are least shielded from radiation (using hallway radstorm)
	// priority_announce("High levels of radiation detected near the station. Maintenance is best shielded from radiation.", "Anomaly Alert", ANNOUNCER_RADIATION)
	priority_announce("High levels of radiation detected near the station. Station hallways are least shielded from radiation - please evacuate hallways until the threat has passed.", "Anomaly Alert", ANNOUNCER_RADIATION)
	//sound not longer matches the text, but an audible warning is probably good

/datum/round_event/radiation_storm/start()
	SSweather.run_weather(/datum/weather/rad_storm/hallway) //VENUS: Use hallway radstorm
