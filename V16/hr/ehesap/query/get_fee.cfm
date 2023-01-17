<cfquery name="GET_FEE" datasource="#dsn#">
	SELECT
		ES.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE ES,
		EMPLOYEES E
	WHERE 
		E.EMPLOYEE_ID = ES.EMPLOYEE_ID AND 
		ES.FEE_ID = #attributes.FEE_ID#
</cfquery>
