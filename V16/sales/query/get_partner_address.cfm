<cfquery name="GET_PARTNER_ADDRESS" datasource="#dsn#">
	SELECT
		COMPANY_PARTNER_ADDRESS
	FROM
		COMPANY_PARTNER
	WHERE
		PARTNER_ID = #PARTNER_ID#
</cfquery>
