<cfquery name="GET_PARTNERS" datasource="#dsn#">
	SELECT
		*
	FROM	
		COMPANY_PARTNER,COMPANY
	WHERE
		COMPANY_PARTNER.COMPANY_ID=COMPANY.COMPANY_ID
	ORDER BY
		COMPANY_PARTNER_NAME
</cfquery>
