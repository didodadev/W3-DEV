<cfquery name="GET_MONEY_DOVIZ" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	ORDER BY 
		MONEY_ID
</cfquery>
