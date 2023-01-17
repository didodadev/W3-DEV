<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT,
        CATEGORY_SITE_DOMAIN
	WHERE
		COMPANY_CAT.COMPANYCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
        <!--- <cfif isDefined('session.pp.menu_id')>
        	CATEGORY_SITE_DOMAIN.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> AND
		<cfelseif isDefined('session.ww.menu_id')>
        	CATEGORY_SITE_DOMAIN.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#"> AND   
        <cfelse>
        	CATEGORY_SITE_DOMAIN.MENU_ID IN (SELECT MENU_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#">) AND                
        </cfif> --->
        CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'COMPANY' AND
		IS_VIEW = 1
</cfquery>
