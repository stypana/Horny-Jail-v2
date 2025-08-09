/turf/open/indestructible/boss/necropolis
	icon = 'modules/code/icons/new_necropolis.dmi'
	name = "necropolis floor"

/turf/open/indestructible/boss/necropolis/tile1
	icon_state = "necropolis_floor1"

/turf/open/indestructible/boss/necropolis/tile2
	icon_state = "necropolis_floor2"

/turf/open/indestructible/boss/necropolis/tile3
	icon_state = "necropolis_floor3"

/turf/open/indestructible/boss/necropolis/tile4
	icon_state = "necropolis_floor4"

/turf/open/indestructible/boss/necropolis/fakechasm
	name = "chasm"
	desc = "Watch your step."
	icon = 'icons/turf/floors/junglechasm.dmi'
	icon_state = "junglechasm-255"
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/chasm/jungle/necropolis
	smoothing_flags = NONE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = FALSE

/area/lavaland/surface/necropolis
	area_flags = NOTELEPORT | FLORA_ALLOWED | EVENT_PROTECTED
	requires_power = FALSE

/area/lavaland/surface/necropolis/cult
	area_flags = FLORA_ALLOWED | EVENT_PROTECTED | CULT_PERMITTED

/obj/machinery/door/puzzle/keycard/gates
	gender = PLURAL
	name = "locked gates"
	desc = "A gate made out of hard metal. Opens with a key."
	icon = 'icons/obj/doors/gates.dmi'
	icon_state = "door_closed"
	layer = BLASTDOOR_LAYER
	closingLayer = BLASTDOOR_LAYER
	glass = TRUE
	opacity = FALSE
	move_resist = MOVE_FORCE_OVERPOWERING
	open_message = "You bring key to gates and it opens."
	var/animation_sound = 'sound/machines/airlock/gate.ogg'

/obj/machinery/door/puzzle/keycard/gates/animation_effects(animation)
	switch(animation)
		if(DOOR_OPENING_ANIMATION)
			playsound(src, animation_sound, 50, TRUE)

/obj/machinery/door/puzzle/keycard/gates/animation_segment_delay(animation)
	switch(animation)
		if(DOOR_OPENING_PASSABLE)
			return 2 SECONDS
		if(DOOR_OPENING_FINISHED)
			return 2.4 SECONDS


/obj/machinery/door/puzzle/keycard/gates/necropolis
	name = "locked gates"


/obj/machinery/door/puzzle/keycard/gates/necropolis/legion
	puzzle_id = "legion"
	name = "locked gates"

/obj/machinery/door/puzzle/keycard/gates/necropolis/gladiator
	puzzle_id = "gladiator"
	name = "locked gates"

/obj/machinery/door/puzzle/keycard/gates/necropolis/cultist
	puzzle_id = "cultist"
	name = "locked gates"
	glass = FALSE

/obj/item/keycard/legion
	name = "Pulsating Key"
	desc = "A key with a legion core on it.. It feels very wet and unpleasent to touch.. I guess better not to lose it."
	icon_state = "legion_key"
	puzzle_id = "legion"

/obj/item/keycard/gladiator
	name = "Ominous Key"
	desc = "Strange grey key with two holes on top.. Wait.. Does this thing just looked at me?!"
	icon_state = "gladiator_key"
	puzzle_id = "gladiator"

/obj/item/keycard/cultist
	name = "Pentagramm Key"
	desc = "A key with a pentagramm on it.. I think I see my reflection then.. Fuck! Is this blood?!"
	icon_state = "cultist_key"
	puzzle_id = "cultist"

/obj/item/guardian_creator/miner/notrandom
	random = FALSE

/obj/structure/closet/crate/necropolis_open
	name = "necropolis chest"
	desc = "It's watching you closely."
	icon_state = "necrocrate"
	base_icon_state = "necrocrate"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	can_install_electronics = FALSE
	paint_jobs = null
	can_weld_shut = FALSE
	integrity_failure = 0

/obj/structure/closet/crate/necropolis_open/PopulateContents()
	var/loot = rand(1,16)
	switch(loot)
		if(1)
			new /obj/item/shared_storage/red(src)
		if(2)
			new /obj/item/soulstone/anybody/mining(src)
		if(3)
			new /obj/item/organ/cyberimp/arm/toolkit/shard/katana(src)
		if(4)
			new /obj/item/clothing/glasses/godeye(src)
		if(5)
			new /obj/item/reagent_containers/cup/bottle/potion/flight(src)
		if(6)
			new /obj/item/clothing/gloves/gauntlets(src)
		if(7)
			new /obj/item/organ/heart/cursed/wizard(src)
		if(8)
			new /obj/item/clothing/suit/hooded/berserker(src)
		if(9)
			new /obj/item/guardian_creator/miner(src)
		if(10)
			new /obj/item/warp_cube/red(src)
		if(11)
			new /obj/item/wisp_lantern(src)
		if(12)
			new /obj/item/book/granter/action/spell/summonitem(src)
		if(13)
			new /obj/item/book_of_babel(src)
		if(14)
			new /obj/item/clothing/neck/necklace/memento_mori(src)
		if(15)
			new /obj/item/clothing/gloves/fingerless/punch_mitts(src)
			new /obj/item/clothing/head/cowboy(src)


/obj/structure/closet/crate/necropolis_open/major

/obj/structure/closet/crate/necropolis_open/major/PopulateContents()
	var/loot = rand(1,9)
	switch(loot)
		if(1)
			new /obj/item/cain_and_abel(src)
		if(2)
			new /obj/item/clothing/suit/hooded/cloak/drake(src)
		if(3)
			new /obj/item/dice/d20/fate(src)
		if(4)
			new /obj/item/melee/energy/sword/bananium(src)
		if(5)
			new /obj/item/gun/magic/staff/spellblade(src)
		if(6)
			new /obj/item/guardian_creator/miner/notrandom(src)
		if(7)
			new /obj/item/gun/magic/hook(src)
		if(8)
			new /obj/item/crusher_trophy/demon_claws(src)
		if(9)
			new /obj/item/crusher_trophy/wendigo_horn(src)

/mob/living/simple_animal/hostile/megafauna/cult_templar
	name = "cult templar"
	desc = "Forever a servant of the Nar'sie, this cultist has gone more insane than what is considered the normal insanity for cultist. They forever seek battle, waiting for sacrifices to battle them."
	health = 1000
	maxHealth = 1000
	icon_state = "cult_templar"
	icon_living = "cult_templar"
	icon = 'modules/code/icons/new_necropolis.dmi'
	faction = list("cult","boss")
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	light_color = "#FFFFFF"
	movement_type = GROUND
	speak_emote = list("echoes")
	speed = 3
	move_to_delay = 3
	light_range = 6
	projectiletype = /obj/projectile/bullet/chaos_bomb
	ranged = TRUE
	ranged_cooldown_time = 20
	vision_range = 10
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 0.5, CLONE = 0.5, STAMINA = 0, OXY = 0.5)
	loot = list(/obj/structure/closet/crate/necropolis_open/major, /obj/item/clothing/suit/hooded/cultrobes/hardened, /obj/item/keycard/cultist)
	wander = FALSE
	del_on_death = TRUE
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "Chaotic Signal"
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = 'sound/effects/magic/curse.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/blood_dash,
								/datum/action/innate/megafauna_attack/teleport_b,
								/datum/action/innate/megafauna_attack/runic_blast,
								/datum/action/innate/megafauna_attack/infernal_summon,
								/datum/action/innate/megafauna_attack/blast,
								/datum/action/innate/megafauna_attack/rapid_fire)
	move_force = MOVE_FORCE_NORMAL
	var/obj/item/claymore/weapon
	var/turf/starting
	var/charging = FALSE
	var/dash_cooldown = 6 SECONDS
	var/runic_blast_cooldown = 14 SECONDS
	var/teleport_cooldown = 6 SECONDS
	var/infernal_summon_cooldown = 30 SECONDS
	var/dash_mod = 0.9
	var/dash_num = 3
	var/newcolor = rgb(149, 10, 10)

/mob/living/simple_animal/hostile/megafauna/cult_templar/Initialize()
	. = ..()
	starting = get_turf(src)
	weapon = new(src)

/turf/closed/indestructible/cult
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult_wall-255"

/turf/open/indestructible/cult
	icon = 'icons/turf/floors.dmi'
	icon_state = "cult"
	initial_gas_mix = OPENTURF_LOW_PRESSURE

/datum/action/innate/megafauna_attack/blood_dash
	name = "Blood Dash"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = span_colossus("You are now dashing through your enemies, piercing everyone caught in your path.")
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/runic_blast
	name = "Runic Blast"
	button_icon = 'icons/obj/antags/cult/rune.dmi'
	button_icon_state = "4"
	chosen_message = span_colossus("You are now setting up a big explosion, with a delay.")
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/blast
	name = "Blast"
	button_icon = 'icons/obj/weapons/guns/projectiles.dmi'
	button_icon_state = "blood_bolt"
	chosen_message = span_colossus("You are now shooting at your enemy with explosive bullets.")
	chosen_attack_num = 3

/datum/action/innate/megafauna_attack/infernal_summon
	name = "Infernal Summon"
	button_icon = 'icons/mob/simple/demon.dmi'
	button_icon_state = "imp"
	chosen_message = span_colossus("You will now summon demons to assist you.")
	chosen_attack_num = 4

/datum/action/innate/megafauna_attack/teleport_b
	name = "Teleport"
	button_icon = 'icons/obj/weapons/guns/projectiles.dmi'
	button_icon_state = "bluespace"
	chosen_message = span_colossus("You will now teleport next to your target.")
	chosen_attack_num = 5

/datum/action/innate/megafauna_attack/rapid_fire
	name = "Rapid Fire"
	button_icon = 'icons/obj/weapons/guns/projectiles.dmi'
	button_icon_state = "blood_bolt"
	chosen_message = span_colossus("You are now rapidly shooting at your enemy with explosive bullets (5).")
	chosen_attack_num = 6

/mob/living/simple_animal/hostile/megafauna/cult_templar/AttackingTarget()
	if(charging)
		return
	face_atom(target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.health <= HEALTH_THRESHOLD_DEAD || L.stat == DEAD) //To prevent memento mori limbo
			visible_message(span_danger("[src] butchers [L]!"),
			span_userdanger("You butcher [L], restoring your health!"))
			adjustHealth(-(L.maxHealth * 0.5))
			L.gib()
			if(ishuman(L)) // If target is a human - yell some funny shit.
				telegraph()
				say("Mah'weyh pleggh at e'ntrath!!")
			return TRUE
	weapon.melee_attack_chain(src, target)
	return TRUE

/mob/living/simple_animal/hostile/megafauna/cult_templar/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/adjustCMspeed()
	if(health <= maxHealth*0.25)
		speed = 4
		dash_mod = 0.4
		dash_num = 5
		rapid_melee = 3.5
	else if(health <= maxHealth*0.5)
		speed = 4.8
		dash_mod = 0.6
		dash_num = 4
		rapid_melee = 2.5
	else if(health <= maxHealth*0.75)
		speed = 5.4
		dash_mod = 1.5
		dash_num = initial(dash_num)
		rapid_melee = 2
	else if(health > maxHealth*0.75)
		speed = initial(speed)
		dash_mod = initial(dash_mod)
		dash_num = initial(dash_num)
		rapid_melee = initial(rapid_melee)

/mob/living/simple_animal/hostile/megafauna/cult_templar/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!used_item && !isturf(A))
		used_item = weapon
	..()

/mob/living/simple_animal/hostile/megafauna/cult_templar/OpenFire()
	adjustCMspeed()

	if(client)
		switch(chosen_attack)
			if(1)
				blood_dash(target)
			if(2)
				runic_blast()
			if(3)
				blast()
			if(4)
				infernal_summon()
			if(5)
				teleport_b(target)
			if(6)
				rapid_fire()
		return

	Goto(target, move_to_delay, minimum_distance)
	if(get_dist(src, target) >= 1 && dash_cooldown <= world.time && !charging)
		blood_dash(target)
	if(get_dist(src, target) > round(5*dash_mod) && teleport_cooldown <= world.time && !charging)
		teleport_b(target)
	if(get_dist(src, target) > 4 && ranged_cooldown <= world.time && !charging)
		if(health <= maxHealth*0.5)
			rapid_fire()
		else
			blast()
	if(get_dist(src, target) <= 3 && runic_blast_cooldown <= world.time && !charging)
		runic_blast()
	if(infernal_summon_cooldown <= world.time && !charging)
		infernal_summon()

/obj/projectile/bullet/chaos_bomb
	name ="bolter bullet"
	desc = "Oh god oh fu..."
	icon_state = "blood_bolt"
	damage = 20

/obj/projectile/bullet/chaos_bomb/on_hit(atom/target, blocked = FALSE, pierce_hit)
	..()
	explosion(target, -1, 0, 0, 0, 0, flame_range = 2)
	return BULLET_ACT_HIT

/obj/projectile/bullet/chaos_bomb/blood
	name = "blood bolt"
	icon_state = "mini_leaper"
	damage = 10
	nondirectional_sprite = TRUE
	impact_effect_type = /obj/effect/temp_visual/dir_setting/bloodsplatter

/mob/living/simple_animal/hostile/megafauna/cult_templar/ex_act(severity, target)
	return //Resistant to explosions

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/blood_dash(target)
	if(charging || dash_cooldown > world.time)
		return
	dash_cooldown = world.time + (initial(dash_cooldown) * dash_mod)
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/turf/T = get_step(get_turf(src), dir_to_target)
	for(var/i in 1 to dash_num)
		new /obj/effect/temp_visual/dragon_swoop/legionnaire(T)
		T = get_step(T, dir_to_target)
	addtimer(CALLBACK(src, PROC_REF(blood_dash_2), dir_to_target, 0), (5 * dash_mod))
	playsound(src,'sound/effects/meteorimpact.ogg', 200, 1)

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/blood_dash_2(move_dir, times_ran)
	if(times_ran >= dash_num)
		charging = FALSE
		return
	var/turf/T = get_step(get_turf(src), move_dir)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	if(T.density)
		charging = FALSE
		return
	for(var/obj/structure/window/W in T.contents)
		charging = FALSE
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			charging = FALSE
			return
	forceMove(T)
	playsound(src,"sound/effects/footstep/heavy[pick(1,2)].ogg", 200, 1)
	for(var/mob/living/L in T.contents - src)
		if(!faction_check_atom(L))
			visible_message(span_boldwarning("[src] runs through [L]!"))
			to_chat(L, span_userdanger("[src] pierces you with a longsword!"))
			explosion(L, -1, 0, 0, 0, 0, flame_range = 2)
			shake_camera(L, 4, 3)
			L.adjustBruteLoss(30)
			playsound(L,"sound/misc/desceration-[pick(1,2,3)].ogg", 200, 1)
	addtimer(CALLBACK(src, PROC_REF(blood_dash_2), move_dir, (times_ran + 1)), (1.5 * dash_mod))

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/teleport_b(target)
	if(charging || teleport_cooldown > world.time)
		return
	charging = TRUE
	telegraph()
	cmempower()
	var/turf/T = get_step(target, pick(1,2,4,8))
	var/turf/S = get_turf(src)
	if(T.density)
		T = get_turf(target)
	layer = 3
	SLEEP_CHECK_DEATH(3, src)
	new /obj/effect/temp_visual/cult/blood(S)
	SLEEP_CHECK_DEATH(1, src)
	new /obj/effect/temp_visual/cult/blood/out(T)
	SLEEP_CHECK_DEATH(2, src)
	forceMove(T)
	playsound(T,'sound/effects/magic/exit_blood.ogg', 200, 1)
	if(health <= maxHealth*0.5)
		layer = initial(layer)
		cmdepower()
		teleport_cooldown = world.time + (initial(teleport_cooldown) * dash_mod)
		charging = FALSE
		blood_dash(target)
	else
		SLEEP_CHECK_DEATH(5, src)
		layer = initial(layer)
		cmdepower()
		teleport_cooldown = world.time + (initial(teleport_cooldown) * dash_mod)
		charging = FALSE

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/blast()
	if(ranged_cooldown <= world.time && !Adjacent(target) && !charging)
		ranged_cooldown = world.time + ranged_cooldown_time
		visible_message(span_danger("[src] fires with bolter gun!"))
		face_atom(target)
		new /obj/effect/temp_visual/dir_setting/firing_effect(loc, dir)
		Shoot(target)
		changeNext_move(CLICK_CD_RANGE)

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/rapid_fire()
	if(ranged_cooldown <= world.time && !Adjacent(target) && !charging)
		ranged_cooldown = world.time + ranged_cooldown_time
		charging = TRUE
		visible_message(span_danger("[src] rapidly fires with bolter gun!"))
		face_atom(target)
		for(var/i = 1 to 5)
			new /obj/effect/temp_visual/dir_setting/firing_effect(loc, dir)
			Shoot(target)
			SLEEP_CHECK_DEATH(3, src)
		changeNext_move(CLICK_CD_RANGE)
		charging = FALSE

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/runic_blast()
	if(runic_blast_cooldown > world.time || charging)
		return
	var/turf/T = get_turf(src)
	var/dir_mod = pick(-1,1)
	charging = TRUE
	telegraph()
	cmempower()
	new /obj/effect/temp_visual/dragon_swoop/bubblegum(T)
	SLEEP_CHECK_DEATH(10, src)
	explosion(src, -1, 0, 3, 0, 0, flame_range = 4)
	SLEEP_CHECK_DEATH(5, src)
	for(var/i = 1 to 8)
		shoot_projectile(T, (i*dir_mod*45))
		if(src.health > src.maxHealth*0.5)
			SLEEP_CHECK_DEATH(3, src)
	SLEEP_CHECK_DEATH(15, src)
	cmdepower()
	runic_blast_cooldown = (world.time + initial(runic_blast_cooldown))
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/infernal_summon()
	if(infernal_summon_cooldown > world.time || charging)
		return
	charging = TRUE
	cmempower()
	var/turf/T = get_turf(src)
	var/turf/X1 = get_step(T, pick(1,2))
	var/turf/X2 = get_step(T, pick(4,8))
	telegraph()
	new /obj/effect/temp_visual/cult/sparks(X1)
	new /obj/effect/temp_visual/cult/sparks(X2)
	SLEEP_CHECK_DEATH(25, src)
	telegraph()
	new /obj/effect/temp_visual/cult/sparks(X1)
	new /obj/effect/temp_visual/cult/sparks(X2)
	SLEEP_CHECK_DEATH(25, src)
	new /obj/effect/temp_visual/cult/blood/out(X1)
	new /obj/effect/temp_visual/cult/blood/out(X2)
	playsound(src,'sound/effects/magic/exit_blood.ogg', 200, 1)
	if(src.health <= src.maxHealth*0.5)
		new /mob/living/simple_animal/hostile/cult_demon/greater(X1)
		new /mob/living/simple_animal/hostile/cult_demon/greater(X2)
	else
		new /mob/living/simple_animal/hostile/cult_demon(X1)
		new /mob/living/simple_animal/hostile/cult_demon(X2)
	SLEEP_CHECK_DEATH(20, src)
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, newcolor)
	cmdepower()
	infernal_summon_cooldown = (world.time + initial(infernal_summon_cooldown))
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/bullet/chaos_bomb/blood(startloc)
	P.aim_projectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/telegraph()
	for(var/mob/M in range(10,src))
		if(M.client)
			flash_color(M.client, "#FF0000", 2)
			shake_camera(M, 2, 1)
	playsound(src, 'sound/effects/magic/clockwork/narsie_attack.ogg', 200, TRUE)

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/cmempower()
	damage_coeff = list(BRUTE = 0.6, BURN = 0.2, TOX = 0.2, CLONE = 0.2, STAMINA = 0, OXY = 0.2)
	add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/cmdepower()
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 0.5, CLONE = 0.5, STAMINA = 0, OXY = 0.5)
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, newcolor)
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

/datum/armor/hooded_cultrobes/hardened
	melee = 75
	bullet = 50
	laser = 30
	energy = 50
	bomb = 100
	bio = 100
	fire = 100
	acid = 100

/obj/item/clothing/suit/hooded/cultrobes/hardened
	name = "\improper Cursed Nar'Sien hardened armor"
	desc = "A heavily-armored exosuit worn by warriors of the Nar'Sien cult. This one is cursed, screaming voices into the mind of the wearer."
	allowed = list(/obj/item/gun, /obj/item/tank/internals)
	armor_type = /datum/armor/hooded_cultrobes/hardened
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/hardened

/obj/item/clothing/head/hooded/cult_hoodie/hardened
	name = "\improper Cursed Nar'Sien hardened helmet"
	desc = "A heavily-armored helmet worn by warriors of the Nar'Sien cult. This one is cursed, screaming voices into the mind of the wearer."
	armor_type = /datum/armor/hooded_cultrobes/hardened
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/obj/item/clothing/suit/hooded/cultrobes/hardened/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/C = loc
	if(istype(C) && prob(4))
		if(prob(25))
			C.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 60)
			to_chat(C, span_danger("[pick("Voices... Voices everywhere", "Your mind shatters.", "Voices echo inside your head.")]."))
		SEND_SOUND(C, sound(pick('sound/effects/hallucinations/over_here3.ogg', 'sound/effects/hallucinations/behind_you2.ogg', 'sound/effects/magic/exit_blood.ogg', 'sound/effects/hallucinations/im_here1.ogg', 'sound/effects/hallucinations/turn_around1.ogg', 'sound/effects/hallucinations/turn_around2.ogg')))

//DEMONS
/mob/living/simple_animal/hostile/cult_demon
	name = "lesser daemon"
	real_name = "daemon"
	unique_name = TRUE
	desc = "A large, menacing creature covered in armored black scales."
	response_help_continuous = "thinks better of touching"
	response_help_simple = "think better of touching"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	icon = 'icons/mob/simple/demon.dmi'
	icon_state = "demon"
	icon_living = "demon"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 4
	stop_automated_movement = 1
	status_flags = CANPUSH
	attack_sound = 'sound/effects/magic/demon_attack1.ogg'
	atmos_requirements = null
	faction = list("cult")
	maxHealth = 60
	health = 60
	vision_range = 16
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_HUGE
	melee_damage_lower = 6
	melee_damage_upper = 8
	see_in_dark = 8
	light_color = "#FF0000"
	light_range = 2
	move_to_delay = 3
	del_on_death = TRUE
	death_message = "screams in agony as it sublimates into a sulfurous smoke."
	death_sound = 'sound/effects/magic/demon_dies.ogg'

/mob/living/simple_animal/hostile/cult_demon/greater
	name = "daemon"
	icon_state = "slaughter_demon"
	icon_living = "slaughter_demon"
	desc = "A powerful creature that was brought here straight from a hellish realm."
	melee_damage_lower = 10
	melee_damage_upper = 14
	light_range = 4
	maxHealth = 125
	health = 125

/mob/living/simple_animal/hostile/cult_demon/ex_act(severity, target)
	return //Resistant to explosions
