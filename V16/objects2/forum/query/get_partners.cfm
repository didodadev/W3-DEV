<cfquery name="PARTNERS" datasource="#DSN#">
	SELECT
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_USERNAME,		
		COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER
	WHERE
		COMPANY_PARTNER_STATUS = 1
	<cfif isDefined("attributes.partner_poss")>
		AND PARTNER_ID IN (#Listsort(attributes.partner_poss,'numeric')#)
	</cfif>
</cfquery>	
	
