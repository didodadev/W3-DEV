<cfquery name="COMPANY_PARTNER_NAME" datasource="#dsn#">
	SELECT
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER
	WHERE
		PARTNER_ID = #attributes.PARTNER_ID#
</cfquery>
