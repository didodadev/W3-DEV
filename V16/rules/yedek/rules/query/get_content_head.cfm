<cfquery name="GET_CONTENT_HEAD" datasource="#dsn#">
	SELECT 
		CONT_HEAD 
	FROM 
		CONTENT 
	WHERE 
		CONTENT_ID = <cfqueryparam value ="#attributes.CONTENT_ID#">
</cfquery>
