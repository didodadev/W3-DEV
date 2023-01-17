<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_interceptor_categories" returntype="query">
        <cfargument name="interceptor_category_id" default="">
        <cfargument name="interceptor_kind" default="">
        <cfargument name="title" default="">
        <cfargument name="status" default="">
        <cfargument name="timeout" default="24">

        <cfquery name="query_get_interceptor_categories_cached" datasource="#dsn#" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT * FROM PLVN_INTERCEPTOR_CATEGORIES
        </cfquery>
        <cfquery name="query_get_interceptor_categories" dbtype="query">
            SELECT * FROM query_get_interceptor_categories_cached
            WHERE 1 = 1
            <cfif len(arguments.interceptor_category_id)>
                <cfif listLen(arguments.interceptor_category_id) gt 1>
                AND INTERCEPTOR_CATEGORY_ID IN (<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category_id#' list="true">)
                <cfelse>
                AND INTERCEPTOR_CATEGORY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category_id#'>
                </cfif>
            </cfif>
            <cfif len(arguments.interceptor_kind)>
                AND INTERCEPTOR_KIND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_kind#'>
            </cfif>
            <cfif len(arguments.title)>
                AND TITLE LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.title#%'>
            </cfif>
            <cfif len(arguments.status)>
                AND STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
        </cfquery>

        <cfreturn query_get_interceptor_categories>
    </cffunction>

    <cffunction name="save_interceptor_categories">
        <cfargument name="interceptor_category_id" type="numeric" default="0">
        <cfargument name="interceptor_kind" type="numeric">
        <cfargument name="title" type="string">
        <cfargument name="status" type="numeric">

        <cfif arguments.interceptor_category_id eq 0>
            <cfquery name="insert_interceptor_category" datasource="#dsn#">
                INSERT INTO PLVN_INTERCEPTOR_CATEGORIES (INTERCEPTOR_KIND, TITLE, STATUS)
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_kind#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                )
            </cfquery>
        <cfelse>
            <cfquery name="update_interceptor_category" datasource="#dsn#">
                UPDATE PLVN_INTERCEPTOR_CATEGORIES SET 
                <cfif isDefined("arguments.interceptor_kind")>
                    INTERCEPTOR_KIND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_kind#'>
                <cfelse>
                    INTERCEPTOR_KIND = INTERCEPTOR_KIND
                </cfif>
                <cfif isDefined("arguments.title")>
                    ,TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                </cfif>
                <cfif isDefined("arguments.status")>
                    ,STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                </cfif>
                WHERE INTERCEPTOR_CATEGORY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category_id#'>
            </cfquery>
        </cfif>
        <cfset get_interceptor_categories(interceptor_category_id: 0, timeout: 0)>
    </cffunction>

    <cffunction name="delete_interceptor_categories">
        <cfargument name="interceptor_category_id" type="numeric" default="0">

        <cfquery name="query_delete_interceptor_category" datasource="#dsn#">
            DELETE FROM PLVN_INTERCEPTOR_CATEGORIES WHERE INTERCEPTOR_CATEGORY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.interceptor_category_id#'>
        </cfquery>
        <cfset get_interceptor_categories(interceptor_category_id: 0, timeout: 0)>
    </cffunction>
    
</cfcomponent>