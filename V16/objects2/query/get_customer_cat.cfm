<cfquery name="GET_CUSTOMER_CAT" datasource="#dsn#">	
	SELECT 
		CONSCAT_ID, 
		CONSCAT 
	FROM 
		CONSUMER_CAT,
        CATEGORY_SITE_DOMAIN
    WHERE
    	CONSUMER_CAT.CONSCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
        <!--- CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND  --->
        CATEGORY_SITE_DOMAIN.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#">
		CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'CONSUMER'
</cfquery>
