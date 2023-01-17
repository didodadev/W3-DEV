<cfquery name="GET_STOCK_PROPERTIES" datasource="#DSN3#">
	SELECT
		STOCK_ID
	FROM
		STOCKS_PROPERTY
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
