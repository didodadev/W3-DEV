<cfquery name="MONEY" datasource="#dsn#">
	SELECT
		MONEY,
		RATE1,
		RATE2
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS = 1 AND
	<cfif isDefined("attributes.MONEY_ID")>
		MONEY_ID = #attributes.MONEY_ID#
	<cfelseif isDefined("attributes.MONEY")>
		MONEY = '#attributes.MONEY#'
	</cfif>
</cfquery>
