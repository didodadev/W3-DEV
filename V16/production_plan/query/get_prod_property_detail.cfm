<cfquery name="get_product_property" datasource="#DSN3#">
	SELECT 
		PRODUCT_OPTIONS.*,
		PRODUCT_PROPERTY.*
	FROM 
		PRODUCT_OPTIONS,
		#dsn1_alias#.PRODUCT_PROPERTY PRODUCT_PROPERTY,
		STOCKS S
	WHERE 
		S.STOCK_ID = #attributes.STOCK_ID# AND
		PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_OPTIONS.PROPERTY_ID AND 
		PRODUCT_OPTIONS.PRODUCT_ID = S.PRODUCT_ID 
	ORDER BY
		PRODUCT_OPTIONS.PROPERTY_ID 
</cfquery>
