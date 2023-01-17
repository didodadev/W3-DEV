<cfquery name="GET_ACTION_RATE" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY = '#CURRENCY#'
</cfquery>
