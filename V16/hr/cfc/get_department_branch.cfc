<cfcomponent>
	<cffunction name="get_department_branch" access="public" returntype="query">
		<cfargument name="branch_status" default="1">
		<cfargument name="ehesap_control" default="1">
		<cfargument name="department_status" default="1">
        <cfquery name="get_dep_branch" datasource="#this.dsn#">
			SELECT
				B.BRANCH_NAME,
				B.BRANCH_ID,
				D.DEPARTMENT_HEAD,
				D.DEPARTMENT_ID
			FROM
				BRANCH B
				INNER JOIN DEPARTMENT D ON D.BRANCH_ID = B.BRANCH_ID
			WHERE
				D.IS_STORE <> 1
				<cfif len(arguments.branch_status)>
					AND B.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.branch_status#">
				</cfif>
				<cfif len(arguments.department_status)>
					AND D.DEPARTMENT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.department_status#">
				</cfif>
				<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
					AND B.BRANCH_ID IN 
					(
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					)
				</cfif>
			ORDER BY
				B.BRANCH_NAME   
        </cfquery>
  		<cfreturn get_dep_branch>
	</cffunction>
</cfcomponent>
