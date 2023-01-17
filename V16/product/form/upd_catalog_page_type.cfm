<cfquery name="get_page_type" datasource="#dsn3#">
	SELECT * FROM CATALOG_PAGE_TYPES WHERE PAGE_TYPE_ID = #attributes.type_id#
</cfquery>
<cfquery name="get_catalog" datasource="#dsn3#">
	SELECT CATALOG_ID FROM CATALOG_PROMOTION_PRODUCTS WHERE PAGE_TYPE_ID = #attributes.type_id#
</cfquery>
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_catalog_page_type"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37765.Katalog Sayfa Tipi'> <cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#txt#">
	<cfform name="add_page_type" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_catalog_page_type">
	<input type="hidden" name="page_type_id" id="page_type_id" value="<cfoutput>#attributes.type_id#</cfoutput>">
	<table>
		<tr>
			<td width="70"><cf_get_lang dictionary_id ='58069.Sayfa Tipi'>*</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='37766.Sayfa Tipi Eklemelisiniz'>!</cfsavecontent>
				<cfinput type="text" name="page_type" value="#get_page_type.page_type#" message="#message#" required="yes" maxlength="50" style="width:200px;">
			</td>
		</tr>
		<tr>
			<td align="right" style="text-align:right;">
				<input type="checkbox" value="1" name="is_standart" id="is_standart" <cfif get_page_type.is_default eq 1>checked</cfif>>
			</td>
			<td><cf_get_lang dictionary_id ='43115.Standart Seçenek Olarak Gelsin'></td>
		</tr>
		</table>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_page_type">
			<cfif get_catalog.recordcount eq 0>
				<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_catalog_page_type&type_id=#attributes.type_id#'>
			<cfelse>
				<cf_workcube_buttons is_upd='1' is_delete='0'>
			</cfif>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>

