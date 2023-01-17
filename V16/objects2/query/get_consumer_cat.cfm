<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT 
		CONSUMER_CAT.CONSCAT_ID,
		CONSUMER_CAT.CONSCAT
	FROM 
		CONSUMER_CAT,
        CATEGORY_SITE_DOMAIN
	WHERE 
		IS_INTERNET = 1 AND
        CONSUMER_CAT.CONSCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
        <!--- <cfif isDefined('session.pp.menu_id')>
        	CATEGORY_SITE_DOMAIN.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> AND
		<cfelseif isDefined('session.ww.menu_id')>
        	CATEGORY_SITE_DOMAIN.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#"> AND        
        </cfif> --->
		CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'CONSUMER'
		<!--- Ekleme sayfasından geliyorsa kategorinin aktiflik durumuna bakıyor --->		
		<!--- <cfif isdefined("is_active_consumer_cat")> --->
			AND IS_ACTIVE = 1
		<!--- </cfif> --->
	ORDER BY 
		CONSUMER_CAT.CONSCAT
</cfquery>
