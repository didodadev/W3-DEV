<cfquery name="GET_POS" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE=#POSITION_CODE#
	AND
		POSITION_STATUS=1
</cfquery>