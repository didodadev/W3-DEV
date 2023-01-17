<cfquery name="GET_PDA_MENU_SETTINGS" datasource="#DSN#">
	SELECT MENU_ID, MYHOME_FILE, AYRAC_WIDTH FROM MAIN_MENU_SETTINGS WHERE SITE_TYPE = 4 AND IS_ACTIVE = 1 AND SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
</cfquery>
<cfif not get_pda_menu_settings.recordcount>
	Bu Sistem İçin Pda Portal Tanımı Yapılmamış!
	<cfexit method="exittemplate">
<cfelse>
	<cfquery name="GET_PDA_MENU_SELECTS" datasource="#DSN#">
		SELECT SELECTED_LINK, LINK_IMAGE, LINK_NAME FROM MAIN_MENU_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pda_menu_settings.menu_id#"> AND IS_SESSION = 0 ORDER BY ORDER_NO
	</cfquery>
	<table style="width:100%">
		<cfoutput>
            <cfif len(get_pda_menu_settings.myhome_file)>
                <tr>
                    <td style="vertical-align:top">
                    	<cfinclude template="../../#get_pda_menu_settings.myhome_file#">
                    </td>
                </tr>
    		<cfelse>
                <tr>
                    <td style="vertical-align:top">
                        <table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:100%">
                            <cfif get_pda_menu_selects.recordcount mod 2 eq 1>
                                <cfset count = get_pda_menu_selects.recordcount + 1>
                            <cfelse>
                                <cfset count = get_pda_menu_selects.recordcount>
                            </cfif>
                            <cfloop from="1" to="#count#" index="x">
                                <cfif x mod 2 eq 1>
                                    <tr class="color-row" <cfif len(get_pda_menu_settings.ayrac_width)>style="height:#get_pda_menu_settings.ayrac_width#px;"<cfelse>style="height:30px;"</cfif>>
                                </cfif>
                                    <td align="center" style="width:20px;"><cfif len(get_pda_menu_selects.selected_link[x])><a href="#request.self#?fuseaction=#get_pda_menu_selects.selected_link[x]#"><img src="/documents/settings/#get_pda_menu_selects.link_image[x]#" align="absmiddle" border="0" title="#get_pda_menu_selects.link_name[x]#"></a></cfif></td>
                                    <td style="width:40%"><cfif len(get_pda_menu_selects.selected_link[x])><a href="#request.self#?fuseaction=#get_pda_menu_selects.selected_link[x]#" class="main_menu_link">#get_pda_menu_selects.link_name[x]#</a></cfif></td>
                                <cfif x mod 2 eq 0></tr></cfif>
                            </cfloop>
                        </table>
                    </td>
                </tr>
            </cfif>
		</cfoutput>
	</table>
</cfif>
