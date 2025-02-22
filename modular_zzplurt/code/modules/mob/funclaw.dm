/mob/living/basic/hostile/deathclaw
	name = "deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match."
	icon = 'modular_zzplurt/icons/mob/claws/funclaws.dmi'
	icon_state = "deathclaw"
	icon_living = "deathclaw"
	icon_dead = "deathclaw_dead"
	pixel_x = -16
	gender = MALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	stat_attack = HARD_CRIT
	speak = list("ROAR!","Rawr!","GRRAAGH!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("grumbles.","grawls.")
	emote_taunt = list("stares ferociously", "stomps")
	speak_chance = 10
	taunt_chance = 25
	speed = 0
	see_in_dark = 8
	butcher_results = list(/obj/item/food/meat/slab/ = 4,
							/obj/item/stack/sheet/animalhide = 2,
							/obj/item/stack/sheet/bone = 4)
	attack_verb_continuous = "claws"
	maxHealth = 500
	health = 500
	obj_damage = 60
	armour_penetration = 30
	melee_damage_lower = 56
	melee_damage_upper = 56
	faction = list("deathclaw")
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 5
	gold_core_spawnable = HOSTILE_SPAWN
	//Someone other than me is gonna have to give the mobs lewd stuff. -Evan
	/*
	var/charging = FALSE
	var/has_penis = FALSE
	var/has_butt = FALSE
	var/has_breasts = FALSE
	var/has_vagina = FALSE
	*/

/mob/living/basic/hostile/deathclaw/Initialize(mapload)
	. = ..()

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw
	icon_state = "newclaw"
	stat_attack = CONSCIOUS
	/*
	var/base_state = "newclaw"
	var/cock_state = "newclaw_cocked"
	var/cock_shown = FALSE
	*/

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/alphaclaw
	name = "Alpha Funclaw"
	icon_state = "alphaclaw"
	stat_attack = HARD_CRIT
	//base_state = "alphaclaw"
	//cock_state = "alphaclaw_cocked"

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/death()
	..()
	gib()

/*
/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/proc/show_cock()
	if (cock_shown)
		return
	cock_shown = TRUE
	icon_state = cock_state
	visible_message("<font color=purple><b>\The [src]</b>'s cock unsheathes.</font>")

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/proc/hide_cock()
	if (!cock_shown)
		return
	cock_shown = FALSE
	icon_state = base_state
	visible_message("<font color=purple><b>\The [src]</b>'s cock slowly retracts back into its sheath.</font>")

/mob/living/basic/hostile/deathclaw/funclaw/gentle/newclaw/handle_post_sex(amount, orifice, mob/living/partner)
	..()
	if (lust > 0)
		show_cock()
	else
		hide_cock()
*/

/mob/living/basic/hostile/deathclaw/funclaw/femclaw
	icon_state = "femclaw"
	gender = FEMALE
	name = "Breasted Funclaw"
	desc = "She's large and in charge... and has her eyes on you."
	maxHealth = 400
	health = 400
	armour_penetration = 45

/mob/living/basic/hostile/deathclaw/funclaw/femclaw/mommyclaw
	icon_state = "mommyclaw"
	desc = "A machine that turns her victim's pelvis into pelvwas."
	name = "Mommy Funclaw"
	maxHealth = 1200
	health = 1200
	obj_damage = 145
	armour_penetration = 80
	melee_damage_lower = 80
	melee_damage_upper = 80

/mob/living/basic/hostile/deathclaw/funclaw/femclaw/death()
	..()
	gib()
