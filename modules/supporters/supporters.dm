#define PLAYER_RANK_TABLE_NAME "player"

#define SUPPORTER_TIER_NONE 0
#define SUPPORTER_TIER_1 1
#define SUPPORTER_TIER_2 2
#define SUPPORTER_TIER_3 3
#define SUPPORTER_TIER_4 4
#define SUPPORTER_TIER_5 5

GLOBAL_LIST_EMPTY(supporter_list)
GLOBAL_PROTECT(supporter_list)

GLOBAL_LIST_EMPTY(griefer_list)
GLOBAL_PROTECT(griefer_list)

/proc/load_supporters_from_db()
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT ckey, supporter_tier FROM [format_table_name(PLAYER_RANK_TABLE_NAME)] WHERE supporter_tier > 0"
	)
	if(!query.warn_execute())
		qdel(query)
		log_world("❌ Не удалось загрузить донатеров из БД.")
		return

	while(query.NextRow())
		var/ckey = lowertext(query.item[1])
		var/tier = text2num(query.item[2])
		if(isnum(tier) && tier > 0)
			GLOB.supporter_list[ckey] = tier

	qdel(query)
	log_world("✅ Загружено донатеров: [length(GLOB.supporter_list)]")


/proc/load_griefers_from_db()
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT ckey, is_griefer FROM [format_table_name(PLAYER_RANK_TABLE_NAME)] WHERE is_griefer != 0"
	)
	if(!query.warn_execute())
		qdel(query)
		log_world("❌ Не удалось загрузить набегаторов.")
		return

	while(query.NextRow())
		var/ckey = lowertext(query.item[1])
		var/bool = text2num(query.item[2])
		if(isnum(bool) && bool > 0)
			GLOB.griefer_list[ckey] += bool

	qdel(query)
	log_world("✅ Загружено набегаторов: [length(GLOB.griefer_list)]")
