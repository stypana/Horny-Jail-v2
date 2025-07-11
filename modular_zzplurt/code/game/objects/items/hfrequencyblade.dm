/obj/item/highfrequencyblade/slash(atom/target, mob/living/user, list/modifiers)
	animate_attack(user, target, ATTACK_ANIMATION_SLASH)
	return ..()

/obj/item/highfrequencyblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK)
		if(HAS_TRAIT(src, TRAIT_WIELDED) || prob(final_block_chance))
			owner.visible_message(span_danger("[owner] deflects [attack_text] with [src]!"))
			var/owner_turf = get_turf(owner)
			new block_effect(owner_turf, COLOR_WHITE)
			playsound(src, block_sound, BLOCK_SOUND_VOLUME, vary = TRUE)
			return TRUE
		return FALSE
	if(prob(final_block_chance * (HAS_TRAIT(src, TRAIT_WIELDED) ? 2 : 1)))
		owner.visible_message(span_danger("[owner] parries [attack_text] with [src]!"))
		var/owner_turf = get_turf(owner)
		new block_effect(owner_turf, COLOR_WHITE)
		playsound(src, block_sound, BLOCK_SOUND_VOLUME, vary = TRUE)
		return TRUE
	return FALSE
