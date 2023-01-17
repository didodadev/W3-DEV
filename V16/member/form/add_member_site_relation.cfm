<cfquery name="GET_DOMAINS" datasource="#DSN#">
	SELECT 
		SITE_DOMAIN,
        MENU_ID
	FROM 
		COMPANY_CONSUMER_DOMAINS 
	WHERE 
		<cfif isdefined("attributes.company_id")>
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        <cfelseif isdefined("attributes.consumer_id")>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        <cfelse>
            PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
        </cfif>
</cfquery>

<cfquery name="GET_MENU_DOMAINS" datasource="#DSN#">
	SELECT MENU_ID, SITE_DOMAIN FROM MAIN_MENU_SETTINGS
</cfquery>

<cfset site_list = valuelist(get_domains.menu_id)>
<table border="0" cellspacing="1" cellpadding="2" align="center" class="color-border" style="width:100%; height:100%;">
	<tr class="color-list" style="height:35px;">
	 	<td class="headbold"><cf_get_lang dictionary_id ='58442.Site Erişim Hakları'></td>
 	</tr>
 	<tr class="color-row">
 		<td style="vertical-align:top;">
			<cfform name="add_site_domain" action="#request.self#?fuseaction=member.emptypopup_add_member_site_relation" method="post">
				<table>
					<cfoutput>
						<cfif isdefined("attributes.company_id")>
                            <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                        <cfelseif isdefined("attributes.consumer_id")>
                            <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                        <cfelse>
                            <input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
                        </cfif>
                            <tr>
                                <td class="txtbold"><cf_get_lang dictionary_id ='34307.Partner Adresleri'></td>
                            </tr>
                        <cfloop list="#partner_url#" index="pu" delimiters=";">
                            <cfquery name="GET_MENU_DOMAIN" dbtype="query">
                                SELECT * FROM GET_MENU_DOMAINS WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pu#">
                            </cfquery>                        	
                            <tr>
                                <td><input type="checkbox" name="site_domain" id="site_domain" value="#get_menu_domain.menu_id#" <cfif listfindnocase(site_list,get_menu_domain.menu_id,',')>checked</cfif>> #pu#</td>
                            </tr>
                        </cfloop>
                            <tr>
                                <td class="txtbold"><cf_get_lang dictionary_id ='30600.Public Adresleri'></td>
                            </tr>
                        <cfloop list="#server_url#" index="su" delimiters=";">
                            <cfquery name="GET_MENU_DOMAIN" dbtype="query">
                                SELECT * FROM GET_MENU_DOMAINS WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#su#">
                            </cfquery>   
                            <tr>
                                <td><input type="checkbox" name="site_domain" id="site_domain" value="#get_menu_domain.menu_id#" <cfif listfindnocase(site_list,get_menu_domain.menu_id,',')>checked</cfif>> #su#</td>
                            </tr>
                        </cfloop>
					</cfoutput>
					<tr style="height:30px;">
						<td  style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
					</tr>
				</table>
			</cfform>
        </td>
 	</tr>
</table>
