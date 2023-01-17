<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="get_position" datasource="#dsn#">
			SELECT
				POSITION_CODE,
				POSITION_NAME,
				POSITION_STAGE
			FROM
				EMPLOYEE_POSITIONS
			WHERE
				POSITION_ID = #attributes.position_id#
		</cfquery>
		<cfif get_position.recordcount>
			<cfquery name="del_pos_auto" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITIONS_AUTHORITY WHERE POSITION_ID = #attributes.position_id# AND POSITION_CAT_ID IS NULL
			</cfquery>
			
			<cfquery name="del_pos_cost" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITIONS_COST WHERE POSITION_ID = #attributes.position_id#
			</cfquery>
			
			<cfquery name="del_pos_denied" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITIONS_DENIED WHERE POSITION_CODE = #get_position.position_code#
			</cfquery>
			
			<cfquery name="del_pos_branch" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #get_position.position_code#
			</cfquery>
			
			<cfquery name="del_pos_period" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID = #attributes.position_id#
			</cfquery>			
			<cfquery name="del_pos_standby" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_position.position_code#
			</cfquery>
			
			<cfquery name="del_pos_history" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_ID= #attributes.position_id#
			</cfquery>
			
			<cfquery name="del_pos" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #attributes.position_id#
			</cfquery>
		</cfif>
		<cf_add_log  log_type="-1" action_id="#attributes.position_id#" action_name="#get_position.position_name#" process_stage="#get_position.position_stage#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=hr.list_positions" addtoken="no">
