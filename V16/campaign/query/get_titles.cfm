<cfquery name="GET_TITLES" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_TITLE
	WHERE
		TITLE_ID IS NOT NULL
</cfquery>
