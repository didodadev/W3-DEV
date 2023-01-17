<cfquery name="GET_EMP_AUTHORITY_CODES" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEES_AUTHORITY_CODES
	WHERE
		POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
</cfquery>
