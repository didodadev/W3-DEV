<cfquery name="get_product" datasource="#DSN3#">
	SELECT 
		PRODUCT_NAME, TAX, PROD_COMPETITIVE
	FROM 
		PRODUCT 
	WHERE 
		PRODUCT_ID=#attributes.PID#
</cfquery>

