<cfquery name="GET_PARTNERS" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE
		COMPANY_PARTNER_STATUS = 1
	<cfif isDefined("attributes.COMPANYCAT_ID")>
		AND
		COMPANYCAT_ID = #attributes.COMPANYCAT_ID#
	<cfelseif isDefined("attributes.PARTNER_IDS")>
		AND
		PARTNER_ID IN (#attributes.PARTNER_IDS#)
	</cfif>
</cfquery>
