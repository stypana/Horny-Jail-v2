#define POLLS_CACHE_FILE "data/polls_cache.json"

SUBSYSTEM_DEF(polls)
name = "Polls"
flags = SS_NO_FIRE | SS_NO_INIT

var/ready = FALSE
var/loading = FALSE

/datum/controller/subsystem/polls/Initialize(timeofday)
	loading = TRUE
	load_from_cache()
	if(load_from_db())
		ready = TRUE
		write_cache()
		loading = FALSE
		return SS_INIT_SUCCESS

/datum/controller/subsystem/polls/proc/load_from_cache()
	if(!fexists(POLLS_CACHE_FILE))
		return FALSE
	var/text = file2text(POLLS_CACHE_FILE)
	if(!text)
		return FALSE
	var/list/data = json_decode(text)
	if(!islist(data))
		return FALSE
	var/list/polls_data = data["polls"]
	if(!islist(polls_data))
		return FALSE
	for(var/list/p in polls_data)
		var/datum/poll_question/poll = new(p["id"], p["polltype"], p["starttime"], p["endtime"], p["question"], p["subtitle"], p["adminonly"], p["multiplechoiceoptions"], p["dontshow"], p["allow_revoting"], p["poll_votes"], p["created_by"], p["future_poll"], TRUE)
		var/list/options = p["options"]
	if(islist(options))
		for(var/list/o in options)
		var/datum/poll_option/option = new(o["id"], o["text"], o["minval"], o["maxval"], o["descmin"], o["descmid"], o["descmax"], o["default_percentage_calc"])
		poll.options += option
		option.parent_poll = poll
		ready = GLOB.polls.len > 0
		return ready

/datum/controller/subsystem/polls/proc/load_from_db()
	var/mob/user = usr
	if(!SSdbcore.Connect())
		if(user)
		to_chat(user, span_danger("Failed to establish database connection."), confidential = TRUE)
		return FALSE
	var/datum/db_query/query_load_polls = SSdbcore.NewQuery("SELECT id, polltype, starttime, endtime, question, subtitle, adminonly, multiplechoiceoptions, dontshow, allow_revoting, IF(polltype='TEXT',(SELECT COUNT(ckey) FROM [format_table_name(\"poll_textreply\")] AS t WHERE t.pollid = q.id AND deleted = 0), (SELECT COUNT(DISTINCT ckey) FROM [format_table_name(\"poll_vote\")] AS v WHERE v.pollid = q.id AND deleted = 0)), IFNULL((SELECT byond_key FROM [format_table_name(\"player\")] AS p WHERE p.ckey = q.createdby_ckey), createdby_ckey), IF(starttime > NOW(), 1, 0) FROM [format_table_name(\"poll_question\")] AS q WHERE NOW() < endtime AND deleted = 0")
	if(!query_load_polls.Execute())
		qdel(query_load_polls)
		return FALSE
	var/list/poll_ids = list()
	while(query_load_polls.NextRow())
		new /datum/poll_question(query_load_polls.item[1], query_load_polls.item[2], query_load_polls.item[3], query_load_polls.item[4], query_load_polls.item[5], query_load_polls.item[6], query_load_polls.item[7], query_load_polls.item[8], query_load_polls.item[9], query_load_polls.item[10], query_load_polls.item[11], query_load_polls.item[12], query_load_polls.item[13], TRUE)
		poll_ids += query_load_polls.item[1]
		qdel(query_load_polls)
	if(length(poll_ids))
		var/datum/db_query/query_load_poll_options = SSdbcore.NewQuery("SELECT id, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc, pollid FROM [format_table_name(\"poll_option\")] WHERE pollid IN ([jointext(poll_ids, \",\")])")
	if(!query_load_poll_options.Execute())
		qdel(query_load_poll_options)
		return FALSE
	while(query_load_poll_options.NextRow())
		var/datum/poll_option/option = new(query_load_poll_options.item[1], query_load_poll_options.item[2], query_load_poll_options.item[3], query_load_poll_options.item[4], query_load_poll_options.item[5], query_load_poll_options.item[6], query_load_poll_options.item[7], query_load_poll_options.item[8])
		var/option_poll_id = text2num(query_load_poll_options.item[9])
	for(var/q in GLOB.polls)
		var/datum/poll_question/poll = q
	if(poll.poll_id == option_poll_id)
		poll.options += option
		option.parent_poll = poll
		qdel(query_load_poll_options)
		return TRUE

/datum/controller/subsystem/polls/proc/write_cache()
	var/list/polls_cache = list()
	for(var/datum/poll_question/poll in GLOB.polls)
		var/list/poll_entry = list(
		"id" = poll.poll_id,
		"polltype" = poll.poll_type,
		"starttime" = poll.start_datetime,
		"endtime" = poll.end_datetime,
		"question" = poll.question,
		"subtitle" = poll.subtitle,
		"adminonly" = poll.admin_only,
		"multiplechoiceoptions" = poll.options_allowed,
		"dontshow" = poll.dont_show,
		"allow_revoting" = poll.allow_revoting,
		"poll_votes" = poll.poll_votes,
		"created_by" = poll.created_by,
		"future_poll" = poll.future_poll,
		"options" = list()
		)
	for(var/datum/poll_option/option in poll.options)
		poll_entry["options"] += list(list(
		"id" = option.option_id,
		"text" = option.text,
		"minval" = option.min_val,
		"maxval" = option.max_val,
		"descmin" = option.desc_min,
		"descmid" = option.desc_mid,
		"descmax" = option.desc_max,
		"default_percentage_calc" = option.default_percentage_calc,
		))
		polls_cache += list(poll_entry)
		var/list/file_data = list("polls" = polls_cache)
		text2file(json_encode(file_data), POLLS_CACHE_FILE)

/datum/controller/subsystem/polls/proc/reload()
	if(loading)
		return
	loading = TRUE
	ready = FALSE
	GLOB.polls.Cut()
	GLOB.poll_options.Cut()
	if(load_from_db())
		ready = TRUE
		write_cache()
		loading = FALSE

