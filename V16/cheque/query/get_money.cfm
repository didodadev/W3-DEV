<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS = 1 AND
		MONEY <> '#session.ep.money#'
		<cfif isDefined('attributes.money') and len(attributes.money)>
		AND MONEY_ID = #attributes.money#
		</cfif>
	ORDER BY 
		MONEY_ID
</cfquery>
