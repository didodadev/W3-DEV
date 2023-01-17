<cfquery name="GET_TITLE" datasource="#DSN#">
	SELECT 
		TITLE
	FROM 
		SETUP_TITLE	
	WHERE 
		TITLE_ID = #attributes.title_id#
</cfquery>
