/obj/item/storage/box/bluespace
	name = "bluespace box"
	desc = "A box that stores items in a bluespace pocket dimension."
	icon = 'modular_zzplurt/icons/obj/machines/room_controller.dmi'
	icon_state = "box"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	foldable_result = null

/obj/item/storage/box/bluespace/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = INFINITY
	atom_storage.max_total_storage = INFINITY
	atom_storage.max_slots = INFINITY

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
	. += span_info("A large number reads out on the screen: [room_number].")
	. += span_info("There is an old tag on the back of the device, scribbled all around it. 'Last Serviced: 3025-02-27'.")

/obj/machinery/room_controller/Initialize()
	. = ..()
	main_sphere = GLOB.main_hilbert_sphere
	if(!main_sphere)
		to_chat(world, span_warning("Hilbert's Hotel Room Controller failed to locate the main sphere!"))
		return INITIALIZE_HINT_QDEL
	bluespace_box = new /obj/item/storage/box/bluespace(src)

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
		. += mutable_appearance(icon, "box_inserted", src)

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
	data["bluespace_box"] = bluespace_box
	data["id_card"] = inserted_id

	return data

/obj/machinery/room_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!room_number || !main_sphere?.room_data["[room_number]"])
		return

	var/list/room_data = main_sphere.room_data["[room_number]"]

	switch(action)
		if("toggle_visibility")
			room_data["visibility"] = !room_data["visibility"]
			. = TRUE
		if("toggle_status")
			room_data["status"] = !room_data["status"]
			. = TRUE
		if("toggle_privacy")
			room_data["privacy"] = !room_data["privacy"]
			. = TRUE
		if("update_description")
			room_data["description"] = params["description"]
			. = TRUE
		if("confirm_description")
			room_data["description"] = params["description"]
			. = TRUE
		if("set_icon")
			room_data["icon"] = params["icon"]
			. = TRUE
		if("eject_box")
			if(bluespace_box)
				bluespace_box.forceMove(drop_location())
				. = TRUE
		if("eject_id")
			if(inserted_id)
				var/obj/item/card/id/id = inserted_id
				id.forceMove(drop_location())
				if(usr.CanReach(src))
					usr.put_in_hands(id)
				inserted_id = null
				update_appearance()
				. = TRUE

/obj/machinery/room_controller/emp_act(severity)
	return

/obj/machinery/room_controller/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/card/id))
		if(inserted_id)
			to_chat(user, span_warning("There's already an ID card inside!"))
			return
		if(!user.transferItemToLoc(item, src))
			return
		inserted_id = item
		playsound(src, 'sound/machines/terminal/terminal_insert_disc.ogg', 50, TRUE)
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

/obj/machinery/room_controller/click_alt(mob/user)
	if(inserted_id)
		if(!user.transferItemToLoc(inserted_id, src))
			return
		playsound(src, 'sound/machines/terminal/terminal_eject.ogg', 50, TRUE)
		return TRUE
	return ..()
