<cfquery name="GET_WORK_PARTNER" datasource="#dsn#">
	SELECT
		*
	FROM
		COMPANY_PARTNER
	WHERE
		PARTNER_ID=#CMP_PARTNER_ID#
</cfquery>
