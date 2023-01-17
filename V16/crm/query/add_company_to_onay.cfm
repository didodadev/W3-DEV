<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="GET_COMPANY_STATE" datasource="#dsn#">
			SELECT
				COMPANY_STATE
			FROM
				COMPANY
			WHERE
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="GET_STAGE" datasource="#dsn#" maxrows="1">
			SELECT 
				PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
				PROCESS_TYPE_ROWS.ACTION_DETAIL,
				PROCESS_TYPE_ROWS.STAGE
			FROM
				PROCESS_TYPE,
				PROCESS_TYPE_ROWS,
				PROCESS_TYPE_OUR_COMPANY,
				PROCESS_TYPE_ROWS_POSID
			WHERE
				PROCESS_TYPE.IS_ACTIVE = 1 AND
				PROCESS_TYPE.FACTION LIKE '%crm.form_add_company%' AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
				PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				PROCESS_TYPE_ROWS_POSID.POSITION_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND 
				PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID
			ORDER BY 
				PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID
			DESC
		</cfquery>
		<cfif get_stage.process_row_id gt get_company_state.company_state>
			<cfquery name="UPDATE_COMPANY" datasource="#dsn#">
				UPDATE
					COMPANY
				SET
					COMPANY_STATE = #get_stage.process_row_id#
				WHERE
					COMPANY_ID = #attributes.cpid#
			</cfquery>
			<cfquery name="GET_COMPANY_INFO" datasource="#dsn#">
				SELECT
					UPDATE_DATE,
					UPDATE_EMP
				FROM
					COMPANY
				WHERE
					COMPANY_ID = #attributes.cpid#
			</cfquery>
			<cfscript>
				record_member = get_company_info.update_emp;
				record_date = get_company_info.update_date;
				action_page = "#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#";
			</cfscript>
			<cf_workcube_process 
				process_action_dsn='#dsn#' 
				is_upd='1' 
				process_stage='#get_stage.process_row_id#' 
				record_member='#record_member#' 
				record_date='#record_date#' 
				action_page='#action_page#' 
				action_id='#attributes.cpid#'>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
