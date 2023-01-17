<cfcomponent output="no">
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss - Query Runner component is accessible.">
	</cffunction>
    
    <!--- CROSS FUNCTIONS --->
        
    <!--- Run Query--->
    <cffunction name="runQuery" access="remote" returntype="any" output="no">        
        <cfargument name="query_id" type="any" required="no">
        <cfargument name="query" type="any" required="no">
        <cfargument name="filter_query" type="any" required="no">
        <cfargument name="max_rows" type="numeric" required="no" default="-1">
        
        <cfset result = StructNew()>
        
        <cfif isDefined('arguments.query_id') and len(arguments.query_id)>
            <cfquery name="get_query" datasource="#session.databaseName#">
                SELECT
                    REPORT_QUERY_NAME				AS queryName,
                    REPORT_QUERY					AS query,
                    LIST_VIEW						AS listView,
                    GRAPHIC_TYPE					AS graphicType,
                    MAX_ROWS						AS pageSize,
                    GRAPH_LABEL_QUERY_COLUMN_ID		AS chartLabelColumnID,
                    GRAPH_VALUE_QUERY_COLUMN_ID		AS chartValueColumnID,
                    (SELECT COUNT(COLUMN_TYPE) FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = RQ.REPORT_QUERY_ID AND COLUMN_TYPE = 1) AS conditionCount,
                    (SELECT COUNT(COLUMN_FUNCTION) FROM REPORT_QUERY_COLUMNS WHERE REPORT_QUERY_ID = RQ.REPORT_QUERY_ID AND COLUMN_FUNCTION <> 0) AS functionCount
                FROM
                    REPORT_QUERY RQ
                WHERE
                    REPORT_QUERY_ID = #arguments.query_id#
            </cfquery>
            
            <cfquery name="get_query_columns" datasource="#session.databaseName#">
                SELECT 
                    REPORT_QUERY_COLUMN_ID	AS id,
                    COLUMN_NAME 			AS name,
                    COLUMN_FUNCTION			AS func,
                    COLUMN_FORMAT 			AS format,
                    SOURCE_DB_TABLE			AS targetField
                FROM
                    REPORT_QUERY_COLUMNS
                WHERE
                    REPORT_QUERY_ID = #arguments.query_id# AND
                    COLUMN_TYPE = 0
				ORDER BY
                	COLUMN_PRIORITY
            </cfquery>
            
            <cfif get_query.recordcount gt 0 and len(get_query.query)>
            	<cfif isDefined('arguments.filter_query') and len(arguments.filter_query)>
                	<cfset result = CreateObject("component", "core.common").getQuery(_____query_____: arguments.filter_query, _____max_rows_____: arguments.max_rows)>
                <cfelse>
                	<cfset result = CreateObject("component", "core.common").getQuery(_____query_____: get_query.query, _____max_rows_____: arguments.max_rows)>    
                </cfif>
                <cfset result["queryInfo"] = get_query>
                <cfset result["columnInformations"] = get_query_columns>
            <cfelse>
                <cfset result["errorCode"] = 267>
            </cfif>
		<cfelse>
        	<cfif isDefined('arguments.filter_query') and len(arguments.filter_query)>
                <cfset result = CreateObject("component", "core.common").getQuery(_____query_____: arguments.filter_query)>
			<cfelse>
            	<cfset result = CreateObject("component", "core.common").getQuery(_____query_____: arguments.query)>
            </cfif>
        </cfif>
        
        <cfreturn result>
    </cffunction>
</cfcomponent>