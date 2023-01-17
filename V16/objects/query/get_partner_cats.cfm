<cfquery name="GET_PARTNER_CATS" datasource="#dsn#">
	SELECT 
		COMPANYCAT,
		COMPANYCAT_ID
	FROM 
		COMPANY_CAT
</cfquery>
