<cfquery name="GET_MOBILCAT" datasource="#DSN#">
	SELECT 
		MOBILCAT_ID, 
		MOBILCAT 
	FROM 
		SETUP_MOBILCAT
	ORDER BY
		MOBILCAT
</cfquery>
