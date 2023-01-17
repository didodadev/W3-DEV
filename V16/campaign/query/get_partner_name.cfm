<cfquery name="GET_PARTNER_NAME" datasource="#dsn#">
	SELECT
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.COMPANY_ID,
		COMPANY.NICKNAME,
		COMPANY.FULLNAME
	FROM
		COMPANY_PARTNER,
		COMPANY
	WHERE
		COMPANY_PARTNER.PARTNER_ID = #attributes.PARTNER_ID#
		AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
</cfquery>
