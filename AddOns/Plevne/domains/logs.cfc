<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="get_logs" returntype="query">
        <cfargument name="log_id" default="">
        <cfargument name="source" default="">
        <cfargument name="source_id" default="">
        <cfargument name="type" default="">
        <cfargument name="top" default="1000">
        <cfargument name="skip" default="0">

        <cfquery name="query_get_logs" datasource="#dsn#">
            SELECT * FROM PLVN_LOGS WHERE 1 = 1
            <cfif len(arguments.log_id)>
                AND LOG_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.log_id#'>
            </cfif>
            <cfif len(arguments.source)>
                AND SOURCE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.source#'>
                <cfif len(arguments.source_id)>
                    AND SOURCE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.source_id#'>
                </cfif>
            </cfif>
            <cfif len(arguments.type)>
                AND TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.type#'>
            </cfif>
            ORDER BY LOG_ID DESC
            OFFSET #arguments.skip# ROWS FETCH NEXT #arguments.top# ROWS ONLY
        </cfquery>

        <cfreturn query_get_logs>
    </cffunction>

    <cffunction name="count_logs" returntype="any">
        <cfargument name="source" default="">
        <cfargument name="source_id" default="">
        <cfargument name="type" default="">
        <cfargument name="date_start" default="">
        <cfargument name="date_finish" default="">
        <cfargument name="groups" default="">

        <cfquery name="query_get_logs" datasource="#dsn#">
            SELECT <cfif len(arguments.groups)>#arguments.groups#,</cfif> COUNT(*) AS CNT FROM PLVN_LOGS WHERE 1 = 1
            <cfif len(arguments.source)>
                AND SOURCE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.source#'>
                <cfif len(arguments.source_id)>
                    AND SOURCE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.source_id#'>
                </cfif>
            </cfif>
            <cfif len(arguments.type)>
                AND TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.type#'>
            </cfif>
            <cfif len(arguments.date_start)>
                AND LOGDATE >= #arguments.date_start#
            </cfif>
            <cfif len(arguments.date_finish)>
                AND LOGDATE >= #arguments.date_finish#
            </cfif>
            <cfif len(arguments.groups)>
                GROUP BY #arguments.groups#
            </cfif>
        </cfquery>

        <cfreturn query_get_logs>
    </cffunction>

    <cffunction name="save_log">
        <cfargument name="source" type="string">
        <cfargument name="source_id" type="numeric">
        <cfargument name="type" type="numeric">
        <cfargument name="message" type="string">
        <cfargument name="trace" type="string">

        <cfquery name="insert_log" datasource="#dsn#">
            INSERT INTO PLVN_LOGS (SOURCE, SOURCE_ID, MESSAGE, TYPE, TRACE, LOGDATE)
            VALUES (
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.source#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.source_id#'>,
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.message#'>,
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.type#'>,
                <cfif isDefined('arguments.trace') and len(arguments.trace)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.trace#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null='true'>
                </cfif>
                ,#now()#
            )
        </cfquery>
    </cffunction>

</cfcomponent>