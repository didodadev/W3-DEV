<cfquery name="CONSUMER_CATS" datasource="#dsn#">
	SELECT 
		CONSCAT_ID,
		CONSCAT
	FROM 
		CONSUMER_CAT,
        CATEGORY_SITE_DOMAIN
	WHERE
	<cfif isDefined("attributes.CONS_CATS_IDS") and len(Listsort(attributes.CONS_CATS_IDS,'numeric'))>
		CONSCAT_ID IN (#Listsort(attributes.CONS_CATS_IDS,'numeric')#) AND
	</cfif>
    	CONSUMER_CAT.CONSCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
        CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#"> AND 
		CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'CONSUMER'
</cfquery>
