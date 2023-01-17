<cfquery   name="get_lang" datasource="#DSN#">
	SELECT 
			* 
	FROM 
		SETUP_LANGUAGE 
	WHERE 
		( LANGUAGE_SHORT NOT LIKE 'TR%' 
	AND 
		LANGUAGE_SHORT	NOT LIKE 'tr%') 
	AND 
		(LANGUAGE_SHORT NOT LIKE 'ENG%' 
	AND 
		LANGUAGE_SHORT NOT LIKE 'eng%')
</cfquery>

