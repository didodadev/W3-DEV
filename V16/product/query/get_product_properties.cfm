<cfquery name="GET_PRODUCT_PROPERTIES" datasource="#DSN1#">
	SELECT 
		* 
	FROM 
		PRODUCT_PROPERTY 
	WHERE 
		PRODUCT_ID=#attributes.PID#
</cfquery>
