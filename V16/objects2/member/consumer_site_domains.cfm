<cfif isdefined("session.ww.userid") or isDefined("session.pp")>
	<cfquery name="GET_DOMAINS" datasource="#DSN#">
        SELECT 
        	MMS.MENU_ID,
            MMS.SITE_DOMAIN 
        FROM 
            COMPANY_CONSUMER_DOMAINS CCD,
            MAIN_MENU_SETTINGS MMS
        WHERE 
            CCD.MENU_ID = MMS.MENU_ID AND
            <cfif isdefined("session.ww")>
				CCD.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			<cfelseif isdefined("session.pp")>
				CCD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			</cfif>
	</cfquery>
    <cfquery name="GET_MENU_DOMAINS" datasource="#DSN#">
        SELECT MENU_ID, SITE_DOMAIN FROM MAIN_MENU_SETTINGS
    </cfquery>
	<cfset site_list = valuelist(get_domains.menu_id)>
	<cfform name="add_" action="#request.self#?fuseaction=objects2.emptypopup_add_member_site_relation" method="post">
		<div class="table-responsive-lg">
			<table class="table">
				<tbody>
					<cfif get_domains.recordcount>
						<cfloop list="#server_url#" index="su" delimiters=";">
							<cfquery name="GET_MENU_DOMAIN" dbtype="query">
								SELECT * FROM GET_MENU_DOMAINS WHERE SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#su#">
							</cfquery>
							<cfoutput>
								<tr class="color-row">
									<td>#su#</td>
									<td style="width:15px;"><input type="checkbox" name="site_domain" id="site_domain" value="#get_menu_domain.menu_id#" <cfif listfindnocase(site_list,get_menu_domain.menu_id,',')>checked</cfif>></td>
								</tr>
							</cfoutput>
						</cfloop>
						<tr style="height:30px;">
							<td colspan="2"  style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
						</tr>
					<cfelse>
						<tr class="color-row">
							<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
	</cfform>
</cfif>