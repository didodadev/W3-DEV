<cfquery name="GET_EMPLOYEE_CAUTIONS" datasource="#DSN#">
	SELECT 
		*
 	FROM
		EMPLOYEES_CAUTION
	WHERE 
		CAUTION_TO = #attributes.employee_id#
</cfquery>
