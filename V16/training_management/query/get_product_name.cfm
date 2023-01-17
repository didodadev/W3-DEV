<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
	SELECT 
		PRODUCT_NAME,
		PRODUCT_ID
	FROM
		PRODUCT
	WHERE
		PRODUCT_ID = #attributes.PRODUCT_ID#
</cfquery>
