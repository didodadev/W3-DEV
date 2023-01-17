<cfquery name="GET_ACC_MONEY" datasource="#dsn#">
	SELECT
		ISNULL(SUM(C.CASH_ACTION_VALUE * (SM.RATE2/SM.RATE1)),0) AS AMOUNT_MONEY
	FROM
		#dsn2_alias#.CASH_ACTIONS C,
		#dsn2_alias#.SETUP_MONEY SM
	WHERE
		((SM.MONEY = C.CASH_ACTION_CURRENCY_ID)
		<cfif session.ep.period_year lt 2009>
			OR (SM.MONEY = 'YTL' AND C.CASH_ACTION_CURRENCY_ID = 'TL')
		</cfif>)
		AND
			(
				C.ACTION_DATE < #DATEADD("D",1,now())# AND
				C.ACTION_DATE > #DATEADD("D",-1,now())#
			)
		AND
			(
				ACTION_TYPE_ID=#attributes.BA# OR
				ACTION_TYPE_ID=#attributes.BA1#
			)
</cfquery>

