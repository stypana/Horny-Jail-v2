/obj/item/clothing/sextoy/portalpanties
	name = "portal panties"
	desc = "A pair of panties with bluespace tech allowing lovers to hump at a distance. Needs to be paired with a portal fleshlight before use."
	icon = 'modular_zzplurt/icons/obj/lewd/fleshlight.dmi'
	icon_state = "portalpanties"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_MASK
	extra_slot_flags = ITEM_SLOT_UNDERWEAR
	lewd_slot_flags = LEWD_SLOT_PENIS | LEWD_SLOT_VAGINA | LEWD_SLOT_ANUS
	var/obj/item/clothing/sextoy/portallight/linked_fleshlight = null
	var/current_target = null
	var/equipped_slot = null
	/// Whether the panties' wearer is anonymous
	var/anonymous = FALSE

/obj/item/clothing/sextoy/portalpanties/examine(mob/user)
	. = ..()
	if(!linked_fleshlight)
		. += span_notice("The status light is off. The device needs to be paired with a portal fleshlight.")
		return

	. += span_notice("The status light is [equipped_slot ? "on" : "off"]. The portal is [equipped_slot ? "open" : "closed"].")
	if(equipped_slot)
		. += span_notice("The current target is: [current_target]")

/obj/item/clothing/sextoy/portalpanties/attackby(obj/item/W, mob/user, params)
	. = ..()
	var/obj/item/clothing/sextoy/portallight/portal_toy = W
	if(!istype(portal_toy))
		return
	portal_toy.link_panties(src, user)

/obj/item/clothing/sextoy/portalpanties/lewd_equipped(mob/living/carbon/human/user, slot, initial)
	. = ..()
	update_target(user, slot)

/obj/item/clothing/sextoy/portalpanties/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	update_target(user, slot)

/obj/item/clothing/sextoy/portalpanties/dropped(mob/living/carbon/human/user)
	. = ..()
	update_target(user)

/obj/item/clothing/sextoy/portalpanties/proc/update_target(mob/living/carbon/human/user, slot)
	if(!istype(user))
		return

	equipped_slot = slot

	switch(slot)
		if(ITEM_SLOT_UNDERWEAR)
			if(ismob(loc))
				var/mob/living/carbon/human/H = loc
				if(H.has_vagina())
					current_target = ORGAN_SLOT_VAGINA
				else if(H.has_penis())
					current_target = ORGAN_SLOT_PENIS
				else
					current_target = ORGAN_SLOT_ANUS
		if(ITEM_SLOT_MASK)
			current_target = BODY_ZONE_PRECISE_MOUTH
		if(ORGAN_SLOT_PENIS)
			current_target = ORGAN_SLOT_PENIS
		if(ORGAN_SLOT_VAGINA)
			current_target = ORGAN_SLOT_VAGINA
		if(ORGAN_SLOT_ANUS)
			current_target = ORGAN_SLOT_ANUS
		else
			current_target = null

	if(linked_fleshlight)
		linked_fleshlight.update_appearance()
	else if(slot in list(ITEM_SLOT_UNDERWEAR, ITEM_SLOT_MASK, ORGAN_SLOT_PENIS, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS))
		audible_message("[icon2html(src, hearers(src))] *beep* *beep* *beep*")
		playsound(src, 'sound/machines/beep/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
		to_chat(user, span_notice("The panties are not linked to a portal fleshlight."))

/obj/item/clothing/sextoy/portalpanties/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	anonymous = !anonymous
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	to_chat(user, span_notice("You toggle anonymous mode [anonymous ? "on" : "off"]."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/sextoy/portalpanties/Destroy()
	if(linked_fleshlight)
		linked_fleshlight.unlink_panties()
		linked_fleshlight = null
	return ..()
