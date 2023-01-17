<cfquery name="GET_MONEY_DOVIZ" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1 AND
		MONEY <> '#session.ep.money#'
	ORDER BY 
		MONEY_ID
</cfquery>
