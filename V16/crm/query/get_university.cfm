<cfquery name="get_university" datasource="#DSN#">
	SELECT 
		UNIVERSITY_ID,
		UNIVERSITY_NAME 
	FROM 
		SETUP_UNIVERSITY 
	ORDER BY
		UNIVERSITY_ID
</cfquery>
