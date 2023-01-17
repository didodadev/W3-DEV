<cf_xml_page_edit default_value="1" fuseact="product.form_upd_catalog_promotion">
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<cfquery name="get_camp_info" datasource="#dsn3#">
		SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
	</cfquery>
	<cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
	<cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
	<cfset camp_id = get_camp_info.camp_id>
	<cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,dateformat_style)#-#dateformat(camp_finish,dateformat_style)#)'>
<cfelse>
	<cfset camp_start = ''>
	<cfset camp_finish = ''>
	<cfset camp_id = ''>
	<cfset camp_head = ''>
</cfif>
<cfset module_name="product">
<cfset var_ = "add_purchase_basket">
<cfinclude template="../query/get_action_stages.cfm">
<cfinclude template="../query/get_price_cats.cfm">
<cfscript>
	std_price=StructNew();
	std_price={PRICE_CATID = -2, PRICE_CAT = "#getLang('','Standart satış',58721)#"};
	QueryAddRow(get_price_cats,std_price);
</cfscript>
<cfinclude template="../query/get_company_cat.cfm">
<!--- Aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cat.cfm">
<cfset catalog_head = isdefined("attributes.prom_head") and len(attributes.prom_head)?attributes.prom_head:''>
<cfif IsDefined("attributes.id") and len(attributes.id)>
	<cfinclude template="../query/get_catalog_promotion_detail.cfm">
	<cfset attributes.catalog_id = get_catalog_detail.catalog_id>
	<cfset attributes.catalog_head = get_catalog_detail.catalog_head>
	<cfset catalog_head = get_catalog_detail.catalog_head>
	<cfset attributes.catalog_detail = get_catalog_detail.catalog_detail>
	<cfset attributes.startdate = get_catalog_detail.startdate>
	<cfset attributes.finishdate = get_catalog_detail.finishdate>
	<cfset attributes.kondusyon_date = get_catalog_detail.kondusyon_date>
	<cfset attributes.kondusyon_finish_date = get_catalog_detail.kondusyon_finish_date>
	<cfset attributes.validator_position_code = get_catalog_detail.validator_position_code>
	<cfif len(get_catalog_detail.validator_position_code)>
		<cfset attributes.validator = get_emp_info(get_catalog_detail.validator_position_code,1,0)>
	</cfif>
	<cfif len(get_catalog_detail.camp_id)>
		<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
			SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_catalog_detail.camp_id#
		</cfquery>
		<cfif get_campaign.recordcount>
			<cfset camp_start = date_add("H",session.ep.time_zone,get_campaign.camp_startdate)>
			<cfset camp_finish = date_add("H",session.ep.time_zone,get_campaign.camp_finishdate)>
			<cfset camp_id = get_campaign.camp_id>
			<cfset camp_head = '#get_campaign.camp_head#(#dateformat(camp_start,dateformat_style)#-#dateformat(camp_finish,dateformat_style)#)'>
		</cfif>
	</cfif>
</cfif>
<cf_papers paper_type="cat_prom">
<!---<table class="dph">
	<tr>
		<td class="dpht">
			<a href="javascript:gizle_goster_ikili('detail_catalog','detail_catalog_sepet');">&raquo;</a><cf_get_lang no='291.Aksiyon Planlama Aracı'>
		</td>
		<cfif isdefined("extra_price_list") and len(extra_price_list)>
			<td class="dphb"><a href="<cfoutput>#request.self#?fuseaction=product.</cfoutput>form_add_catalog_from_file"><img src="images/file.gif" border="0" title="Excel İmport"></a></td>
		</cfif>
	</tr>
</table>--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_add_catalog_promotion">
			<cfoutput>  
				<input type="hidden" name="visible" id="visible" value="0">
				<input type="hidden" name="var_" id="var_" value="#var_#">
				<input type="hidden" name="module_name" id="module_name" value="#module_name#">
				<input type="hidden" name="catalog_id" id="catalog_id" value="<cfif IsDefined('attributes.catalog_id')>#attributes.catalog_id#</cfif>">
			</cfoutput>
			<cfif Find(fuseaction, "popup")>
				<input type="hidden" name="is_pop_true" id="is_pop_true" value="1">
			</cfif>
			<cf_basket_form>
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">                	
						<div class="form-group" id="item-catalog_head">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37210.Aksiyon'> *</label>
							<div class="col col-8 col-xs-12" <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")></cfif>>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='37399.Aksiyon Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="catalog_head" required="Yes" message="#message#" maxlength="100" value="#catalog_head#" style="width:171px;">
							</div>
						</div>
						<div class="form-group" id="item-camp_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="camp_id" id="camp_id" value="<cfif len(camp_id)><cfoutput>#camp_id#</cfoutput></cfif>">
									<input type="text" name="camp_name" id="camp_name" value="<cfif len(camp_head)><cfoutput>#camp_head#</cfoutput></cfif>" style="width:171px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=form_basket.camp_id&field_name=form_basket.camp_name&field_start_date=form_basket.startdate&field_finish_date=form_basket.finishdate<cfif (isdefined("is_condition_date") and is_condition_date eq 1) or not isdefined("is_condition_date")>&field_start_date1=form_basket.kondusyon_date&field_finish_date1=form_basket.kondusyon_finish_date</cfif>&is_next_day','list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-startdate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37398.Geçerlilik Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfif len(camp_start)>
										<cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(camp_start,dateformat_style)#">
									<cfelseif IsDefined('attributes.startdate') and len(attributes.startdate)>
										<cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(attributes.startdate,dateformat_style)#">
									<cfelse>
										<cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
									<span class="input-group-addon no-bg"></span>
									<cfif len(camp_finish)>
										<cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(date_add("d",1,camp_finish),dateformat_style)#">
									<cfelseif IsDefined('attributes.finishdate') and len(attributes.finishdate)>
										<cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(attributes.finishdate,dateformat_style)#">
									<cfelse>
										<cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
						</div>
						<cfif (isdefined("is_condition_date") and is_condition_date eq 1) or not isdefined("is_condition_date")>
						<div class="form-group" id="item-kondusyon_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37213.Kondüsyon Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37400.Kondüsyon Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfif len(camp_start)>
										<cfinput type="text" name="kondusyon_date" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(camp_start,dateformat_style)#">
									<cfelseif IsDefined('attributes.kondusyon_date') and len(attributes.kondusyon_date)>
										<cfinput type="text" name="kondusyon_date" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(attributes.kondusyon_date,dateformat_style)#">
									<cfelse>
										<cfinput type="text" name="kondusyon_date" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="kondusyon_date"></span>
									<span class="input-group-addon no-bg"></span>
									<cfif len(camp_finish)>
										<cfinput type="text" name="kondusyon_finish_date" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(date_add("d",1,camp_finish),dateformat_style)#">
									<cfelseif IsDefined('attributes.kondusyon_finish_date') and len(attributes.kondusyon_finish_date)>
										<cfinput type="text" name="kondusyon_finish_date" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;" value="#dateformat(attributes.kondusyon_finish_date,dateformat_style)#">
									<cfelse>
										<cfinput type="text" name="kondusyon_finish_date" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="kondusyon_finish_date"></span>
								</div>
							</div>
						</div>
						<cfelse>
						<div class="form-group" id="item-VALIDATOR">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="<cfoutput><cfif IsDefined('attributes.validator_position_code') and IsDefined('attributes.validator')>#attributes.validator_position_code#</cfif></cfoutput>">
									<input type="text" name="VALIDATOR" id="VALIDATOR" value="<cfoutput><cfif IsDefined('attributes.validator_position_code') and IsDefined('attributes.validator')>#attributes.validator#</cfif></cfoutput>" style="width:171px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions</cfoutput>&field_code=form_basket.VALIDATOR_POSITION_CODE&field_name=form_basket.VALIDATOR','list');"></span>
								</div>
							</div>
						</div>
						</cfif>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' is_detail='0'>
							</div>
						</div>
						<div class="form-group" id="item-stage_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57482.Asama'> *</label>
							<div class="col col-8 col-xs-12">
								<select name="stage_id" id="stage_id" style="width:150px;">
									<cfoutput query="get_action_stages">
										<option value="#stage_id#">#stage_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açiklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail" style="width:150px;height:70px;"><cfif IsDefined('attributes.catalog_detail')><cfoutput>#attributes.catalog_detail#</cfoutput></cfif></textarea>
							</div>
						</div>
						<cfif (isdefined("is_condition_date") and is_condition_date neq 0)>
							<div class="form-group" id="item-VALIDATOR">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="<cfoutput><cfif IsDefined('attributes.validator_position_code') and IsDefined('attributes.validator')>#attributes.validator_position_code#</cfif></cfoutput>">
										<input type="text" name="VALIDATOR" id="VALIDATOR" value="<cfoutput><cfif IsDefined('attributes.validator_position_code') and IsDefined('attributes.validator')>#attributes.validator#</cfif></cfoutput>" style="width:171px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions</cfoutput>&field_id=form_basket.VALIDATOR_POSITION_CODE&field_name=form_basket.VALIDATOR','list');"></span>
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
									<cfif IsDefined('price_list') and len(price_list)>
										<cf_multiselect_check 
											name="PRICE_CATS"
											option_name="price_cat"
											option_value="price_catid"
											query_name="get_price_cats"
											value="#price_list#" 
											width="250">
									<cfelse>
										<cf_multiselect_check 
											name="PRICE_CATS"
											option_name="price_cat"
											option_value="price_catid"
											query_name="get_price_cats"
											width="250">
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-companycat_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37798.Kurumsal Kategoriler'></label>
								<div class="col col-8 col-xs-12">
									<cfif IsDefined('company_list') and len(company_list)>
										<cf_multiselect_check 
											name="COMPANYCAT_ID"
											option_name="companycat"
											option_value="companycat_id"
											query_name="get_companycat"
											value="#company_list#"
											width="250">
									<cfelse>
										<cf_multiselect_check 
											name="COMPANYCAT_ID"
											option_name="companycat"
											option_value="companycat_id"
											query_name="get_companycat"
											width="250">
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-conscat_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37799.Bireysel Kategoriler'></label>
								<div class="col col-8 col-xs-12">
									<cfif IsDefined('consumer_list') and len(consumer_list)>
										<cf_multiselect_check 
											name="CONSCAT_ID"
											option_name="conscat"
											option_value="conscat_id"
											query_name="get_consumer_cat"
											value="#consumer_list#"
											width="250">
									<cfelse>
										<cf_multiselect_check 
											name="CONSCAT_ID"
											option_name="conscat"
											option_value="conscat_id"
											query_name="get_consumer_cat"
											width="250">
									</cfif>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-catalog">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59154.Katalog'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="related_catalog_id" id="related_catalog_id" value="<cfif isdefined("related_catalog_id")><cfoutput>#related_catalog_id#</cfoutput></cfif>">
                                    <input type="text" name="related_catalog_head" id="related_catalog_head" value="<cfif isdefined("related_catalog_head")><cfoutput>#related_catalog_head#</cfoutput></cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=catalogList&isbox=1&is_submitted=1&field_id=form_basket.related_catalog_id&field_name=form_basket.related_catalog_head')"></span>
                                </div>
                            </div>
                        </div>
					</div>
				</cf_box_elements>    
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cf_basket_form>
			<div id="detail_catalog_sepet"><cfinclude template="../display/basket_purchase.cfm"></div>
		</cfform>
	</cf_box>
</div>
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
		x = (250 - form_basket.detail.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id ='57629.Açıklama'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
			return false;
		}
		
		if(form_basket.herkes != undefined)
			temp3 = form_basket.herkes.checked;
		else
			temp3 = 1;
			
		temp1=0;
		
		if(form_basket.PRICE_CATS != undefined)
		{
			<cfif get_price_cats.recordcount gt 1>
				for(i=0;i<form_basket.PRICE_CATS.length;i++)
					if(form_basket.PRICE_CATS[i].checked==1)
						temp1 = 1;
			<cfelseif get_price_cats.recordcount eq 1>
				if(form_basket.PRICE_CATS.checked==1)
					temp1 = 1;
			</cfif>
		}
		
		if(row_count==0)
		{
			alert("<cf_get_lang dictionary_id='57725.ürün seçiniz'>");
			return false;
		}
		
		//Fiyat Listesi secili olmasa bile internet secili olma durumu BK 20070307
		if(form_basket.is_public != undefined && form_basket.is_public.checked==1)
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
				if(str_me_value < 0 || str_me_value > 100) {alert(i + " <cf_get_lang dictionary_id ='37803.no lu satırdaki İskonto 1 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37804.no lu satırdaki İskonto 2 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + " <cf_get_lang dictionary_id ='37805.no lu satırdaki İskonto 3 alanındaki değer, 0 ile 100 arasında olmalı '>!"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37806.no lu satırdaki İskonto 4 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + " <cf_get_lang dictionary_id ='37807.no lu satırdaki İskonto 5 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37808.no lu satırdaki İskonto 6 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37809.no lu satırdaki İskonto 7 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37810. no lu satırdaki İskonto 8 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37811.no lu satırdaki İskonto 9 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
				var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
				if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37812.no lu satırdaki İskonto 10 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
			}
			
			//Ayni urun bir satirlarda bir kez secilmeli BK 20100907
			if(eval("document.form_basket.row_kontrol"+i).value==1)	
			{
				temp_product_id = "'"+eval("form_basket.product_id"+i).value+"'";
				//Promosyonlardan aksiyon eklerken ihtiyaç duyuldupu için kapatıldı.

				// if(list_find(product_id_list,temp_product_id,','))
				// {
				// 	alert("<cf_get_lang dictionary_id='60443.Aynı Ürünü Bir Defa Seçebilirsiniz'> !");
				// 	return false;
				// }
				if(list_len(product_id_list,',') == 0)
					product_id_list+=temp_product_id;
				else
					product_id_list+=","+temp_product_id;
				
			}			
		}	
		
		<cfif isdefined("extra_price_list") and len(extra_price_list)>
			if(form_basket.stage_id.value ==  -2)
			{
				if(confirm("<cf_get_lang dictionary_id='37953.Kataloğu Yayın Aşamasına Getirdiniz. Ürünler İçin Satırdaki Tüm Fiyat Listelerine Fiyat Yazılacak. Emin misiniz?'>") == true)
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
	<cfif isdefined('is_promotion')>
		openProducts();
	</cfif>
</script>
