<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_traces" returntype="query">
        <cfargument name="id" default="">
        <cfargument name="page" default="">
        <cfargument name="user_name" default="">
        <cfargument name="parameters" default="">
        <cfargument name="record_date_start" default="">
        <cfargument name="record_date_finish" default="">
        <cfargument name="req_time_start" default="">
        <cfargument name="req_time_finish" default="">
        <cfargument name="server" default="">

        <cfquery name="query_get_traces" datasource="#dsn#">
            SELECT TOP 1000 * FROM WRK_TRACE WHERE 1 = 1
            <cfif len(arguments.id)>
                AND TRACE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
            </cfif>
            <cfif len(arguments.page)>
                AND PAGE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.page#'>
            </cfif>
            <cfif len(arguments.user_name)>
                AND USER_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.user_name#'>
            </cfif>
            <cfif len(arguments.parameters)>
                AND PARAMETERS LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.parameters#%'>
            </cfif>
            <cfif len(arguments.record_date_start)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.req_time_start#'>
            </cfif>
            <cfif len(arguments.record_date_finish)>
                AND RECORD_DATE <= <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.record_date_finish#'>
            </cfif>
            <cfif len(arguments.server)>
                AND SERVER = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.server#'>
            </cfif>
            
            ORDER BY RECORD_DATE DESC
        </cfquery>
        
        <cfreturn query_get_traces>
    </cffunction>

    <cffunction name="get_traces_count" returntype="query">
        <cfargument name="id" default="">
        <cfargument name="page" default="">
        <cfargument name="user_name" default="">
        <cfargument name="parameters" default="">
        <cfargument name="record_date_start" default="">
        <cfargument name="record_date_finish" default="">
        <cfargument name="req_time_start" default="">
        <cfargument name="req_time_finish" default="">
        <cfargument name="server" default="">
        <cfargument name="groups" default="">

        <cfquery name="query_get_traces" datasource="#dsn#">
            SELECT <cfif len(arguments.groups)>#arguments.groups#,</cfif> COUNT(*) AS CNT FROM WRK_TRACE WHERE 1 = 1
            <cfif len(arguments.id)>
                AND TRACE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.id#'>
            </cfif>
            <cfif len(arguments.page)>
                AND PAGE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.page#'>
            </cfif>
            <cfif len(arguments.user_name)>
                AND USER_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.user_name#'>
            </cfif>
            <cfif len(arguments.parameters)>
                AND PARAMETERS LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.parameters#%'>
            </cfif>
            <cfif len(arguments.record_date_start)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.record_date_start#'>
            </cfif>
            <cfif len(arguments.record_date_finish)>
                AND RECORD_DATE <= <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.record_date_finish#'>
            </cfif>
            <cfif len(arguments.server)>
                AND SERVER = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.server#'>
            </cfif>
            <cfif len(arguments.groups)>
                GROUP BY #arguments.groups#
            </cfif>
        </cfquery>
        
        <cfreturn query_get_traces>
    </cffunction>

    <cffunction name="save_trace">
        <cfargument name="page" type="string">
        <cfargument name="user_name" type="string">
        <cfargument name="parameters" type="string">
        <cfargument name="record_date" type="date">
        <cfargument name="req_time" type="numeric">
        <cfargument name="server" type="string">

        <cfquery name="query_insert_trace" datasource="#dsn#">
            INSERT INTO WRK_TRACE (PAGE, USER_NAME, PARAMETERS, RECORD_DATE, REQ_TIME, SERVER)
            VALUES (
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.page#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.user_name#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.parameters#'>,
                <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.record_date#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_time#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.server#'>
            )
        </cfquery>
    </cffunction>

</cfcomponent>