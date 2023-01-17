<cfcomponent>
	<cffunction name="get_branch" access="public" returntype="query">
		<cfargument name="branch_status" default="">
		<cfargument name="ehesap_control" default="0">
		<cfargument name="comp_id" default="">
		<cfargument name="position_code" default="#session.ep.position_code#">
		<cfargument name="branch_id" default="">
        <cfquery name="get_branches" datasource="#this.dsn#">
			SELECT
				BRANCH.BRANCH_STATUS,
				BRANCH.HIERARCHY,
				BRANCH.HIERARCHY2,
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				OUR_COMPANY.COMP_ID,
				OUR_COMPANY.COMPANY_NAME,
				OUR_COMPANY.NICK_NAME
			FROM
				BRANCH
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			WHERE
				BRANCH.BRANCH_ID IS NOT NULL
				AND BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.branch_status#">
				<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">)
				</cfif>
				<cfif len(arguments.comp_id)>
					AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
				</cfif>	
				<cfif len(arguments.branch_id)>
					AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
			ORDER BY
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME    
        </cfquery>
  		<cfreturn get_branches>
	</cffunction>
</cfcomponent>
