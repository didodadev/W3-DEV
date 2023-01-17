<cfquery name="GET_RELATIVE" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEES_RELATIVES
	WHERE
		RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.RELATIVE_ID#">
</cfquery>
