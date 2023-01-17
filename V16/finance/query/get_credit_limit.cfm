<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_CREDIT
	WHERE 
		COMPANY_CREDIT_ID = #ATTRIBUTES.COMPANY_CREDIT_ID#
</cfquery>

