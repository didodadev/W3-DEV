<cfquery name="get_position_info" datasource="#DSN#">
	SELECT
		POSITION_ID,
		POSITION_CODE,
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE = #attributes.position_code#
</cfquery>

