<cfquery name="get_authority_definitions" datasource="#dsn#">
<cfif isdefined('attributes.user_group_id') and len(attributes.user_group_id)>
	WITH CTE1 AS (
</cfif>
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.IS_VEKALETEN,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.NICK_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		SETUP_POSITION_CAT.POSITION_CAT,
		SETUP_TITLE.TITLE,
        STUFF(( SELECT ', ' + UG.USER_GROUP_NAME FROM USER_GROUP_EMPLOYEE AS UGE LEFT JOIN USER_GROUP AS UG ON UG.USER_GROUP_ID = UGE.USER_GROUP_ID WHERE UGE.POSITION_ID = EMPLOYEE_POSITIONS.POSITION_ID <cfif isdefined('attributes.user_group_id') and len(attributes.user_group_id)>AND UGE.USER_GROUP_ID IN (#attributes.user_group_id#)</cfif> FOR XML PATH(''),TYPE).value('.','NVARCHAR(MAX)'),1,2,'') AS USER_GROUP_NAME
	FROM
		EMPLOYEE_POSITIONS
		INNER JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		INNER JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		LEFT JOIN SETUP_POSITION_CAT ON EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
		LEFT JOIN SETUP_TITLE ON SETUP_TITLE.TITLE_ID = EMPLOYEE_POSITIONS.TITLE_ID
	WHERE
		1=1
		<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			AND EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			AND EMPLOYEE_POSITIONS.POSITION_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
		<cfif isdefined("attributes.empty_position") and (attributes.empty_position eq 0)>
			AND (EMPLOYEE_POSITIONS.EMPLOYEE_ID = 0 OR EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NULL)
		<cfelseif isdefined("attributes.empty_position") and (attributes.empty_position eq 1)>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NOT NULL
		</cfif> 
		<cfif isdefined("attributes.status") and (attributes.status eq 0)>
			AND EMPLOYEE_POSITIONS.POSITION_STATUS = 0		  
		<cfelseif isdefined("attributes.status") and (attributes.status eq 1)>
			AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
		</cfif>
		<cfif isdefined("attributes.unit_id") and len(attributes.unit_id)>
			AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
		</cfif>
		<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
			AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
		</cfif>
		<cfif isdefined("attributes.organization_step_id") and len(attributes.organization_step_id)>
			AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#">
		</cfif>
		<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
			AND OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				EMPLOYEE_POSITIONS.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">) OR
                EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME+' '+EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
				)
		</cfif>
		<cfif not session.ep.ehesap>
			AND DEPARTMENT.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
		</cfif>
		<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)>
			AND (
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					EMPLOYEE_POSITIONS.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR 
					(SELECT E.HIERARCHY FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR 
					(SELECT E.OZEL_KOD FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR 
					(SELECT E.OZEL_KOD2 FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
					<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>OR</cfif>	 
				</cfloop>
				<cfif fusebox.dynamic_hierarchy>
					OR(
						<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                            ('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
                            <cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>										
						</cfloop>
					)			
				</cfif>
				)
		</cfif> 
		<cfif isdefined("attributes.branch_id") and len(trim(attributes.branch_id))>
			AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif isDefined("attributes.department") and len(trim(attributes.department))>
			AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
		</cfif>
<cfif isdefined('attributes.user_group_id') and len(attributes.user_group_id)>
    )
    SELECT * FROM CTE1 WHERE USER_GROUP_NAME IS NOT NULL
	ORDER BY
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
<CFELSE>
	ORDER BY
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfif>
</cfquery>