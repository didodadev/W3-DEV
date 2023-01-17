<cfquery name="PARTNERS" datasource="#dsn#">
	SELECT
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_USERNAME,
		COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER
	WHERE
		COMPANY_PARTNER_STATUS = 1
	<cfif isDefined("attributes.PARTNER_POSS")>
		AND
		PARTNER_ID IN (#Listsort(attributes.PARTNER_POSS,'numeric')#)
	</cfif>
</cfquery>	
	
