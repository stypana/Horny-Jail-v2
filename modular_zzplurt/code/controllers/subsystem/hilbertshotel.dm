SUBSYSTEM_DEF(hilbertshotel)
	name = "Hilbert's Hotel"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_HILBERTSHOTEL

	var/list/obj/item/hilbertshotel/all_hilbert_spheres = list()

	// Some placeholder templates
	var/datum/map_template/hilbertshotel/hotel_room_template
	var/datum/map_template/hilbertshotel/empty/hotel_room_template_empty
	var/datum/map_template/hilbertshotel/lore/hotel_room_template_lore

	/// List of active rooms with their data.
	var/list/room_data = list()
	/// List of "frozen" rooms.
	var/list/conservated_rooms = list()
	var/storageTurf
	// Lore stuff
	var/lore_room_spawned = FALSE

	var/list/hotel_map_list = list()
	/// Name of the first template in the list - used as default
	var/default_template

	// List of strings used for the prompt check-in message
	var/static/list/vanity_strings = list(
		"You feel a strange sense of déjà vu.",
		"You feel chills rolling down your spine.",
		"You suddenly feel like you're being watched from behind.",
		"You feel like a gust of bone-chilling cold is passing through you.",
		"Your vision gets a little blurry for a moment.",
		"Your heart sinks as you feel a strange sense of dread.",
		"Your mouth goes dry.",
		"You feel uneasy.",
	)

	/// List of ckey-based user preferences
	var/list/user_data = list()

	var/hhMysteryroom_number

/datum/controller/subsystem/hilbertshotel/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_HILBERT_ROOM_UPDATED, PROC_REF(on_room_updated))
	hhMysteryroom_number = hhMysteryroom_number || rand(1, 999999)
	setup_storage_turf()
	prepare_rooms()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/hilbertshotel/proc/setup_storage_turf()
	if(!storageTurf) // setting up a storage for the room objects
		var/datum/map_template/hilbertshotelstorage/storageTemp = new()
		var/datum/turf_reservation/storageReservation = SSmapping.request_turf_block_reservation(3, 3)
		var/turf/bottom_left = get_turf(storageReservation.bottom_left_turfs[1])
		storageTemp.load(bottom_left)
		storageTurf = locate(bottom_left.x + 1, bottom_left.y + 1, bottom_left.z)

/datum/controller/subsystem/hilbertshotel/proc/prepare_rooms()
	if(length(hotel_map_list))
		return
	var/list/hotel_map_templates = typecacheof(list(
		/datum/map_template/ghost_cafe_rooms,
	), ignore_root_path = TRUE)

	hotel_room_template = new()
	hotel_room_template_empty = new()
	hotel_room_template_lore = new()

	for(var/template_type in hotel_map_templates)
		var/datum/map_template/this_template = new template_type()
		hotel_map_list[this_template.name] = this_template

	default_template = hotel_map_list[hotel_map_list[1]]

/// Attempts to join an existing active room. Returns TRUE if successful, FALSE otherwise. Requires `room_number` to be set.
/datum/controller/subsystem/hilbertshotel/proc/try_join_active_room(room_number, mob/user)
	if(!room_data["[room_number]"])
		return FALSE
	var/datum/turf_reservation/roomReservation = room_data["[room_number]"]["reservation"]
	do_sparks(3, FALSE, get_turf(user))
	var/turf/room_bottom_left = roomReservation.bottom_left_turfs[1]
	user.forceMove(locate(
		room_bottom_left.x + hotel_room_template.landingZoneRelativeX,
		room_bottom_left.y + hotel_room_template.landingZoneRelativeY,
		room_bottom_left.z,
	))
	return TRUE

/// Attempts to recreate and join an existing stored room. Returns TRUE if successful, FALSE otherwise. Requires `room_number` to be set.
/datum/controller/subsystem/hilbertshotel/proc/try_join_conservated_room(room_number, mob/user, obj/item/hilbertshotel/parentSphere)
	if(!conservated_rooms["[room_number]"])
		return FALSE

	var/list/conservated_room_data = conservated_rooms["[room_number]"]
	if(!conservated_room_data)
		return FALSE

	var/list/storage = conservated_room_data["storage"]
	if(!storage)
		return FALSE

	var/datum/turf_reservation/roomReservation = SSmapping.request_turf_block_reservation(hotel_room_template.width, hotel_room_template.height, 1)
	var/turf/room_turf = roomReservation.bottom_left_turfs[1]

	var/template_name = conservated_room_data["template"]
	var/datum/map_template/template_to_load = hotel_map_list[template_name]
	template_to_load.load(room_turf)

	// clearing default objects
	for(var/x in 0 to hotel_room_template.width - 1)
		for(var/y in 0 to hotel_room_template.height - 1)
			var/turf/T = locate(room_turf.x + x, room_turf.y + y, room_turf.z)
			for(var/atom/movable/A in T)
				if(ismachinery(A))
					var/obj/machinery/M = A
					M.obj_flags += NO_DEBRIS_AFTER_DECONSTRUCTION
				if(ismob(A) && !isliving(A))
					continue
				if(istype(A, /obj/effect))
					continue
				if(length(A.GetComponents(/datum/component/wall_mounted)))
					continue
				QDEL_LIST(A.contents)
				qdel(A)

	// restoring saved objects
	var/turfNumber = 1
	for(var/x in 0 to hotel_room_template.width-1)
		for(var/y in 0 to hotel_room_template.height-1)
			var/turf/target_turf = locate(room_turf.x + x, room_turf.y + y, room_turf.z)
			for(var/atom/movable/A in storage["[turfNumber]"])
				if(istype(A.loc, /obj/item/abstracthotelstorage))
					var/old_resist = A.resistance_flags
					A.resistance_flags |= INDESTRUCTIBLE
					A.forceMove(target_turf)
					A.resistance_flags = old_resist
					if(istype(A, /obj/machinery/room_controller))
						var/obj/machinery/room_controller/controller = A
						controller.bluespace_box.in_hotel_room = TRUE
						controller.bluespace_box.creation_area = get_area(A.loc)
			turfNumber++

	// clearing the storage
	for(var/obj/item/abstracthotelstorage/this_item in storageTurf)
		if((this_item.room_number == room_number))
			qdel(this_item)

	// updating the room data
	conservated_rooms -= "[room_number]"
	room_data["[room_number]"] = list(
		"reservation" = roomReservation,
		"room_preferences" = list(
			"status" = ROOM_CLOSED,
			"visibility" = ROOM_VISIBLE,
			"privacy" = ROOM_GUESTS_HIDDEN,
		),
		"description" = null,
		"name" = conservated_room_data["name"],
		"door_reference" = room_turf,
		"icon" = conservated_room_data["icon"] || "door-open",
		"template" = conservated_room_data["template"]
	)

	link_turfs(roomReservation, room_number, parentSphere)
	var/turf/closed/indestructible/hoteldoor/door = room_data["[room_number]"]["door_reference"]
	door.entry_points[user.ckey] = parentSphere
	do_sparks(3, FALSE, get_turf(user))
	user.forceMove(locate(
		room_turf.x + hotel_room_template.landingZoneRelativeX,
		room_turf.y + hotel_room_template.landingZoneRelativeY,
		room_turf.z,
	))
	return TRUE

/// Creates a new room. Loads the room template and sends the user there. Requires `room_number` and `chosen_room` to be set.
/datum/controller/subsystem/hilbertshotel/proc/send_to_new_room(room_number, mob/user, template, obj/item/hilbertshotel/parentSphere)

	var/datum/turf_reservation/roomReservation = SSmapping.request_turf_block_reservation(hotel_room_template.width, hotel_room_template.height, 1)
	var/mysteryRoom = hhMysteryroom_number

	var/datum/map_template/load_from = hotel_room_template
	var/turf/bottom_left = roomReservation.bottom_left_turfs[1]

	if(lore_room_spawned && room_number == mysteryRoom)
		load_from = hotel_room_template_lore
	else if(template in hotel_map_list)
		load_from = hotel_map_list[template]
	else
		to_chat(user, span_warning("You are washed over by a wave of heat as the sphere violently wiggles. You wonder if you did something wrong..."))
		return

	load_from.load(bottom_left)

	var/area/misc/hilbertshotel/current_area = get_area(locate(bottom_left.x, bottom_left.y, bottom_left.z))

	for(var/obj/machinery/vending/this_vending in current_area)
		this_vending.onstation = ROOM_ONSTATION_OVERRIDE
		this_vending.onstation_override = ROOM_ONSTATION_OVERRIDE

	LAZYSET(room_data, "[room_number]", list(
		"reservation" = roomReservation,
		"room_preferences" = list(
			"status" = ROOM_CLOSED,
			"visibility" = ROOM_VISIBLE,
			"privacy" = ROOM_GUESTS_HIDDEN,
		),
		"description" = null,
		"name" = template,
		"door_reference" = null,
		"icon" = "door-open",
		"template" = template
	))

	link_turfs(roomReservation, room_number, parentSphere)
	var/turf/closed/indestructible/hoteldoor/door = room_data["[room_number]"]["door_reference"]
	door.entry_points[user.ckey] = parentSphere // adding the sphere to the entry points list
	do_sparks(3, FALSE, get_turf(user))
	user.forceMove(locate(
		bottom_left.x + hotel_room_template.landingZoneRelativeX,
		bottom_left.y + hotel_room_template.landingZoneRelativeY,
		bottom_left.z,
	))

/datum/controller/subsystem/hilbertshotel/proc/link_turfs(datum/turf_reservation/currentReservation, currentroom_number, obj/item/hilbertshotel/parentSphere)
	var/turf/room_bottom_left = currentReservation.bottom_left_turfs[1]
	var/area/misc/hilbertshotel/currentArea = get_area(room_bottom_left)

	currentArea.name = "Hilbert's Hotel Room [currentroom_number]"
	currentArea.parentSphere = parentSphere
	currentArea.storageTurf = storageTurf
	currentArea.room_number = currentroom_number
	currentArea.reservation = currentReservation

	for(var/turf/closed/indestructible/hoteldoor/door in currentReservation.reserved_turfs)
		door.parentSphere = parentSphere
		door.desc = "The door to this hotel room. \
			The placard reads 'Room [currentroom_number]'. \
			Strangely, this door doesn't even seem openable. \
			The doorknob, however, seems to buzz with unusual energy...<br/>\
			[span_info("Alt-Click to look through the peephole.")]"
		SShilbertshotel.room_data["[currentroom_number]"]["door_reference"] = door // easier door referencing to keep track of entry points
	for(var/turf/T in currentReservation.reserved_turfs)
		for(var/obj/machinery/room_controller/controller in T.contents)
			controller.room_number = currentroom_number
			if(controller.bluespace_box)
				controller.bluespace_box.in_hotel_room = TRUE
				controller.bluespace_box.creation_area = currentArea
			controller.update_appearance()
	for(var/turf/open/space/bluespace/BSturf in currentReservation.reserved_turfs)
		BSturf.parentSphere = parentSphere

/datum/controller/subsystem/hilbertshotel/proc/generate_occupant_list(room_number)
	var/list/occupants = list()
	if(room_data["[room_number]"])
		var/datum/turf_reservation/room = room_data["[room_number]"]["reservation"]
		var/turf/room_bottom_left = room.bottom_left_turfs[1]
		for(var/i in 0 to hotel_room_template.width-1)
			for(var/j in 0 to hotel_room_template.height-1)
				for(var/atom/movable/movable_atom in locate(room_bottom_left.x + i, room_bottom_left.y + j, room_bottom_left.z))
					if(ismob(movable_atom))
						var/mob/this_mob = movable_atom
						if(isliving(this_mob))
							if(this_mob.mind)
								occupants += this_mob.mind.name
	return occupants

/// "Reserves" the room when the last guest leaves it. Creates an abstract storage object and forceMoves all the contents into it, deleting the reservation afterwards.
/datum/controller/subsystem/hilbertshotel/proc/conservate_room(area/misc/hilbertshotel/current_area)
	var/turf/room_bottom_left = current_area.reservation.bottom_left_turfs[1]
	var/list/storage = list()
	var/turfNumber = 1
	var/obj/item/abstracthotelstorage/storageObj = new(current_area.storageTurf)
	storageObj.room_number = current_area.room_number
	storageObj.parentSphere = current_area.parentSphere
	storageObj.name = "Room [current_area.room_number] Storage"

	// saving room contents
	for(var/x in 0 to hotel_room_template.width - 1)
		for(var/y in 0 to hotel_room_template.height - 1)
			var/turf/T = locate(room_bottom_left.x + x, room_bottom_left.y + y, room_bottom_left.z)
			var/list/turfContents = list()

			for(var/atom/movable/movable_atom in T)
				if(istype(movable_atom, /obj/effect))
					continue
				if(ismob(movable_atom) && !isliving(movable_atom))
					continue
				if(movable_atom.loc != T)
					continue
				if(istype(movable_atom, /obj/machinery/room_controller))
					var/obj/machinery/room_controller/controller = movable_atom
					controller.bluespace_box?.in_hotel_room = FALSE
					controller.bluespace_box?.creation_area = null
				if(length(movable_atom.GetComponents(/datum/component/wall_mounted)))
					continue
				turfContents += movable_atom
				var/old_resist = movable_atom.resistance_flags
				movable_atom.resistance_flags |= INDESTRUCTIBLE
				movable_atom.forceMove(storageObj)
				movable_atom.resistance_flags = old_resist
			storage["[turfNumber]"] = turfContents
			turfNumber++

	var/room_name = room_data["[current_area.room_number]"]["name"]
	var/room_template = room_data["[current_area.room_number]"]["template"]

	conservated_rooms["[current_area.room_number]"] = list(
		"storage" = storage,
		"name" = room_name,
		"template" = room_template
	)
	room_data -= "[current_area.room_number]"
	qdel(current_area.reservation)

/datum/controller/subsystem/hilbertshotel/proc/eject_all_rooms()
	if(room_data.len)
		for(var/number in room_data)
			var/datum/turf_reservation/room = room_data[number]["reservation"]
			var/turf/room_bottom_left = room.bottom_left_turfs[1]
			for(var/i in 0 to hotel_room_template.width-1)
				for(var/j in 0 to hotel_room_template.height-1)
					for(var/atom/movable/A in locate(room_bottom_left.x + i, room_bottom_left.y + j, room_bottom_left.z))
						if(ismob(A))
							var/mob/M = A
							if(M.mind)
								to_chat(M, span_warning("As the sphere breaks apart, you're suddenly ejected into the depths of space!"))
						var/max = world.maxx-TRANSITIONEDGE
						var/min = 1+TRANSITIONEDGE
						var/list/possible_transtitons = list()
						for(var/AZ in SSmapping.z_list)
							var/datum/space_level/D = AZ
							if (D.linkage == CROSSLINKED)
								possible_transtitons += D.z_value
						var/_z = pick(possible_transtitons)
						var/_x = rand(min,max)
						var/_y = rand(min,max)
						var/turf/T = locate(_x, _y, _z)
						A.forceMove(T)
			qdel(room)

	if(conservated_rooms.len)
		for(var/x in conservated_rooms)
			var/list/atomList = conservated_rooms[x]
			for(var/atom/movable/A in atomList)
				var/max = world.maxx-TRANSITIONEDGE
				var/min = 1+TRANSITIONEDGE
				var/list/possible_transtitons = list()
				for(var/AZ in SSmapping.z_list)
					var/datum/space_level/D = AZ
					if (D.linkage == CROSSLINKED)
						possible_transtitons += D.z_value
				var/_z = pick(possible_transtitons)
				var/_x = rand(min,max)
				var/_y = rand(min,max)
				var/turf/T = locate(_x, _y, _z)
				A.forceMove(T)

/datum/controller/subsystem/hilbertshotel/proc/on_room_updated(datum/source, list/data)
	SIGNAL_HANDLER

	for(var/obj/item/hilbertshotel/sphere in all_hilbert_spheres)
		SStgui.update_uis(sphere)

	return
