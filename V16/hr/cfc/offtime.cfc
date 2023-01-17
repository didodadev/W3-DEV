<cfcomponent>
	<cffunction name="add_offtime" access="public">
		<cfargument name="in_out_id" default="">
		<cfargument name="is_puantaj_off" default="">
		<cfargument name="is_from_pdks" default="">
		<cfargument name="pdks_file_id" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="offtimecat_id" default="">
		<cfargument name="startdate" default="">
		<cfargument name="finishdate" default="">
		<cfargument name="work_startdate" default="">
		<cfargument name="total_hours" default="">
		<cfargument name="validator_position_code" default="">
		<cfargument name="valid" default="">
		<cfargument name="valid_employee_id" default="">
		<cfargument name="validdate" default="">
		<cfargument name="offtime_stage" default="">
		<cfquery name="add_row" datasource="#this.dsn#">
			INSERT INTO
				OFFTIME
			(
				IN_OUT_ID,
				IS_PUANTAJ_OFF,
				IS_FROM_PDKS,
				PDKS_FILE_ID,
				EMPLOYEE_ID,
				OFFTIMECAT_ID,
				STARTDATE,
				FINISHDATE,
				WORK_STARTDATE,
				TOTAL_HOURS,
				VALIDATOR_POSITION_CODE,
				VALID,
				VALID_EMPLOYEE_ID,
				VALIDDATE,
				OFFTIME_STAGE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfif len(arguments.in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_puantaj_off)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_puantaj_off#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_from_pdks)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_from_pdks#"><cfelse>NULL</cfif>,
				<cfif len(arguments.pdks_file_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pdks_file_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.offtimecat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offtimecat_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"><cfelse>NULL</cfif>,
				<cfif len(arguments.finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#"><cfelse>NULL</cfif>,
				<cfif len(arguments.work_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.work_startdate#"><cfelse>NULL</cfif>,
				<cfif len(arguments.total_hours)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_hours#"><cfelse>NULL</cfif>,
				<cfif len(arguments.validator_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.validator_position_code#"><cfelse>NULL</cfif>,
				<cfif len(arguments.valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.valid#"><cfelse>NULL</cfif>,
				<cfif len(arguments.valid_employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.valid_employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.validdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.validdate#"><cfelse>NULL</cfif>,
				<cfif len(arguments.offtime_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offtime_stage#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
        </cfquery>
	</cffunction>
</cfcomponent>
