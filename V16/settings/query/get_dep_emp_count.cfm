<cfquery name="GET_DEP_EMP_COUNT" datasource="#dsn#" maxrows="1">
	SELECT 
		COUNT(DEPARTMENT_ID) AS TOTAL 
	FROM 
		EMPLOYEE_POSITIONS 
	WHERE 
		DEPARTMENT_ID=#attributes.ID#
</cfquery>
<cfquery name="GET_DEPARTMENT_KONTROL" datasource="#dsn#" maxrows="1">
	SELECT 
		DEPARTMENT_ID
	FROM 
		EMPLOYEE_POSITIONS_HISTORY
	WHERE 
		DEPARTMENT_ID=#attributes.ID#
</cfquery>
<cfquery name="GET_DEPARTMENT_KONTROL2" datasource="#dsn#" maxrows="1">
	SELECT 
		DEPARTMENT_ID
	FROM 
		STOCKS_LOCATION
	WHERE 
		DEPARTMENT_ID=#attributes.ID#
</cfquery>
<cfquery name="GET_DEPARTMENT_KONTROL3" datasource="#dsn#" maxrows="1">
	SELECT 
		DEPARTMENT_ID
	FROM 
		EMPLOYEES_IN_OUT
	WHERE 
		DEPARTMENT_ID=#attributes.ID#
</cfquery>
