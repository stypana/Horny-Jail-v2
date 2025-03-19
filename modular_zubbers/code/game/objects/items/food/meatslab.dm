/obj/item/food/meat/slab/drakebait
	name = "Seasoned Goliath Meat"
	desc = "A slab of goliath meat cooked to a scorching perfection. Offer this to a friendly Ash Drake in exchange for their valuable, sturdy hide."
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 20,
		/datum/reagent/toxin = 1,
		/datum/reagent/consumable/nutriment/fat/oil = 5,
	)
	icon_state = "bearsteak"
	tastes = list("meat" = 1)
	foodtypes = MEAT | TOXIC
