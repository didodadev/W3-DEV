<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1 AND
		MONEY<>'#session.ep.money#'
</cfquery>
