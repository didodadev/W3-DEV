<cf_date tarih ='attributes.block_start_date'>
<cfif len(attributes.block_finish_date)><cf_date tarih ='attributes.block_finish_date'></cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_law_request" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				COMPANY_BLOCK_REQUEST
			(
				PROCESS_STAGE,
				BLOCK_START_DATE,
				BLOCK_FINISH_DATE,
				COMPANY_ID,
				CONSUMER_ID,
				BLOCK_EMPLOYEE_ID,
				BLOCK_GROUP_ID,
				DETAIL,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				#attributes.process_stage#,
				#attributes.block_start_date#,
				<cfif len(attributes.block_finish_date)>#attributes.block_finish_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
					#attributes.member_id#,NULL,
				<cfelse>
					NULL,#attributes.member_id#,
				</cfif>
				#attributes.blocker_employee_id#,
				#attributes.block_group#,
				<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#
			)
		</cfquery>
		<cf_workcube_process is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='COMPANY_BLOCK_REQUEST'
			action_column='COMPANY_BLOCK_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=ch.list_block_request&event=upd&block_id=#MAX_ID.IDENTITYCOL#' 
			warning_description='Blok Takibi : #MAX_ID.IDENTITYCOL#'>
	</cftransaction>
</cflock>
<cfset attributes.actionId = MAX_ID.IDENTITYCOL>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_block_request&event=upd&block_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
