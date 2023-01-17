<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT 
		* 
	FROM 
		PRODUCT_PROPERTY_DETAIL 
	WHERE 
		PROPERTY_DETAIL_ID=#attributes.property_detail_id#
</cfquery>
