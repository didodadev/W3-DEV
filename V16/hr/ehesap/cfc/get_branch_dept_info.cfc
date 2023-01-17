<cfcomponent>
 	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_branch_dept_info" access="public" returntype="query">
		<cfargument name="employee_id" type="numeric" default="">
		<cfquery name="get_branch_dept_info" datasource="#this.dsn#">
			SELECT
				EP.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME,
				B.BRANCH_ID,
				SBC.BUSINESS_CODE_ID,
				SBC.BUSINESS_CODE_NAME,
				SBC.BUSINESS_CODE
			FROM
				EMPLOYEE_POSITIONS EP
				LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
				LEFT JOIN SETUP_BUSINESS_CODES SBC ON SPC.BUSINESS_CODE_ID = SBC.BUSINESS_CODE_ID,
				DEPARTMENT D,
				BRANCH B
			WHERE
				EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				EP.POSITION_STATUS = 1 AND
				D.BRANCH_ID = B.BRANCH_ID AND
				<cfif len(arguments.employee_id)>
					EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
				</cfif>
		</cfquery>
	  	<cfreturn get_branch_dept_info>
	</cffunction>
	<cffunction name="get_all_departments" access="public" returntype="query"><!--- Bütün departmanlar --->
		<cfquery name="get_all_departments" datasource="#dsn#">
			SELECT 
				D.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD
			FROM 
				DEPARTMENT D,
				BRANCH B
			WHERE 
				D.BRANCH_ID = B.BRANCH_ID AND
				BRANCH_STATUS = 1 AND
				D.IS_STORE = 2 
				AND	D.DEPARTMENT_STATUS = 1
				AND B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif not session.ep.ehesap>
					AND
					D.BRANCH_ID IN (
										SELECT
											BRANCH_ID
										FROM
											EMPLOYEE_POSITION_BRANCHES
										WHERE
											POSITION_CODE = #SESSION.EP.POSITION_CODE# AND
											DEPARTMENT_ID IS NULL
									)
				</cfif>
				ORDER BY
					D.DEPARTMENT_HEAD
		</cfquery>
	  	<cfreturn get_all_departments>
	</cffunction>
</cfcomponent>
