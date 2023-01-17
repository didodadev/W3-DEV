<cfquery name="GET_PRODUCT_COMP" datasource="#DSN3#">
	SELECT 
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE COMPETITIVE
		END AS COMPETITIVE,
		COMPETITIVE_ID 
	FROM 
		PRODUCT_COMP
		LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_COMP.COMPETITIVE_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMPETITIVE">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_COMP">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY COMPETITIVE
</cfquery>
