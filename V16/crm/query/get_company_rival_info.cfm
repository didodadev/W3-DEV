<cfquery name="GET_COMPANY_RIVAL_INFO" datasource="#DSN#">
	SELECT
		SETUP_RIVALS.R_ID,
		SETUP_RIVALS.RIVAL_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER_RIVAL,
		SETUP_RIVALS
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER_RIVAL.COMPANY_ID AND
		COMPANY_PARTNER_RIVAL.RIVAL_ID = SETUP_RIVALS.R_ID AND
		COMPANY.COMPANY_ID = #attributes.cpid#
</cfquery>