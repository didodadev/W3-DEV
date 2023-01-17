<cfinclude template="upd_dates.cfm">
<cfif warning eq 0>
	<cfinclude template="add_event.cfm">
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='0'
		process_stage='#attributes.process_stage#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='EVENT'
		action_column='EVENT_ID'
		action_id='#get_last_event_id.max_id#'
		action_page='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#'
		warning_description='Ajanda : #get_last_event_id.max_id#'>
	<cfset attributes.actionid = get_last_event_id.max_id> 
	<script type="text/javascript">
		window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#</cfoutput>';
	</script>
<cfelseif warning eq 1>
	<cfinclude template="add_event.cfm">
	<cfif warning eq 1>
		<cfquery name="UPD_LINK" datasource="#DSN#">
			UPDATE
				EVENT
			SET
				LINK_ID = #GET_LAST_EVENT_ID.MAX_ID#
			WHERE
				EVENT_ID = #GET_LAST_EVENT_ID.MAX_ID#
		</cfquery>
	</cfif>
	<cfset link_id = get_last_event_id.max_id>
	<cfloop from="1" to="#evaluate(attributes.warning_count-1)#" index="i">
		<cfif warning_type eq 1>
			<!--- günde bir--->
			<cfset attributes.startdate = date_add("d",1,attributes.startdate)>
			<cfset attributes.finishdate = date_add("d",1,attributes.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset attributes.SMS_ALERT_DAY = date_add("d",1,attributes.SMS_ALERT_DAY)>
			</cfif>
			<cfset attributes.email_ALERT_DAY = date_add("d",1,attributes.email_ALERT_DAY)>
			<cfif len(attributes.warning_start)>
				<cfset attributes.warning_start = date_add("d",1,attributes.warning_start)>
			</cfif>
		<cfelseif warning_type eq 7>
			<!--- hafta ekle --->
			<cfset attributes.startdate = date_add("ww",1,attributes.startdate)>
			<cfset attributes.finishdate = date_add("ww",1,attributes.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset attributes.SMS_ALERT_DAY = date_add("ww",1,attributes.SMS_ALERT_DAY)>
			</cfif>
			<cfset attributes.email_ALERT_DAY = date_add("ww",1,attributes.email_ALERT_DAY)>
			<cfif len(attributes.warning_start)>
				<cfset attributes.warning_start = date_add("ww",1,attributes.warning_start)>
			</cfif>
		<cfelseif warning_type eq 30>
			<!--- ay ekle --->
			<cfset attributes.startdate = date_add("m",1,attributes.startdate)>
			<cfset attributes.finishdate = date_add("m",1,attributes.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset attributes.SMS_ALERT_DAY = date_add("m",1,attributes.SMS_ALERT_DAY)>
			</cfif>
			<cfset attributes.email_ALERT_DAY = date_add("m",1,attributes.email_ALERT_DAY)>
			<cfif len(attributes.warning_start)>
				<cfset attributes.warning_start = date_add("m",1,attributes.warning_start)>
			</cfif>
		</cfif>
		<cfinclude template="add_event.cfm">
	</cfloop>
	<cfset attributes.actionid = link_id>
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='0'
		process_stage='#attributes.process_stage#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='EVENT'
		action_column='EVENT_ID'
		action_id='#get_last_event_id.max_id#'
		action_page='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#'
		warning_description='Ajanda : #attributes.event_head#'>
	<script type="text/javascript">
		window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#link_id#</cfoutput>';
	</script>
</cfif>
