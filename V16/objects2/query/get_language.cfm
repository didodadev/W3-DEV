<!--- get_language.cfm --->
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT 
		LANGUAGE_ID,
		LANGUAGE_SET,
        LANGUAGE_SHORT
	FROM 
		SETUP_LANGUAGE
</cfquery>
