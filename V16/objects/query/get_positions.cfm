<cfif not isdefined("attributes.show_empty_pos")>
	<cfquery name="GET_POSITIONS" datasource="#DSN#">
		SELECT
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.OZEL_KOD,
            EMPLOYEE_POSITIONS.TITLE_ID,
            SETUP_TITLE.TITLE,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			BRANCH.COMPANY_ID,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			ZONE.ZONE_NAME,
			USER_GROUP.USER_GROUP_NAME
		FROM
			EMPLOYEE_POSITIONS
			LEFT JOIN USER_GROUP ON USER_GROUP.USER_GROUP_ID = EMPLOYEE_POSITIONS.USER_GROUP_ID
			LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID,
			DEPARTMENT,
			BRANCH,
			ZONE,
			EMPLOYEES,
            SETUP_TITLE
		WHERE
			EMPLOYEE_POSITIONS.POSITION_STATUS=<cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			EMPLOYEE_POSITIONS.EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="0"> AND
			EMPLOYEES.EMPLOYEE_STATUS=<cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
			<cfif isDefined("attributes.department") and len(attributes.department)>
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> AND
			</cfif>
            <cfif isDefined("attributes.title_id") and len(attributes.title_id)>
				EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#"> AND
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			</cfif>
			<cfif isDefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> AND
			</cfif>
				EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
                EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
				DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
				BRANCH.ZONE_ID=ZONE.ZONE_ID
			<cfif isdefined("attributes.is_branch_control") and not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>		
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif len(attributes.keyword) eq 1>
					AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				<cfelse>
					AND
						(
						EMPLOYEE_POSITIONS.POSITION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EMPLOYEE_POSITIONS.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						)
				</cfif>
			</cfif>
			<cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
				AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
			</cfif>
		ORDER BY
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME
	</cfquery>
<cfelse>
	<cfquery name="GET_POSITIONS" datasource="#DSN#">
		SELECT
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.OZEL_KOD,
            EMPLOYEE_POSITIONS.TITLE_ID,
            SETUP_TITLE.TITLE,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			BRANCH.COMPANY_ID,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			ZONE.ZONE_NAME
		FROM
			EMPLOYEE_POSITIONS
			LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID,
			DEPARTMENT,
			BRANCH,		
			ZONE,
            SETUP_TITLE
		WHERE
			<cfif isDefined("attributes.department") and len(attributes.department)>
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> AND
			</cfif>
              <cfif isDefined("attributes.title_id") and len(attributes.title_id)>
				EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#"> AND
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			</cfif>
				EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
				DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
                EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
				BRANCH.ZONE_ID=ZONE.ZONE_ID
			<cfif isdefined("attributes.is_branch_control") and not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>			
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif len(attributes.keyword) eq 1>
					AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				<cfelse>
					AND
						(
						EMPLOYEE_POSITIONS.POSITION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EMPLOYEE_POSITIONS.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						)
				</cfif>
			</cfif>
			<cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
				AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
			</cfif>
		ORDER BY 
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME
	</cfquery>
</cfif>
