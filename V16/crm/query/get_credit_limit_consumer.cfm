<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_CREDIT
	WHERE 	
		CONSUMER_ID = #URL.CID#
</cfquery>

