<cfquery name="COMPANY_PARS" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER_USERNAME,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	<cfif isDefined("attributes.PARS_IDS") and listlen(attributes.PARS_IDS)>
	WHERE
		PARTNER_ID IN (#Listsort(attributes.PARS_IDS,'numeric')#)
	</cfif>
</cfquery>		

