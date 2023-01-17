<cfquery name="GET_ACTION_RATE" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# 
		<cfif  isdefined("other_money_currency") and len(other_money_currency)>
		AND MONEY='#other_money_currency#'
		<cfelseif isdefined("CURRENCY")>
		AND MONEY='#CURRENCY#'
		</cfif>
</cfquery>
