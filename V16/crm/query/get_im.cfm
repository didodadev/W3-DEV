<cfquery name="GET_IM" datasource="#dsn#">
	SELECT 
		IMCAT_ID, 
		IMCAT 
	FROM 
		SETUP_IM
	ORDER BY
		IMCAT
</cfquery>
