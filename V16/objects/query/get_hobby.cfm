<cfquery name="GET_HOBBY" datasource="#dsn#">
	SELECT 
		HOBBY_ID, 
		HOBBY_NAME 
	FROM 
		SETUP_HOBBY 
	ORDER BY
		HOBBY_NAME
</cfquery>
