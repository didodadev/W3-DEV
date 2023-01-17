<cfquery name="GET_PARTNER_CATS" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID,
		COMPANYCAT 
	FROM 
		COMPANY_CAT
</cfquery>
