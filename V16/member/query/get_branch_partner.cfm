<cfquery name="GET_BRANCH_PARTNER" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY_PARTNER
	WHERE
		COMPBRANCH_ID = #url.brid#
	ORDER BY
		COMPANY_PARTNER_NAME
</cfquery>
