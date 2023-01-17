<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_CREDIT
	WHERE 
		COMPANY_ID = #URL.CPID#
</cfquery>

