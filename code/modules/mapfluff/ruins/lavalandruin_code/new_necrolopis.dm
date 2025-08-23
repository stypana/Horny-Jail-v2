/turf/open/indestructible/boss/necropolis
	icon = 'modules/icons/new_necropolis.dmi'
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

/turf/open/indestructible/boss/necropolis/fakechasm/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/open/indestructible/boss/necropolis/fakechasm/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	return FALSE

/turf/open/chasm/jungle/necropolis
	smoothing_flags = NONE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = FALSE

/turf/open/chasm/jungle/necropolis/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	return FALSE

/turf/open/chasm/jungle/necropolis/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	return FALSE

/turf/open/chasm/jungle/necropolis/can_cross_safely(atom/movable/crossing)
        return HAS_TRAIT(src, TRAIT_CHASM_STOPPED)

/turf/open/chasm/jungle/necropolis/Entered(atom/movable/arrived, atom/old_loc)
	var/mob/living/carbon/human/H = ishuman(arrived) ? arrived : null
	if(HAS_TRAIT(src, TRAIT_CHASM_STOPPED) || !isliving(arrived) || !HAS_TRAIT(arrived, TRAIT_MOVE_FLOATING) || !H || !istype(H.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS), /obj/item/organ/wings/functional))
		return ..()
	var/mob/living/M = arrived
	ADD_TRAIT(M, TRAIT_CHASM_STOPPER, REF(src))
	M.Stun(3 SECONDS, ignore_canstun = TRUE)
	QDEL_NULL(M.drift_handler)
	var/message
	if(ishuman(M) && M.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS))
		message = "You feel that your wings are trembling and than.. Treacherously stops waving, after what, you see that celling under your head is moving away and it's starting to become very dark.."
	else
		message = "You feel that your stop flying for some reason, after what, you see that celling under your head is moving away and it's starting to become very dark.."
	to_chat(M, span_danger(message))
	addtimer(CALLBACK(src, PROC_REF(drop_floater), M), 3 SECONDS)
	return ..()

/turf/open/chasm/jungle/necropolis/proc/drop_floater(mob/living/M)
	if(!M)
		return
	REMOVE_TRAIT(M, TRAIT_CHASM_STOPPER, REF(src))
	drop(M)

/turf/closed/indestructible/cult
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult_wall-255"

/turf/open/indestructible/cult
	icon = 'icons/turf/floors.dmi'
	icon_state = "cult"
	initial_gas_mix = OPENTURF_LOW_PRESSURE

/area/lavaland/surface/necropolis
	area_flags = NOTELEPORT | FLORA_ALLOWED | EVENT_PROTECTED | QUIET_LOGS
	requires_power = FALSE
	ambience_index = AMBIENCE_SPOOKY
	ambient_buzz = 'sound/music/antag/heretic/VoidsEmbrace.ogg'

/area/lavaland/surface/necropolis/cult
	area_flags = FLORA_ALLOWED | EVENT_PROTECTED | CULT_PERMITTED | QUIET_LOGS
	ambience_index = AMBIENCE_SPOOKY
	ambient_buzz = 'sound/music/antag/heretic/heretic_sacrifice.ogg'

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

/obj/machinery/door/puzzle/keycard/gates/animation_length(animation)
	switch(animation)
		if(DOOR_OPENING_ANIMATION)
			return 6 SECONDS

/obj/machinery/door/puzzle/keycard/gates/animation_effects(animation)
	switch(animation)
		if(DOOR_OPENING_ANIMATION)
			playsound(src, animation_sound, 50, TRUE)

/obj/machinery/door/puzzle/keycard/gates/necropolis
	name = "locked gates"


/obj/machinery/door/puzzle/keycard/gates/necropolis/legion
	puzzle_id = "legion"
	name = "locked gates"

/obj/machinery/door/puzzle/keycard/gates/necropolis/clockwork
	puzzle_id = "clockwork"
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

/obj/item/keycard/cloclwork
	name = "Clockwork Key"
	desc = "Strange brass key with some gear on it, which keep rotating no matter what."
	icon_state = "clockwork_key"
	puzzle_id = "clockwork"

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
	var/loot = rand(1,14)
	switch(loot)
		if(1)
			new /obj/item/clothing/gloves/fingerless/punch_mitts(src)
			new /obj/item/clothing/head/cowboy(src)
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


/obj/structure/closet/crate/necropolis_open/major

/obj/structure/closet/crate/necropolis_open/major/PopulateContents()
	var/loot = rand(1,8)
	switch(loot)
		if(1)
			new /obj/item/cain_and_abel(src)
		if(2)
			new /obj/item/clothing/suit/hooded/hostile_environment(src)
			new /obj/item/clothing/head/hooded/hostile_environment (src)
		if(3)
			new /obj/item/dice/d20/fate(src)
		if(4)
			new /obj/item/crusher_trophy/wendigo_horn(src)
		if(5)
			new /obj/item/gun/magic/staff/spellblade(src)
		if(6)
			new /obj/item/guardian_creator/miner/notrandom(src)
		if(7)
			new /obj/item/gun/magic/hook(src)
		if(8)
			new /obj/item/crusher_trophy/demon_claws(src)



/mob/living/simple_animal/hostile/megafauna/cult_templar
	name = "cult templar"
	desc = "Forever a servant of the Nar'sie, this cultist has gone more insane than what is considered the normal insanity for cultist. They forever seek battle, waiting for sacrifices to battle them."
	health = 2000
	maxHealth = 2000
	icon_state = "cult_templar"
	icon_living = "cult_templar"
	icon = 'modules/icons/new_necropolis.dmi'
	faction = list("cult","boss")
	mob_biotypes = MOB_ORGANIC | MOB_HUMANOID
	light_color = "#FFFFFF"
	movement_type = GROUND
	speak_emote = list("echoes")
	speed = 5
	move_to_delay = 2
	light_range = 6
	projectiletype = /obj/projectile/bullet/chaos_bomb
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 1
	ranged_cooldown_time = 5
	vision_range = 10
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 0.5, CLONE = 0.5, STAMINA = 0, OXY = 0.5)
	loot = list(/obj/structure/closet/crate/necropolis_open/major, /obj/item/keycard/cultist)
	crusher_loot = list(/obj/structure/closet/crate/necropolis_open/major, /obj/item/clothing/suit/hooded/cultrobes/templar, /obj/item/keycard/cultist)
	wander = FALSE
	del_on_death = TRUE
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "Chaotic Signal"
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = 'sound/effects/magic/curse.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/blood_dash,
								/datum/action/innate/megafauna_attack/runic_blast,
								/datum/action/innate/megafauna_attack/infernal_summon,
								/datum/action/innate/megafauna_attack/blast,
								/datum/action/innate/megafauna_attack/rapid_fire)
	move_force = MOVE_FORCE_NORMAL
	var/obj/item/claymore/weapon
	var/turf/starting
	var/charging = FALSE
	var/dash_cooldown = 5 SECONDS
	var/runic_blast_cooldown = 10 SECONDS
	var/teleport_cooldown = 6 SECONDS
	var/infernal_summon_cooldown = 15 SECONDS
	var/dash_mod = 0.9
	var/dash_num = 3
	var/newcolor = rgb(149, 10, 10)

/mob/living/simple_animal/hostile/megafauna/cult_templar/Initialize(mapload)
	. = ..()
	starting = get_turf(src)
	weapon = new(src)

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

/mob/living/simple_animal/hostile/megafauna/cult_templar/AttackingTarget(atom/attacked_target)
	if(charging || QDELETED(attacked_target))
		return

	face_atom(attacked_target)
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		if(L.health <= HEALTH_THRESHOLD_DEAD || L.stat == DEAD) //To prevent memento mori limbo
			visible_message(span_danger("[src] butchers [L]!"),
			span_userdanger("You butcher [L], restoring your health!"))
			adjustHealth(-(L.maxHealth * 0.5))
			L.gib(DROP_ALL_REMAINS)
			if(ishuman(L)) // If target is a human - yell some funny shit.
				telegraph()
				say("Mah'weyh pleggh at e'ntrath!!")
			changeNext_move(CLICK_CD_MELEE)
			return TRUE
	changeNext_move(CLICK_CD_MELEE)
	weapon.melee_attack_chain(src, attacked_target)
	return TRUE

/mob/living/simple_animal/hostile/megafauna/cult_templar/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/cult_templar/proc/adjustCMspeed()
	if(health <= maxHealth*0.25)
		speed = 2.5
		dash_mod = 0.4
		dash_num = 6
		rapid_melee = 3.5
	else if(health <= maxHealth*0.5)
		speed = 3.5
		dash_mod = 0.6
		dash_num = 5
		rapid_melee = 2.5
	else if(health <= maxHealth*0.75)
		speed = 4
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
			// if(5)
			// 	teleport_b(target)
			if(5)
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
	name ="blood missile"
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
	var/next_cooldown = world.time + (initial(teleport_cooldown) * dash_mod)
	if(health > maxHealth*0.5)
		SLEEP_CHECK_DEATH(5, src)
	layer = initial(layer)
	cmdepower()
	teleport_cooldown = next_cooldown
	charging = FALSE
	if(health <= maxHealth*0.5)
		blood_dash(target)

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

/datum/armor/hooded_cultrobes/templar
	melee = 75
	bullet = 50
	laser = 50
	energy = 50
	bomb = 85
	bio = 100
	fire = 100
	acid = 100

/obj/item/clothing/suit/hooded/cultrobes/templar
	name = "\improper Cursed Nar'Sien hardened armor"
	desc = "A heavily-armored exosuit worn by warriors of the Nar'Sien cult. This one is cursed, screaming voices into the mind of the wearer."
	allowed = list(/obj/item/gun, /obj/item/tank/internals, /obj/item/kinetic_crusher)
	icon_state = "cult_armor"
	armor_type = /datum/armor/hooded_cultrobes/templar
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	transparent_protection = HIDEGLOVES|HIDESUITSTORAGE|HIDEJUMPSUIT|HIDESHOES
	clothing_flags = THICKMATERIAL|HEADINTERNALS
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/templar

/obj/item/clothing/head/hooded/cult_hoodie/templar
	name = "\improper Cursed Nar'Sien hardened helmet"
	desc = "A heavily-armored helmet worn by warriors of the Nar'Sien cult. This one is cursed, screaming voices into the mind of the wearer."
	armor_type = /datum/armor/hooded_cultrobes/templar
	icon_state = "cult_helmet"
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS|HIDESNOUT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	clothing_flags = SNUG_FIT|THICKMATERIAL

/obj/item/clothing/suit/hooded/cultrobes/templar/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/C = loc
	if(istype(C) && prob(25))
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
	maxHealth = 200
	health = 200
	vision_range = 16
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_HUGE
	melee_damage_lower = 8
	melee_damage_upper = 16
	see_in_dark = 8
	light_color = "#FF0000"
	light_range = 2
	move_to_delay = 3
	del_on_death = TRUE
	death_message = "screams in agony as it sublimates into a sulfurous smoke."
	death_sound = 'sound/effects/magic/demon_dies.ogg'
	/// How long this daemon exists before fading away
	var/lifespan = 15 SECONDS
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile

/mob/living/simple_animal/hostile/cult_demon/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(death)), lifespan)

/mob/living/simple_animal/hostile/cult_demon/death(gibbed)
	if(!gibbed)
		new /obj/effect/temp_visual/despawn_effect(get_turf(src), /* copy_from = */ src)
	return ..()

/mob/living/simple_animal/hostile/cult_demon/greater
	name = "daemon"
	icon_state = "slaughter_demon"
	icon_living = "slaughter_demon"
	desc = "A powerful creature that was brought here straight from a hellish realm."
	melee_damage_lower = 16
	melee_damage_upper = 24
	light_range = 4
	maxHealth = 250
	health = 250
	lifespan = 10 SECONDS

/mob/living/simple_animal/hostile/cult_demon/ex_act(severity, target)
	return //Resistant to explosions

// Копирка Берсерка, но с другим лутом и моделькой (просто через карту нельзя поменять, ибо в скиллах у него изменение модельки)

#define MARKED_ONE_STUN_DURATION (1.5 SECONDS)
#define MARKED_ONE_ANGER_DURATION (10 MINUTES)
#define MARKED_ONE_FIRST_PHASE 1
#define MARKED_ONE_SECOND_PHASE 2
#define MARKED_ONE_THIRD_PHASE 3
#define MARKED_ONE_FINAL_PHASE 4
#define ONE_HUNDRED_PERCENT 100
#define SEVENTY_FIVE_PERCENT 75
#define FIFTY_PERCENT 50
#define SHOWDOWN_PERCENT 25
#define CHARGE_MODIFIER 0.4
#define TELE_QUIP_CHANCE 5

/**
 * A mean-ass single-combat sword-wielding nigh-demigod that is nothing but a walking, talking, breathing Berserk reference. He do kill shit doe!
 */
/mob/living/simple_animal/hostile/megafauna/clock_gladiator
	name = "\proper Clockwork Champion"
	desc = "A traitorous clockwork knight who lived on, despite its creators destruction."
	icon = 'icons/mob/simple/icemoon/icemoon_monsters.dmi'
	icon_state = "clockwork_defender"
	attack_verb_simple = "cleave"
	attack_verb_continuous = "cleaves"
	attack_sound = 'modular_skyrat/master_files/sound/weapons/bloodyslice.ogg'
	death_sound = 'sound/mobs/non-humanoids/space_dragon/space_dragon_roar.ogg'
	death_message = "falls, quickly decaying into centuries old dust."
	gps_name = "Bronze Signal"
	gender = MALE
	rapid_melee = 1
	melee_queue_distance = 2
	melee_damage_lower = 20
	melee_damage_upper = 40
	speed = 3
	move_to_delay = 5
	wander = FALSE
	ranged = 1
	ranged_cooldown_time = 30
	minimum_distance = 1
	health = 1500
	maxHealth = 1500 //for contrast, bubblegum and the colossus both have 2500 health
	movement_type = FLOATING
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	loot = list(/obj/structure/closet/crate/necropolis_open/major, /obj/item/keycard/cloclwork)
	crusher_loot = list(/obj/structure/closet/crate/necropolis_open/major, /obj/item/keycard/cloclwork)
	del_on_death = TRUE
	/// Boss phase, from 1 to 3
	var/phase = MARKED_ONE_FIRST_PHASE
	/// People we have introduced ourselves to - WEAKREF list
	var/list/introduced = list()
	/// Are we doing the spin attack?
	var/spinning = FALSE
	/// Range of spin attack
	var/spinning_range = 6
	/// Are we doing the charge attack
	var/charging = FALSE
	/// If we are charging, this is a counter for how many tiles we have ran past
	var/chargetiles = 0
	/// Maximum range for charging, in case we don't ram any closed turf
	var/chargerange = 16
	/// We get stunned whenever we ram into a closed turf
	var/stunned = FALSE
	/// Chance to block damage entirely on phases 1 and 4
	var/block_chance = 30
	/// This mob will not attack mobs randomly if not in anger, the time doubles as a check for anger
	var/anger_timer_id = null

/mob/living/simple_animal/hostile/megafauna/clock_gladiator/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, INNATE_TRAIT)

/mob/living/simple_animal/hostile/megafauna/clock_gladiator/Destroy()
	get_calm()
	return ..()

/mob/living/simple_animal/hostile/megafauna/clock_gladiator/Life()
	. = ..()
	if(stat >= DEAD)
		return
	/// Try introducing ourselvess to people while not pissed off
	if(!anger_timer_id)
		/// Yes, i am calling view on life! I don't think i can avoid this!
		for(var/mob/living/friend_or_foe in (view(4, src)-src))
			var/datum/weakref/friend_or_foe_ref = WEAKREF(friend_or_foe)
			if(!(friend_or_foe_ref in introduced) && (friend_or_foe.stat != DEAD))
				introduction(friend_or_foe)
				break

/mob/living/simple_animal/hostile/megafauna/clock_gladiator/Found(atom/A)
	//We only attack when pissed off
	if(!anger_timer_id)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/clock_gladiator/ListTargets()
	if(!anger_timer_id)
		return list()
	return ..()

/// Adds the text descriptor of what phase the Marked One is in, or tells you he's a corpse if he's dead as fuck
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/examine()
	if(stat >= DEAD)
		. = ..()
		. += span_boldwarning("Unearthly energies bind the body to it's place of defeat. You cannot move it.")
	else
		. = ..()
		. += span_boldwarning("They are currently in Phase [phase].")

/// Gets him mad at you if you're a species he's not racist towards, and provides the 50% to block attacks in the first and fourth phases
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/adjustHealth(amount, updating_health, forced)
	get_angry()
	if(prob(block_chance) && (phase == 1 || phase == 4) && !stunned)
		var/our_turf = get_turf(src)
		new /obj/effect/temp_visual/block(our_turf, COLOR_YELLOW)
		playsound(src, 'sound/items/weapons/parry.ogg', BLOCK_SOUND_VOLUME * 2, vary = TRUE) // louder because lavaland low pressure maybe?
		return FALSE
	. = ..()
	update_phase()
	// Taking damage makes us unable to attack for a while
	var/adjustment_amount = min(amount * 0.15, 15)
	if((world.time + adjustment_amount) > next_move)
		changeNext_move(adjustment_amount)

/mob/living/simple_animal/hostile/megafauna/clock_gladiator/AttackingTarget() //calls bump when charging into a target
	. = ..()
	if(spinning || stunned)
		return
	if(charging && (get_dist(src, target) <= 1))
		Bump(target)
	if(. && prob(5 * phase))
		INVOKE_ASYNC(src, PROC_REF(teleport), target)

/// As the marked one is only theoretically capable of ignoring gravity, this makes him not walk on chasms, and prevents him from moving if spinning or stunned. It also figures out if he hits a wall while charging!
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/Move(atom/newloc, dir, step_x, step_y)
	if(spinning || stunned)
		return FALSE
	if(ischasm(newloc))
		var/list/possible_locs = list()
		switch(get_dir(src, newloc))
			if(NORTH)
				possible_locs += locate(x +1, y + 1, z)
				possible_locs += locate(x -1, y + 1, z)
			if(EAST)
				possible_locs += locate(x + 1, y + 1, z)
				possible_locs += locate(x + 1, y - 1, z)
			if(WEST)
				possible_locs += locate(x - 1, y + 1, z)
				possible_locs += locate(x - 1, y - 1, z)
			if(SOUTH)
				possible_locs += locate(x - 1, y - 1, z)
				possible_locs += locate(x + 1, y - 1, z)
			if(SOUTHEAST)
				possible_locs += locate(x + 1, y, z)
				possible_locs += locate(x + 1, y + 1, z)
			if(SOUTHWEST)
				possible_locs += locate(x - 1, y, z)
				possible_locs += locate(x - 1, y + 1, z)
			if(NORTHWEST)
				possible_locs += locate(x - 1, y, z)
				possible_locs += locate(x - 1, y - 1, z)
			if(NORTHEAST)
				possible_locs += locate(x + 1, y - 1, z)
				possible_locs += locate(x + 1, y, z)
		//locates may add nulls to the list
		for(var/turf/possible_turf as anything in possible_locs)
			if(!istype(possible_turf) || ischasm(possible_turf))
				possible_locs -= possible_turf
		if(LAZYLEN(possible_locs))
			var/turf/validloc = pick(possible_locs)
			. = ..(validloc)
			if(. && charging)
				chargetiles++
				if(chargetiles >= chargerange)
					INVOKE_ASYNC(src, PROC_REF(discharge))
		return FALSE
	. = ..()
	if(. && charging)
		chargetiles++
		if(chargetiles >= chargerange)
			INVOKE_ASYNC(src, PROC_REF(discharge))

/// Fucks up the day of whoever he walks into, so long as he's charging and the mob is alive. If he walks into a wall, he gets stunned instead!
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/Bump(atom/A)
	. = ..()
	if(!charging)
		return
	if(isliving(A))
		var/mob/living/living_atom = A
		forceMove(get_turf(living_atom))
		visible_message(span_danger("[src] knocks [living_atom] down!"))
		living_atom.Paralyze(20)
		discharge()
	else if(istype(A, /turf/closed))
		visible_message(span_danger("[src] crashes headfirst into [A]!"))
		discharge(1.5)

/// Makes the Marked One unhappy and more befitting of his "hostile" subtype status.
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/get_angry()
	if(stat >= DEAD)
		return
	if(anger_timer_id)
		deltimer(anger_timer_id)
	anger_timer_id = addtimer(CALLBACK(src, PROC_REF(get_calm)), MARKED_ONE_ANGER_DURATION, TIMER_STOPPABLE)

/// Makes the Marked One a sleepy boy that don't wanna hurt nobody. He starts like this and progresses to his hostile state after seeing an ash walker or being punched in the noggin.
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/get_calm()
	if(anger_timer_id)
		deltimer(anger_timer_id)
	anger_timer_id = null

/// Proc that makes the Marked One spout a morally grey/absurdly racist one-liner dependong on who his target is
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/introduction(mob/living/target)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/datum/species/targetspecies = human_target.dna.species
		// The gladiator hates non-humans, he especially hates ash walkers.
		// BUBBER TODO - Bring the says back when refactoring to basicmobs
		if(targetspecies.id == SPECIES_HUMAN)
			var/static/list/human_messages = list(
									"Is this all that is left?",
									"Show the necropolis it was wrong to choose me.",
									"Ironic that I become what I once fought like you.",
									"Sometimes, the abyss gazes back.",
									"Show me a good time, miner!",
									"I'll give you the first hit.",
								)
			//say(message = pick(human_messages))
			introduced |= WEAKREF(target)
		else if(targetspecies.id == SPECIES_LIZARD_ASH)
			var/static/list/ashie_messages = list(
									"Foolishness, ash walker!",
									"I've had enough of you for a lifetime!",
									"I don't need a crusher to KICK YOUR ASS!",
									"GET OVER HERE!!",
								)

			//say(message = pick(ashie_messages), language = /datum/language/ashtongue)
			introduced |= WEAKREF(target)
			get_angry()
			GiveTarget(target)
		else
			var/static/list/other_humanoid_messages = list(
									"I will smite you!",
									"I will show you true power!",
									"Let us see how worthy you are!",
									"You will make a fine rug!",
									"For the necropolis!"
									)
			//say(message = pick(other_humanoid_messages))
			introduced |= WEAKREF(target)
			get_angry()
			GiveTarget(target)
	else
		//simplemobs beware
		//say("It's berserkin' time!")
		introduced |= WEAKREF(target)

/// Checks against the Marked One's current health and updates his phase accordingly. Uses variable shitcode to make sure his phase updates only ever happen *once*
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/update_phase()
	var/healthpercentage = 100 * (health/maxHealth)
	if(src.stat >= DEAD)
		return
	switch(healthpercentage)
		if(SEVENTY_FIVE_PERCENT to ONE_HUNDRED_PERCENT)
			phase = MARKED_ONE_FIRST_PHASE
			rapid_melee = initial(rapid_melee)
			move_to_delay = initial(move_to_delay)
			melee_damage_upper = initial(melee_damage_upper)
			melee_damage_lower = initial(melee_damage_lower)
		if(FIFTY_PERCENT to SEVENTY_FIVE_PERCENT)
			if(phase == MARKED_ONE_FIRST_PHASE)
				phase = MARKED_ONE_SECOND_PHASE
				INVOKE_ASYNC(src, PROC_REF(charge), target, 21)
				ranged_cooldown += 8 SECONDS //this needs to be here lest another ranged attack override the charge while it's prepping
				rapid_melee = 2
				move_to_delay = 2
				melee_damage_upper = 30
				melee_damage_lower = 30
		if(SHOWDOWN_PERCENT to FIFTY_PERCENT)
			if(phase == MARKED_ONE_SECOND_PHASE)
				phase = MARKED_ONE_THIRD_PHASE
				INVOKE_ASYNC(src, PROC_REF(charge), target, 21)
				ranged_cooldown += 5 SECONDS
				rapid_melee = 4
				melee_damage_upper = 25
				melee_damage_lower = 25
				move_to_delay = 1.5
		if(0 to SHOWDOWN_PERCENT)
			if (phase == MARKED_ONE_THIRD_PHASE)
				phase = MARKED_ONE_FINAL_PHASE
				INVOKE_ASYNC(src, PROC_REF(swordslam))
				INVOKE_ASYNC(src, PROC_REF(stomp))
				INVOKE_ASYNC(src, PROC_REF(charge), target, 21)
				ranged_cooldown += 8 SECONDS
				rapid_melee = 1
				melee_damage_upper = 50
				melee_damage_lower = 50
				move_to_delay = 1.2

/// Proc name speaks for itself. Vinesauce Joel
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/spinattack()
	var/turf/our_turf = get_turf(src)
	if(!istype(our_turf))
		return
	var/static/list/spin_messages = list(
							"Duck!",
							"I'll break your legs!",
							"Plain, dead, simple!",
							"SWING AND A MISS!",
							"Only one of us makes it outta here!",
							"JUMP-ROPE!!",
							"Slice and dice, right?!",
							"Come on, HIT ME!",
							"CLANG!!",
						)
	say(message = pick(spin_messages))
	spinning = TRUE
	animate(src, color = "#ff6666", 1 SECONDS)
	SLEEP_CHECK_DEATH(5, src)
	var/list/spinningturfs = list()
	var/current_angle = 360
	while(current_angle > 0)
		var/turf/target_turf = get_turf_in_angle(current_angle, our_turf, spinning_range)
		if(!istype(target_turf))
			continue
		// Yes, there may be repeats with previous turfs! Yes, this is intentional!
		spinningturfs += get_line(our_turf, target_turf)
		current_angle -= 30
	var/list/hit_things = list()
	spinning = TRUE
	for(var/turf/targeted as anything in spinningturfs)
		dir = get_dir(src, targeted)
		var/obj/effect/temp_visual/small_smoke/smonk = new /obj/effect/temp_visual/small_smoke(targeted)
		QDEL_IN(smonk, 0.5 SECONDS)
		for(var/mob/living/slapped in targeted)
			if(!faction_check(faction, slapped.faction) && !(slapped in hit_things))
				playsound(src, 'modular_skyrat/modules/gladiator/Clang_cut.ogg', 75, 0)
				if(slapped.apply_damage(40, BRUTE, BODY_ZONE_CHEST, slapped.run_armor_check(BODY_ZONE_CHEST), wound_bonus = CANT_WOUND))
					visible_message(span_danger("[src] slashes through [slapped] with his spinning blade!"))
				else
					visible_message(span_danger("[src]'s spinning blade is stopped by [slapped]!"))
					spinning = FALSE
				hit_things |= slapped
		if(!spinning)
			break
		sleep(0.75) //addtimer(CALLBACK(src, PROC_REF(convince_zonespace_to_let_me_use_sleeps)), 2 WEEKS)
	animate(src, color = initial(color), 0.3 SECONDS)
	sleep(1)
	spinning = FALSE

/// The Marked One's charge is extremely quick, but takes a moment to power-up, allowing you to get behind cover to stun him if he hits a wall.
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/charge(atom/target, range = 1)
	face_atom(target)
	var/static/list/charge_messages = list(
							"Heads up!",
							"Coming through!",
							"This ends only one way!",
							"Hold still!",
							"GET OVER HERE!",
							"Looking for this?!",
							"COME ON!!",
						)
	say(message = pick(charge_messages))
	animate(src, color = "#ff6666", 0.3 SECONDS)
	SLEEP_CHECK_DEATH(4, src)
	face_atom(target)
	minimum_distance = 0
	charging = TRUE
	move_to_delay -= CHARGE_MODIFIER
	update_phase()

/// Discharge stuns the marked one momentarily after landing a charge into a wall or a person
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/discharge(modifier = 1)
	stunned = TRUE
	charging = FALSE
	minimum_distance = initial(minimum_distance)
	chargetiles = 0
	playsound(src, 'modular_skyrat/modules/gladiator/Clang_cut.ogg', 75, 0)
	animate(src, color = initial(color), 0.5 SECONDS)
	move_to_delay += CHARGE_MODIFIER
	update_phase()
	sleep(CEILING(MARKED_ONE_STUN_DURATION * modifier, 1))
	stunned = FALSE

/// Teleport makes him teleport. woah.
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/teleport(atom/target)
	var/turf/targeted = get_step(target, target.dir)
	new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(src))
	SLEEP_CHECK_DEATH(4, src)
	if(istype(targeted) && !ischasm(targeted) && !istype(targeted, /turf/open/openspace))
		new /obj/effect/temp_visual/small_smoke/halfsecond(targeted)
		forceMove(targeted)
	else
		var/list/possible_locs = (view(3, target))
		for(var/turf/possible_turf as anything in possible_locs)
			if(!istype(possible_turf) || ischasm(possible_turf) || istype(targeted, /turf/open/openspace) || istype(possible_turf, /turf/closed))
				possible_locs -= possible_turf
				continue
		if(LAZYLEN(possible_locs))
			targeted = pick(possible_locs)
			new /obj/effect/temp_visual/small_smoke/halfsecond(targeted)
			forceMove(targeted)
			var/static/list/tele_messages = list(
				"Hi.",
				"Hello there.",
				"Hello.",
				"Hey.",
				"Yo.",
				"Boo.",
				"Sup.",
			)

			if(prob(TELE_QUIP_CHANCE))
				say(message = pick(tele_messages))

/// Bone Knife Throw makes him throw bone knives. woah.
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/spear_throw(atom/target)
	var/obj/item/clockwork/weapon/brass_spear/spear = new /obj/item/clockwork/weapon/brass_spear(get_turf(src))
	spear.throwforce = 35
	playsound(src, 'sound/items/weapons/bolathrow.ogg', 60, 0)
	spear.throw_at(target, 7, 3, thrower = src)
	QDEL_IN(spear, 3 SECONDS)

/// Effectively just a copied and pasted version of the wendigo ground slam. Used to create radiating shockwaves that force quick thinking and repositioning, and must be defined here because *someone* un-globaled the shit out of this proc
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/ground_pound(range, delay, throw_range)
	var/turf/origin = get_turf(src)
	if(!origin)
		return
	var/list/all_turfs = RANGE_TURFS(range, origin)
	for(var/sound_range = 0 to range)
		playsound(origin,'sound/effects/bamf.ogg', 600, TRUE, 10)
		for(var/turf/stomp_turf in all_turfs)
			if(get_dist(origin, stomp_turf) > sound_range)
				continue
			new /obj/effect/temp_visual/small_smoke/halfsecond(stomp_turf)
			for(var/mob/living/target in stomp_turf)
				if(target == src || target.throwing)
					continue
				to_chat(target, span_userdanger("[src]'s ground slam shockwave sends you flying!"))
				var/turf/thrownat = get_ranged_target_turf_direct(src, target, throw_range, rand(-10, 10))
				target.throw_at(thrownat, 8, 2, null, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = TRUE)
				target.apply_damage(20, BRUTE, wound_bonus=CANT_WOUND)
				shake_camera(target, 2, 1)
			all_turfs -= stomp_turf
		sleep(delay)

/// Large radius but slow-to-move radiating ground slam
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/swordslam()
	ground_pound(5, 0.4 SECONDS, 8)

/// Sort range slam with faster shockwave travel
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/proc/stomp()
	ground_pound(2, 0.2 SECONDS, 3)

/// Used to determine what attacks the Marked One actually uses. This works by making him a ranged mob without a projectile. Shitcode? Maybe! But it woooorks.
/mob/living/simple_animal/hostile/megafauna/clock_gladiator/OpenFire()
	if(!COOLDOWN_FINISHED(src, ranged_cooldown))
		return FALSE
	if(spinning || stunned || charging)
		return FALSE
	ranged_cooldown = world.time
	switch(phase)
		if(MARKED_ONE_FIRST_PHASE)
			if(prob(10) && (get_dist(src, target) <= spinning_range))
				INVOKE_ASYNC(src, PROC_REF(spinattack))
				ranged_cooldown += 5.5 SECONDS
			else
				if(prob(50))
					INVOKE_ASYNC(src, PROC_REF(swordslam))
					ranged_cooldown += 3 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(spear_throw), target)
					ranged_cooldown += 1 SECONDS
		if(MARKED_ONE_SECOND_PHASE)
			if(prob(75))
				if(prob(80))
					if(prob(50) && (get_dist(src, target) <= spinning_range))
						INVOKE_ASYNC(src, PROC_REF(spinattack))
						ranged_cooldown += 5 SECONDS
					else
						INVOKE_ASYNC(src, PROC_REF(swordslam))
						ranged_cooldown += 2 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(teleport), target)
					ranged_cooldown += 5 SECONDS
			else
				INVOKE_ASYNC(src, PROC_REF(teleport), target)
				ranged_cooldown += 0.5 SECONDS
		if(MARKED_ONE_THIRD_PHASE)
			if(prob(70))
				if(prob(50))
					if(prob(30) && (get_dist(src, target) <= spinning_range))
						INVOKE_ASYNC(src, PROC_REF(spinattack))
						ranged_cooldown += 3 SECONDS
					else
						INVOKE_ASYNC(src, PROC_REF(teleport), target)
						INVOKE_ASYNC(src, PROC_REF(stomp))
						ranged_cooldown += 4 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(spear_throw), target)
					INVOKE_ASYNC(src, PROC_REF(swordslam))
					ranged_cooldown += 2 SECONDS
			else
				INVOKE_ASYNC(src, PROC_REF(spear_throw), target)
				ranged_cooldown += 0.5 SECONDS
		if(MARKED_ONE_FINAL_PHASE)
			if(prob(50))
				if(prob(50))
					if(prob(25))
						INVOKE_ASYNC(src, PROC_REF(spear_throw), target)
						INVOKE_ASYNC(src, PROC_REF(teleport), target)
						INVOKE_ASYNC(src, PROC_REF(stomp))
						ranged_cooldown += 1 SECONDS
					else
						INVOKE_ASYNC(src, PROC_REF(swordslam))
						INVOKE_ASYNC(src, PROC_REF(stomp))
						ranged_cooldown += 1 SECONDS
				else
					INVOKE_ASYNC(src, PROC_REF(spear_throw), target)
					INVOKE_ASYNC(src, PROC_REF(stomp))
					ranged_cooldown += 0.5 SECONDS
			else
				INVOKE_ASYNC(src, PROC_REF(teleport), target)
				INVOKE_ASYNC(src, PROC_REF(stomp))
				ranged_cooldown += 1 SECONDS

#undef MARKED_ONE_STUN_DURATION
#undef MARKED_ONE_ANGER_DURATION
#undef MARKED_ONE_FIRST_PHASE
#undef MARKED_ONE_SECOND_PHASE
#undef MARKED_ONE_THIRD_PHASE
#undef MARKED_ONE_FINAL_PHASE
#undef ONE_HUNDRED_PERCENT
#undef SEVENTY_FIVE_PERCENT
#undef FIFTY_PERCENT
#undef SHOWDOWN_PERCENT
#undef CHARGE_MODIFIER
#undef TELE_QUIP_CHANCE
