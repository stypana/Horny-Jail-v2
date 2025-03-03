/obj/item/storage/box/bluespace
	name = "bluespace box"
	desc = "A box that stores items in a bluespace pocket dimension."
	icon = 'modular_zzplurt/icons/obj/machines/room_controller.dmi'
	icon_state = "box"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	foldable_result = null
	w_class = WEIGHT_CLASS_BULKY
	// The controller this box was initialized at
	var/datum/weakref/origin_controller
	// The hotel room area
	var/area/creation_area
	// If the box was sent to the station (required to ignore area checks)
	var/successfully_sent = FALSE
	// The name of the person who sent the package to the station
	var/assigned_name = "Unknown"
	// List of roles that are disallowed to use the "Depart" feature
	var/list/disallowed_roles = list(
		/datum/job/ghostcafe,
		/datum/job/hotel_staff,
	)

/obj/item/storage/box/bluespace/proc/return_to_station()
	atom_storage.max_slots = 7 // shrinking the box back so it wouldn't get abused
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = WEIGHT_CLASS_SMALL * 7

	name = "bluespace box ([assigned_name])"
	desc += span_info("There's a red \"BLUESPACE-REACTIVE. HANDLE WITH CARE.\" sticker on it.")

	resistance_flags = FLAMMABLE // no more plot armour

/obj/item/storage/box/bluespace/attack_self(mob/user)
	if(!successfully_sent)
		return ..()
	else if(contents)
		return ..()
	else
		visible_message("[src] begins to violently shake, shrinking in size!")
		src.Shake(3, 3, 1 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(qdel), src), 3 SECONDS)

/obj/item/storage/box/bluespace/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = INFINITY
	atom_storage.max_total_storage = INFINITY
	atom_storage.max_slots = INFINITY
	creation_area = get_area(src)
	START_PROCESSING(SSobj, src)

/obj/item/storage/box/bluespace/process()
	if(!creation_area)
		return

	// The INPUT box should NOT exist outside of the hotel room in any scenario, since it's gonna keep it's perks then
	var/area/current_area = get_area(src)
	if(current_area != creation_area)
		var/obj/machinery/room_controller/controller = origin_controller?.resolve()
		do_sparks(5, TRUE, src)
		if(controller)
			forceMove(controller)
			controller.bluespace_box = src
			controller.update_appearance()
		else
			qdel(src)

/obj/machinery/room_controller
	name = "Hilbert's Hotel Room Controller"
	desc = "A mysterious device."
	icon = 'modular_zzplurt/icons/obj/machines/room_controller.dmi'
	icon_state = "room_controller"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	use_power = NO_POWER_USE
	rad_insulation = RAD_FULL_INSULATION
	integrity_failure = 0
	max_integrity = INFINITY

	var/obj/item/hilbertshotel/main_sphere
	var/room_number
	var/list/current_room_data

	var/inserted_id
	var/obj/item/storage/box/bluespace/bluespace_box

/obj/machinery/room_controller/examine(mob/user)
	. = ..()
	. += span_info("The screen displays [room_number? "the word \"Error\". Nothing else." : "some small text and a large number [room_number]."]")
	. += span_info("There is an old tag on the back of the device, scribbled all around it. 'Last Serviced: 3025-02-27'.")

/obj/machinery/room_controller/Initialize()
	. = ..()
	main_sphere = GLOB.main_hilbert_sphere
	if(!main_sphere)
		to_chat(world, span_warning("Hilbert's Hotel Room Controller failed to locate the main sphere!"))
		return INITIALIZE_HINT_QDEL
	bluespace_box = new /obj/item/storage/box/bluespace(src)
	bluespace_box.origin_controller = WEAKREF(src)
	inserted_id = null

/obj/machinery/room_controller/update_overlays()
	. = ..()
	var/list/to_display = list()
	if(!room_number)
		var/mutable_appearance/error = mutable_appearance(icon, "n_err")
		error.pixel_x = 9
		error.pixel_y = -11
		. += error
	else
		var/room_text = "[room_number]"
		to_display = list()

		to_display += room_text[1]
		to_display += room_text[2]

		if(length(room_text) > 3)
			to_display += "dot"
		else if(length(room_text) == 3)
			to_display += room_text[3]

		var/x_offset = 9
		for(var/digit in to_display)
			var/mutable_appearance/digit_overlay = mutable_appearance(icon, "n_[digit]")
			digit_overlay.pixel_x = x_offset
			digit_overlay.pixel_y = -11
			. += digit_overlay
			x_offset += 4
	. += emissive_appearance(icon, "screen_dim", src)
	if(bluespace_box)
		. += mutable_appearance(icon, "box_inserted")

/obj/machinery/room_controller/proc/can_depart(id)
	var/obj/item/card/id/this_id = id


/obj/machinery/room_controller/interact(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/room_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HilbertsHotelRoomControl")
		ui.open()

/obj/machinery/room_controller/ui_data(mob/user)
	var/list/data = list()

	var/obj/item/card/id/this_id = inserted_id
	data["id_card"] = this_id?.registered_name
	data["bluespace_box"] = !isnull(bluespace_box)

	if(!room_number || !main_sphere?.room_data["[room_number]"])
		return data

	current_room_data = main_sphere.room_data["[room_number]"]
	data["room_number"] = room_number
	data["room_status"] = current_room_data["status"]
	data["room_visibility"] = current_room_data["visibility"]
	data["room_privacy"] = current_room_data["privacy"]
	data["room_description"] = current_room_data["description"]
	data["name"] = current_room_data["name"]
	data["icon"] = current_room_data["icon"]

	return data

/obj/machinery/room_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject_id")
			if(inserted_id)
				eject_id(inserted_id, usr)
				return TRUE
		if("eject_box")
			if(bluespace_box)
				bluespace_box.forceMove(drop_location())
				bluespace_box = null
				update_appearance()
				return TRUE

	if(!room_number || !main_sphere?.room_data["[room_number]"])
		return

	var/list/room_data = main_sphere.room_data["[room_number]"]
	switch(action)
		if("toggle_visibility")
			room_data["visibility"] = !room_data["visibility"]
			return TRUE
		if("toggle_status")
			room_data["status"] = !room_data["status"]
			return TRUE
		if("toggle_privacy")
			room_data["privacy"] = !room_data["privacy"]
			return TRUE
		if("update_description")
			room_data["description"] = params["description"]
			return TRUE
		if("confirm_description")
			room_data["description"] = params["description"]
			return TRUE
		if("set_icon")
			room_data["icon"] = params["icon"]
			return TRUE

/obj/machinery/room_controller/emp_act(severity)
	return

/obj/machinery/room_controller/proc/eject_id(id, user)
	var/obj/item/card/id/this_id = id
	var/mob/living/carbon/human/this_humanoid = user
	this_id.forceMove(drop_location())
	if(this_humanoid.CanReach(this_id))
		this_humanoid.put_in_hands(this_id)
	inserted_id = null
	update_appearance()
	SStgui.update_uis(src)
	return TRUE

/obj/machinery/room_controller/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/card/id))
		if(inserted_id)
			to_chat(user, span_warning("There's already an ID card inside!"))
			return
		if(!user.transferItemToLoc(item, src))
			return
		inserted_id = item
		to_chat(user, span_notice("DEBUG: ID inserted, value: [inserted_id]"))
		playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, TRUE)
		update_appearance()
		SStgui.update_uis(src)
		return TRUE
	if(istype(item, /obj/item/storage/box/bluespace))
		if(bluespace_box)
			return
		if(!user.transferItemToLoc(item, src))
			return
		bluespace_box = item
		update_appearance()
		return TRUE
	return ..()

/obj/machinery/room_controller/click_ctrl(mob/user)
	. = ..()
	if(inserted_id)
		if(!eject_id(inserted_id, usr))
			return
		playsound(src, 'sound/machines/terminal/terminal_eject.ogg', 50, TRUE)
		return TRUE
	return ..()

/obj/machinery/room_controller/directional/north
	pixel_x = 0
	pixel_y = 28
	dir = NORTH

/obj/machinery/room_controller/directional/south
	pixel_x = 0
	pixel_y = -28
	dir = SOUTH

/obj/machinery/room_controller/directional/east
	pixel_x = 28
	pixel_y = 0
	dir = EAST

/obj/machinery/room_controller/directional/west
	pixel_x = -28
	pixel_y = 0
	dir = WEST
