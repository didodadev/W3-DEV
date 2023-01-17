<cfinclude template="upd_dates.cfm">
<cfif warning eq 0>
	<cfinclude template="add_event.cfm">
	<cfif isDefined('session.pp.userid')>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.pp.userid#' 
			record_date='#now()#' 
			action_table='EVENT'
			action_column='EVENT_ID'
			action_id='#get_last_event_id.max_id#'
			action_page='#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(get_last_event_id.max_id,session.pp.userid,"CFMX_COMPAT","Hex")#' 
			warning_description='ajanda: #get_last_event_id.max_id#'>
		<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(get_last_event_id.max_id,session.pp.userid,"CFMX_COMPAT","Hex")#" addtoken="No">
	<cfelseif isDefined('session.ww.userid')>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ww.userid#' 
			record_date='#now()#' 
			action_table='EVENT'
			action_column='EVENT_ID'
			action_id='#get_last_event_id.max_id#'
			action_page='#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(get_last_event_id.max_id,session.ww.userid,"CFMX_COMPAT","Hex")#' 
			warning_description='ajanda: #get_last_event_id.max_id#'>
		<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(get_last_event_id.max_id,session.ww.userid,"CFMX_COMPAT","Hex")#" addtoken="No">
	</cfif>
<cfelseif warning eq 1>
	<cfinclude template="add_event.cfm">
	<cfif warning eq 1>
		<cfquery name="UPD_LINK" datasource="#DSN#">
			UPDATE
				EVENT
			SET
				LINK_ID = #get_last_event_id.max_id#
			WHERE
				EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_event_id.max_id#">
		</cfquery>
	</cfif>
	<cfset link_id = get_last_event_id.max_id>
	<cfloop from="1" to="#evaluate(form.warning_count-1)#" index="i">
		<cfif warning_type eq 7>
			<!--- hafta ekle --->
			<cfset form.startdate = date_add("ww",1,form.startdate)>
			<cfset form.finishdate = date_add("ww",1,form.finishdate)>
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
		<cfif isDefined('session.pp.userid')>
			<cf_workcube_process 
				is_upd='1' 
				data_source='#dsn#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.pp.userid#' 
				record_date='#now()#' 
				action_table='EVENT'
				action_column='EVENT_ID'
				action_id='#get_last_event_id.max_id#'
				action_page='#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(get_last_event_id.max_id,session.pp.userid,"CFMX_COMPAT","Hex")#' 
				warning_description='ajanda: #get_last_event_id.max_id#'>
		<cfelseif isDefined('session.ww.userid')>
			<cf_workcube_process 
				is_upd='1' 
				data_source='#dsn#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ww.userid#' 
				record_date='#now()#' 
				action_table='EVENT'
				action_column='EVENT_ID'
				action_id='#get_last_event_id.max_id#'
				action_page='#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(get_last_event_id.max_id,session.ww.userid,"CFMX_COMPAT","Hex")#' 
				warning_description='ajanda: #get_last_event_id.max_id#'>
		</cfif>	
    </cfloop>
	<cfif isDefined('session.pp.userid')>
    	<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(link_id,session.pp.userid,"CFMX_COMPAT","Hex")#" addtoken="No">
    <cfelseif isDefined('session.ww.userid')>
    	<cflocation url="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(link_id,session.ww.userid,"CFMX_COMPAT","Hex")#" addtoken="No">
	</cfif>
</cfif>
