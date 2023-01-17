<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
