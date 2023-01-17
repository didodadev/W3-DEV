<cfquery name="GET_RATE" datasource="#dsn#">
	SELECT
		RATE1,
		RATE2
	FROM
		SETUP_MONEY
	WHERE
		MONEY='#attributes.str_acc_money#' AND 
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
