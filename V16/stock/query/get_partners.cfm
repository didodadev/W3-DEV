<cfquery name="PARTNERS" datasource="#dsn#">
	SELECT
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		PARTNER_ID
	FROM
		COMPANY_PARTNER
	WHERE
		COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1
		<cfif isDefined("attributes.COMPANY_ID")>
	AND
		COMPANY_PARTNER.COMPANY_ID = #attributes.COMPANY_ID#
		</cfif>
</cfquery>
