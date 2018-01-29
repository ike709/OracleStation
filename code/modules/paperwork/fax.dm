// Fax datum - holds all faxes sent during the round
GLOBAL_LIST_EMPTY(faxes)
GLOBAL_LIST_EMPTY(adminfaxes)

/datum/fax
	var/name = "fax"
	var/from_department = null
	var/to_department = null
	var/origin = null
	var/message = null
	var/sent_by = null
	var/sent_at = null

/datum/fax/New()
	GLOB.faxes += src

/datum/fax/admin
	var/list/reply_to = null

/datum/fax/admin/New()
	GLOB.adminfaxes += src

// Fax panel - lets admins check all faxes sent during the round
/client/proc/fax_panel()
	set name = "Fax Panel"
	set category = "Admin"
	if(holder)
		holder.fax_panel(usr)
	SSblackbox.add_details("admin_verb","FXP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/datum/admins/proc/fax_panel(var/mob/living/user)
	var/html = "<A align='right' href='?src=[UID()];[HrefToken(TRUE)];refreshfaxpanel=1'>Refresh</A>"
	html += "<A align='right' href='?src=[UID()];[HrefToken(TRUE)];AdminFaxCreate=1;faxtype=Administrator'>Create Fax</A>"

	html += "<div class='block'>"
	html += "<h2>Admin Faxes</h2>"
	html += "<table>"
	html += "<tr style='font-weight:bold;'><td width='150px'>Name</td><td width='150px'>From Department</td><td width='150px'>To Department</td><td width='75px'>Sent At</td><td width='150px'>Sent By</td><td width='50px'>View</td><td width='50px'>Reply</td><td width='75px'>Replied To</td></td></tr>"
	for(var/thing in GLOB.adminfaxes)
		var/datum/fax/admin/A = thing
		html += "<tr>"
		html += "<td>[A.name]</td>"
		html += "<td>[A.from_department]</td>"
		html += "<td>[A.to_department]</td>"
		html += "<td>[worldtime2text(A.sent_at)]</td>"
		if(A.sent_by)
			var/mob/living/S = A.sent_by
			html += "<td><A HREF='?_src_=holder;[HrefToken(TRUE)];adminplayeropts=[REF(A.sent_by)]'>[S.name]</A></td>"
		else
			html += "<td>Unknown</td>"
		html += "<td><A align='right' href='?src=[UID()];[HrefToken(TRUE)];AdminFaxView=[REF(A.message)]'>View</A></td>"
		if(!A.reply_to)
			if(A.from_department == "Administrator")
				html += "<td>N/A</td>"
			else
				html += "<td><A align='right' href='?src=[UID()];[HrefToken(TRUE)];AdminFaxCreate=[REF(A.sent_by)];originfax=[REF(A.origin)];faxtype=[A.to_department];replyto=[REF(A.message)]'>Reply</A></td>"
			html += "<td>N/A</td>"
		else
			html += "<td>N/A</td>"
			html += "<td><A align='right' href='?src=[UID()];[HrefToken(TRUE)];AdminFaxView=[REF(A.reply_to)]'>Original</A></td>"
		html += "</tr>"
	html += "</table>"
	html += "</div>"

	html += "<div class='block'>"
	html += "<h2>Departmental Faxes</h2>"
	html += "<table>"
	html += "<tr style='font-weight:bold;'><td width='150px'>Name</td><td width='150px'>From Department</td><td width='150px'>To Department</td><td width='75px'>Sent At</td><td width='150px'>Sent By</td><td width='175px'>View</td></td></tr>"
	for(var/thing in GLOB.faxes)
		var/datum/fax/F = thing
		html += "<tr>"
		html += "<td>[F.name]</td>"
		html += "<td>[F.from_department]</td>"
		html += "<td>[F.to_department]</td>"
		html += "<td>[worldtime2text(F.sent_at)]</td>"
		if(F.sent_by)
			var/mob/living/S = F.sent_by
			html += "<td><A HREF='?_src_=holder;[HrefToken(TRUE)];adminplayeropts=[REF(F.sent_by)]'>[S.name]</A></td>"
		else
			html += "<td>Unknown</td>"
		html += "<td><A align='right' href='?src=[UID()];[HrefToken(TRUE)];AdminFaxView=[REF(F.message)]'>View</A></td>"
		html += "</tr>"
	html += "</table>"
	html += "</div>"

	var/datum/browser/popup = new(user, "fax_panel", "Fax Panel", 950, 450)
	popup.set_content(html)
	popup.open()
