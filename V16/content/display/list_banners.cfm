<cfinclude template="../query/get_main_menus.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.menu_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.productcat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.banner_area_id" default="">
<cfparam name="attributes.yayin_type" default="">
<cfparam name="attributes.durum_type" default="">
<cfparam name="attributes.language_id" default="#session.ep.language#">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_banners.cfm">
<cfelse>
	<cfset get_banners.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_banners.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=content.list_banners">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="filtre"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#filtre#">
				</div>
				<div class="form-group">
					<select name="banner_area_id" id="banner_area_id">
						<option value="" selected="selected"><cf_get_lang dictionary_id='50510.Banner Bölgesi'></option>
						<option value="1">1-<cf_get_lang dictionary_id ='50609.Menü Altı Komple'> </option>
						<option value="2">2- <cf_get_lang dictionary_id ='50611.Sol Sütün Üst'></option>
						<option value="3">3- <cf_get_lang dictionary_id ='50615.Sol Sütun Alt'></option>
						<option value="4">4- <cf_get_lang dictionary_id ='50618.Sağ Sütun Üst'></option>
						<option value="5">5- <cf_get_lang dictionary_id ='50621.Sağ Sütün Alt'></option>
						<option value="6">6-<cf_get_lang dictionary_id ='50622.Orta Sütun Üst'> </option>
						<option value="7">7- <cf_get_lang dictionary_id ='50626.Orta Sütun Alt'></option>
						<option value="8">8- <cf_get_lang dictionary_id ='50627.Yanyana'> 1</option>
						<option value="9" >9- <cf_get_lang dictionary_id ='50627.Yanyana'> 2</option>
						<option value="10">10- <cf_get_lang dictionary_id ='50627.Yanyana'> 3</option>
						<option value="11">11- <cf_get_lang dictionary_id ='50637.Menü Üst'></option>
						<option value="12">12- <cf_get_lang dictionary_id ='50650.Gündemdeki Kampanya'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="menu_id" id="menu_id">
						<option value=""><cf_get_lang dictionary_id='50518.Özel Menü'></option>
						<cfoutput query="get_main_menus">
							<option value="#menu_id#" <cfif attributes.menu_id eq menu_id> selected</cfif>>#menu_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfquery name="GET_CHAPTER_HIER" datasource="#DSN#">
						SELECT 
							CC.CONTENTCAT,
							CC.CONTENTCAT_ID,
							CH.CHAPTER_ID,
							CH.CHAPTER
						FROM
							CONTENT_CAT CC,
							CONTENT_CHAPTER CH
						WHERE
							CC.CONTENTCAT_ID = CH.CONTENTCAT_ID AND
							CC.CONTENTCAT_ID <> 0
						ORDER BY
							CC.CONTENTCAT_ID
					</cfquery>
					<select name="cat" id="cat">
						<option value=""> <cf_get_lang dictionary_id='57995.Bölüm'></option>
						<cfoutput query="get_chapter_hier">
							<cfif currentrow is 1>
								<option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#">selected</cfif> >#contentcat#</option>
								<option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>
							<cfelse>
								<cfset old_row = currentrow - 1>
								<cfif contentcat_id is contentcat_id[old_row]>
									<option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>
								<cfelse>
									<option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#">selected</cfif>>#contentcat#</option>
									<option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>						  
								</cfif>
							</cfif>
						</cfoutput>
					</select>
				</div>	
				<div class="form-group">
					<select name="yayin_type" id="yayin_type">
						<option value=""><cf_get_lang dictionary_id='57630.Tip'>
						<option value="1"<cfif attributes.yayin_type eq 1> selected</cfif>><cf_get_lang dictionary_id='50692.Flash Logo'></option>
						<option value="2"<cfif attributes.yayin_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='50532.Anasayfa'></option>
						<option value="3"<cfif attributes.yayin_type eq 3>selected</cfif>><cf_get_lang dictionary_id='50528.Partner Portal'></option>
						<option value="4"<cfif attributes.yayin_type eq 4>selected</cfif>><cf_get_lang dictionary_id='50530.Employee Portal'></option>
					</select>
				</div>		
				<div class="form-group">
					<cfquery name="GET_LANGUAGE" datasource="#DSN#">
						SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
					</cfquery>
					<select name="durum_type" id="durum_type">
						<option value=""><cf_get_lang dictionary_id ='57756.Durum'></option>
						<option value="1"<cfif attributes.durum_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
						<option value="2"<cfif attributes.durum_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="language_id" id="language_id">
						<option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
						<cfoutput query="get_language">
						<option value="#language_short#" <cfif attributes.language_id eq language_short>selected</cfif>>#language_set#</option>
						</cfoutput>
					</select>
				</div>			
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>	
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-product_name">
						<label><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="input-group">
							<input type="hidden" name="product_id"  id="product_id" value="<cfif isdefined("attributes.product_id")><cfoutput>#attributes.product_id#</cfoutput></cfif>">
							<input type="text" name="product_name" id="product_name" value="<cfif isdefined("attributes.product_name")><cfoutput>#attributes.product_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');">
							<span class="input-group-addon icon-ellipsis" href="javascript://"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form.product_id&field_name=form.product_name','list');"></span>
						</div>
					</div>	
					<div class="form-group" id="item-brand_name">
						<label><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="input-group">
							<input type="hidden" name="brand_id"  id="brand_id" value="<cfif isdefined("attributes.brand_id")><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
							<input name="brand_name" type="text" id="brand_name" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','form','3','100');" value="<cfif isdefined("attributes.brand_name")><cfoutput>#attributes.brand_name#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" href="javascript://"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=form.brand_id&brand_name=form.brand_name','small');"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-product_cat">
						<label><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
						<div class="input-group">
							<input type="hidden" name="productcat_id" id="productcat_id" value="<cfif isdefined("attributes.productcat_id")><cfoutput>#attributes.productcat_id#</cfoutput></cfif>">
							<input name="product_cat" type="text" id="product_cat" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');" value="<cfif isdefined("attributes.product_cat")><cfoutput>#attributes.product_cat#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" href="javascript://"onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=form.productcat_id&field_name=form.product_cat');"></span>
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
							<div class="input-group">
								<cfsavecontent variable="date_alert"><cf_get_lang dictionary_id ='57738.Lütfen Başlangıç Tarihini Giriniz'></cfsavecontent>
								<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
									<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#date_alert#">
								<cfelse>
									<cfinput type="text" name="start_date" id="start_date" value="" validate="#validate_style#" message="#date_alert#" style="width:70px;">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
							<div class="input-group">
								<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
									<cfsavecontent variable="date_alert"><cf_get_lang dictionary_id ='50693.Lütfen Bitiş Tarihi Giriniz'>!</cfsavecontent>
									<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#date_alert#">
								<cfelse>
									<cfinput type="text" name="finish_date" id="finish_date" value="" style="width:65px;" validate="#validate_style#" message="#date_alert#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(6,'Banner',50505)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='50505.Banner'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'>/<cf_get_lang dictionary_id='50560.Yayın ALanı'></th>
					<th><cf_get_lang dictionary_id='57992.Bölge'></th>
					<th><cf_get_lang dictionary_id='58847.Marka'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id='58996.Dil'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.list_banners&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='50506.Banner Ekle'>" title="<cf_get_lang dictionary_id='50506.Banner Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_banners.recordcount>
					<cfoutput query="get_banners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr> 
							<td>#currentrow#</td>
							<td><a href="javascript://" onClick="windowopen('#file_web_path#content/banner/#banner_file#','medium');">#banner_name#</a></td>
							<td nowrap="nowrap"><cfif get_banners.is_flash eq 1><cf_get_lang dictionary_id='50692.Flash Logo'><cfif (get_banners.is_homepage) or (get_banners.is_login_page_employee eq 1) or (get_banners.is_login_page eq 1)>,</cfif></cfif>
								<cfif get_banners.is_homepage eq 1><cf_get_lang dictionary_id ='50532.Anasayfa'><cfif (get_banners.is_login_page_employee eq 1) or (get_banners.is_login_page eq 1)>,</cfif></cfif>
								<cfif get_banners.is_login_page eq 1><cf_get_lang dictionary_id='50528.Partner Portal'><cfif get_banners.is_login_page_employee eq 1>,</cfif></cfif>
								<cfif get_banners.is_login_page_employee eq 1><cf_get_lang dictionary_id='50530.Employee Portal'></cfif>
							</td>
							<td><cfif get_banners.banner_area_id eq 1>
									<cf_get_lang dictionary_id ='50609.Menü Altı Komple'>
								<cfelseif get_banners.banner_area_id eq 2>
									<cf_get_lang dictionary_id ='50611.Sol Sütün Üst'>
								<cfelseif get_banners.banner_area_id eq 3>
									<cf_get_lang dictionary_id ='50615.Sol Sütun Alt'>
								<cfelseif get_banners.banner_area_id eq 4>
									<cf_get_lang dictionary_id ='50618.Sağ Sütun Üst'>
								<cfelseif get_banners.banner_area_id eq 5>
									<cf_get_lang dictionary_id ='50621.Sağ Sütün Alt'>
								<cfelseif get_banners.banner_area_id eq 6>
									<cf_get_lang dictionary_id ='50622.Orta Sütun Üst'>
								<cfelseif get_banners.banner_area_id eq 7>
									<cf_get_lang dictionary_id ='50626.Orta Sütun Alt'>
								<cfelseif get_banners.banner_area_id eq 8>
									<cf_get_lang dictionary_id ='50627.Yanyana'> 1
								<cfelseif get_banners.banner_area_id eq 9>
									<cf_get_lang dictionary_id ='50627.Yanyana'> 2
								<cfelseif get_banners.banner_area_id eq 10>
									<cf_get_lang dictionary_id ='50627.Yanyana'> 3
								<cfelseif get_banners.banner_area_id eq 11>
									<cf_get_lang dictionary_id ='50637.Menü Üst'>
								<cfelseif get_banners.banner_area_id eq 12>
									<cf_get_lang dictionary_id ='50650.Gündemdeki Kampanya'>
								</cfif>
								
							<!---<cfif len(get_banners.banner_area_id)>#banner_area_id#.<cf_get_lang dictionary_id='580.Bölge'></cfif>---></td>
							<td><cfif len(GET_BANNERS.banner_brand_id)>
								<cfquery name="GET_PRODUCT_BRANDS" datasource="#DSN3#">
									SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_banners.banner_brand_id#">
								</cfquery>
								#get_product_brands.brand_name#
								<cfelse>
								</cfif>
							</td>
							<td>
								<cfif len(get_banners.banner_product_id)>
									<cfquery name="GET_PRODUCT" datasource="#DSN3#">
										SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_banners.banner_product_id#">
									</cfquery>
									#get_product.product_name#
								<cfelse>
								</cfif>
							</td>
							<td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#employee_name# #employee_surname#</a></td>
							<td>#UCase(language)#</td>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=content.list_banners&event=upd&banner_id=#banner_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='50571.Banner Güncelle'>" title="<cf_get_lang dictionary_id='50571.Banner Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>	
		<cfset adres = "content.list_banners">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
			<cfset adres = '#adres#&product_id=#attributes.product_id#'>
		</cfif>
		<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
			<cfset adres = '#adres#&product_name=#attributes.product_name#'>
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
			<cfset adres = '#adres#&brand_id=#attributes.brand_id#'>
		</cfif>
		<cfif isdefined("attributes.brand_name") and len(attributes.brand_name)>
			<cfset adres = '#adres#&brand_name=#attributes.brand_name#'>
		</cfif>
		<cfif isdefined("attributes.productcat_id") and len(attributes.productcat_id)>
			<cfset adres = '#adres#&productcat_id=#attributes.productcat_id#'>
		</cfif>
		<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
			<cfset adres = '#adres#&product_cat=#attributes.product_cat#'>
		</cfif>
		<cfif isdefined("attributes.banner_area_id") and len(attributes.banner_area_id)>
			<cfset adres = '#adres#&banner_area_id=#attributes.banner_area_id#'>
		</cfif>
		<cfif isdefined("attributes.menu_id") and len(attributes.menu_id)>
			<cfset adres = '#adres#&menu_id=#attributes.menu_id#'>
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
