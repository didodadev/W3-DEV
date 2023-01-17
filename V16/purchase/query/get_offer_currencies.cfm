<cfquery name="GET_OFFER_CURRENCIES" datasource="#dsn3#">
	SELECT 
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE OFFER_CURRENCY
		END AS OFFER_CURRENCY,
		OFFER_CURRENCY_ID
	FROM 
		OFFER_CURRENCY
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = OFFER_CURRENCY.OFFER_CURRENCY_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OFFER_CURRENCY">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OFFER_CURRENCY">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY 
		OFFER_CURRENCY 
</cfquery>
