<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		MONEY_ID
	FROM
		SETUP_MONEY
	WHERE
		MONEY_STATUS = 1	
		AND PERIOD_ID = #SESSION.EP.PERIOD_ID#
	ORDER BY MONEY_ID
</cfquery>
