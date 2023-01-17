<cfsetting showdebugoutput="yes">
<cf_xml_page_edit default_value="1" fuseact="product.form_upd_catalog_promotion">
<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<cfinclude template="../query/get_action_stages.cfm">
<cfinclude template="../query/get_price_cats.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_catalog_promotion_detail.cfm">
<cfif not get_catalog_detail.recordcount>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
</cfif>
<cfif len(get_catalog_detail.camp_id)>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE
		 FROM CAMPAIGNS WHERE CAMP_ID = #get_catalog_detail.camp_id#
	</cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_catalog_promotion">
				<cfoutput>
					<input type="hidden" name="visible" id="visible" value="0">
					<input type="hidden" name="var_" id="var_" value="#var_#">
					<input type="hidden" name="module_name" id="module_name" value="#module_name#">
					<input type="hidden" name="catalog_id" id="catalog_id" value="#get_catalog_detail.catalog_id#">
					<input type="hidden" name="id" id="id" value="#attributes.id#">
				</cfoutput>
				<cf_basket_form>
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-CAT_PROM_NO">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
								<div class="col col-8 col-xs-12" <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")></cfif>>
									<cfinput type="text" name="CAT_PROM_NO" value="#get_catalog_detail.cat_prom_no#" style="width:80px;">
								</div>
							</div>
							<div class="form-group" id="item-CATALOG_HEAD">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37210.Aksiyon'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='37399.Aksiyon Girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="CATALOG_HEAD" required="Yes" message="#message#" value="#get_catalog_detail.catalog_head#" style="width:160px;">
											<span class="input-group-addon">
												<cf_language_info
													table_name="CATALOG_PROMOTION"
													column_name="CATALOG_HEAD" 
													column_id_value="#attributes.id#" 
													maxlength="500" 
													datasource="#dsn3#" 
													column_id="CATALOG_ID" 
													control_type="0">
											</span>
									</div>									
								</div>
							</div>
							<div class="form-group" id="item-camp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#get_catalog_detail.camp_id#</cfoutput>">
										<cfif len(get_catalog_detail.camp_id)>				  
											<input type="text" name="camp_name" id="camp_name" value="<cfoutput>#get_campaign.camp_head# (#dateformat(get_campaign.camp_startdate,dateformat_style)# - #dateformat(get_campaign.camp_finishdate,dateformat_style)#)</cfoutput>" style="width:160px;">
										<cfelse>
											<input type="text" name="camp_name" id="camp_name" value="" style="width:160px;">
										</cfif>									
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=form_basket.camp_id&field_name=form_basket.camp_name&field_start_date=form_basket.startdate&field_finish_date=form_basket.finishdate<cfif (isdefined("is_condition_date") and is_condition_date eq 1) or not isdefined("is_condition_date")>&field_start_date1=form_basket.kondusyon_date&field_finish_date1=form_basket.kondusyon_finish_date</cfif>&is_next_day','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-startdate">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif get_catalog_detail.is_applied neq 1>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37398.Geçerlilik Tarihi girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="startdate" value="#dateformat(get_catalog_detail.startdate,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" style="width:68px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
											<span class="input-group-addon no-bg"></span>
											<cfinput type="text" name="finishdate" value="#dateformat(get_catalog_detail.finishdate,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" style="width:68px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
										<cfelse>
											<cfoutput>
												<input type="hidden" name="startdate" id="startdate" value="#dateformat(get_catalog_detail.startdate,dateformat_style)#">
												<input type="hidden" name="finishdate" id="finishdate" value="#dateformat(get_catalog_detail.finishdate,dateformat_style)#">
												#dateformat(get_catalog_detail.startdate,dateformat_style)#  -  #dateformat(get_catalog_detail.finishdate,dateformat_style)#
											</cfoutput>
										</cfif>			
									</div>
								</div>
							</div>
							<cfif (isdefined("is_condition_date") and is_condition_date eq 1) or not isdefined("is_condition_date")>
							<div class="form-group" id="item-kondusyon_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37213.Kondüsyon Tarihi'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='37400.Kondüsyon Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput required="yes" validate="#validate_style#" message="#message#" type="text" name="kondusyon_date" value="#dateformat(get_catalog_detail.kondusyon_date,dateformat_style)#" style="width:68px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="kondusyon_date"></span>
										<span class="input-group-addon no-bg"></span>
										<cfinput required="yes" validate="#validate_style#" message="#message#" type="text" name="kondusyon_finish_date" value="#dateformat(get_catalog_detail.kondusyon_finish_date,dateformat_style)#" style="width:68px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="kondusyon_finish_date"></span>
									</div>
								</div>
							</div>
							<cfelse>
							<div class="form-group" id="item-VALIDATOR">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="">
										<input type="text" name="VALIDATOR" id="VALIDATOR" value="" style="width:171px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions</cfoutput>&field_code=form_basket.VALIDATOR_POSITION_CODE&field_name=form_basket.VALIDATOR','list');"></span>
									</div>
								</div>
							</div>
							</cfif>							
							<div class="form-group">
								<label><cfif not get_catalog_detail.is_applied neq 1><font color="#FF0000"><b><cf_get_lang dictionary_id='37357.Fiyat oluşturuldu '>!</b></font></cfif></label>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-currency">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<label class="col col-8 col-xs-12">
									<input type="checkbox" name="currency" id="currency" value="1" <cfif get_catalog_detail.catalog_status is 1>checked="checked"</cfif>>
								</label>
							</div>
							<div class="form-group" id="item-process">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value='#get_catalog_detail.process_stage#' process_cat_width='160' is_detail='1'>
								</div>
							</div>
							<div class="form-group" id="item-stage_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57482.Asama'> *</label>
								<div class="col col-8 col-xs-12">
									<select name="stage_id" id="stage_id" style="width:160px;">
										<cfoutput query="get_action_stages">
											<option value="#stage_id#"<cfif  get_catalog_detail.stage_id eq stage_id> selected</cfif>>#stage_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-DETAIL">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açiklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="detail" id="detail" style="width:160px;height:45px;"><cfoutput>#get_catalog_detail.catalog_detail#</cfoutput></textarea>
								</div>
							</div>
							<cfif len(get_catalog_detail.valid)>
							<div class="form-group" id="item-VALIDATOR">
								<cfif get_catalog_detail.valid eq 1>
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58699.Onaylandı'></label>
								<cfelseif get_catalog_detail.valid eq 0>
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57617.Reddedildi'></label>
								<cfelse>
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57615.Onay Bekliyor'></label>
								</cfif> 
								<cfif len(get_catalog_detail.valid)>
									:
									<cfif len(get_catalog_detail.valid_emp)>
										<cfset record_date = date_add('h',session.ep.time_zone,get_catalog_detail.validate_date)>
										<cfoutput>#get_emp_info(get_catalog_detail.valid_emp,0,0)# (#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#) </cfoutput>
									<cfelse>
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37219.Bilinmiyor'></label>  
										</cfif>
								<cfelse>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='37854.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
										<cfsavecontent variable="alert2"><cf_get_lang dictionary_id ='37855.Reedetmekte olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediğinizden emin misiniz?'></cfsavecontent>
										<input type="hidden" name="valid" id="valid" value="">
										<input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id='58475.Onayla'>" onClick="if (confirm(' #alert#')) {form_basket.valid.value='1'} else {return false}" border="0">
										<input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onClick="if (confirm('#alert2#')) {form_basket.valid.value='0'} else {return false}" border="0">
									</div>
								</div>
								</cfif>
							</div>
							<cfelse>
							<div class="form-group" id="item-VALIDATOR">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37275.Onaylayacak'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="<cfoutput>#get_catalog_detail.validator_position_code#</cfoutput>">
										<input type="text" name="VALIDATOR" id="VALIDATOR" value="<cfoutput><cfif len(get_catalog_detail.validator_position_code)>#get_emp_info(get_catalog_detail.validator_position_code,1,0)#</cfif></cfoutput>" style="width:160px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions</cfoutput>&field_code=form_basket.VALIDATOR_POSITION_CODE&field_name=form_basket.VALIDATOR','list');"></span>
									</div>
								</div>
							</div>
							</cfif>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
							<div class="form-group" id="item-price_catid">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'> *</label>
								<div class="col col-8 col-xs-12">
									<cf_multiselect_check 
										name="PRICE_CATS"
										option_name="price_cat"
										option_value="price_catid"
										query_name="get_price_cats"
										value="#price_list#" 
										width="250">
								</div>
							</div>
							</cfif>
							<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
							<div class="form-group" id="item-companycat_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37798.Kurumsal Kategoriler'></label>
								<div class="col col-8 col-xs-12">
									<cf_multiselect_check 
									name="COMPANYCAT_ID"
									option_name="companycat"
									option_value="companycat_id"
									query_name="get_companycat"
									value="#company_list#"
									width="250">
								</div>
							</div>
							</cfif>
							<cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
							<div class="form-group" id="item-conscat_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37799.Bireysel Kategoriler'></label>
								<div class="col col-8 col-xs-12">
									<cf_multiselect_check 
									name="CONSCAT_ID"
									option_name="conscat"
									option_value="conscat_id"
									query_name="get_consumer_cat"
									value="#consumer_list#"
									width="250">
								</div>
							</div>
							</cfif>
							<div class="form-group" id="item-catalog">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59154.Katalog'></label>
								<div class="col col-8 col-xs-12">
									<cfoutput>
										<div class="input-group">
											<input type="hidden" name="related_catalog_id" id="related_catalog_id" value="#get_catalog_detail.related_catalog_id#">
											<input type="text" name="related_catalog_head" id="related_catalog_head" value="#get_catalog_detail.related_catalog_head#">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=catalogList&isbox=1&is_submitted=1&field_id=form_basket.related_catalog_id&field_name=form_basket.related_catalog_head')"></span>
										</div>
									</cfoutput>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-6">
							<cf_record_info query_name="get_catalog_detail">
						</div>
						<div class="col col-6">
							<cfif get_catalog_detail.is_applied neq 1>
								<cfif session.ep.admin or session.ep.userid is get_catalog_detail.update_emp or session.ep.userid is get_catalog_detail.record_emp>
									<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_catalog_promotion&del_cat=#url.id#&module_name=#module_name#&head=#get_catalog_detail.cat_prom_no#' type_format='1'>
								<cfelse>
									<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0' type_format='1'>
								</cfif>
							<cfelse>
								<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()' type_format='1'> 
							</cfif>	
						</div>
					</cf_box_footer>
			</cf_basket_form>	
			<div id="detail_catalog_basket"><cfinclude template="../display/basket_purchase.cfm"></div>    
		</cfform>
	</cf_box>
</div>	
<form name="aksiyon_kopya" method="post" action="">
	<cfoutput>
        <input type="hidden" name="id" id="id" value="#get_catalog_detail.catalog_id#">
        <input type="hidden" name="attributes.id" id="attributes.id" value="#get_catalog_detail.catalog_id#">
        <input type="hidden" name="compid" id="compid">
	</cfoutput>
</form>
<script type="text/javascript">
	function check_all(deger)
	{
		<cfif get_price_cats.recordcount gt 1>
			for(i=0; i<form_basket.PRICE_CATS.length; i++)
				form_basket.PRICE_CATS[i].checked = deger;
		<cfelseif get_price_cats.recordcount eq 1>
			form_basket.PRICE_CATS.checked = deger;
		</cfif>
	}
	
	function kontrol()
	{
		product_id_list='';
		stock_id_list='';
		x = (250 - document.form_basket.detail.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='57629.Açıklama '> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
			return false;
		}
		if(form_basket.herkes != undefined)
			temp3 = form_basket.herkes.checked;
		else
			temp3 = 1;
		temp1 = 0;
		if(form_basket.PRICE_CATS != undefined)
		{
			<cfif get_price_cats.recordcount gt 1>
				for(i=0;i<form_basket.PRICE_CATS.length;i++)
					if (form_basket.PRICE_CATS[i].checked==1)
						temp1 = 1;
			<cfelseif get_price_cats.recordcount eq 1>
				if (form_basket.PRICE_CATS.checked==1)
					temp1 = 1;
			</cfif>
		}
		
		if(row_count==0)
		{
			alert("<cf_get_lang dictionary_id='57725.ürün seçiniz'>");
			return false;
		}
				
		if (form_basket.is_public != undefined && form_basket.is_public.checked==1)
			temp1 = 1;		
		if ((temp1 == 0) && (temp3 == 0))
		{
			alert("<cf_get_lang dictionary_id ='37800.Aksiyonu Fiyat Listesine Bağlamalısınız'> !");
			return false;
		}
		for(var i=1; i<=row_count; i++)
		{
			if(eval("form_basket.disc_ount1"+i) != undefined)
			{
				var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37803.no lu satırdaki İskonto 1 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37804.no lu satırdaki İskonto 2 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37805.no lu satırdaki İskonto 3 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37806. no lu satırdaki İskonto 4 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37807.no lu satırdaki İskonto 5 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37808.no lu satırdaki İskonto 6 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37809.no lu satırdaki İskonto 7 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37810.no lu satırdaki İskonto 8 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37811.no lu satırdaki İskonto 9 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37812.no lu satırdaki İskonto 10 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
			}
			//Ayni urun bir satirlarda bir kez secilmeli BK 20100907
			if(eval("document.form_basket.row_kontrol"+i).value==1)	
			{
				if(document.getElementById('stock_id'+i).value=="")
				{
					temp_product_id = "'"+eval("form_basket.product_id"+i).value+"'";
					if(list_find(product_id_list,temp_product_id,','))
					{
						alert("<cf_get_lang dictionary_id='60443.Aynı Ürünü Bir Defa Seçebilirsiniz'> !");
						return false;
					}
					else
					{
						if(list_len(product_id_list,',') == 0)
							product_id_list+=temp_product_id;
						else
							product_id_list+=","+temp_product_id;
					}
				}
				else
				{
					temp_stock_id = "'"+eval("form_basket.stock_id"+i).value+"'";
					if(list_find(stock_id_list,temp_stock_id,','))
					{
						alert("<cf_get_lang dictionary_id='60443.Aynı Ürünü Bir Defa Seçebilirsiniz'> !");
						return false;
					}
					else
					{
						if(list_len(stock_id_list,',') == 0)
							stock_id_list+=temp_stock_id;
						else
							stock_id_list+=","+temp_stock_id;
					}		
				}
			}
		}
	
		<cfif get_catalog_detail.is_applied neq 1 and isdefined("extra_price_list") and len(extra_price_list)>
			if(form_basket.stage_id.value ==  -2)
			{
				if(confirm("<cf_get_lang dictionary_id ='37953.Kataloğu Yayın Aşamasına Getirdiniz Ürünler İçin Satırdaki Tüm Fiyat Listelerine Fiyat Yazılacak Emin misiniz?'>") == true)
					return true;
				else
					return false;
			}
		</cfif>
		unformat_fields();
		if(date_check(form_basket.startdate,form_basket.finishdate,"<cf_get_lang dictionary_id ='37801.Geçerlilik Tarihleri Hatalı, Lütfen Düzeltin'> !"))
		{
			if(form_basket.kondusyon_date != undefined)
			{
				if(date_check(form_basket.kondusyon_date,form_basket.finishdate,"<cf_get_lang dictionary_id ='37802.Kondüsyon Tarihi Geçerlilik Bitişinden Önce Olmalı, Lütfen Düzeltin '>!"))
					return true;
				else
					return false;
			}
			else
				return true;
		}
		else
			return false;
	}
	
	function unformat_fields()
	{
		var round_num_ = "<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>";
		for(var i=1; i<=row_count; i++)
		{
			var str_me=eval("form_basket.p_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.p_price_kdv"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.s_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.row_nettotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.tax_purchase"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.row_lasttotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.tax"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.action_profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.action_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.action_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.returning_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.returning_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.action_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.returning_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);		
			var str_me=eval("form_basket.rebate_cash_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.rebate_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.extra_product_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.extra_product_2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.return_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.return_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.price_protection_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.unit_sale"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.total_sale"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.new_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			var str_me=eval("form_basket.new_marj"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
		<cfif isdefined("extra_price_list") and len(extra_price_list)>
			<cfoutput query="get_price_cat_row">
				var str_me=eval("form_basket.new_price_kdv#get_price_cat_row.price_catid#"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
			</cfoutput>
		</cfif>
		}
	}
</script>
