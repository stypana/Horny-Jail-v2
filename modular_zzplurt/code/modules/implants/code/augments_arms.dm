//
// Fake arm blade implant
//

// Low-damage changeling arm blade weapon
// Still retains all other abilities
/obj/item/melee/arm_blade/replica_weapon
	name = "ultra-realistic replica arm blade"
	desc = "A grotesque blade made out of foam and plastic that can easily cleave through tables made from warm butter."
	item_flags = NEEDS_PERMIT | ABSTRACT
	force = 5
	armour_penetration = 0
	wound_bonus = 0
	bare_wound_bonus = 0
	armour_penetration = 0

// Variant toy armblade that looks real
/obj/item/toy/foamblade/replica_toy
	name = "replica arm blade"
	desc = "A grotesque blade made out of foam and plastic that struggles to cleave through warm butter."
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	item_flags = NEEDS_PERMIT | ABSTRACT

// Fake arm blade implant
/obj/item/organ/internal/cyberimp/arm/replica_armblade
	name = "replica arm blade implant"
	desc = "A convincing replica of the changeling's arm blade designed by the Tiger Cooperative. Highly effective at honoring the ultimate lifeforms!"
	items_to_create = list(/obj/item/toy/foamblade/replica_toy)
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"

// Fake arm blade implant emag features
/obj/item/organ/internal/cyberimp/arm/replica_armblade/emag_act()
	// Check if already emagged
	if(obj_flags & EMAGGED)
		// Alert user and return
		to_chat(usr, span_notice("[src]'s realism selection is already unlocked!"))
		return FALSE

	// Add emag flag
	obj_flags |= EMAGGED

	// Define item list
	for(var/datum/weakref/created_item in items_list)

	// Alert user
	to_chat(usr, span_notice("You unlock [src]'s realism level selection feature!"))

	// Add new items
	items_list += WEAKREF(new /obj/item/toy/foamblade(src))
	items_list += WEAKREF(new /obj/item/melee/arm_blade/replica_weapon(src))

	// Return success
	return TRUE

// Left and right variant for loadout
/obj/item/organ/internal/cyberimp/arm/replica_armblade/left_arm
	name = "left replica arm blade implant"
	zone = BODY_ZONE_L_ARM
	slot = ORGAN_SLOT_LEFT_ARM_AUG

/obj/item/organ/internal/cyberimp/arm/replica_armblade/right_arm
	name = "right replica arm blade implant"
	zone = BODY_ZONE_R_ARM
	slot = ORGAN_SLOT_RIGHT_ARM_AUG
