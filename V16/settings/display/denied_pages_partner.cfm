<cfquery name="GET_MENU_ID" datasource="#DSN#">
	SELECT 
		MMS.SITE_DOMAIN,
		MMS.MENU_ID,
		MMS.MENU_NAME
	FROM 
		COMPANY_CONSUMER_DOMAINS CCD,
		MAIN_MENU_SETTINGS MMS
	WHERE 
		MMS.MENU_ID = CCD.MENU_ID AND
		CCD.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	ORDER BY
		CCD.RECORD_DATE
</cfquery>
<cfif len(get_menu_id.menu_id)>
	<cfquery name="GET_MAIN_MENU_LAYOUTS" datasource="#DSN#">
		SELECT FACTION FROM MAIN_SITE_LAYOUTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_menu_id.menu_id#"> ORDER BY LAYOUT_ID
	</cfquery>
<cfelse>
	<cfset get_main_menu_layouts.recordcount = 0>
</cfif>

<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#get_partner.company_partner_name# #get_partner.company_partner_surname# / #get_menu_id.menu_name#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_denied_pages_partner&pid=#attributes.id#">
		<cf_grid_list>
			<input type="hidden" name="menu_id" id="menu_id" value="<cfoutput>#get_menu_id.menu_id#</cfoutput>" />
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='42438.Sayfanın Adı'></th>
					<th><cf_get_lang dictionary_id ='57691.Dosya'></th>
					<th width="80"><cf_get_lang dictionary_id='44751.Görmesin'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_main_menu_layouts.recordcount>
					<cfoutput query="get_main_menu_layouts">
						<cfquery name="GET_LAYOUT_NAME" datasource="#DSN#">
							SELECT OBJECT_NAME FROM MAIN_SITE_LAYOUTS_SELECTS WHERE FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#faction#"> AND MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_menu_id.menu_id#">
						</cfquery>
						<cfquery name="GET_DENIED_PARTNER" datasource="#DSN#">
							SELECT IS_VIEW FROM COMPANY_PARTNER_DENIED WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="objects2.#faction#">
						</cfquery>
						<tr>
							<td>#get_layout_name.object_name#</td>
							<td>#faction#</td>
							<td align="center"><input type="checkbox" name="is_view" id="is_view" value="#faction#" <cfif len(get_denied_partner.is_view) and get_denied_partner.is_view eq 1>checked</cfif>></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_faction' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
