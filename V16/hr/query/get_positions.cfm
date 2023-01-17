<cfquery name="GET_POSITIONS" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CAT_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
		EMPLOYEE_POSITIONS.IS_VEKALETEN,
		EMPLOYEE_POSITIONS.VEKALETEN_DATE,
		EMPLOYEE_POSITIONS.TITLE_ID,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.NICK_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.HIERARCHY_DEP_ID,
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		DEPARTMENT.DEPARTMENT_HEAD,
		ZONE.ZONE_NAME
	FROM
		EMPLOYEE_POSITIONS
		INNER JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		INNER JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		INNER JOIN ZONE BRANCH.ZONE_ID = ZONE.ZONE_ID
	WHERE
		1 = 1
		<cfif Len(attributes.collar_type)>
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
		<cfif isdefined('attributes.comp_id') and len(attributes.comp_id) and attributes.comp_id is not "all">
			AND OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
				EMPLOYEE_POSITIONS.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = '#attributes.keyword#') OR
                EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
				<cfif database_type is "MSSQL">
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME+' '+EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
				<cfelseif database_type is "DB2">
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME||' '||EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
				</cfif>
				)
		</cfif>
		<cfif not session.ep.ehesap>
			AND DEPARTMENT.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
		</cfif>
		<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)>
			AND (
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					 EMPLOYEE_POSITIONS.OZEL_KOD LIKE  '%#code_i#%' OR 
					(SELECT E.HIERARCHY FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE  '%#code_i#%' OR 
					(SELECT E.OZEL_KOD FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE  '%#code_i#%' OR 
					(SELECT E.OZEL_KOD2 FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE  '%#code_i#%'
					<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>OR</cfif>	 
				</cfloop>
				<cfif fusebox.dynamic_hierarchy>
					OR(
						<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
							<cfif database_type is "MSSQL">
								('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
								<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>										
							<cfelseif database_type is "DB2">
								('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
								<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>										
							</cfif>
						</cfloop>
					)			
				</cfif>
				)
		</cfif> 
		<cfif (attributes.branch_id is not '0') and len(trim(attributes.branch_id)) and attributes.branch_id is not "all">
			AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif isDefined("attributes.department") and len(trim(attributes.department)) and attributes.department is not "all">
			AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
		</cfif>
		<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN(#attributes.duty_type#) AND FINISH_DATE IS NULL)
		</cfif>
	ORDER BY
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfquery>
