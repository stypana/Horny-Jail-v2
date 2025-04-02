/mob/living/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced, filterproof, message_range, datum/saymode/saymode, list/message_mods)
	. = ..()
	if(. && !message_mods[MODE_CUSTOM_SAY_ERASE_INPUT] && !last_words)
		last_words = message
