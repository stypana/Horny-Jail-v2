/datum/blood_type/get_color(dynamic = FALSE, list/blood_DNA)
	var/original_color = color
	if(LAZYLEN(blood_DNA) && blood_DNA["exotic_blood_color"])
		color = blood_DNA["exotic_blood_color"]

	. = ..()

	color = original_color
