<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_branch" access="public" returntype="query">
		<cfargument name="comp_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="status" default="">
		<cfargument name="ehesap_control" default="0">
		<cfset dsn = application.systemParam.systemParam().dsn>
        <cfquery name="get_branches" datasource="#dsn#">
			SELECT 
            	BRANCH_ID,
                BRANCH_NAME,
                COMPANY_ID
			FROM 
            	BRANCH 
			WHERE 
				<cfif arguments.status eq 1>
					BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
				<cfelse>
					BRANCH_STATUS IS NOT NULL
				</cfif>
				<cfif isdefined('arguments.comp_id') and len(arguments.comp_id)>
                    AND COMPANY_ID IN (#arguments.comp_id#) 
                </cfif>
                <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                    AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>
                <cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
             ORDER BY 
             	BRANCH_NAME        
        </cfquery>
  		<cfreturn get_branches>
	</cffunction>
	<!--- Çalışan id'sine bağlı olarak çalışanın bulunduğu şirket id'lerini çeker ---->
	<cffunction name="get_branches_company" access="public" returntype="query">
		<cfargument name="employee_id" default="" required="yes">
		<cfquery name="get_branches_company" datasource="#dsn#">
			SELECT 
				B.COMPANY_ID
			FROM 
				EMPLOYEES_IN_OUT EIO
				LEFT JOIN BRANCH B ON B.BRANCH_ID = EIO.BRANCH_ID
			WHERE
				EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
		</cfquery>
		<cfreturn get_branches_company>
	</cffunction>
</cfcomponent>
