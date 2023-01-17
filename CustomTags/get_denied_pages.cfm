<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
By :  20030621
Description :
	calisan pozisyonlarina verilen sayfa gorememe kisitini bir listeye atar bunu kontrol eder..
	partner_id sine verilen sayfa gorememe kisitini bir listeye atar ve bunu kontrol eder..
Parameters :
	zone	'required
Syntax :
	<cf_get_denied_pages>
Revisions :
	modified  20030625
	modified  20050309
	modified  20050312
--->
<cfparam name="caller.denied_pages" default="">
<cfparam name="caller.module_name" default="#listfirst(caller.attributes.fuseaction,'.')#">
<cfif caller.workcube_mode><!--- development ortamda 5 dakika, production ortamda 1 saat de query calissin --->
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,1,0,0)>
<cfelse>
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,5,0)>
</cfif>
<cfset caller.izinli_pages = ''>
<cfif isdefined("session.ep.userid")>
	<cftry>
		<cfif isdefined("session.ep.position_code")>
			<cfquery name="GET_EMP_IZINLI_PAGES" datasource="#caller.dsn#" cachedwithin="#caller.get_denied_page_cached_time#">
				SELECT 
					DENIED_PAGE
				FROM
					EMPLOYEE_POSITIONS_DENIED
				WHERE
					IS_VIEW = 1 AND
					DENIED_TYPE = 1 AND
					MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
					DENIED_PAGE	NOT IN 
					( 
						SELECT 
							DENIED_PAGE
						FROM 
							EMPLOYEE_POSITIONS_DENIED EPD,
							EMPLOYEE_POSITIONS EP
						WHERE
							EPD.IS_VIEW = 1 AND
							EPD.DENIED_TYPE = 1 AND
							EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
							EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
							(
								EPD.POSITION_CODE = EP.POSITION_CODE OR
								EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
								EPD.USER_GROUP_ID = EP.USER_GROUP_ID
							)
					)
			</cfquery>
			<cfset caller.izinli_pages = valuelist(get_emp_izinli_pages.denied_page,',')>
		<cfelse>
			<cfset caller.izinli_pages = ''>
		</cfif>
		<cfcatch><cfoutput>#caller.getLang('main',2102)#!</cfoutput></cfcatch>
	</cftry>
	
	<cfif listfindnocase(caller.izinli_pages,caller.attributes.fuseaction) and (caller.module_name neq 'home')>
		<cfset denied_alert = caller.getLang('main',120)>
		<cfoutput>
			<script type="text/javascript">
				alert("#denied_alert#");
				<cfif caller.attributes.fuseaction contains 'emptypopup'>
					alert("#caller.attributes.fuseaction#");
					<cfabort>
				<cfelseif caller.attributes.fuseaction contains 'popup'>
					window.close();
				<cfelse>
					window.location="#caller.user_domain##request.self#?fuseaction=home.login";
					//window.history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	<cfelse>
		<cftry>
			<cfif isdefined("session.ep.position_code")>
				<cfquery name="GET_EMP_DENIEDS_PAGES" datasource="#caller.dsn#" cachedwithin="#caller.get_denied_page_cached_time#">
					SELECT 
						EPD.IS_VIEW,
						EPD.DENIED_PAGE	
					FROM
						EMPLOYEE_POSITIONS_DENIED AS EPD,
						EMPLOYEE_POSITIONS AS EP
					WHERE
						EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
						EPD.DENIED_TYPE <> 1 AND
						EPD.IS_VIEW = 1 AND
						EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
						( 
							EPD.POSITION_CODE = EP.POSITION_CODE OR
							EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
							EPD.USER_GROUP_ID = EP.USER_GROUP_ID
						)
				</cfquery>
				<cfset caller.denied_pages = valuelist(get_emp_denieds_pages.denied_page,',')>
			<cfelse>
				<cfset caller.denied_pages = ''>
			</cfif>
			<cfcatch><cfoutput>#caller.getLang('main',2102)#!</cfoutput></cfcatch>
		</cftry>
	</cfif>
	
	<cfif listfindnocase(caller.denied_pages,caller.attributes.fuseaction) and (caller.module_name neq 'home')>
		<cfset denied_alert = caller.getLang('main',120)>
		<cfoutput>
			<script type="text/javascript">
				alert("#denied_alert#");
				<cfif caller.attributes.fuseaction contains 'popup'>
					window.close();
				<cfelse>
					window.location="#caller.user_domain##request.self#?fuseaction=home.login";
					//window.history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
<cfelseif isdefined("session.pp.userid")>
	<cftry>
		<cfif isdefined("session.pp.userid")>
        	<!--- partner görev pozisyonuna verilen kısıtlarada bakar ve ona göre sayfa kısıtlarını uygular. FA 20091123 --->
			<cfquery name="GET_PAR_DENIEDS_PAGES" datasource="#caller.dsn#" cachedwithin="#caller.get_denied_page_cached_time#">
				SELECT 
					IS_VIEW,
					DENIED_PAGE	
				FROM
					COMPANY_PARTNER_DENIED
				WHERE
					IS_VIEW	= 1 AND
					DENIED_PAGE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.module_name#.%"> AND
                    MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> AND
					(
                    	PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR 
                        COMPANY_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_category#"> OR 
                        PARTNER_POSITION_ID IN (SELECT MISSION FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">)
                    )
			</cfquery>
			<cfset caller.denied_pages = valuelist(get_par_denieds_pages.denied_page,',')>
		<cfelse>
			<cfset caller.denied_pages = ''>
		</cfif>
		<cfcatch><cfoutput>#caller.getLang('main',2102)#!</cfoutput></cfcatch>
	</cftry>
	<cfif listfindnocase(caller.denied_pages, caller.attributes.fuseaction) and (caller.module_name neq 'home')>
		<cfset denied_alert = caller.getLang('main',120)>
		<cfoutput>
			<script type="text/javascript">
				alert("#denied_alert#!");
				<cfif caller.attributes.fuseaction contains 'popup'>
					window.close();
				<cfelse>
					window.location="#caller.user_domain##request.self#?fuseaction=objects2.welcome";
					//window.history.back();
				</cfif>
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
