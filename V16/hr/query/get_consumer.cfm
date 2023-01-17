<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT 
			CONSUMER_ID,
			CONSUMER_NAME,
			CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE 
		CONSUMER_ID IN (#LISTSORT(attributes.CONS_IDS,"NUMERIC")#)
</cfquery>
