<cfquery name="PARTNER_COMPS" datasource="#dsn#">
	SELECT
		COMPANY_ID,
		NICKNAME,
		FULLNAME
	FROM
		COMPANY
	WHERE
		COMPANY_STATUS = 1
		<cfif isDefined("attributes.COMPANYCAT_ID")>
		AND
		COMPANYCAT_ID = #attributes.COMPANYCAT_ID#
		</cfif>
		ORDER BY FULLNAME
</cfquery>
