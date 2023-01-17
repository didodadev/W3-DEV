<cf_date  tarih='attributes.due_date'>
	<cfquery name="add_row_to_tbl" datasource="#DSN#">
		UPDATE
			CORRESPONDENCE_PAYMENT
		SET
			PRIORITY= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRIORITY#">,
			DUEDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date#">,
			PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#">,
			TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
			AMOUNT = <cfif isdefined("attributes.AMOUNT") and len(attributes.AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value = "#attributes.AMOUNT#"><cfelse>NULL</cfif>,
			MONEY= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#">,
			DETAIL= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			SUBJECT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subject#">,
			IN_OUT_ID = <cfif isdefined("attributes.employee_in_out_id") and len(attributes.employee_in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_in_out_id#"><cfelse>NULL</cfif>,
			PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
			STATUS=NULL,
			DEMAND_TYPE= <cfif isdefined("arguments.DEMAND_TYPE") and len(arguments.DEMAND_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DEMAND_TYPE#"><cfelse>NULL</cfif>
			
		WHERE
			ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cf_workcube_process
	is_upd='1'
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='CORRESPONDENCE_PAYMENT'
	action_column='ID'
	action_id='#attributes.id#'
	action_page="#request.self#?fuseaction=ehesap.list_payment_requests&event=upd&id=#attributes.id#"
	warning_description = 'Avans Talebi : #attributes.id#'>
	<script type="text/javascript">
		<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
			closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
			location.href = document.referrer;
		<cfelse>
			wrk_opener_reload();
			window.close();
		</cfif>
	</script>
