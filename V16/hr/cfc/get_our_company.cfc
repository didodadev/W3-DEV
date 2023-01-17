<cfcomponent>
	<cffunction name="get_company" access="public" returntype="query">
		<cfargument name="is_control" default="0">
		<cfquery name="get_our_comp" datasource="#this.dsn#">
            SELECT 
            	COMP_ID,
                COMPANY_NAME,
                NICK_NAME
            FROM
            	OUR_COMPANY 
			WHERE
				1 = 1
				<cfif isDefined("arguments.is_control") and arguments.is_control eq 1 and not session.ep.ehesap>
					AND COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				<cfelseif isDefined("arguments.is_control") and arguments.is_control eq 2>
					AND COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
            ORDER BY
            	COMPANY_NAME
        </cfquery>
  		<cfreturn get_our_comp>
	</cffunction>
</cfcomponent>