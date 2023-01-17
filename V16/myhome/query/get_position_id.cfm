<cfquery name="get_pos_id" datasource="#DSN#">
	SELECT
		POSITION_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID=#SESSION.EP.USERID#
</cfquery>

