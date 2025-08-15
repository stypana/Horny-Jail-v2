/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	inhand_icon_state = "greyscale_gloves"
	lefthand_file = 'icons/mob/inhands/clothing/gloves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/gloves_righthand.dmi'
	greyscale_colors = null
	greyscale_config_inhand_left = /datum/greyscale_config/gloves_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/gloves_inhand_right
	siemens_coefficient = 0.5
	body_parts_covered = HANDS
	slot_flags = ITEM_SLOT_GLOVES
	drop_sound = 'sound/items/handling/glove_drop.ogg'
	pickup_sound = 'sound/items/handling/glove_pick_up.ogg'
	attack_verb_continuous = list("challenges")
	attack_verb_simple = list("challenge")
	strip_delay = 20
	equip_delay_other = 40
	article = "a pair of"

	// Path variable. If defined, will produced the type through interaction with wirecutters.
	var/cut_type = null
	/// Used for handling bloody gloves leaving behind bloodstains on objects. Will be decremented whenever a bloodstain is left behind, and be incremented when the gloves become bloody.
	var/transfer_blood = 0
	/// The max number of accessories we can have on these gloves.
	max_number_of_accessories = 2

/obj/item/clothing/gloves/Initialize(mapload)
       . = ..()
       flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1
       AddElement(/datum/element/update_icon_updates_onmob, flags = ITEM_SLOT_GLOVES, body = TRUE)

/obj/item/clothing/gloves/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	var/changed = FALSE
	if(istype(held_item, /obj/item/clothing/accessory) && length(attached_accessories) < max_number_of_accessories)
		context[SCREENTIP_CONTEXT_LMB] = "Attach accessory"
		changed = TRUE
	if(LAZYLEN(attached_accessories))
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Remove accessory"
		changed = TRUE
	return changed ? CONTEXTUAL_SCREENTIP_SET : .

/obj/item/clothing/gloves/apply_fantasy_bonuses(bonus)
	. = ..()
	siemens_coefficient = modify_fantasy_variable("siemens_coefficient", siemens_coefficient, -bonus / 10)

/obj/item/clothing/gloves/remove_fantasy_bonuses(bonus)
	siemens_coefficient = reset_fantasy_variable("siemens_coefficient", siemens_coefficient)
	return ..()

/obj/item/clothing/gloves/wash(clean_types)
	. = ..()
	if((clean_types & CLEAN_TYPE_BLOOD) && transfer_blood > 0)
		transfer_blood = 0
		. |= COMPONENT_CLEANED|COMPONENT_CLEANED_GAIN_XP

/obj/item/clothing/gloves/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("\the [src] are forcing [user]'s hands around [user.p_their()] neck! It looks like the gloves are possessed!"))
	return OXYLOSS

/obj/item/clothing/gloves/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damagedgloves")
	if(accessory_overlay)
		. += accessory_overlay

/obj/item/clothing/gloves/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands, icon_file)
	. = ..()
	if (isinhands)
		return
	var/blood_overlay = get_blood_overlay("glove")
	if (blood_overlay)
		. += blood_overlay

/obj/item/clothing/gloves/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_worn_gloves()

/obj/item/clothing/gloves/proc/can_cut_with(obj/item/tool)
	if(!cut_type)
		return FALSE
	if(icon_state != initial(icon_state))
		return FALSE // We don't want to cut dyed gloves.
	return TRUE

/obj/item/clothing/gloves/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/clothing/accessory))
		return attach_accessory(attacking_item, user)
	. = ..()
	if(.)
		return
	if(attacking_item.tool_behaviour != TOOL_WIRECUTTER && !attacking_item.get_sharpness())
		return
	if (!can_cut_with(attacking_item))
		return
	balloon_alert(user, "cutting off fingertips...")

	if(!do_after(user, 3 SECONDS, target=src, extra_checks = CALLBACK(src, PROC_REF(can_cut_with), attacking_item)))
		return
	balloon_alert(user, "cut fingertips off")
	qdel(src)
	user.put_in_hands(new cut_type)
	return TRUE

/obj/item/clothing/gloves/proc/attach_accessory(obj/item/clothing/accessory/accessory, mob/living/user, attach_message = TRUE)
	if(!istype(accessory))
		return
	if(!accessory.can_attach_accessory(src, user))
		return
	if(user && !user.temporarilyRemoveItemFromInventory(accessory))
		return
	if(!accessory.attach(src, user))
		return

	LAZYADD(attached_accessories, accessory)
	accessory.forceMove(src)
	accessory.successful_attach(src)

	if(user && attach_message)
		balloon_alert(user, "accessory attached")

	if(isnull(accessory_overlay))
		create_accessory_overlay()

	update_appearance()
	return TRUE

/obj/item/clothing/gloves/proc/pop_accessory(mob/living/user, attach_message = TRUE)
	var/obj/item/clothing/accessory/popped_accessory = attached_accessories[1]
	remove_accessory(popped_accessory)

	if(!user)
		return

	user.put_in_hands(popped_accessory)
	if(attach_message)
		popped_accessory.balloon_alert(user, "accessory removed")

/obj/item/clothing/gloves/remove_accessory(obj/item/clothing/accessory/removed)
	if(removed == attached_accessories[1])
		accessory_overlay = null

	LAZYREMOVE(attached_accessories, removed)
	removed.detach(src)

	if(isnull(accessory_overlay) && LAZYLEN(attached_accessories))
		create_accessory_overlay()

	update_appearance()

/obj/item/clothing/gloves/proc/create_accessory_overlay()
	var/obj/item/clothing/accessory/prime_accessory = attached_accessories[1]
	var/overlay_state = prime_accessory.worn_icon_state ? prime_accessory.worn_icon_state : prime_accessory.icon_state
	accessory_overlay = mutable_appearance(prime_accessory.worn_icon, overlay_state)
	accessory_overlay.alpha = prime_accessory.alpha
	accessory_overlay.color = prime_accessory.color

/obj/item/clothing/gloves/update_accessory_overlay()
	if(isnull(accessory_overlay))
		return

	cut_overlay(accessory_overlay)
	create_accessory_overlay()
	update_appearance()

/obj/item/clothing/gloves/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in attached_accessories)
		remove_accessory(gone)

/obj/item/clothing/gloves/proc/dump_attachments(atom/drop_to = drop_location())
	for(var/obj/item/clothing/accessory/worn_accessory as anything in attached_accessories)
		remove_accessory(worn_accessory)
		worn_accessory.forceMove(drop_to)

/obj/item/clothing/gloves/atom_destruction(damage_flag)
	dump_attachments()
	return ..()

/obj/item/clothing/gloves/Destroy()
	QDEL_LAZYLIST(attached_accessories)
	return ..()

/obj/item/clothing/gloves/click_alt_secondary(mob/user)
	if(!LAZYLEN(attached_accessories))
		balloon_alert(user, "no accessories to remove!")
		return
	pop_accessory(user)

/obj/item/clothing/gloves/examine(mob/user)
	. = ..()
	if(LAZYLEN(attached_accessories))
		. += "Alt-Right-Click to remove [attached_accessories[1]]."
	return .
