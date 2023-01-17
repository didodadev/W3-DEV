<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
	SELECT 
		PRODUCT_NAME, 
		PROD_COMPETITIVE
	FROM 
		PRODUCT 
	WHERE 
		PRODUCT_ID = #attributes.pid#
</cfquery>

