<cfinclude template="../query/get_cat_prom_actions.cfm">
<!-- sil -->

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_counter" title="#iif(isDefined("attributes.draggable"),"getLang('','Aksiyon',37210)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfset var_ = "view_catalog_promotion">
		<cfset attributes.var_ = var_>
		<cfset module_name = "product">
		<cfif get_cat_prom_actions.recordcount>
			<cfoutput query="get_cat_prom_actions">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-price_catid">
							<label class="col col-4"><cf_get_lang dictionary_id='57487.No'></label>
							<div class="col col-6">
								#cat_prom_no#
							</div>
						</div>
						<div class="form-group" id="item-price_catid">
							<label class="col col-4"><cf_get_lang dictionary_id='57482.Aşama'></label>
							<div class="col col-6">
								#stage_name#
							</div>
						</div>
						<div class="form-group" id="item-price_catid">
							<label class="col col-4"><cf_get_lang dictionary_id='29775.Hazırlayan'></label>
							<div class="col col-6">
								#employee_name# #employee_surname#
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-price_catid">
							<label class="col col-4"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></label>
							<div class="col col-6">
								#dateformat(date_add("h",session.ep.time_zone,startdate),dateformat_style)#-#dateformat(date_add("h",session.ep.time_zone,finishdate),dateformat_style)#
							</div>
						</div>
						<cfif len(kondusyon_date)>
							<div class="form-group" id="item-price_catid">
								<label class="col col-4"><cf_get_lang dictionary_id='37213.Kondüsyon Tarihi'></label>
								<div class="col col-6">
									#dateformat(date_add("h",session.ep.time_zone,kondusyon_date),dateformat_style)#-#dateformat(date_add("H",session.ep.time_zone,kondusyon_finish_date),dateformat_style)#
								</div>
							</div>
						</cfif>
					</div>
				</cf_box_elements>
				<cfset attributes.id = catalog_id>
				<cfinclude template="../query/get_catalog_promotion_products.cfm">
				<cfinclude template="dsp_view_camp_basket.cfm">
				<cf_box_footer>
					<cfif not isdefined("attributes.print")>
						<!-- sil -->
						<cfsavecontent variable="list_message"><cf_get_lang dictionary_id ='37866.Fiyat listelerine fiyatlar yazılacak! Emin misiniz'></cfsavecontent>
						<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='37867.Fiyatlar bir kez oluşturulduktan sonra, burada oluşan fiyatlar, sadece fiyat güncellemeleri kullanılarak değiştirilebilecektir Devam etmek istiyormusunuz'></cfsavecontent>
						<input name="fiyatButon" id="fiyatButon" type="button" onClick="if(confirm('<cfoutput>#list_message#</cfoutput>') && confirm('<cfoutput>#message2#</cfoutput>')) {document.getElementById('fiyatButon').disabled = true; location.href='<cfoutput>#request.self#?fuseaction=product.emptypopupflush_add_cat_prom_price_list&catalog_id=#url.catalog_id#&active_company=#session.ep.company_id#</cfoutput>';} else return false;" value="<cf_get_lang dictionary_id='37021.Fiyat Oluştur'>">
					</cfif>
				</cf_box_footer>
			</cfoutput>
			<cfset session[module_name][var_] = ArrayNew(2)>
		  <cfelse>
			  <tr>
				  <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			  </tr>
		  </cfif>
	</cf_box>
</div>
	
<!-- sil -->

