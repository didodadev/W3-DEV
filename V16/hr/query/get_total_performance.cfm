<cfquery name="GET_TOTAL_PERFORMANCE" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_TOTAL_PERFORMANCE
	WHERE
		PERFORMANCE_ID = #attributes.PERFORMANCE_ID#
</cfquery>
