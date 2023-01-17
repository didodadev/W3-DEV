<cfquery name="CAMP_TMARKETS" datasource="#dsn3#">
	SELECT
		CAMPAIGN_TARGET_MARKETS.TMARKET_ID,
		TARGET_MARKETS.TMARKET_NAME,
		TARGET_MARKETS.TARGET_MARKET_TYPE
	FROM
		CAMPAIGN_TARGET_MARKETS, TARGET_MARKETS
	WHERE
		CAMPAIGN_TARGET_MARKETS.TMARKET_ID = TARGET_MARKETS.TMARKET_ID AND
		CAMPAIGN_TARGET_MARKETS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CAMP_ID#">
</cfquery>	
