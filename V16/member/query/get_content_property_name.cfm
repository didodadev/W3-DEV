<cfquery name="GET_PROPERTY_NAME" datasource="#DSN#">
	SELECT 
		NAME 
	FROM 
		CONTENT_PROPERTY 
	WHERE	
		CONTENT_PROPERTY_ID = #content_property_id#
</cfquery>

