<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT 
		* 
	FROM 
		PRODUCT_PROPERTY_DETAIL 
	WHERE 
		PRPT_ID=#attributes.PRPT_ID#
	ORDER BY
		PROPERTY_DETAIL
</cfquery>
