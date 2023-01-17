<cfif isdefined("attributes.is_payment") and attributes.is_payment eq 1>
	<cfset table_name =  "SALARYPARAM_PAY">
	<cfset message = '#getLang("","Ek ödenek",56249)# #getLang("","güncelleme",57703)#'>
	<cfset fuseact_ = 'ehesap.list_payments'>
	<cfquery name="upd_row" datasource="#dsn#">
		UPDATE 
			SALARYPARAM_PAY
		SET
			<cfif isdefined('attributes.comment_pay')>COMMENT_PAY = '#attributes.comment_pay#',</cfif>
			AMOUNT_PAY = #attributes.amount_pay#,
			<!---METHOD_PAY = #attributes.method_pay#,--->
			START_SAL_MON = #attributes.start_sal_mon#,
			END_SAL_MON = #attributes.end_sal_mon#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			PROCESS_STAGE = <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
		WHERE
			SPP_ID = #attributes.id#
	</cfquery>
<cfelseif isdefined("attributes.is_interruption") and attributes.is_interruption eq 1>	
	<cfset table_name =  "SALARYPARAM_GET">
	<cfset message = '#getLang("","kesinti güncelle",53479)#'>
	<cfset fuseact_ = 'ehesap.list_interruption'>
	<cfquery name="upd_row" datasource="#dsn#">
		UPDATE 
			SALARYPARAM_GET
		SET
			<cfif isdefined('attributes.comment_pay')>COMMENT_GET = '#attributes.comment_pay#',</cfif>
			AMOUNT_GET = #attributes.amount_pay#,
			<!---METHOD_GET = #attributes.method_pay#,--->
			START_SAL_MON = #attributes.start_sal_mon#,
			END_SAL_MON = #attributes.end_sal_mon#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			PROCESS_STAGE = <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
		WHERE
			SPG_ID = #attributes.id#
	</cfquery>
<cfelseif isdefined("attributes.is_tax_except") and attributes.is_tax_except eq 1>
	<cfquery name="upd_row" datasource="#dsn#">
		UPDATE 
			SALARYPARAM_EXCEPT_TAX
		SET
			<cfif isdefined('attributes.comment_pay')>TAX_EXCEPTION = '#attributes.comment_pay#',</cfif>
			AMOUNT = #attributes.amount_pay#,
			START_MONTH = #attributes.start_sal_mon#,
			FINISH_MONTH = #attributes.end_sal_mon#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			TAX_EXCEPTION_ID = #attributes.id#
	</cfquery>
<cfelseif isdefined("attributes.is_bes") and attributes.is_bes eq 1>	
	<cfquery name="upd_row" datasource="#dsn#">
		UPDATE 
			SALARYPARAM_BES
		SET
			RATE_BES = #attributes.amount_pay#,
			START_SAL_MON = #attributes.start_sal_mon#,
			END_SAL_MON = #attributes.end_sal_mon#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			SPB_ID = #attributes.id#
	</cfquery>
</cfif>
<cfif (isdefined("attributes.is_payment") and attributes.is_payment eq 1) or (isdefined("attributes.is_interruption") and attributes.is_interruption eq 1)>
	<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='#table_name#'
			action_column='PROCESS_STAGE'
			action_id='#attributes.id#'
			action_page='#request.self#?fuseaction=#fuseact_#' 
			warning_description='#message#'>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
