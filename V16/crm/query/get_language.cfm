<!--- get_language.cfm --->
<cfquery name="GET_LANGUAGE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_LANGUAGE
</cfquery>
