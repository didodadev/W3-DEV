<cfquery name="UPD_RETURN" datasource="#DSN3#">
	UPDATE
		SERVICE_PROD_RETURN
	SET
		RETURN_TYPE = <cfif isdefined("attributes.return_type") and len(attributes.return_type)>#attributes.return_type#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
		<cfif isdefined("session.ep.userid")>UPDATE_EMP = ,#session.ep.userid#</cfif>
		<cfif isdefined("session.ww.userid")>,UPDATE_CONS = #session.ww.userid#</cfif>	
		<cfif isdefined("session.pp.userid")>,UPDATE_PAR = #session.pp.userid#</cfif>	
	WHERE
		RETURN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.return_id#">
</cfquery>
<cfif len(attributes.is_check)>
	<cfloop list="#attributes.is_check#" index="ccc">
		<cfquery name="UPD_STAGE" datasource="#DSN3#">
			UPDATE
				SERVICE_PROD_RETURN_ROWS
			SET
				<cfif attributes.is_process_row eq 1>
					RETURN_STAGE = #evaluate("attributes.row_stage_#ccc#")#
				<cfelse>	
					RETURN_STAGE = #attributes.process_stage#
				</cfif>
			WHERE
				RETURN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ccc#">
		</cfquery>
	</cfloop>
	<cfif attributes.is_process_row eq 0>
		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#'
			old_process_line='#attributes.process_stage#'
			process_stage='#attributes.process_stage#' 
			record_member='#session_base.userid#'
			record_date='#now()#' 
			action_table='SERVICE_PROD_RETURN'
			action_column='RETURN_ID'
			action_id='#attributes.return_id#' 
			action_page='#request.self#?fuseaction=service.popup_upd_product_return&return_id=#attributes.return_id#' 
			warning_description='İade Id : #attributes.return_id#'>
	</cfif>
</cfif>
<cflocation url="#request.self#?fuseaction=objects2.upd_return&return_id=#attributes.return_id#" addtoken="no">
