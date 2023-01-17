<cfquery name="GET_POS" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#">
	AND
		POSITION_STATUS=1
</cfquery>
