<cfquery name="GET_USERS_PARS" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER_EMAIL
	FROM 
		COMPANY_PARTNER
	WHERE
		PARTNER_ID IN (#LISTSORT(attributes.PARTNER_IDS,"NUMERIC")#)
	<cfif isDefined("attributes.searchKey") and len(attributes.searchKey)>
	AND
		(
		COMPANY_PARTNER_NAME LIKE '%#attributes.searchKey#%'
		OR
		COMPANY_PARTNER_SURNAME LIKE '%#attributes.searchKey#%'
		)
	</cfif>		
</cfquery>		

