<cfquery name="GET_ACTION_RATE" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		MONEY='#CURRENCY#'
	AND
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
