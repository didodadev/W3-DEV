<cfquery name="GET_PRODUCT_PROPERTY" datasource="#DSN1#">
	SELECT 
		* 
	FROM 
		PRODUCT_PROPERTY 
	ORDER BY 
		PROPERTY 
</cfquery>
