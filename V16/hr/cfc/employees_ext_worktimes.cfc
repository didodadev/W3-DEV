<cfcomponent>
	<cffunction name="add_worktime" access="public" returntype="numeric">
		<cfargument name="is_puantaj_off" default="">
		<cfargument name="is_from_pdks" default="">
		<cfargument name="pdks_file_id" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="start_time" default="">
		<cfargument name="end_time" default="">
		<cfargument name="day_type" default="">
		<cfargument name="in_out_id" default="">
		<cfargument name="valid" default="">
		<cfargument name="validdate" default="">
		<cfargument name="valid_employee_id" default="">
		<cfquery name="add_row" datasource="#this.dsn#" result="MAX_ID">
			INSERT INTO
				EMPLOYEES_EXT_WORKTIMES
			(
				IS_PUANTAJ_OFF,
				IS_FROM_PDKS,
				PDKS_FILE_ID,
				EMPLOYEE_ID,
				START_TIME,
				END_TIME,
				DAY_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				IN_OUT_ID,
				VALID,
				VALIDDATE,
				VALID_EMPLOYEE_ID
			)
			VALUES
			(
				<cfif len(arguments.is_puantaj_off)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_puantaj_off#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_from_pdks)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_from_pdks#"><cfelse>NULL</cfif>,
				<cfif len(arguments.pdks_file_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pdks_file_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.start_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_time#"><cfelse>NULL</cfif>,
				<cfif len(arguments.end_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.end_time#"><cfelse>NULL</cfif>,
				<cfif len(arguments.day_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.day_type#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif len(arguments.in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.valid#"><cfelse>NULL</cfif>,
				<cfif len(arguments.validdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.validdate#"><cfelse>NULL</cfif>,
				<cfif len(arguments.valid_employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.valid_employee_id#"><cfelse>NULL</cfif>
			)
        </cfquery>
        <cfset myResult = MAX_ID.IDENTITYCOL>
    <cfreturn myResult />
	</cffunction>
</cfcomponent>
