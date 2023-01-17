<cfquery name="GET_CAT_COMP_COUNT" datasource="#dsn#">
	SELECT
		COUNT(COMPANY_ID) AS TOTAL
	FROM
		COMPANY
	WHERE
		COMPANYCAT_ID = #attributes.COMPANYCAT_ID#
</cfquery>
