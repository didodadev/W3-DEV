<cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PRODUCT_CAT
	ORDER BY 
		HIERARCHY
</cfquery>
