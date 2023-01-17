<cfcomponent>
<cffunction name="get_emp" access="public" returntype="query">
    <cfargument name="ID">
    <cfargument name="keyword">
    <cfargument name="position_status">
    <cfquery name="get_emp" datasource="#this.dsn#">
        SELECT 
        	EP.EMPLOYEE_NAME, 
            EP.EMPLOYEE_SURNAME, 
            EP.EMPLOYEE_ID, 
            EP.POSITION_ID,
            EP.POSITION_NAME,
            EP.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            D.DEPARTMENT_ID,
            B.BRANCH_NAME,
            B.BRANCH_ID,
            OC.NICK_NAME
        FROM 
            EMPLOYEE_POSITIONS AS EP INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
            INNER JOIN BRANCH AS B ON B.BRANCH_ID = D.BRANCH_ID
            INNER JOIN OUR_COMPANY AS OC ON OC.COMP_ID = B.COMPANY_ID
        WHERE
        	<cfif isdefined('arguments.id') and len(arguments.id)>
				USER_GROUP_ID= #arguments.ID# 
			</cfif>    
        	<cfif isdefined('arguments.position_status') and len(arguments.position_status)>
				AND POSITION_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_status#">
            </cfif>
			<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                 AND(
                 EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                 OR
                 EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                 )
		 	</cfif>
        ORDER BY 
        	EP.EMPLOYEE_NAME, 
            EP.EMPLOYEE_SURNAME
    </cfquery>
<cfreturn get_emp>
</cffunction>
</cfcomponent>
