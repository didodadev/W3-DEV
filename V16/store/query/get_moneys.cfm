<cfquery name="GET_MONEYS" datasource="#DSN#">
	SELECT
		MONEY_ID,
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
	<cfif isdefined('attributes.prm_money') and attributes.prm_money eq 1 >
		AND MONEY_STATUS=1
		<cfif isdefined("attributes.cash_rev") and (attributes.cash_rev eq 1)>
		AND MONEY = '#CURRENCY#'
		</cfif>
	</cfif>
</cfquery>
