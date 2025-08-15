/client/verb/show_account_identifier()
	set name = "Show Account Identifier"
	set category = "OOC"
	set desc ="Get your ID for account verification."

	verbs -= /client/verb/show_account_identifier
	addtimer(CALLBACK(src, PROC_REF(restore_account_identifier)), 20) //Don't DoS DB queries, asshole

	var/confirm = alert("Do NOT share the verification ID in the following popup. Understand?", "Important Warning", "Yes", "Cancel")
	var/message = ""
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		var/uuid = fetch_uuid()
		if(!uuid)
			alert("Failed to fetch your verification ID. Try again later. If problems persist, tell an admin.", "Account Verification", "Okay")
			log_sql("Failed to fetch UUID for [key_name(src)]")
		else
			message = "Для верификации своего аккаунта откройте личные сообщения бота и отправьте ему следующую команду: <span class='code user-select'>!verify [uuid]</span>"
			var/datum/browser/window = new /datum/browser(usr, "discordverification", "Discord Verification")
			window.set_content("<div>[message]</div>")
			window.open()

/client/proc/restore_account_identifier()
	verbs += /client/verb/show_account_identifier
