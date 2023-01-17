<cfquery name="GET_CONTENT_PROPERTY" datasource="#dsn#">
	SELECT 
	   CONTENT_PROPERTY_ID,
	   NAME
	FROM 
	   CONTENT_PROPERTY CP  
</cfquery>
