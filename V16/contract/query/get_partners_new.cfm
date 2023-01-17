<cfquery name="GET_PARTNERS" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID
	FROM 
		COMPANY,
		COMPANY_PARTNER
	WHERE
		COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
	<cfif isDefined("attributes.companycat_id")>
		AND COMPANY.COMPANYCAT_ID = #attributes.companycat_id#
	</cfif>
	<cfif isDefined("attributes.company_id")>
		AND COMPANY_PARTNER.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%'
	</cfif>
	ORDER BY
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
</cfquery>
