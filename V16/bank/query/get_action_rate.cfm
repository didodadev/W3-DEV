<cfquery name="GET_ACTION_RATE" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY = '#CURRENCY#' AND
		MONEY_STATUS=1
</cfquery>
