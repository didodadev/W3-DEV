<cfinclude template="upd_dates.cfm">
<cfif (link_id is "") and (not isdefined("warning") or (warning eq 0))>
<!--- tek olayı tek olarak güncelle --->
	<cfinclude template="upd_event.cfm">
<cfelseif (link_id is "") and (not isdefined("warning") or (warning eq 1))>
<!--- tek olayı çoðalt --->
	<cfset link_id = event_id>
	<!--- kaydı güncelle --->
	<cfinclude template="upd_event.cfm">
	<!--- çoğalt --->
	<cfloop from="1" to="#evaluate(form.warning_count-1)#" index="i">
		<cfif warning_type eq 7>
			<!--- hafta ekle --->
			<cfset form.startdate = date_add("ww",1,form.startdate)>
			<cfset form.finishdate = date_add("ww",1,form.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset form.sms_alert_day = date_add("ww",1,form.sms_alert_day)>
			</cfif>
			<cfset form.email_alert_day = date_add("ww",1,form.email_alert_day)>
			<cfif len(form.warning_start)>
				<cfset form.warning_start = date_add("ww",1,form.warning_start)>
			</cfif>
		<cfelseif warning_type eq 30>
			<!--- ay ekle --->
			<cfset form.startdate = date_add("m",1,form.startdate)>
			<cfset form.finishdate = date_add("m",1,form.finishdate)>
			<cfset form.email_alert_day = date_add("m",1,form.email_alert_day)>
			<cfif len(form.warning_start)>
				<cfset form.warning_start = date_add("m",1,form.warning_start)>
			</cfif>
		</cfif>
		<cfinclude template="add_event.cfm">
	</cfloop>
<cfelseif (len(link_id)) and (not isdefined("warning") or (warning eq 1))>
<!--- çokluyu çoklu olarak güncelle --->
	<cfinclude template="upd_event.cfm">
<cfelseif (len(link_id)) and (warning eq 0)>
<!--- çokluyu tekli yap --->
	<cfset link_id = "">
	<!--- kaydı güncelle --->
	<cfinclude template="upd_event.cfm">
</cfif>
<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#" addtoken="No">
