<cfquery name="GET_TITLE" datasource="#dsn#">
	SELECT 
		TITLE
	FROM 
		SETUP_TITLE	
	WHERE 
		TITLE_ID = #attributes.TITLE_ID#
</cfquery>
