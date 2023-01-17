<cfquery name="GET_EMPLOYEE_PRIZES" datasource="#DSN#">
	SELECT 
		*
 	FROM
		EMPLOYEES_PRIZE
	WHERE 
		PRIZE_TO = #attributes.employee_id#
</cfquery>
