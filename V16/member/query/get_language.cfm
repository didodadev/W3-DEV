<cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT 
		LANGUAGE_SHORT,
		LANGUAGE_SET
	FROM 
		SETUP_LANGUAGE
</cfquery>
