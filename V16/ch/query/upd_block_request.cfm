<cf_date tarih ='attributes.block_start_date'>
<cfif len(attributes.block_finish_date)><cf_date tarih ='attributes.block_finish_date'></cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="upd_law_request" datasource="#dsn#">
			UPDATE
				COMPANY_BLOCK_REQUEST
			SET
				PROCESS_STAGE = #attributes.process_stage#,
				BLOCK_START_DATE = #attributes.block_start_date#,
				BLOCK_FINISH_DATE = <cfif len(attributes.block_finish_date)>#attributes.block_finish_date#<cfelse>NULL</cfif>,
				COMPANY_ID = <cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>#attributes.member_id#<cfelse>NULL</cfif>,
				CONSUMER_ID = <cfif isdefined("attributes.member_type") and attributes.member_type is 'consumer'>#attributes.member_id#<cfelse>NULL</cfif>,
				BLOCK_EMPLOYEE_ID = #attributes.blocker_employee_id#,
				BLOCK_GROUP_ID = #attributes.block_group#,
				DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				COMPANY_BLOCK_ID = #attributes.block_id#
		</cfquery>		
		<cf_workcube_process is_upd='1' 
				data_source='#dsn#' 
				old_process_line='#attributes.old_process_line#'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='COMPANY_BLOCK_REQUEST'
				action_column='COMPANY_BLOCK_ID'
				action_id='#attributes.block_id#'
				action_page='#request.self#?fuseaction=ch.list_block_request&event=upd&block_id=#attributes.block_id#' 
			    warning_description='Blok Takibi : #attributes.block_id#'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_block_request&event=upd&block_id=#attributes.block_id#</cfoutput>';
</script>
