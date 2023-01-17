<cfquery name="PARTNER_CATS" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID,
		COMPANYCAT 
	FROM 
		COMPANY_CAT, 
        CATEGORY_SITE_DOMAIN
	WHERE
	<cfif isDefined("attributes.PARS_IDS")>
		COMPANYCAT_ID IN (#attributes.PARS_IDS#) AND
	</cfif>
    	COMPANY_CAT.COMPANYCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
        CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#"> AND
		CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'COMPANY'
</cfquery>		

