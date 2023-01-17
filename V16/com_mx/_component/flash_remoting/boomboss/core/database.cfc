<cfcomponent output="no">
	<!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "BoomBoss Core - Database component is accessible.">
	</cffunction>
 
	<!--- Get Databases --->
    <cffunction name="getDatabases" access="remote" returntype="any" output="no">
    	<cfargument name="filter" type="string" required="no" default="">
                 
        <cfset result = StructNew()>
        
        <cfif not len(arguments.filter)><cfset arguments.filter = session.databaseName></cfif>
         
        <cfset databases = ArrayNew(1)>
        <cfif isDefined("session.workcubeReportSystem") and session.workcubeReportSystem eq true>
			<cfif fileexists("#SERVER.Coldfusion.rootdir#\lib\neo-datasource.xml")>
                <cfquery name="get_databases" datasource="#session.defaultDatabaseName#">
                	SELECT name FROM Sys.databases WHERE name LIKE '#session.defaultDatabaseName#%'
                </cfquery>     
                <cfloop query="get_databases">
                	<cfset ArrayAppend(databases, get_databases.name)>
                </cfloop>  
                <cfset sorted = ArraySort(databases, "textnocase", "asc")>
            </cfif>
        <cfelse>
        	<cfset ArrayAppend(databases, session.databaseName)>
        </cfif>
                
        <cfreturn databases>
    </cffunction>
	
	<!--- Get Tables --->
    <cffunction name="getTables" access="remote" returntype="any" output="no">
    	<cfargument name="db_name" type="string" required="yes">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_tables" datasource="#arguments.db_name#">
                SELECT
                    name
                FROM
                    sys.Tables
                WHERE							-- Hide system tables
                    name <> 'sysdiagrams'
                    AND name <> 'dtproperties'
                UNION
                SELECT
                    name
                FROM
                    sys.Views
                WHERE							-- Hide system tables
                    name <> 'sysdiagrams'
                    AND name <> 'dtproperties'
                ORDER BY
                    name
            </cfquery>
            <cfset result["tables"] = get_tables>
            
            <cfcatch type="any">
            	<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                <cfreturn result>
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Get Fields --->
    <cffunction name="getFields" access="remote" returntype="any" output="no">
    	<cfargument name="db_name" type="string" required="yes">
        <cfargument name="table_name" type="string" required="yes">
        <cfargument name="only_identity_fields" type="boolean" required="no" default="0">
        
        <cfset result = StructNew()>
        
        <cftry>
            <cfquery name="get_fields" datasource="#arguments.db_name#">
                SELECT
                    COLS.COLUMN_NAME 				AS name,
                    COLS.DATA_TYPE 					AS type,
                    COLS.IS_NULLABLE 				AS isNullable,
                    COLS.CHARACTER_MAXIMUM_LENGTH 	AS maxChar,
					(SELECT VALUE FROM fn_listextendedproperty('MS_Description', 'schema', , 'table', '#arguments.table_name#', 'column', COLS.COLUMN_NAME)) AS description
                FROM
                    INFORMATION_SCHEMA.COLUMNS	AS COLS
                WHERE
                    COLS.TABLE_NAME = '#arguments.table_name#'
                    <cfif not isDefined("session.workcubeReportSystem") or isDefined("session.workcubeReportSystem") and session.workcubeReportSystem eq false>AND COLS.COLUMN_NAME NOT LIKE '%PATH%'</cfif>
                    <cfif arguments.only_identity_fields eq 1>AND COLUMNPROPERTY(OBJECT_ID('#arguments.table_name#'), COLS.COLUMN_NAME, 'IsIdentity') = 1</cfif>
                ORDER BY
                    name
            </cfquery>
            <cfset result["fields"] = get_fields>
            
		    <cfcatch type="any">
            	<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nLine: #cfcatchLine#">
                <cfreturn result>
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
</cfcomponent>
