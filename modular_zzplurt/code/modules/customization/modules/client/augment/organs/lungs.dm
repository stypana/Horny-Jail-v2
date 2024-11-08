//
// Lungs slot
//

// Ultimate lungs that resist almost everything
/datum/augment_item/organ/lungs/elite
	name = "Elite Cybernetic Lungs"
	slot = AUGMENT_SLOT_LUNGS
	path = /obj/item/organ/internal/lungs/cybernetic/elite
	allowed_biotypes = MOB_ORGANIC|MOB_ROBOTIC
	cost = 6

// Lungs that require no oxygen
/datum/augment_item/organ/lungs/recycler
	name = "Recycler Cybernetic Lungs"
	slot = AUGMENT_SLOT_LUNGS
	path = /obj/item/organ/internal/lungs/cybernetic/tier2/recycler
	allowed_biotypes = MOB_ORGANIC|MOB_ROBOTIC
	cost = 4
