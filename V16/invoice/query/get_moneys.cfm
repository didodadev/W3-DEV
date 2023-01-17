<cfquery name="GET_FUNC_MONEY" datasource="#DSN#">
	SELECT 
		MONEY
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
</cfquery>
