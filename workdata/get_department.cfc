<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
		<cfargument name="is_store_module" default="0">
		<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
			SELECT 
				DEPARTMENT_HEAD,
				DEPARTMENT_ID,
				BRANCH_ID,
				(SELECT #dsn#.Get_Dynamic_Language(BRANCH_ID,'#session.ep.language#','BRANCH','BRANCH_NAME',NULL,NULL,BRANCH_NAME) AS BRANCH_NAME FROM BRANCH WHERE DEPARTMENT_ID = BRANCH_ID)
			FROM 
				DEPARTMENT
			WHERE
				DEPARTMENT_STATUS = 1
				AND BRANCH_ID IN(SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID=#session.ep.company_id#)
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
	<cffunction name = "getDepartmentLocation">
	<cfquery name="STORES" datasource="#DSN#">
        SELECT
        	D.DEPARTMENT_ID,
			B.BRANCH_ID,
			B.COMPANY_ID,
			B.BRANCH_NAME,			
			D.DEPARTMENT_HEAD,
			SL.COMMENT,
			SL.ID,			
			SL.LOCATION_ID,
			D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS LOCATION_NAME			
        FROM 
            DEPARTMENT D,
            BRANCH B,
            STOCKS_LOCATION SL
        WHERE 
			<cfif isDefined('session.ep')>
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfelseif isDefined('session.pp')>
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND                
			</cfif>
			D.IS_STORE <>2 AND
			B.BRANCH_ID = D.BRANCH_ID
			AND D.DEPARTMENT_STATUS = 1
            AND SL.STATUS = 1 
			AND SL.DEPARTMENT_ID=D.DEPARTMENT_ID 
			AND
				(
				CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				OR
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
				)
			<cfif session.ep.isBranchAuthorization>
				B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			</cfif>
		ORDER BY
			LOCATION_NAME
    </cfquery>
	<cfreturn STORES>
	</cffunction>
</cfcomponent>

