<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY_ID,
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = 1
</cfquery>
