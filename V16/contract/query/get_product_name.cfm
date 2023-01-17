<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
	SELECT 
		PRODUCT_NAME
	FROM 
		PRODUCT
	WHERE
		PRODUCT_ID = #PRODUCT_ID#
</cfquery>
