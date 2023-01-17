<cfquery name="PARTNER_CATS" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID,
		COMPANYCAT 
	FROM 
		COMPANY_CAT
	<cfif isDefined("attributes.PARS_IDS")>
	WHERE
		COMPANYCAT_ID IN (#attributes.PARS_IDS#)
	</cfif>
</cfquery>		

