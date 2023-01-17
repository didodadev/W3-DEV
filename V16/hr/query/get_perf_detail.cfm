<cfquery name="GET_PERF_DETAIL" datasource="#dsn#">
	SELECT 
		EMPLOYEE_PERFORMANCE.*,
		EMPLOYEE_QUIZ_RESULTS.QUIZ_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_PERFORMANCE,
		EMPLOYEE_QUIZ_RESULTS,
		EMPLOYEES
	WHERE
		EMPLOYEE_PERFORMANCE.PER_ID = #attributes.PER_ID# AND
		EMPLOYEE_PERFORMANCE.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
		EMPLOYEE_PERFORMANCE.EMP_ID = EMPLOYEES.EMPLOYEE_ID 
</cfquery>
<cfif len(GET_PERF_DETAIL.MANAGER_1_EMP_ID)>
	<cfquery name="GET_EMP_MANG_1" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID,POSITION_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = #GET_PERF_DETAIL.MANAGER_1_EMP_ID# 
	</cfquery>
</cfif>
<cfif len(GET_PERF_DETAIL.MANAGER_2_EMP_ID)>
	<cfquery name="GET_EMP_MANG_2" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID, POSITION_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = #GET_PERF_DETAIL.MANAGER_2_EMP_ID# 
	</cfquery>
</cfif>
<cfif len(GET_PERF_DETAIL.MANAGER_3_EMP_ID)>
	<cfquery name="GET_EMP_MANG_3" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID, POSITION_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = #GET_PERF_DETAIL.MANAGER_3_EMP_ID# 
	</cfquery>
</cfif>