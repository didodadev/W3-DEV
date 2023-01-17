<cffunction name="get_location_id" access="public" returntype="query" output="no">
	<cfargument name="location_id" required="yes" type="string">
    <cfargument name="department_id" required="no" type="string">
        <cfquery name="get_dep_loc" datasource="#dsn#">
             SELECT
                COMMENT,
                LOCATION_ID,
                DEPARTMENT_ID
            FROM
                STOCKS_LOCATION
            WHERE
                LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">  AND
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
    <cfreturn get_dep_loc>
</cffunction>
		
