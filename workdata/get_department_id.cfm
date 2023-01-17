<cffunction name="get_department_id" access="public" returntype="query" output="no">
    <cfargument name="department_id" required="yes" type="string">
        <cfquery name="get_dep" datasource="#dsn#">
            SELECT
                DEPARTMENT_HEAD,
                DEPARTMENT_ID
            FROM
                DEPARTMENT
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
    <cfreturn get_dep>
</cffunction>
		
