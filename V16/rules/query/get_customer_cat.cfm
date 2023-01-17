<cfquery name="GET_CUSTOMER_CAT" datasource="#DSN#">	
	SELECT 
		CONSCAT_ID, 
		CONSCAT 
	FROM 
		CONSUMER_CAT
</cfquery>