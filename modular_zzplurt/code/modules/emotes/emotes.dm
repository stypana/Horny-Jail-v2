/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/hiss/get_sound(mob/living/user)
	return pick('modular_zzplurt/sound/voice/catpeople/cat_hiss1.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_hiss2.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_hiss3.ogg')

/datum/emote/living/coo
	key = "coo"
	key_third_person ="coos"
	message = "coos."
	emote_type = EMOTE_AUDIBLE
	vary = TRUE
	sound = 'modular_zzplurt/sound/voice/coo.ogg'

/datum/emote/living/huh
	key = "huh"
	key_third_person = "huh's"
	message = "seems confused."
	sound = 'modular_zzplurt/sound/voice/huh.ogg'

/datum/emote/living/whine
	key = "whine"
	key_third_person = "whines"
	message = "whines."
	sound = 'modular_zzplurt/sound/voice/whine.ogg'

/datum/emote/living/meow4
	key = "meow"
	key_third_person = "meows"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/meow4/get_sound(mob/living/user)
	return pick('modular_zzplurt/sound/voice/catpeople/cat_meow4.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_meow5.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_meow6.ogg',
				'modular_zzplurt/sound/voice/catpeople/cat_meow7.ogg')
