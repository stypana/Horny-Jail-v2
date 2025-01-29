// OOC Escape code in case of pref-breaking or predators going AFK. What was the safe word, again?

/mob/living/proc/escapeOOC()
	set name = "OOC Escape"
	set category = "IC"

	if(istype(loc, /obj/item/dogborg/sleeper))
		var/obj/item/dogborg/sleeper/this_sleeper = loc

		var/confirmation = alert(src, "You're currently in a dogborg sleeper. This is meant for escaping from preference-breaking or if your predator disconnects/AFKs only. You can also resist out naturally too.", "Attention!", "Confirm", "Cancel")
		if(!confirmation == "Confirm" || loc != this_sleeper)
			return
		// Ejecting the sleeper's occupant. There you go buddy cham pal friend bucko friend pal chum
		this_sleeper.go_out(src)
		message_admins("[src] 'OOC Escape'-d from a dogborg sleeper.")
		log_ooc("[src] 'OOC Escape'-d from a dogborg sleeper.")
	else
		to_chat(src,"<span class='alert'>You aren't inside anyone, though, is the thing.</span>")
