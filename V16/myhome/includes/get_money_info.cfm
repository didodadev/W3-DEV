<cfquery name="GET_MONEY_INFO" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT
		DSP_RATE_PUR,
		DSP_RATE_SALE,
		DSP_UPDATE_DATE,
		EFFECTIVE_SALE,
		EFFECTIVE_PUR,
		CURRENCY_CODE,
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"> AND
		DSP_RATE_PUR IS NOT NULL AND
		DSP_RATE_SALE IS NOT NULL
	ORDER BY
		MONEY_ID
</cfquery>
