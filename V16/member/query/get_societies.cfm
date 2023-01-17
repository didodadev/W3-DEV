<cfquery name="GET_SOCIETIES" datasource="#DSN#">
	SELECT
		SOCIETY_ID,
		#dsn#.Get_Dynamic_Language(SOCIETY_ID,'#session.ep.language#','SETUP_SOCIAL_SOCIETY','SOCIETY',NULL,NULL,SOCIETY) AS SOCIETY
	FROM 
		SETUP_SOCIAL_SOCIETY
	ORDER BY
		SOCIETY
</cfquery>
