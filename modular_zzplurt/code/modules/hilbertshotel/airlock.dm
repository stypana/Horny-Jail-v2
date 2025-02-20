// /obj/machinery/door
// 	var/list/autodir_list

// obj/machinery/door/Initialize(mapload)
// 	. = ..()
// 	autodir_list = typecacheof(list(
// 		/obj/machinery/door/poddoor,
// 		/obj/machinery/door/airlock,
// 		/obj/structure/window/fulltile,
// 		/obj/structure/window/reinforced/fulltile,
// 	))

// /obj/machinery/door/poddoor/Initialize(mapload)
//     . = ..()
//     update_dir()

// /obj/machinery/door/airlock/Initialize(mapload)
//     . = ..()
//     update_dir()

// /obj/machinery/door/proc/update_dir()
// 	var/weight_list = list(NORTH = 0, EAST = 0, SOUTH = 0, WEST = 0)
// 	for(var/direction in list(NORTH, EAST, SOUTH, WEST))
// 		for(var/turf/this_turf in get_step(src, direction))
// 			for(var/obj/this_object in this_turf)
// 				if(istype(this_object, /turf/closed/wall))
// 					weight_list[direction] += 2
// 				else if(is_type_in_typecache(this_object, autodir_list))
// 					weight_list[direction] += 3
// 	var/total_horizontal = weight_list[WEST] + weight_list[EAST]
// 	var/total_vertical = weight_list[SOUTH] + weight_list[NORTH]
// 	if(total_horizontal == 0 && total_vertical == 0)
// 		return
// 	if(total_horizontal > total_vertical)
// 		setDir(2)
// 	else
// 		setDir(4)
