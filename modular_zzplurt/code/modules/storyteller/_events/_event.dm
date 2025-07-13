/datum/round_event_control/New()
	. = ..()
	if(!(tags & TAG_OPFOR_ONLY) && (tags & TAG_CREW_ANTAG))
		tags |= TAG_OPFOR_ONLY
