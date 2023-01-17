<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_ID, 
		FULLNAME 
	FROM 
		COMPANY
</cfquery>
