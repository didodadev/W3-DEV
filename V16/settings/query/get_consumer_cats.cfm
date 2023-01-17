<cfquery name="GET_CONSUMER_CATS" datasource="#DSN#">
	SELECT
		CONSCAT_ID,
		#dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session.ep.language#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSCAT) AS CONSCAT
	FROM 
		CONSUMER_CAT 
	ORDER BY
		CONSCAT		
</cfquery>
