<cfquery name="RECORD_EMPLOYEE" datasource="#DSN#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
