<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT
</cfquery>
