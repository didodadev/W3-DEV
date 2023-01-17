<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	 <cfset dsn3 ="#dsn#_#session.ep.company_id#">
    <cfset predefined_table = "TEXTILE_PREDEFINED_PROC">
    <cfset predefined_row_table = "TEXTILE_PREDEFINED_PROC_ROW">

    <!---
    <cffunction name="get_stations" access="public" returntype="query">
        <cfquery name="query_stations" datasource="#dsn#">
            SELECT DISTINCT STATION_ID FROM HY_TEXTILE_STATION_PROCESS
        </cfquery>
        <cfreturn query_stations>
    </cffunction>

    <cffunction name="get_process_cat" access="public" returntype="query">
        <cfquery name="query_process_cat" datasource="#dsn#">
            SELECT STATION_ID, PROCESS_CAT FROM HY_TEXTILE_STATION_PROCESS
            GROUP BY STATION_ID, PROCESS_CAT
        </cfquery>
        <cfreturn query_process_cat>
    </cffunction>

    <cffunction name="get_process" access="public" returntype="query">
        <cfquery name="query_process" datasource="#dsn#">
            SELECT * FROM HY_TEXTILE_STATION_PROCESS
            WHERE ACTIVE = 1
        </cfquery>
        <cfreturn query_process>
    </cffunction>
    --->

    <cffunction name="get_stations" access="public" returntype="query">
        <cfargument name="dsn3" type="string"> 
        <cfquery name="query_stations" datasource="#dsn3#">
            SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS
        </cfquery>
        <cfreturn query_stations>
    </cffunction>

    <cffunction name="get_predefineds" access="public" returntype="query">
     <cfargument name="req_id" type="any" default="">
        <cfquery name="query_predefined" datasource="#dsn3#">
            SELECT * FROM #predefined_table# WHERE PREDEFINED_STATUS = 1 
            <cfif len( arguments.req_id )>
            AND REQUEST_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
            </cfif>
        </cfquery>
        <cfreturn query_predefined>
    </cffunction>

    <cffunction name="get_predefined_byname" access="public" returntype="query">
        <cfargument name="title" type="string">
        <cfquery name="query_predefined" datasource="#dsn3#">
            SELECT * FROM #predefined_table# WHERE PREDEFINED_TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.title#'>
        </cfquery>
        <cfreturn query_predefined>
    </cffunction>

    <cffunction name="insert_predefined" access="public" returntype="any">
        <cfargument name="PREDEFINED_TITLE" type="string">
         <cfargument name="req_id" type="any">
        <cfquery name="query_predefined" datasource="#dsn3#" result="result_predefined">
            INSERT INTO #predefined_table#(PREDEFINED_TITLE,REQUEST_ID) VALUES(<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PREDEFINED_TITLE#'>,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>)
        </cfquery>
        <cfreturn result_predefined["GENERATEDKEY"]>
    </cffunction>

    <cffunction name="update_predefined" access="public">
        <cfargument name="PREDEFINED_ID" type="numeric">
        <cfargument name="PREDEFINED_TITLE" type="string">
        <cfquery name="query_predefined" datasource="#dsn3#">
            UPDATE #predefined_table# SET PREDEFINED_TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PREDEFINED_TITLE#'> WHERE PREDEFINED_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ID#'>
        </cfquery>
    </cffunction>
    
    <cffunction name="delete_predefined" access="public">
        <cfargument name="PREDEFINED_ID" type="numeric">
        <cfquery name="query_predefined" datasource="#dsn3#">
            DELETE FROM #predefined_table# WHERE PREDEFINED_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ID#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_predefined_rows" access="public" returntype="query">
        <cfargument name="dsn3" type="string">
        <cfargument name="predefined_id" type="any" default="">
        <cfquery name="query_predefined_rows" datasource="#dsn3#">
            /*SELECT ppr.*, wst.STATION_NAME  FROM #predefined_row_table# ppr INNER JOIN #arguments.dsn3#.WORKSTATIONS wst ON ppr.STATION_ID = wst.STATION_ID ORDER BY ppr.PREDEFINED_ROW_ID*/
            SELECT ppr.*, opr.OPERATION_TYPE  FROM #predefined_row_table# ppr INNER JOIN #arguments.dsn3#.OPERATION_TYPES opr ON ppr.STATION_ID = opr.OPERATION_TYPE_ID 
            <cfif len(arguments.predefined_id)>
            WHERE ppr.PREDEFINED_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.predefined_id#'>
            </cfif>
            ORDER BY ppr.PREDEFINED_ROW_ID
        </cfquery>
        <cfreturn query_predefined_rows>
    </cffunction>

    <cffunction name="insert_predefined_row" access="public">
        <cfargument name="PREDEFINED_ID" type="any">
        <cfargument name="STATION_ID" type="any">
        <cfquery name="query_predefined_row" datasource="#dsn3#">
            INSERT INTO #predefined_row_table#(PREDEFINED_ID, STATION_ID) VALUES(<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ID#'>, <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#STATION_ID#'>)
        </cfquery>
    </cffunction>

    <cffunction name="upate_predefined_row" access="public">
        <cfargument name="PREDEFINED_ROW_ID" type="numeric">
        <cfargument name="PREDEFINED_ID" type="numeric">
        <cfargument name="STATION_ID" type="numeric">
        <cfquery name="query_predefined_row" datasource="#dsn3#">
            UPDATE #predefined_row_table# SET PREDEFINED_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ID#'>, STATION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.STATION_ID#'> WHERE PREDEFINED_ROW_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.PREDEFINED_ROW_ID#'>
        </cfquery>
    </cffunction>

    <cffunction name="clear_predefined_rows" access="public">
        <cfargument name="PREDEFINED_ID" type="numeric">
        <cfquery name="query_predefined_row" datasource="#dsn3#">
            DELETE FROM #predefined_row_table# WHERE PREDEFINED_ID = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.PREDEFINED_ID#'>
        </cfquery>
    </cffunction>

</cfcomponent>