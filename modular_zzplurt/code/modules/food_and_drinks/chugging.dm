/obj/item/reagent_containers/cup/glass
	var/beingChugged = FALSE // For checking

/obj/item/reagent_containers/cup/glass/attack(mob/living/target_mob, mob/living/user, obj/target)
	if(!canconsume(target_mob, user))
		return

	if(!spillable)
		return

	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src] is empty!"))
		return

	if(!istype(target_mob))
		return

	var/gulp_amount = gulp_size
	if(target_mob != user)
		target_mob.visible_message(span_danger("[user] attempts to feed [target_mob] something from [src]."), \
					span_userdanger("[user] attempts to feed you something from [src]."))
		if(!do_after(user, 3 SECONDS, target_mob))
			return
		if(!reagents || !reagents.total_volume)
			return // The drink might be empty after the delay, such as by spam-feeding
		target_mob.visible_message(span_danger("[user] feeds [target_mob] something from [src]."), \
					span_userdanger("[user] feeds you something from [src]."))
		log_combat(user, target_mob, "fed", reagents.get_reagent_log_string())
	else
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH && !beingChugged)
			beingChugged = TRUE
			user.visible_message("<span class='notice'>[user] starts chugging [src].</span>", \
				"<span class='notice'>You start chugging [src].</span>")
			if(!do_after(user, 3 SECONDS, target_mob))
				beingChugged = FALSE
				return
			if(!reagents || !reagents.total_volume)
				beingChugged = FALSE
				return
			gulp_amount = 50
			user.visible_message(span_notice("[user] chugs [src]."), \
				span_notice("You chug [src]."))
			beingChugged = FALSE
		else
			to_chat(user, span_notice("You swallow a gulp of [src]."))

	SEND_SIGNAL(src, COMSIG_GLASS_DRANK, target_mob, user)
	SEND_SIGNAL(target_mob, COMSIG_GLASS_DRANK, src, user) // SKYRAT EDIT ADDITION - Hemophages can't casually drink what's not going to regenerate their blood
	var/fraction = min(gulp_amount/reagents.total_volume, 1)
	reagents.trans_to(target_mob, gulp_amount, transferred_by = user, methods = INGEST)
	checkLiked(fraction, target_mob)
	playsound(target_mob.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
	if(!iscarbon(target_mob))
		return
	var/mob/living/carbon/carbon_drinker = target_mob
	var/list/diseases = carbon_drinker.get_static_viruses()
	if(!LAZYLEN(diseases))
		return
	var/list/datum/disease/diseases_to_add = list()
	for(var/datum/disease/malady as anything in diseases)
		if(malady.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
			diseases_to_add += malady
	if(LAZYLEN(diseases_to_add))
		AddComponent(/datum/component/infective, diseases_to_add)
