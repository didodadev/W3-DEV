<cffunction name="get_branch_dep" access="public" returntype="query" output="no">
    <cfargument name="branch_id" required="no" type="string">
        <cfquery name="get_branch_dep" datasource="#dsn#">
            SELECT 
                DEPARTMENT_HEAD,
                DEPARTMENT_ID 
           FROM 
                DEPARTMENT 
           WHERE 
                DEPARTMENT_STATUS = 1 AND 
                IS_PRODUCTION = 1 AND 	
                BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
           ORDER BY 
				DEPARTMENT_HEAD
        </cfquery>
    <cfreturn get_branch_dep>
</cffunction>
		
