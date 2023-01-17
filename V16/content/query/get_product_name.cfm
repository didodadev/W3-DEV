<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
	SELECT 
		PRODUCT_NAME,
		PRODUCT_ID
	FROM
		PRODUCT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>
