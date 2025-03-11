/datum/storyteller/extended
	name = "Extended (No Chaos)"
	//VENUS: Description will be set at runtime based on config
	desc = "Extended is the absence of a Storyteller." // Default placeholder
	//VENUS EDIT END
	welcome_text = "How is dorms already full? The shift hasn't even started yet."
	disable_distribution = TRUE
	population_max = 40
	antag_divisor = 32
	storyteller_type = STORYTELLER_TYPE_CALM
	votable = FALSE

//VENUS EDIT START: Description will be set at runtime based on config
/datum/storyteller/extended/New()
	. = ..()
	if(CONFIG_GET(flag/allow_random_events))
		desc = "Extended is the absence of a Storyteller. It will not run any Antagonists, but will still allow random events to occur. Best for rounds where the population is so low that not even peaceful storytellers are low enough."
	else
		desc = "Extended is the absence of a Storyteller. It will not spawn a single event of any sort, or run any Antagonists. Best for rounds where the population is so low that not even peaceful storytellers are low enough."
//VENUS EDIT END
