SUBSYSTEM_DEF(redbot)
	name = "Bot Comms"
	flags = SS_NO_FIRE

/datum/controller/subsystem/redbot/Initialize(timeofday)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/redbot/proc/round_end_ping()
	var/comms_key = CONFIG_GET(string/comms_key)
	var/bot_ip = CONFIG_GET(string/bot_ip)
	var/round_id = GLOB.round_id
	if(bot_ip)
		var/list/data = list(
			"roundEnd" = 1,
			"roundID" = round_id,
			"key" = comms_key,
		)
		var/datum/feedback_variable/round_stats = SSblackbox.feedback_list?["round_end_stats"]
		if(round_stats)
			var/list/stats = round_stats.json?["data"]
			if(stats)
				data["survivors"] = stats?["survivors"]?["total"] || 0
				data["escapees"] = stats?["escapees"]?["total"] || 0
				data["players"] = stats?["players"]?["total"] || 0
				data["deaths"] = stats?["players"]?["dead"] || 0
			var/datum/feedback_variable/food_stats = SSblackbox.feedback_list?["food_made"]
			if(food_stats)
				var/list/foods = food_stats.json?["data"]
				var/drinks = 0
				for(var/item_path in foods)
					if(findtext(item_path, "/obj/item/reagent_containers/food/drinks"))
						drinks += foods[item_path]
				data["drinks"] = drinks
		var/moths = 0
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.mind && H.dna?.species?.id == SPECIES_MOTH)
				moths++
		data["moths"] = moths
		world.Export("http://[bot_ip]/?[list2params(data)]")

/datum/controller/subsystem/redbot/proc/send_discord_message(var/channel, var/message, var/priority_type)
	var/bot_ip = CONFIG_GET(string/bot_ip)
	if(!bot_ip)
		return

	var/list/data = list()
	data["key"] = CONFIG_GET(string/comms_key)
	data["announce_channel"] = channel
	data["announce"] = message
	data["type"] = priority_type

	world.Export("http://[bot_ip]/?[list2params(data)]")
