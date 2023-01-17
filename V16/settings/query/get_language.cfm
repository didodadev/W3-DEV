<cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_LANGUAGE
	WHERE
		IS_ACTIVE = 1
</cfquery>
