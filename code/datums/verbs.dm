#define VERB_CACHE_FILE "data/verbs_cache.json"

var/static/list/cached_verbs = list()

/world/proc/LoadVerbCache()
	if(rustg_file_exists(VERB_CACHE_FILE))
		var/list/raw = json_decode(rustg_file_read(VERB_CACHE_FILE))
		if(islist(raw))
			for(var/verb_type_str in raw)
				var/list/stored = raw[verb_type_str]
				var/path_type = text2path(verb_type_str)
				if(!path_type || !islist(stored))
					continue
				var/list/path_list = list()
				for(var/verb_path_str in stored)
					var/verb_path = text2path(verb_path_str)
					if(verb_path)
						path_list += verb_path
				cached_verbs[path_type] = path_list

/world/proc/SaveVerbCache()
	var/list/output = list()
	for(var/verb_type in cached_verbs)
		var/list/path_list = list()
		for(var/path in cached_verbs[verb_type])
			path_list += "[path]"
		output["[verb_type]"] = path_list
	rustg_file_write(json_encode(output), VERB_CACHE_FILE)

/datum/verbs
	var/name
	var/list/children
	var/datum/verbs/parent
	var/list/verblist
	var/abstract = FALSE

//returns the master list for verbs of a type
/datum/verbs/proc/GetList()
	CRASH("Abstract verblist for [type]")

//do things for each entry in Generate_list
//return value sets Generate_list[verbpath]
/datum/verbs/proc/HandleVerb(list/entry, procpath/verbpath, ...)
	return entry

/datum/verbs/New()
	var/mainlist = GetList()
	var/ourentry = mainlist[type]
	children = list()
	verblist = list()
	if (ourentry)
		if (!islist(ourentry)) //some of our childern already loaded
			qdel(src)
			CRASH("Verb double load: [type]")
		Add_children(ourentry)

	mainlist[type] = src

	Load_verbs(type, typesof("[type]/verb"))

	var/datum/verbs/parent = mainlist[parent_type]
	if (!parent)
		mainlist[parent_type] = list(src)
	else if (islist(parent))
		parent += src
	else
		parent.Add_children(list(src))

/datum/verbs/proc/Set_parent(datum/verbs/_parent)
	parent = _parent
	if (abstract)
		parent.Add_children(children)
		var/list/verblistoftypes = list()
		for(var/thing in verblist)
			LAZYADD(verblistoftypes[verblist[thing]], thing)

		for(var/verbparenttype in verblistoftypes)
			parent.Load_verbs(verbparenttype, verblistoftypes[verbparenttype])

/datum/verbs/proc/Add_children(list/kids)
	if (abstract && parent)
		parent.Add_children(kids)
		return

	for(var/thing in kids)
		var/datum/verbs/item = thing
		item.Set_parent(src)
		if (!item.abstract)
			children += item

/datum/verbs/proc/Load_verbs(verb_parent_type, list/verbs)
	if (abstract && parent)
		parent.Load_verbs(verb_parent_type, verbs)
		return

	for (var/verbpath in verbs)
		verblist[verbpath] = verb_parent_type

/datum/verbs/proc/Generate_list(...)
	. = list()
	if (length(children))
		for (var/thing in children)
			var/datum/verbs/child = thing
			var/list/childlist = child.Generate_list(arglist(args))
			if (childlist)
				var/childname = "[child]"
				if (childname == "[child.type]")
					var/list/tree = splittext(childname, "/")
					childname = tree[tree.len]
				.[child.type] = "parent=[url_encode("[type]")];name=[childname]"
				. += childlist

	for (var/thing in verblist)
		var/procpath/verbpath = thing
		if (!verbpath)
			stack_trace("Bad VERB in [type] verblist: [english_list(verblist)]")
		var/list/entry = list()
		entry["parent"] = "[type]"
		entry["name"] = verbpath.desc
		if (verbpath.name[1] == "@")
			entry["command"] = copytext(verbpath.name, length(verbpath.name[1]) + 1)
		else
			entry["command"] = replacetext(verbpath.name, " ", "-")

		.[verbpath] = HandleVerb(arglist(list(entry, verbpath) + args))

/world/proc/LoadVerbs(verb_type)
		if(!ispath(verb_type, /datum/verbs) || verb_type == /datum/verbs)
				CRASH("Invalid verb_type: [verb_type]")

		var/list/list_paths = cached_verbs[verb_type]
		if(!list_paths)
				list_paths = subtypesof(verb_type)
				cached_verbs[verb_type] = list_paths

		for(var/typepath in list_paths)
				new typepath()
