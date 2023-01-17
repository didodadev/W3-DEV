<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
		<cfargument name="is_deny_control" default="0">
		<cfargument name="is_store_module" default="0">
		<cfargument name="branch_id" default="">
		<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
			SELECT 
				DEPARTMENT_HEAD,
				DEPARTMENT_ID,
				BRANCH_ID,
				(SELECT BRANCH_NAME FROM BRANCH WHERE DEPARTMENT_ID = BRANCH_ID)
			FROM 
				DEPARTMENT
			WHERE
				DEPARTMENT_STATUS = 1
				AND BRANCH_ID IN(SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID=#session.ep.company_id#)
				<cfif len(arguments.branch_id)>
					AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
				<cfif arguments.is_deny_control eq 1>
					AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
				<cfif arguments.is_store_module eq 1>
					AND BRANCH_ID IN(SELECT BRANCH_ID FROM DEPARTMENT D WHERE D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(session.ep.user_location,'-')#">)
				</cfif>
			ORDER BY 
				DEPARTMENT_HEAD
		</cfquery>
		<cfreturn GET_DEPARTMENT>
    </cffunction>
	<cffunction name="getComponentFunction1">
		<cfargument name="is_deny_control" default="0">
		<cfquery name="GET_BRANCH" datasource="#dsn#">
			SELECT 
				BRANCH_ID,
				BRANCH_NAME
			FROM 
				BRANCH
			WHERE
				BRANCH_STATUS = 1
				AND COMPANY_ID=#session.ep.company_id#
				<cfif arguments.is_deny_control eq 1>
					AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
			ORDER BY 
				BRANCH_NAME
		</cfquery>
		<cfreturn GET_BRANCH>
	</cffunction>
</cfcomponent>

