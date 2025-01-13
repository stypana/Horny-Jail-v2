/**
 * Custom emote panel preference handler
 */
/datum/preference/choiced/custom_emote_panel
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "custom_emote_panel"
	savefile_identifier = PREFERENCE_CHARACTER

/**
 * Creates default empty list for new characters
 */
/datum/preference/choiced/custom_emote_panel/create_default_value()
	return list()

/**
 * Saves custom emotes to character slot
 * Returns TRUE on success, FALSE on failure
 */
/datum/preferences/proc/save_custom_emotes()
	if(!path)
		return FALSE

	var/tree_key = "character[default_slot]"
	if(!(tree_key in savefile.get_entry()))
		return FALSE

	var/save_data = savefile.get_entry(tree_key)
	save_data["custom_emote_panel"] = custom_emote_panel
	savefile.save()
	return TRUE
