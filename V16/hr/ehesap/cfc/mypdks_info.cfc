<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>
    <cfset dsn3_alias = dsn & "_" & session.ep.company_id>
    <cfset dsn_alias = dsn >
    <cfset dsn1_alias = dsn & "_product">
    <cffunction name="get_last_login" returntype="query">
        <cfquery name="get_last_login" datasource="#this.DSN#">
            SELECT TOP (1) * FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY ROW_ID DESC
        </cfquery>
        <cfreturn get_last_login />
    </cffunction>
    <cffunction name="add_login" access="remote" returntype="any">
        <cfargument name="coordinate1" default=""/>
		<cfargument name="coordinate2" default=""/>
		<cfargument name="type" default=""/>
		<cfargument name="row_id" default=""/>
        <cfif arguments.type eq 'login_'>
            <cfquery name="add_login" datasource="#DSN#">
                INSERT INTO
                    EMPLOYEE_DAILY_IN_OUT
                    (
                        EMPLOYEE_ID,
                        START_DATE,
                        IN_COORDINATE1,
                        IN_COORDINATE2,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate1#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate2#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                    )
            </cfquery>
        <cfelseif arguments.type eq 'logout_'>
            <cfquery name="add_login" datasource="#DSN#">
                UPDATE
                    EMPLOYEE_DAILY_IN_OUT
                SET 
                    FINISH_DATE =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    OUT_COORDINATE1 =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate1#">,
                    OUT_COORDINATE2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate2#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value='#cgi.remote_addr#'>
                WHERE 
                    ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_id#">
            </cfquery>
        </cfif>
        <cfreturn 1>
    </cffunction>
</cfcomponent>