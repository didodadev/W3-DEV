<cfquery name="GET_PRODUCT_FIS" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		PRODUCT
	WHERE 
		STOCK_ID IN (#attributes.STOCK_IDS#)
</cfquery>
