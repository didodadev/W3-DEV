<cfcomponent>
    
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_responses" returntype="query">
        <cfargument name="response_id" default="">
        <cfargument name="type" default="">
        <cfargument name="header" default="">
        <cfargument name="status" default="">
        <cfargument name="timeout" default="24">

        <cfquery name="query_get_responses_cached" datasource="#dsn#" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT * FROM PLVN_RESPONSES
        </cfquery>
        <cfquery name="query_get_responses" dbtype="query">
            SELECT * FROM query_get_responses_cached
            WHERE 1 = 1
            <cfif len(arguments.response_id)>
                AND RESPONSE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.response_id#'>
            </cfif>
            <cfif len(arguments.type)>
                AND TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.type#'>
            </cfif>
            <cfif len(arguments.header)>
                AND HEADER LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.header#%'>
            </cfif>
            <cfif len(arguments.status)>
                AND STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
        </cfquery>

        <cfreturn query_get_responses>
    </cffunction>

    <cffunction name="save_responses">
        <cfargument name="response_id" type="numeric" default="0">
        <cfargument name="type" type="numeric">
        <cfargument name="header" type="string">
        <cfargument name="response_data" type="string">
        <cfargument name="status" type="numeric">

        <cfif arguments.response_id eq 0>
            <cfquery name="query_insert_response" datasource="#dsn#">
                INSERT INTO PLVN_RESPONSES ( TYPE, HEADER, RESPONSE_DATA, STATUS )
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.type#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.header#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.response_data#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                )
            </cfquery>
        <cfelse>
            <cfquery name="query_update_response" datasource="#dsn#">
                UPDATE PLVN_RESPONSES SET
                <cfif len(arguments.type)>
                    TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.type#'>
                <cfelse>
                    TYPE = TYPE
                </cfif>
                <cfif len(arguments.header)>
                    ,HEADER = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.header#'>
                </cfif>
                <cfif len(arguments.response_data)>
                    ,RESPONSE_DATA = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.response_data#'>
                </cfif>
                <cfif len(arguments.status)>
                    ,STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                </cfif>
                WHERE RESPONSE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.response_id#'>
            </cfquery>
        </cfif>
        <cfset get_responses(response_id: 0, timeout: 0)>
    </cffunction>

</cfcomponent>