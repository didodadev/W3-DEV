<cfquery name="GET_MAIN_MENU_LAYOUTS" datasource="#DSN#">
	SELECT FACTION, MENU_ID FROM MAIN_SITE_LAYOUTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> ORDER BY LAYOUT_ID
</cfquery>

<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<cfquery name="GET_DENIED_PARTNER" datasource="#DSN#">
	SELECT DENIED_PAGE, IS_VIEW FROM COMPANY_PARTNER_DENIED WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"><!--- AND DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="objects2.#faction#">--->
</cfquery>

<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%;">
  	<tr style="height:35px;">
    	<td class="headbold"><cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput></td>
  	</tr>
</table>
<cfform name="add_faction" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_denied_pages_partner&pid=#attributes.id#">
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">
	  	<tr class="color-header" style="height:22px;">
			<td class="form-title">Sayfanin Adi</td>
			<td class="form-title" style="width:50px;"><cf_get_lang no ='1535.Grmesin'></td>
	  	</tr>
        <cfif get_main_menu_layouts.recordcount>
			<cfoutput query="get_main_menu_layouts">
     			<cfquery name="GET_ONLY_DENIED_PARTNER" dbtype="query">
					SELECT * FROM GET_DENIED_PARTNER WHERE DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="objects2.#faction#">
		  		</cfquery>
                <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                    <td>#faction#</td>
                    <td align="center"><input type="checkbox" name="is_view" id="is_view" value="#faction#" <cfif len(get_only_denied_partner.is_view) and get_only_denied_partner.is_view eq 1>checked</cfif>></td>
				</tr>
            </cfoutput>
        </cfif>
		<tr class="color-list" style="height:20px;">
			<td style="text-align:right;" colspan="6"><cf_workcube_buttons is_upd='0'></td>
		</tr>
	</table>
</cfform>

