/datum/round_event_control/antagonist/New()
	. = ..()
	if(!(tags & TAG_OPFOR_ONLY))
		tags |= TAG_OPFOR_ONLY
