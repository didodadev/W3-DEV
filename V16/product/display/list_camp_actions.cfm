<cfinclude template="../query/get_campaign_name_with_func.cfm">
<cfinclude template="../query/get_campaign_actions.cfm">
<!-- sil -->
<cfsavecontent variable="right">
		<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1' simple="1">
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57446.Kampanya'></cfsavecontent>
<cf_popup_box title='#message# : #get_camp_name(url.camp_id)#' right_images='#right#'>
<!-- sil -->
<table width="99%" align="center">
<cfset var_ = "view_catalog_promotion">
<cfset attributes.var_ = var_>
<cfset module_name = "product">
<cfif get_campaign_actions.recordcount>
		<cfoutput query="get_campaign_actions">
			<tr>
				<td>
				<table>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
						<td width="100">#cat_prom_no#</td>
						<td class="txtbold"><cf_get_lang dictionary_id='57482.Aşama'></td>
						<td width="100">#stage_name#</td>
						<td class="txtbold"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></td>
						<td>#dateformat(date_add("h",session.ep.time_zone,startdate),dateformat_style)#-#dateformat(date_add("h",session.ep.time_zone,finishdate),dateformat_style)#</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='37210.Aksiyon'></td>
						<td>#catalog_head#</td>
						<td class="txtbold"><cf_get_lang dictionary_id='29775.Hazırlayan'></td>
						<td>#employee_name# #employee_surname#</td>
					<cfif len(kondusyon_date)>
						<td class="txtbold"><cf_get_lang dictionary_id='37213.Kondüsyon Tarihi'></td>
						<td>#dateformat(date_add("h",session.ep.time_zone,kondusyon_date),dateformat_style)#-#dateformat(date_add("h",session.ep.time_zone,kondusyon_finish_date),dateformat_style)#</td>
					</cfif>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
					<cfset attributes.id = catalog_id>
					<cfinclude template="../query/get_catalog_promotion_products.cfm">
					<cfinclude template="dsp_view_camp_basket.cfm">
				</td>
			</tr>
			<tr>
				<td height="10"></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
</table>
<cf_popup_box_footer>
	<table align="right">
		<tr>
			<td>
				<cfif not isdefined("attributes.print")>
					<cfsavecontent variable="list_message"><cf_get_lang dictionary_id ='37866.Fiyat listelerine fiyatlar yazılacak! Emin misiniz'></cfsavecontent>
					<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='37867.Fiyatlar bir kez oluşturulduktan sonra, burada oluşan fiyatlar, sadece fiyat güncellemeleri kullanılarak değiştirilebilecektir Devam etmek istiyormusunuz'></cfsavecontent>
					<input name="fiyatButon" id="fiyatButon" type="button" onClick="if(confirm('<cfoutput>#list_message#</cfoutput>') && confirm('<cfoutput>#message2#</cfoutput>')) {document.getElementById('fiyatButon').disabled = true; location.href='<cfoutput>#request.self#?fuseaction=product.emptypopupflush_add_camp_price_list&camp_id=#url.camp_id#&active_company=#session.ep.company_id#</cfoutput>';} else return false;" value="<cf_get_lang dictionary_id='37021.Fiyat Oluştur'>">
				</cfif>
			</td>
		</tr>
	</table>
</cf_popup_box_footer>
</cf_popup_box>
