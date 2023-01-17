<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="get_level_process" returntype="query">
        <cfargument name="level_process_id" default="">
        <cfargument name="process_kind" default="">
        <cfargument name="process_type" default="">
        <cfargument name="relation_id" default="">
        <cfargument name="contrast" default="">
        <cfargument name="timeout" default="24">

        <cfquery name="query_get_level_process_cached" datasource="#dsn#" cacheID="level_process_get_level_process" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT LEVEL_PROCESS_ID, PROCESS_KIND, PROCESS_TYPE, RELATION_ID, CONTRAST
            FROM PLVN_LEVEL_PROCESS
        </cfquery>
        <cfquery name="query_get_level_process" dbtype="query">
            SELECT * FROM query_get_level_process_cached
            WHERE 1 = 1
            <cfif len(arguments.level_process_id)>
                AND LEVEL_PROCESS_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.level_process_id#'>
            </cfif>
            <cfif len(arguments.process_kind)>
                AND PROCESS_KIND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_kind#'>
            </cfif>
            <cfif len(arguments.process_type)>
                AND PROCESS_TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_type#'>
            </cfif>
            <cfif len(arguments.relation_id)>
                AND RELATION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.relation_id#'>
            </cfif>
            <cfif len(arguments.contrast)>
                AND CONTRAST = <cfqueryparam cfsqltype='CF_SQL_VARCHAR' value='#arguments.contrast#'>
            </cfif>
        </cfquery>
        <cfreturn query_get_level_process>
    </cffunction>

    <cffunction name="save_level_process">
        <cfargument name="level_process_id" default="0">
        <cfargument name="process_kind" type="numeric">
        <cfargument name="process_type" type="numeric">
        <cfargument name="relation_id" type="numeric">
        <cfargument name="contrast" type="string">

        <cfif arguments.level_process_id eq "0">
            <cfquery name="query_insert_level_process" datasource="#dsn#">
                INSERT INTO PLVN_LEVEL_PROCESS ( PROCESS_KIND, PROCESS_TYPE, RELATION_ID, CONTRAST )
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_kind#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_type#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.relation_id#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.contrast#'>
                )
            </cfquery>
        <cfelse>
            <cfquery name="query_update_level_process" datasource="#dsn#">
                UPDATE PLVN_LEVEL_PROCESS SET
                PROCESS_KIND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_kind#'>,
                PROCESS_TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_type#'>,
                RELATION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.relation_id#'>,
                CONTRAST = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.contrast#'>
                WHERE LEVEL_PROCESS_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.level_process_id#'>
            </cfquery>
        </cfif>

        <cfset get_level_process(level_process_id: 0, timeout: 0)>
    </cffunction>

</cfcomponent>