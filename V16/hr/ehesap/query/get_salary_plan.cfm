<cfquery name="get_salary_plan" datasource="#dsn#">
	SELECT
		ESP.*,
  		EMPLOYEE_NAME,
  		EMPLOYEE_SURNAME 
	FROM
		EMPLOYEES_SALARY_PLAN ESP,
		EMPLOYEES E
	WHERE
		ESP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND ESP.RECORD_EMP = E.EMPLOYEE_ID
		AND ESP.IN_OUT_ID = #attributes.IN_OUT_ID#
</cfquery>
