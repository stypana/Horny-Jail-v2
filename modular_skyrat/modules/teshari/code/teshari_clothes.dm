/obj/item/storage/backpack
	species_clothing_color_coords = list(list(BACK_COLORPIXEL_X_1, BACK_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/backpack

/obj/item/clothing/glasses
	species_clothing_color_coords = list(list(GLASSES_COLORPIXEL_X_1, GLASSES_COLORPIXEL_Y_1), list(GLASSES_COLORPIXEL_X_2, GLASSES_COLORPIXEL_Y_2))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/glasses

/obj/item/clothing/gloves
	species_clothing_color_coords = list(list(GLOVES_COLORPIXEL_X_1, GLOVES_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/gloves

/obj/item/clothing/neck
	species_clothing_color_coords = list(list(SCARF_COLORPIXEL_X_1, SCARF_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/scarf

/obj/item/clothing/neck/cloak
	species_clothing_color_coords = list(list(CLOAK_COLORPIXEL_X_1, CLOAK_COLORPIXEL_Y_1), list(CLOAK_COLORPIXEL_X_2, CLOAK_COLORPIXEL_Y_2))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/cloak

/obj/item/clothing/neck/mantle
	species_clothing_color_coords = list(list(MANTLE_COLORPIXEL_X_1, MANTLE_COLORPIXEL_Y_1), list(MANTLE_COLORPIXEL_X_2, MANTLE_COLORPIXEL_Y_2))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/mantle

/obj/item/clothing/neck/tie
	species_clothing_color_coords = list(list(TIE_COLORPIXEL_X_1, TIE_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/tie

/obj/item/clothing/shoes
	species_clothing_color_coords = list(list(SHOES_COLORPIXEL_X_1, SHOES_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/shoes

/obj/item/clothing/suit/teshari
	name = "teshari base"
	desc = "HOW YOU GET THIS?"
	icon = 'modules/icons/clothing/teshari/suit.dmi'
	worn_icon = 'modules/icons/clothing/teshari/suit.dmi'
	worn_icon_teshari = 'modules/icons/clothing/teshari/suit.dmi'

/obj/item/clothing/suit/teshari/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(!is_species(equipper, /datum/species/teshari))
		to_chat(equipper, span_warning("[src] is far too small for you!"))
		return FALSE
	return ..()

/obj/item/clothing/under/teshari
	name = "teshari base"
	desc = "HOW YOU GET THIS?"
	icon = 'modules/icons/clothing/teshari/under.dmi'
	worn_icon = 'modules/icons/clothing/teshari/under.dmi'
	worn_icon_teshari = 'modules/icons/clothing/teshari/under.dmi'

/obj/item/clothing/under/teshari/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(!is_species(equipper, /datum/species/teshari))
		to_chat(equipper, span_warning("[src] is far too small for you!"))
		return FALSE
	return ..()

/obj/item/clothing/suit/teshari/furcoat
	name = "tenka fabric coat"
	desc = "This is a small tenka fabric coat, with slits for wings. It’s visible that it was sewn for a small creature."
	icon_state = "zanozkin_furcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/labcoat
	name = "lab coat"
	desc = "This is a very long laboratory coat and it has slits for wings."
	icon_state = "zanozkin_labcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/labcoat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/teshari/graycoat
	name = "grey coat"
	desc = "This is a grey coat, it has hidden slits for wings, the material seems expensive and from a certain angle the bottom part seems transparent."
	icon_state = "zanozkin_strangeshirt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/jacket
	name = "black jacket FZ"
	desc = "This is a black jacket from an unknown company with hidden slits for wings."
	icon_state = "zanozkin_coldcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/jacket/noblue
	icon_state = "zanozkin_coldcoat_noblue"

/obj/item/clothing/suit/teshari/russian_jacket
	name = "russian raptor coat"
	desc = "This is a fucking Russian jacket for raptors."
	icon_state = "zanozkin_coat_korea"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/aqua_cloak
	name = "short shirt FZ"
	desc = "This is a short shirt from an unknown company for small winged creatures"
	icon_state = "zanozkin_aquacloak"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/aqua_cloak/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/under/teshari/consultant
	name = "crocs suit"
	desc = "Crocs clothes for little winged creatures!"
	icon_state = "zanozkin_consultant"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/consultant/female
	name = "crocs skirt"
	icon_state = "zanozkin_consultant_skirt"

/obj/item/clothing/under/teshari/nt_combineso
	name = "combeniso NT"
	desc = "This jumpsuit was custom-made for workers of the Avali race near their homeland."
	icon_state = "zanozkin_nt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/meme
	name = "shirt and shorts"
	desc = "It's just a shirt and shorts, but it reminds me of something."
	icon_state = "zanozkin_meme"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/elite_suit
	name = "elite feathered"
	desc = "White shirt, black bow tie and beige pants. This suit doesn't look bad."
	icon_state = "zanozkin_elite"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/elite_suit/plus
	name = "elite feathered deluxe"
	desc = "White shirt, black bow tie, beige jacket and beige pants. This suit doesn't look bad"
	icon_state = "zanozkin_eliteplus"

/obj/item/clothing/under/teshari/waistcoat
	name = "delicate suit"
	desc = "Costume for winged pick-up artist."
	icon_state = "zanozkin_waistcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/mechsuit
	name = "rivka"
	desc = "Personalized suit, it seems it was made to order and given as a gift"
	icon_state = "zanozkin_mechsuit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit
	species_clothing_color_coords = list(list(COAT_COLORPIXEL_X_1, COAT_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/coat

/obj/item/clothing/suit/wizrobe
	species_clothing_color_coords = list(list(THICKROBE_COLORPIXEL_X_1, THICKROBE_COLORPIXEL_Y_1), list(THICKROBE_COLORPIXEL_X_2, THICKROBE_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(THICKROBE_COLORPIXEL_X_4, THICKROBE_COLORPIXEL_Y_4), list(THICKROBE_COLORPIXEL_X_5, THICKROBE_COLORPIXEL_Y_5), list(THICKROBE_COLORPIXEL_X_6, THICKROBE_COLORPIXEL_Y_6))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/thickrobe/wiz

/obj/item/clothing/suit/jacket/trenchcoat
	species_clothing_color_coords = list(list(LONGCOAT_COLORPIXEL_X_1, LONGCOAT_COLORPIXEL_Y_1), list(THICKROBE_COLORPIXEL_X_2, THICKROBE_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(LONGCOAT_COLORPIXEL_X_4, LONGCOAT_COLORPIXEL_Y_4))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/thickrobe/longcoat

/obj/item/clothing/suit/jacket
	species_clothing_color_coords = list(list(JACKET_COLORPIXEL_X_1, JACKET_COLORPIXEL_Y_1), list(JACKET_COLORPIXEL_X_2, JACKET_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(JACKET_COLORPIXEL_X_4, JACKET_COLORPIXEL_Y_4))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/thickrobe/jacket

/obj/item/clothing/suit/armor
	species_clothing_color_coords = list(list(ARMOR_COLORPIXEL_X_1, ARMOR_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/armor

/obj/item/clothing/suit/space
	species_clothing_color_coords = list(list(SPACESUIT_COLORPIXEL_X_1, SPACESUIT_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/spacesuit

/obj/item/clothing/suit/mod
	species_clothing_color_coords = list(list(MODSUIT_COLORPIXEL_X_1, MODSUIT_COLORPIXEL_Y_1), list(MODSUIT_COLORPIXEL_X_2, MODSUIT_COLORPIXEL_Y_2), list(MODSUIT_COLORPIXEL_X_3, MODSUIT_COLORPIXEL_Y_3))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/hardsuit

/obj/item/clothing/under
	species_clothing_color_coords = list(list(UNDER_COLORPIXEL_X_1, UNDER_COLORPIXEL_Y_1), list(UNDER_COLORPIXEL_X_2, UNDER_COLORPIXEL_Y_2), list(UNDER_COLORPIXEL_X_3, UNDER_COLORPIXEL_Y_3))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/under
	greyscale_config_worn_teshari_fallback_skirt = /datum/greyscale_config/teshari/under_skirt

/obj/item/mod/control
	species_clothing_color_coords = list(list(MODCONTROL_COLORPIXEL_X_1, MODCONTROL_COLORPIXEL_Y_1))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/modcontrol

///GAGS below here

/obj/item/clothing/under/color
	greyscale_config_worn_teshari = /datum/greyscale_config/jumpsuit/worn/teshari

/obj/item/clothing/under/color/jumpskirt
	greyscale_config_worn_teshari = /datum/greyscale_config/jumpsuit/worn/teshari

/obj/item/clothing/shoes/sneakers
	greyscale_config_worn_teshari = /datum/greyscale_config/sneakers/worn/teshari

/obj/item/clothing/shoes/sneakers/orange
	greyscale_config_worn_teshari = /datum/greyscale_config/sneakers_orange/worn/teshari

/obj/item/clothing/head/collectable/beret
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/collectable/flatcap
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/frenchberet
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/flatcap
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/caphat/beret
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/beret/badge
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/hats/hos/beret
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/sec
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/science/fancy
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/science/rd
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/durathread
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/centcom_formal
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/militia
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/sec/navywarden
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge_fancy/worn/teshari

/obj/item/clothing/head/beret/medical
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/engi
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/atmos
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/cargo/qm
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/hopcap/beret
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/blueshield
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/flatcap
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/frenchberet
	greyscale_config_worn_teshari = /datum/greyscale_config/beret/worn/teshari

/obj/item/clothing/head/beret/sec/navywarden/syndicate
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/nanotrasen_consultant/beret
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/head/beret/sec/peacekeeper/armadyne
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge_fancy/worn/teshari

/obj/item/clothing/head/beret/sec/peacekeeper
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari

/obj/item/clothing/neck/ranger_poncho
	greyscale_config_worn_teshari = /datum/greyscale_config/ranger_poncho/worn/teshari

/obj/item/clothing/under/dress/skirt/plaid
	greyscale_config_worn_teshari = /datum/greyscale_config/plaidskirt/worn/teshari

/obj/item/clothing/under/dress/sundress
	greyscale_config_worn_teshari = /datum/greyscale_config/sundress/worn/teshari

/obj/item/clothing/neck/scarf
	greyscale_config_worn_teshari = /datum/greyscale_config/scarf/worn/teshari

/obj/item/clothing/suit/toggle/suspenders
	greyscale_config_worn_teshari = /datum/greyscale_config/suspenders/worn/teshari

// Unique clothing here

/obj/item/clothing/suit/kimjacket
	species_clothing_color_coords = list(list(JACKET_COLORPIXEL_X_1, JACKET_COLORPIXEL_Y_1), list(JACKET_COLORPIXEL_X_2, JACKET_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(JACKET_COLORPIXEL_X_4, JACKET_COLORPIXEL_Y_4))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/thickrobe/jacket

/obj/item/clothing/suit/discoblazer
	species_clothing_color_coords = list(list(JACKET_COLORPIXEL_X_1, JACKET_COLORPIXEL_Y_1), list(JACKET_COLORPIXEL_X_2, JACKET_COLORPIXEL_Y_2), list(THICKROBE_COLORPIXEL_X_3, THICKROBE_COLORPIXEL_Y_3), list(JACKET_COLORPIXEL_X_4, JACKET_COLORPIXEL_Y_4))
	greyscale_config_worn_teshari_fallback = /datum/greyscale_config/teshari/thickrobe/jacket

// Wintercoats and Satchels

/obj/item/storage/backpack/satchel
	worn_icon_teshari = 'modular_skyrat/master_files/icons/mob/clothing/species/teshari/back.dmi'

/obj/item/storage/backpack/duffelbag
	worn_icon_teshari = 'modular_skyrat/master_files/icons/mob/clothing/species/teshari/back.dmi'

/obj/item/clothing/suit/hooded/wintercoat/equipped(mob/living/user, slot)
	var/mob/living/carbon/human/teshari = user
	if(teshari.dna.species.name == "Teshari")
		var/datum/component/toggle_attached_clothing/component = GetComponent(/datum/component/toggle_attached_clothing)
		component.undeployed_overlay = null
	. = ..()

