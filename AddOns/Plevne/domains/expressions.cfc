<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="get_expressions" returntype="query">
        <cfargument name="expression_id" default="">
        <cfargument name="expression_category" default="">
        <cfargument name="expression_body" default="">
        <cfargument name="status" default="">
        <cfargument name="timeout" default="24">

        <cfquery name="query_get_expressions_cached" datasource="#dsn#" cachedwithin="#createTimespan(0, arguments.timeout, 0, 1)#">
            SELECT * FROM PLVN_EXPRESSIONS
        </cfquery>
        <cfquery name="query_get_expressions" dbtype="query">
            SELECT * FROM query_get_expressions_cached
            WHERE 1 = 1
            <cfif len(arguments.expression_id)>
                AND EXPRESSION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_id#'>
            </cfif>
            <cfif len(arguments.expression_category)>
                <cfif listLen(arguments.expression_category) gt 1>
                AND EXPRESSION_CATEGORY IN (<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category#' list="true">)
                <cfelse>
                AND EXPRESSION_CATEGORY = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category#'>
                </cfif>
            </cfif>
            <cfif len(arguments.expression_body)>
                AND EXPRESSION_BODY LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.expression_body#%'>
            </cfif>
            <cfif len(arguments.status)>
                AND STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
            </cfif>
        </cfquery>

        <cfreturn query_get_expressions>
    </cffunction>

    <cffunction name="save_expressions">
        <cfargument name="expression_id" type="numeric" default="0">
        <cfargument name="expression_category" type="numeric">
        <cfargument name="expression_body" type="string">
        <cfargument name="status" type="numeric">
        
        <cfif arguments.expression_id eq 0>
            <cfquery name="query_insert_expression" datasource="#dsn#">
                INSERT INTO PLVN_EXPRESSIONS ( EXPRESSION_CATEGORY, EXPRESSION_BODY, STATUS )
                VALUES (
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category#'>,
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.expression_body#'>,
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                )
            </cfquery>
        <cfelse>
            <cfquery name="query_update_expression" datasource="#dsn#">
                UPDATE PLVN_EXPRESSIONS SET
                <cfif isDefined("arguments.expression_category")>
                    EXPRESSION_CATEGORY = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_category#'>
                <cfelse>
                    EXPRESSION_CATEGORY = EXPRESSION_CATEGORY
                </cfif>
                <cfif isDefined("arguments.expression_body")>
                    ,EXPRESSION_BODY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.expression_body#'>
                </cfif>
                <cfif isDefined("arguments.status")>
                    ,STATUS = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.status#'>
                </cfif>
                WHERE EXPRESSION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_id#'>
            </cfquery>
        </cfif>

        <cfset get_expressions(expression_id: 0, timeout: 0)>
    </cffunction>

    <cffunction name="delete_expression">
        <cfargument name="expression_id" type="numeric" default="0">

        <cfquery name="query_delete_expression" datasource="#dsn#">
            DELETE FROM PLVN_EXPRESSIONS WHERE EXPRESSION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.expression_id#'>
        </cfquery>

        <cfset get_expressions(expression_id: 0, timeout: 0)>
    </cffunction>

</cfcomponent>