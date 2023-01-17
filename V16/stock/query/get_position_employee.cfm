<cfquery name="GET_POSITION_EMPLOYEE" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE 
		POSITION_CODE = #attributes.position_code#
</cfquery>
