<cfquery name="GET_EMPLOYEES1" datasource="#DSN#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.DIRECT_TELCODE,
		EMPLOYEES.DIRECT_TEL,
		EMPLOYEES.EXTENSION
	FROM 
	<cfif attributes.show_all is "1" or isdefined("attributes.is_store_module")>
		EMPLOYEE_POSITIONS,
	</cfif>
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_STATUS = 1 
 	<cfif isDefined("attributes.EMPLOYEE_IDS") and len(attributes.EMPLOYEE_IDS)>
		AND EMPLOYEES.EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
	</cfif>
		AND
		<cfif database_type is "MSSQL">
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
			<cfelseif database_type is "DB2">
			EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
		</cfif>
		<cfif isdefined("attributes.is_store_module")>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (
			SELECT
				EMPLOYEE_POSITIONS.EMPLOYEE_ID
			FROM 
				BRANCH,
				EMPLOYEE_POSITIONS,
				DEPARTMENT
			WHERE
				BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID )
		</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
