/obj/effect/decal/cleanable/get_blood_color()
	switch(blood_state)
		if(BLOOD_STATE_HUMAN)
			return "#950a0a"
		if(BLOOD_STATE_XENO)
			return "#2bba00"
		if(BLOOD_STATE_OIL)
			return "#161616"
		if(BLOOD_STATE_SYNTHETIC)
			return "#3f48aa"
		if(BLOOD_STATE_SLIME)
			return "#00ff90"
		if(BLOOD_STATE_BUG)
			return "#ffc933"
		if(BLOOD_STATE_PLANT)
			return "#3d610e"

	return null
