/datum/job/captain/New()
	var/list/extra_titles = list(
		"Station Director",
		// "Station Commander",
		"Station Overseer",
		"Station Mistress",
		"Station Master",
		"Senator",
		"Consul",
		"Ark Commander"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chief_engineer/New()
	var/list/extra_titles = list(
		"Head Engineer",
		"Construction Coordinator",
		"Project Manager",
		"Power Plant Director",
		"Magos",
		"Magos Biologis"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/head_of_personnel/New()
	var/list/extra_titles = list(
		"Personnel Manager",
		"Staff Administrator",
		"Records Administrator"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/head_of_security/New()
	var/list/extra_titles = list(
		"Division Leader",
		"Cerberus Leader",
		"Big Iron",
		"Commissar",
		"Head of Red Hawk"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/quartermaster/New()
	var/list/extra_titles = list(
		"Supply Chief",
		"Cargonia Chief",
		"Brigadier"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/research_director/New()
	var/list/extra_titles = list(
		"Science Administrator",
		"Research Manager"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chief_medical_officer/New()
	var/list/extra_titles = list(
		"Medical Director",
		"Medical Administrator"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/atmospheric_technician/New()
	var/list/extra_titles = list(
		"Atmos Plumber",
		"Disposals Technician"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/station_engineer/New()
	var/list/extra_titles = list(
		"Structural Engineer",
		"Astromechanic",
		"Station Architect",
		"Hazardous Material Operator",
		"Junior Engineer",
		"Apprentice Engineer",
		"Techpriest Enginseer"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/assistant/New()
	var/list/extra_titles = list(
		// "Tourist",
		"Clerk",
		"Secretary",
		"Blacksmith",
		// "Waiter",
		"Greytider",
		"Bard",
		"Freeloader",
		"Slavic Activist",
		"Bear Communist"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/bartender/New()
	var/list/extra_titles = list(
		"Mixologist",
		"Sommelier",
		"Bar Owner",
		"Barmaid",
		"Expediter"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/janitor/New()
	var/list/extra_titles = list(
		"Liquidator",
		"Custodial Technician"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chaplain/New()
	var/list/extra_titles = list(
		"Bishop",
		// "Priestess",
		"Prior",
		// "Monk",
		"Tiger Cooperative Disciple",
		// "Nun",
		"Counselor",
		"Techpriest"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/clown/New()
	var/list/extra_titles = list(
		// "Jester",
		// "Comedian",
		"Cumedian",
		"Sexy Clown",
		"Performer",
		"Zeleboba"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/cook/New()
	var/list/extra_titles = list(
		"Chef de part",
		"Poissonier",
		"Boss Of This Gym",
		"Waffle Co. Specialist"
		// "Baker"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/curator/New()
	var/list/extra_titles = list(
		"Keeper",
		// "Archaeologist",
		// "Historian",
		"Scholar",
		"Hentai Artist",
		"Artist",
		"Nerd"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/botanist/New()
	var/list/extra_titles = list(
		// "Hydroponicist",
		// "Farmer",
		// "Beekeeper",
		"Plants Breeder",
		"Vintner",
		"Soiler"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/lawyer/New()
	var/list/extra_titles = list(
		// "Internal Affairs Agent",
		"Attorney"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/mime/New()
	var/list/extra_titles = list(
		"Pantomime",
		"Sexy Mime",
		"Mimic"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/scientist/New()
	var/list/extra_titles = list(
		"Researcher",
		"Toxins Researcher",
		"Research Intern",
		"Junior Scientist",
		"Nanite Programmer",
		"Tetromino Researcher",
		"Xenoarchaeologist"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/roboticist/New()
	var/list/extra_titles = list(
		"Ripperdoc",
		"MOD Mechanic",
		"Synth Technician",
		"Droid Mechanic",
		"Techpriest Biologis"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/chemist/New()
	var/list/extra_titles = list(
		// "Alchemist",
		"Apothecarist",
		"Chemical Plumber",
		"Organomegaly Healer",
		"Matter Converter"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/doctor/New()
	var/list/extra_titles = list(
		// "Physician",
		"Medical Intern",
		"Medical Resident",
		"Medtech"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/psychologist/New()
	var/list/extra_titles = list(
		// "Therapist",
		// "Psychiatrist",
		"Hypnotist",
		"Hypnosis Expert",
		"Hypnotherapist",
		"Sex Educator",
		"Sexual Advisor"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/geneticist/New()
	var/list/extra_titles = list(
		"Genetics Researcher"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/paramedic/New()
	var/list/extra_titles = list(
		"Trauma Team"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/virologist/New()
	var/list/extra_titles = list(
		"Microbiologist",
		"Biochemist",
		"Plague Doctor",
		"Monkey Destroyer"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/detective/New()
	var/list/extra_titles = list(
		"Gumshoe",
		"Van Dorn Agent",
		"Forensic Investigator",
		"Cooperate Auditor",
		"RHIB Agent"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/security_officer/New()
	var/list/extra_titles = list(
		"Security Agent",
		"Probation Officer",
		"Guardsman",
		"Police Officer",
		"Civil Protection",
		"Tyranny Lover",
		"Cerberus",
		"Red Hawk Private"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/warden/New()
	var/list/extra_titles = list(
		"Prison Chief",
		"Armory Manager",
		"Prison Administrator",
		"Dungeon Master",
		"Brig Superintendent",
		"Brig Overwatch",,
		"Red Hawk Sergeant",
		"Security Sergeant"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/cargo_technician/New()
	var/list/extra_titles = list(
		"Deliveries Officer",
		// "Mail Man",
		// "Mail Woman",
		"Mailroom Technician",
		"Logistics Technician",
		"Cryptocurrency Technician",
		"Disposal Technician",
		"Donk Co. Specialist",
		"Package Handler"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/shaft_miner/New()
	var/list/extra_titles = list(
		"Exotic Ore Miner",
		"Digger",
		"Hunter",
		"Slayer"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()

/datum/job/prisoner/New()
	var/list/extra_titles = list(
		"Low Security Prisoner",
		"Medium Security Prisoner",
		"Supermax Prisoner",
		"Captured Syndicate Member"
	)
	LAZYADD(alt_titles, extra_titles)
	. = ..()
