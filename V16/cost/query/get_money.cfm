<cfquery name="get_money" datasource="#DSN#">
	SELECT
		MONEY,
		MONEY_ID
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
