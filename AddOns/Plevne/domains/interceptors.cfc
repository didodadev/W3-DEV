<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="get_interceptors" returntype="query">
        <cfargument name="interceptor_id" default="">
        <cfargument name="interceptor_category" default="">
        <cfargument name="interceptor_path" default="">
        <cfargument name="status" default="">
        <cfargument name="timeout" default="24">

        <cfquery name="query_get_interceptors_cached" datasource="#dsn#" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT * FROM PLVN_INTERCEPTORS 
        </cfquery>
        <cfquery name="query_get_interceptors" dbtype="query">
            SELECT * FROM query_get_interceptors_cached
            WHERE 1 = 1
            <cfif len(arguments.interceptor_id)>
                AND INTERCEPTOR_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_id#'>
            </cfif>
            <cfif len(arguments.interceptor_category)>
                <cfif listLen(arguments.interceptor_category) gt 1>
                AND INTERCEPTOR_CATEGORY IN (<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category#' list='true'>)
                <cfelse>
                AND INTERCEPTOR_CATEGORY = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category#'>
                </cfif>
            </cfif>
            <cfif len(arguments.interceptor_path)>
                AND INTERCEPTOR_PATH LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.interceptor_path#%'>
            </cfif>
            <cfif len(arguments.status)>
                AND STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
        </cfquery>

        <cfreturn query_get_interceptors>
    </cffunction>

    <cffunction name="save_interceptors">
        <cfargument name="interceptor_id" type="numeric" default="0">
        <cfargument name="interceptor_category" type="numeric">
        <cfargument name="interceptor_path" type="string">
        <cfargument name="status" type="numeric">
        
        <cfif arguments.interceptor_id eq 0>
            <cfquery name="query_insert_interceptor" datasource="#dsn#">
                INSERT INTO PLVN_INTERCEPTORS ( INTERCEPTOR_CATEGORY, INTERCEPTOR_PATH, STATUS )
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.interceptor_path#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                )
            </cfquery>
        <cfelse>
            <cfquery name="query_update_interceptor" datasource="#dsn#">
                UPDATE PLVN_INTERCEPTORS SET
                <cfif isDefined("arguments.interceptor_category")>
                    INTERCEPTOR_CATEGORY = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category#'>
                <cfelse>
                    INTERCEPTOR_CATEGORY = INTERCEPTOR_CATEGORY
                </cfif>
                <cfif isDefined("arguments.interceptor_path")>
                    ,INTERCEPTOR_PATH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.interceptor_path#'>
                </cfif>
                <cfif isDefined("arguments.status")>
                    ,STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                </cfif>
                WHERE INTERCEPTOR_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_id#'>
            </cfquery>
        </cfif>

        <cfset get_interceptors(interceptor_id: 0, timeout: 0)>
    </cffunction>

    <cffunction name="delete_interceptor">
        <cfargument name="interceptor_id" type="numeric" default="0">

        <cfquery name="query_delete_interceptor" datasource="#dsn#">
            DELETE FROM PLVN_INTERCEPTORS WHERE INTERCEPTOR_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_id#'>
        </cfquery>

        <cfset get_interceptors(interceptor_id: 0, timeout: 0)>
    </cffunction>

</cfcomponent>