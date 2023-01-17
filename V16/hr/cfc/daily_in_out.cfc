<cfcomponent>
	<cffunction name="add_daily_in_out" access="public" returntype="numeric">
		<cfargument name="file_id" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="in_out_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="start_date" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="is_week_rest_day" default="">
		<cfquery name="add_row" datasource="#this.dsn#" result="MAX_ID">
			INSERT INTO
				EMPLOYEE_DAILY_IN_OUT
			(
				FILE_ID,
				EMPLOYEE_ID,
				IN_OUT_ID,
				BRANCH_ID,
				START_DATE,
				FINISH_DATE,
				IS_WEEK_REST_DAY,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfif len(arguments.file_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.file_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"><cfelse>NULL</cfif>,
				<cfif len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_week_rest_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_week_rest_day#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
        </cfquery>
        <cfset myResult = MAX_ID.IDENTITYCOL>
    <cfreturn myResult />
	</cffunction>
</cfcomponent>
