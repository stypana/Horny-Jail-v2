/datum/world_topic
	/// query key
	var/key

	/// can be used with anonymous authentication
	var/anonymous = FALSE

	var/list/required_params = list()
	var/statuscode
	var/response
	var/data

/datum/world_topic/proc/CheckParams(list/params)
	var/list/missing_params = list()
	var/errorcount = 0

	for(var/param in required_params)
		if(!params[param])
			errorcount++
			missing_params += param

	if(errorcount)
		statuscode = 400
		response = "Bad Request - Missing parameters"
		data = missing_params
		return errorcount

/datum/world_topic/proc/Run(list/input)
	// Always returns true; actual details in statuscode, response and data variables
	return TRUE

// API INFO TOPICS

/datum/world_topic/api_get_authed_functions
	key = "api_get_authed_functions"
	anonymous = TRUE

/datum/world_topic/api_get_authed_functions/Run(list/input)
	. = ..()
	var/list/functions = GLOB.topic_tokens[input["auth"]]
	if(functions)
		statuscode = 200
		response = "Authorized functions retrieved"
		data = functions
	else
		statuscode = 401
		response = "Unauthorized - No functions found"
		data = null

// TOPICS

/datum/world_topic/identify_uuid
	key = "identify_uuid"
	anonymous = TRUE

/datum/world_topic/identify_uuid/Run(list/input, addr)
	var/uuid = input["uuid"]
	. = list()

	if(!SSdbcore.Connect())
		return null

	var/datum/db_query/query_ckey_lookup = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE uuid = :uuid",
		list("uuid" = uuid)
	)
	if(!query_ckey_lookup.Execute())
		qdel(query_ckey_lookup)
		return null

	.["identified_ckey"] = null
	if(query_ckey_lookup.NextRow())
		.["identified_ckey"] = query_ckey_lookup.item[1]
	qdel(query_ckey_lookup)
	return .

/datum/world_topic/ping
	key = "ping"
	anonymous = TRUE

/datum/world_topic/ping/Run(list/input)
	. = ..()
	statuscode = 200
	response = "Pong!"
	data = length(GLOB.clients)

/datum/world_topic/status
	key = "status"
	anonymous = TRUE

/datum/world_topic/status/Run(list/input)
	. = ..()

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]

	data = list()

	data["mode"] = SSgamemode.storyteller ? SSgamemode.storyteller.name : "N/A"

	data["round_id"] = null
	if(GLOB.round_id)
		data["round_id"] = GLOB.round_id

	data["enter"] = config ? !!CONFIG_GET(flag/allow_respawn) : FALSE // show respawn as true regardless of "respawn as char" or "free respawn"

	data["map_name"] = null
	if(SSmapping.current_map)
		data["map_name"] = SSmapping.current_map.map_name

	data["players"] = length(GLOB.clients)

	data["revision"] = GLOB.revdata.commit
	data["revision_date"] = GLOB.revdata.date

	data["round_duration"] = world.time - SSticker.round_start_time
	data["security_level"] = SSsecurity_level ? SSsecurity_level.get_current_level_as_number() : "0"

	data["admins"] = length(presentmins) + length(afkmins)

	data["admins"] = length(presentmins) + length(afkmins)

	statuscode = 200
	response = "Status retrieved"

/datum/world_topic/status/authed
	key = "status_authed"
	anonymous = FALSE

/datum/world_topic/status/authed/Run(list/input)
	. = ..()

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	data["admins"] = length(presentmins) + length(afkmins)
	data["gamestate"] = SSticker.current_state

	//Time dilation stats.
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	data["mcpu"] = world.map_cpu
	data["cpu"] = world.cpu


/datum/world_topic/lookup_ckey
	key = "lookup_ckey"
	required_params = list("ckey")

/datum/world_topic/lookup_ckey/Run(list/input)
	data = list()

	statuscode = 500
	response = "Something went wrong, address issues."

	var/datum/db_query/query_player_ckey = SSdbcore.NewQuery({"
		SELECT ckey
		FROM [format_table_name("player")]
		WHERE ckey LIKE :ckey"},
		list("ckey" = input["ckey"])
	)

	var/seen_before
	if(query_player_ckey.warn_execute())
		seen_before = query_player_ckey.NextRow()

	var/datum/discord_link_record/player_link = SSdiscord.find_discord_link_by_ckey(input["ckey"])
	if(!player_link && !seen_before)
		statuscode = 501
		response = "Not found player."
		qdel(query_player_ckey)
		return

	data["ckey"] = player_link ? player_link.ckey : query_player_ckey.item[1]
	data["discord_id"] = player_link ? player_link.discord_id : FALSE
	qdel(query_player_ckey)
	if(input["additional"])
		request_additional_data(data)
	statuscode = 200
	response = "Lookup successful."

/proc/request_additional_data(list/data)
	//BANS
	var/datum/db_query/query_search_bans = SSdbcore.NewQuery({"
		SELECT id, bantime, bantype, reason, job, duration, expiration_time, IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey), IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey), unbanned, IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].unbanned_ckey), unbanned_ckey), unbanned_datetime, edits, round_id
		FROM [format_table_name("ban")]
		WHERE ckey = :ckey ORDER BY bantime"}, list("ckey" = data["ckey"]))
	if(query_search_bans.Execute())
		data["bans"] = list()
		while(query_search_bans.NextRow())
			if(query_search_bans.item[10])
				continue

			data["bans"] += list(list(
				"bantime" = query_search_bans.item[2],
				"bantype"  = query_search_bans.item[3],
				"reason" = query_search_bans.item[4],
				"job" = query_search_bans.item[5],
				"duration" = query_search_bans.item[6],
				"expiration" = query_search_bans.item[7],
				"round_id" = query_search_bans.item[14]
			))
	qdel(query_search_bans)

	//NOTES
	var/datum/db_query/query_get_messages = SSdbcore.NewQuery({"
		SELECT
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE ckey = adminckey), adminckey),
			text,
			timestamp,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE ckey = lasteditor), lasteditor)
		FROM [format_table_name("messages")]
		WHERE type = :type
		AND deleted = 0
		AND (expire_timestamp > NOW() OR expire_timestamp IS NULL)
		AND targetckey = :targetckey)
	"}, list("targetckey" = data["ckey"]))
	if(query_get_messages.Execute())
		data["notes"] = list()
		while(query_get_messages.NextRow())
			data["notes"] += list(list(
				"admin_key" = query_get_messages.item[1],
				"text" = query_get_messages.item[2],
				"timestamp" = query_get_messages.item[3],
				"editor_key" = query_get_messages.item[4]
			))
	qdel(query_get_messages)

	var/datum/db_query/exp_read = SSdbcore.NewQuery(
		"SELECT job, minutes FROM [format_table_name("role_time")] WHERE ckey = :ckey",
		list("ckey" = data["ckey"])
	)
	if(exp_read.Execute())
		var/list/play_records = list()
		data["playtimes"] = play_records
		while(exp_read.NextRow())
			play_records[exp_read.item[1]] = text2num(exp_read.item[2])
	qdel(exp_read)

GLOBAL_LIST_EMPTY(bot_event_sending_que)
GLOBAL_LIST_EMPTY(bot_ooc_sending_que)
GLOBAL_LIST_EMPTY(bot_asay_sending_que)

/datum/world_topic/receive_info
	key = "receive_info"

/datum/world_topic/receive_info/Run(list/input)
	data = list()
	if(!length(GLOB.bot_event_sending_que) && !length(GLOB.bot_ooc_sending_que) && !length(GLOB.bot_asay_sending_que))
		statuscode = 501
		response = "No events pool."
		return

	//Yeah, we can use /datum/http_request, but nuh... it's less fun.
	data["events"] = GLOB.bot_event_sending_que
	data["ooc"] = GLOB.bot_ooc_sending_que
	data["admin"] = GLOB.bot_asay_sending_que
	GLOB.bot_event_sending_que = list()
	GLOB.bot_ooc_sending_que = list()
	GLOB.bot_asay_sending_que = list()
	statuscode = 200
	response = "Events sent."

/datum/world_topic/send_info
	key = "send_info"
	required_params = list("data")

/datum/world_topic/send_info/Run(list/input)
	data = list()

	var/list/bot_data = input["data"]
	if(!istype(bot_data) || !length(bot_data))
		statuscode = 403
		response = "Wrong data"
		return

	if(bot_data["ooc"])
		for(var/list/data in bot_data["ooc"])
			var/msg = sanitize(data["message"])
			for(var/client/C in GLOB.clients)
				if(C.prefs.chat_toggles & CHAT_OOC)
					to_chat(C, "<span class='ooc'><span class='prefix'>DISCORD OOC:</span> <EM>[data["author"]]:</EM> <span class='message linkify'>[msg]</span></span>")

	if(bot_data["admin"])
		for(var/list/data in bot_data["admin"])
			to_chat(GLOB.admins, "<span class='adminsay'><span class='prefix'>DISCORD ADMIN:</span> <EM>[data["author"]]</EM>: <span class='message linkify'>[sanitize(data["message"])]</span></span>", confidential = TRUE)

	statuscode = 200
	response = "Events received."

/datum/world_topic/whois
	key = "whoIs"

/datum/world_topic/whois/Run(list/input)
	. = list()
	.["players"] = GLOB.clients

	return list2params(.)

/datum/world_topic/getadmins
	key = "getAdmins"

/datum/world_topic/getadmins/Run(list/input)
	. = list()
	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	.["admins"] = presentmins
	.["admins"] += afkmins

	return list2params(.)
