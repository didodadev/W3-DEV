<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
	SELECT 
	   CONTENT_PROPERTY_ID,
	   NAME
	FROM 
	   CONTENT_PROPERTY CP 
	ORDER BY 
		NAME
</cfquery>