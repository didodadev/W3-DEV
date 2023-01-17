<cf_date tarih="form.startdate">
<cf_date tarih="form.finishdate">
<cfif isdefined("session.ep.time_zone")>
	<cfset form.startdate = date_add("h", form.event_start_clock-session.ep.time_zone, form.startdate)>
<cfelseif isdefined("session.pp.time_zone")>
	<cfset form.startdate = date_add("h", form.event_start_clock-session.pp.time_zone, form.startdate)>
</cfif>
<cfset form.startdate = date_add("n", form.event_start_minute, form.startdate)>
<cfif isdefined("session.ep.time_zone")>
	<cfset form.finishdate = date_add("h", form.event_finish_clock-session.ep.time_zone, form.finishdate)>
<cfelseif isdefined("session.pp.time_zone")>
	<cfset form.finishdate = date_add("h", form.event_finish_clock-session.pp.time_zone, form.finishdate)>
</cfif>
<cfset form.finishdate = date_add("n", form.event_finish_minute, form.finishdate)>
