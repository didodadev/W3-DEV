<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_department" access="public" returntype="query">
		<cfargument name="branch_id" default="">
		<cfargument name="department_id" default="">
        <cfquery name="get_department" datasource="#dsn#">
			SELECT 
                #dsn#.Get_Dynamic_Language(DEPARTMENT_ID,'#session.ep.language#','DEPARTMENT','DEPARTMENT_HEAD',NULL,NULL,DEPARTMENT_HEAD) AS DEPARTMENT_HEAD_,
            	* 
            FROM 
            	DEPARTMENT 
            WHERE 
            	DEPARTMENT_STATUS = 1
                AND IS_STORE <> 1
                <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                    AND BRANCH_ID IN (#arguments.branch_id#)
                </cfif>
                <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
                    AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                </cfif>
            ORDER BY 
            	DEPARTMENT_HEAD        
        </cfquery>
  		<cfreturn get_department>
	</cffunction>
</cfcomponent>
