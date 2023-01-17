<cfquery name="GET_CONTENT_HEAD" datasource="#dsn#">
	SELECT 
		CONT_HEAD 
	FROM 
		CONTENT 
	WHERE 
		CONTENT_ID = #attributes.CONTENT_ID#
</cfquery>