<cfquery name="GET_POSITIONS" datasource="#DSN#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_STATUS = 1 AND
		POSITION_CODE IN (#attributes.position_codes#)
</cfquery>
