<cfquery name="TITLES" datasource="#dsn#">
	SELECT 
		TITLE_ID,
		#dsn#.Get_Dynamic_Language(TITLE_ID,'#session.ep.language#','SETUP_TITLE','TITLE',NULL,NULL,TITLE) AS TITLE
	FROM 
		SETUP_TITLE 
	WHERE 
		IS_ACTIVE = 1 
	ORDER BY 
		TITLE
</cfquery>
