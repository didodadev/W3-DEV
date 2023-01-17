<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_expression_categories" returntype="query">
        <cfargument name="expression_category_id" default="">
        <cfargument name="expression_kind" default="">
        <cfargument name="title" default="">
        <cfargument name="status" default="">
        <cfargument name="timeout" default="24">

        <cfquery name="query_get_expression_categories_cached" datasource="#dsn#" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT * FROM PLVN_EXPRESSION_CATEGORIES
        </cfquery>
        <cfquery name="query_get_expression_categories" dbtype="query">
            SELECT * FROM query_get_expression_categories_cached
            WHERE 1 = 1
            <cfif len(arguments.expression_category_id)>
                <cfif listLen(arguments.expression_category_id) gt 1>
                AND EXPRESSION_CATEGORY_ID IN (<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category_id#' list="true">)
                <cfelse>
                AND EXPRESSION_CATEGORY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category_id#'>
                </cfif>
            </cfif>
            <cfif len(arguments.expression_kind)>
                AND EXPRESSION_KIND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_kind#'>
            </cfif>
            <cfif len(arguments.title)>
                AND TITLE LIKE <cfqueryparam cfsqltype='CF_SQL_VARCHAR' value='%#arguments.title#%'>
            </cfif>
            <cfif len(arguments.status)>
                AND STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
        </cfquery>
        
        <cfreturn query_get_expression_categories>
    </cffunction>

    <cffunction name="save_expression_categories">
        <cfargument name="expression_category_id" type="numeric" default="0">
        <cfargument name="expression_kind" type="numeric">
        <cfargument name="title" type="string">
        <cfargument name="status" type="numeric">

        <cfif arguments.expression_category_id eq 0>
            <cfquery name="insert_expression_category" datasource="#dsn#">
                INSERT INTO PLVN_EXPRESSION_CATEGORIES (EXPRESSION_KIND, TITLE, STATUS, RECORD_DATE, RECORD_EMP, RECORD_IP)
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_kind#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>,
                    <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#now()#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
            </cfquery>
        <cfelse>
            <cfquery name="update_expression_category" datasource="#dsn#">
                UPDATE PLVN_EXPRESSION_CATEGORIES SET 
                <cfif isDefined("arguments.expression_kind")>
                    EXPRESSION_KIND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_kind#'>
                <cfelse>
                    EXPRESSION_KIND = EXPRESSION_KIND
                </cfif>
                <cfif isDefined("arguments.title")>
                    ,TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
                </cfif>
                <cfif isDefined("arguments.status")>
                    ,STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                </cfif>
                    ,UPDATE_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#now()#'>
                    ,UPDATE_EMP = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
                    ,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE EXPRESSION_CATEGORY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category_id#'>
            </cfquery>
        </cfif>
        <cfset get_expression_categories(expression_category_id: 0, timeout: 0)>
    </cffunction>

    <cffunction name="delete_expression_categories">
        <cfargument name="expression_category_id" type="numeric" default="0">

        <cfquery name="query_delete_expression_category" datasource="#dsn#">
            DELETE FROM PLVN_EXPRESSION_CATEGORIES WHERE EXPRESSION_CATEGORY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category_id#'>
        </cfquery>
        <cfset get_expression_categories(expression_category_id: 0, timeout: 0)>
    </cffunction>
    
</cfcomponent>