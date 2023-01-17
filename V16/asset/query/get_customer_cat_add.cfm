<cfquery name="GET_CUSTOMER_CAT" datasource="#DSN#">
	SELECT 
		CONSCAT_ID, 
		#dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session.ep.language#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSUMER_CAT.CONSCAT) AS CONSCAT
		
	FROM 
		CONSUMER_CAT
	WHERE
		IS_ACTIVE = 1
</cfquery>
