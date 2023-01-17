<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
	SELECT 
		* 
	FROM 
		PRODUCT_PROPERTY 
	WHERE 
		PROPERTY_ID = #attributes.property_id#
</cfquery>
