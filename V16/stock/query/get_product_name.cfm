<cfquery name="get_product_name" datasource="#dsn3#">
	SELECT
		PRODUCT_NAME,
		PROPERTY
	FROM
		STOCKS
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	<cfif isDefined('attributes.stock_id') and len(attributes.stock_id)>
		AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfif>
</cfquery>
