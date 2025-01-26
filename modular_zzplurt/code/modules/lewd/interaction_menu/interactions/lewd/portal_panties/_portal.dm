/datum/interaction/lewd/portal
	category = INTERACTION_CAT_HIDE

	/// Messages used when the interaction is anonymous
	var/list/hidden_message = list()
	/// User messages used when the portal panties are anonymous
	var/list/hidden_user_messages = list()
	/// Target messages used when the portal fleshlight is anonymous
	var/list/hidden_target_messages = list()

	/// Hidden climax message overrides for anonymous interactions
	var/list/hidden_cum_message_text_overrides = list(CLIMAX_POSITION_USER = list(), CLIMAX_POSITION_TARGET = list())
	/// Hidden climax self message overrides for anonymous interactions
	var/list/hidden_cum_self_text_overrides = list(CLIMAX_POSITION_USER = list(), CLIMAX_POSITION_TARGET = list())
	/// Hidden climax partner message overrides for anonymous interactions
	var/list/hidden_cum_partner_text_overrides = list(CLIMAX_POSITION_USER = list(), CLIMAX_POSITION_TARGET = list())

/datum/interaction/lewd/portal/act(mob/living/user, mob/living/target)
	var/list/original_message = message.Copy()
	var/list/original_user_messages = user_messages?.Copy()
	var/list/original_target_messages = target_messages?.Copy()

	// TODO: Replace these with actual item checks once implemented
	var/portal_fleshlight_anonymous = FALSE // Replace with actual check
	var/portal_panties_anonymous = FALSE // Replace with actual check

	if(portal_fleshlight_anonymous && length(hidden_target_messages))
		target_messages = hidden_target_messages.Copy()

	if(portal_panties_anonymous && length(hidden_user_messages))
		user_messages = hidden_user_messages.Copy()

	if((portal_fleshlight_anonymous || portal_panties_anonymous) && length(hidden_message))
		message = hidden_message.Copy()

	. = ..()

	// Restore original messages
	message = original_message
	if(length(original_user_messages))
		user_messages = original_user_messages
	if(length(original_target_messages))
		target_messages = original_target_messages

/datum/interaction/lewd/portal/show_climax(mob/living/cumming, mob/living/came_in, position)
	var/portal_fleshlight_anonymous = FALSE // Replace with actual check
	var/portal_panties_anonymous = FALSE // Replace with actual check

	// Store original climax messages
	var/list/original_cum_message = cum_message_text_overrides.Copy()
	var/list/original_cum_self = cum_self_text_overrides.Copy()
	var/list/original_cum_partner = cum_partner_text_overrides.Copy()

	// Replace with anonymous messages if needed
	var/is_anonymous = (portal_fleshlight_anonymous && position == CLIMAX_POSITION_TARGET) || (portal_panties_anonymous && position == CLIMAX_POSITION_USER)
	if(is_anonymous && length(hidden_cum_message_text_overrides[position]))
		cum_message_text_overrides[position] = hidden_cum_message_text_overrides[position]
		cum_self_text_overrides[position] = hidden_cum_self_text_overrides[position]
		cum_partner_text_overrides[position] = hidden_cum_partner_text_overrides[position]

	. = ..()

	// Restore original climax messages
	cum_message_text_overrides[position] = original_cum_message[position]
	cum_self_text_overrides[position] = original_cum_self[position]
	cum_partner_text_overrides[position] = original_cum_partner[position]
