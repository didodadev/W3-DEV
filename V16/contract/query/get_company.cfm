<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_ID
	FROM 
		COMPANY
	WHERE COMPANY_ID="COMP_ID"
</cfquery>
