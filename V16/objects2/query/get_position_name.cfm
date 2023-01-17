<cfquery name="GET_POSITION_NAME" datasource="#dsn#">
	SELECT
		POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
</cfquery>
