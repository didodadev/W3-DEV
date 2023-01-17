<cfquery name="get_in_out_other" datasource="#dsn#">
	SELECT 
		EI.EMPLOYEE_ID,
		EI.IN_OUT_ID,
		EI.POSITION_CODE,
		EI.START_DATE,
		EI.FINISH_DATE,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		OUR_COMPANY.NICK_NAME,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
	FROM
		EMPLOYEES_IN_OUT EI
        LEFT JOIN EMPLOYEES AS E ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID,
		BRANCH,
		DEPARTMENT,
		OUR_COMPANY
	WHERE
		EI.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	ORDER BY EI.START_DATE DESC
</cfquery>
