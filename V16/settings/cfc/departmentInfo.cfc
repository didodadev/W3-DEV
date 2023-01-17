<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cffunction name="getDepartmentInfo" access="remote" returntype="any" returnformat="plain">
        <cfargument name="department_info" type="numeric" required="yes">
        <cfif isdefined("session.ep")>
            <cfquery name="get_department" datasource="#dsn#">
                SELECT 
                	BRANCH_ID 
                FROM 
                	DEPARTMENT 
                WHERE 
                	DEPARTMENT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_info#">
            </cfquery>
            <cfset return_val =  SerializeJSON(get_department)>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
        <cfreturn return_val>
    </cffunction>
    
</cfcomponent>
