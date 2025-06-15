/datum/ticket_stats
	var/client/admin_client
	var/list/last_query_result = list()
	var/last_error_message = ""
	var/is_loading = FALSE

/datum/ticket_stats/New(client/admin)
	. = ..()
	admin_client = admin

/datum/ticket_stats/Destroy(force, ...)
	admin_client = null
	SStgui.close_uis(src)
	return ..()

/datum/ticket_stats/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "AdminTicketStats", "Admin Ticket Statistics")
		ui.open()

/datum/ticket_stats/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/ticket_stats/ui_static_data(mob/user)
	. = list()

	var/current_time = world.timeofday
	var/current_year = text2num(time2text(current_time, "YYYY"))
	var/current_month = text2num(time2text(current_time, "MM"))

	.["current_year"] = current_year
	.["current_month"] = current_month
	.["current_date"] = time2text(current_time, "YYYY-MM-DD")

	var/month_start = "[current_year]-[add_leading(num2text(current_month), 2, "0")]-01"
	var/days_in_month = 31
	if(current_month == 2)
		days_in_month = (current_year % 4 == 0) ? 29 : 28
	else if(current_month == 4 || current_month == 6 || current_month == 9 || current_month == 11)
		days_in_month = 30
	var/month_end = "[current_year]-[add_leading(num2text(current_month), 2, "0")]-[add_leading(num2text(days_in_month), 2, "0")]"

	.["default_start_date"] = month_start
	.["default_end_date"] = month_end

	.["available_columns"] = list(
		list("key" = "Total_tickets", "name" = "Total Tickets"),
		list("key" = "Ticket_replies", "name" = "Ticket Replies"),
		list("key" = "Rejected_count", "name" = "Rejected"),
		list("key" = "Resolved_count", "name" = "Resolved"),
		list("key" = "Closed_count", "name" = "Closed"),
		list("key" = "IC_Issue_count", "name" = "IC Issues"),
		list("key" = "Interaction_count", "name" = "Interaction")
	)

	.["grouping_options"] = list(
		list("key" = "none", "name" = "No Grouping"),
		list("key" = "day", "name" = "By Day"),
		list("key" = "month", "name" = "By Month")
	)

	var/list/admin_list = list()
	if(SSdbcore.IsConnected())
		var/datum/db_query/admin_query = SSdbcore.NewQuery("SELECT DISTINCT ckey FROM admin WHERE rank != 'NEW ADMIN' ORDER BY ckey")
		if(admin_query.warn_execute())
			while(admin_query.NextRow())
				admin_list += admin_query.item[1]
		qdel(admin_query)
	.["admin_list"] = admin_list

/datum/ticket_stats/ui_data(mob/user)
	. = list()
	.["loading"] = is_loading
	.["stats_data"] = last_query_result
	.["error_message"] = last_error_message

/datum/ticket_stats/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/client/admin_client = usr?.client
	if(!check_rights_for(admin_client, R_ADMIN))
		return

	switch(action)
		if("fetch_stats")
			if(is_loading)
				return TRUE

			is_loading = TRUE
			SStgui.update_uis(src)

			log_admin("[admin_client.ckey] requested ticket stats with params: [json_encode(params)]")
			var/result = fetch_ticket_statistics(params)

			is_loading = FALSE
			if(result["error"])
				last_error_message = result["error"]
				last_query_result = list()
				log_admin("Ticket stats error: [result["error"]]")
			else if(result["success"])
				last_query_result = result["data"] || list()
				last_error_message = ""
				log_admin("Ticket stats success: [length(result["data"])] rows returned")
			SStgui.update_uis(src)
			return TRUE

/datum/ticket_stats/proc/fetch_ticket_statistics(list/params)
	if(!SSdbcore.IsConnected())
		return list("error" = "Database not connected")

	var/start_date = params["start_date"] || ""
	var/end_date = params["end_date"] || ""
	var/admin_filter = params["admin_filter"] || params["admin_name"] || ""
	var/grouping = params["grouping"] || "none"
	var/list/selected_columns = params["selected_columns"] || params["columns"] || list()
	var/sort_column = params["sort_column"] || "admin_name"
	var/sort_order = params["sort_order"] || "ASC"

	if(!start_date || !end_date)
		return list("error" = "Start and end dates are required")

	return generate_report(start_date, end_date, admin_filter, grouping, selected_columns, sort_column, sort_order)

/datum/ticket_stats/proc/generate_report(start_date, end_date, admin_filter = "", grouping = "none", selected_columns = list(), sort_column = "admin_name", sort_order = "ASC")
	if(length(start_date) <= 10)
		start_date += " 00:00:00"
	if(length(end_date) <= 10)
		end_date += " 23:59:59"

	var/list/column_clauses = list()
	var/date_condition = "timestamp BETWEEN '[start_date]' AND '[end_date]'"

	if(grouping == "none")
		for(var/column in selected_columns)
			switch(column)
				if("Total_tickets")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action IN ('Rejected', 'Resolved', 'Closed', 'IC Issue') AND [date_condition]) AS Total_tickets"
				if("Ticket_replies")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Reply' AND [date_condition]) AS Ticket_replies"
				if("Rejected_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Rejected' AND [date_condition]) AS Rejected_count"
				if("Resolved_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Resolved' AND [date_condition]) AS Resolved_count"
				if("Closed_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Closed' AND [date_condition]) AS Closed_count"
				if("IC_Issue_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'IC Issue' AND [date_condition]) AS IC_Issue_count"
				if("Interaction_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Interaction' AND [date_condition]) AS Interaction_count"
	else
		var/period_field = ""
		switch(grouping)
			if("day")
				period_field = "DATE(ticket.timestamp)"
			if("month")
				period_field = "DATE_FORMAT(ticket.timestamp, '%Y-%m')"

		for(var/column in selected_columns)
			switch(column)
				if("Total_tickets")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action IN ('Rejected', 'Resolved', 'Closed', 'IC Issue') AND [date_condition] AND [period_field] = periods.period_group) AS Total_tickets"
				if("Ticket_replies")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Reply' AND [date_condition] AND [period_field] = periods.period_group) AS Ticket_replies"
				if("Rejected_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Rejected' AND [date_condition] AND [period_field] = periods.period_group) AS Rejected_count"
				if("Resolved_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Resolved' AND [date_condition] AND [period_field] = periods.period_group) AS Resolved_count"
				if("Closed_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Closed' AND [date_condition] AND [period_field] = periods.period_group) AS Closed_count"
				if("IC_Issue_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'IC Issue' AND [date_condition] AND [period_field] = periods.period_group) AS IC_Issue_count"
				if("Interaction_count")
					column_clauses += "(SELECT COUNT(*) FROM ticket WHERE CAST(sender AS CHAR) = CAST(admin.ckey AS CHAR) AND action = 'Interaction' AND [date_condition] AND [period_field] = periods.period_group) AS Interaction_count"

	if(!length(column_clauses))
		return list("error" = "No columns selected")

	var/main_query = ""
	if(grouping == "none")
		main_query = "SELECT admin.ckey AS admin_name, admin.rank AS admin_rank, " + jointext(column_clauses, ", ")
		main_query += " FROM admin WHERE admin.rank != 'NEW ADMIN'"
	else
		var/period_query = ""
		switch(grouping)
			if("day")
				period_query = "SELECT DISTINCT DATE(timestamp) AS period_group FROM ticket WHERE [date_condition] ORDER BY period_group"
			if("month")
				period_query = "SELECT DISTINCT DATE_FORMAT(timestamp, '%Y-%m') AS period_group FROM ticket WHERE [date_condition] ORDER BY period_group"

		main_query = "SELECT periods.period_group, admin.ckey AS admin_name, admin.rank AS admin_rank, " + jointext(column_clauses, ", ")
		main_query += " FROM admin CROSS JOIN ([period_query]) AS periods"
		main_query += " WHERE admin.rank != 'NEW ADMIN'"

	if(admin_filter && admin_filter != "")
		main_query += " AND admin.ckey LIKE '%[admin_filter]%'"

	if(grouping != "none")
		main_query += " ORDER BY period_group ASC, admin_name ASC"
	else
		main_query += " ORDER BY admin_name ASC"

	var/datum/db_query/query = SSdbcore.NewQuery(main_query)

	if(!query.warn_execute())
		qdel(query)
		return list("error" = "Database query failed: [query.ErrorMsg()]")

	var/list/results = list()
	while(query.NextRow())
		var/list/row = list()
		var/column_index = 1

		if(grouping != "none")
			row["period_group"] = query.item[column_index++]

		row["admin_name"] = query.item[column_index++]
		row["admin_rank"] = query.item[column_index++]

		var/has_tickets = FALSE
		for(var/column in selected_columns)
			var/raw_value = query.item[column_index++]
			var/numeric_value = text2num("[raw_value]") || 0
			row[column] = numeric_value
			if(numeric_value > 0)
				has_tickets = TRUE

		if(has_tickets)
			results += list(row)

	qdel(query)
	return list("success" = TRUE, "data" = results, "grouping" = grouping)

ADMIN_VERB(show_admin_ticket_stats, R_ADMIN, "Show Admin tickets Stats", "View statistics for admin ticket handling", ADMIN_CATEGORY_MAIN)
	var/datum/ticket_stats/stats = new(user)
	stats.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Show Admin Ticket Stats")
