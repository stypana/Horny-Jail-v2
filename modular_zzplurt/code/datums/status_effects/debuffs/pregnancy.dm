/**
 * Who is the liar but he who denies that Jesus is the Christ? This is the antichrist, he who denies the Father and the Son.
 * - John 2:22
 */
/datum/status_effect/pregnancy
	id = "pregnancy"
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/decloning
	remove_on_fullheal = TRUE

/atom/movable/screen/alert/status_effect/pregnancy
	name = "Pregnant"
	desc = "Something rumbles inside you."
	icon = 'modular_zzplurt/icons/hud/screen_alert.dmi'
	icon_state = "baby"
