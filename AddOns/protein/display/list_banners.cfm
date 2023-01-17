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
<cfinclude template="../protein_upper.cfm">
<cfform name="form" method="post" action="#request.self#?fuseaction=protein.list_banners">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="#getLang('content',6)#">
	<cf_big_list_search_area>
		<div class="row">
				<div class="col col-12 uniqueRow">
					<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
						<div class="form-group require">	
									<div class="col col-1 col-sm-12" style="text-align:right"><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="Filtrele" maxlength="50" style="width:100px;"></div>
									<div class="col col-1 col-sm-12">
										<select name="banner_area_id" id="banner_area_id" class="form-control" style="width:150px">
											<option value="" selected="selected"><cfoutput>#getLang('content',11)#</cfoutput></option>
											<option value="1">1- <cfoutput>#getLang('content',110)#</cfoutput> </option>
											<option value="2">2- <cfoutput>#getLang('content',186)#</cfoutput></option>
											<option value="3">3- <cfoutput>#getLang('content',112)#</cfoutput></option>
											<option value="4">4- <cfoutput>#getLang('content',119)#</cfoutput></option>
											<option value="5">5- <cfoutput>#getLang('content',122)#</cfoutput></option>
											<option value="6">6- <cfoutput>#getLang('content',123)#</cfoutput> </option>
											<option value="7">7- <cfoutput>#getLang('content',127)#</cfoutput></option>
											<option value="8">8- <cfoutput>#getLang('content',128)#</cfoutput> 1</option>
											<option value="9" >9- <cfoutput>#getLang('content',128)#</cfoutput> 2</option>
											<option value="10">10- <cfoutput>#getLang('content',128)#</cfoutput> 3</option>
											<option value="11">11- <cfoutput>#getLang('content',138)#</cfoutput></option>
											<option value="12">12- <cfoutput>#getLang('content',151)#</cfoutput></option>
										</select>
									</div>
									<div class="col col-1 col-sm-12">
										<select name="menu_id" id="menu_id" class="form-control" style="width:150px">
											<option value=""><cf_get_lang no='19.Özel Menü'></option>
											<cfoutput query="get_main_menus">
												<option value="#menu_id#" <cfif attributes.menu_id eq menu_id> selected</cfif>>#menu_name#</option>
											</cfoutput>
										</select>
									</div>
									<div class="col col-1 col-sm-12" style="text-align:right;">
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
											<option value=""> <cfoutput>#getLang('main',583)#</cfoutput></option>
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
									<div class="col col-1 col-sm-12">
										<select name="yayin_type" id="yayin_type" style="width:85px">
											<option value=""><cfoutput>#getLang('main',218)#</cfoutput>
											<option value="1"<cfif attributes.yayin_type eq 1> selected</cfif>><cfoutput>#getLang('content',193)#</cfoutput></option>
											<option value="2"<cfif attributes.yayin_type eq 2> selected</cfif>><cfoutput>#getLang('content',33)#</cfoutput></option>
											<option value="3"<cfif attributes.yayin_type eq 3>selected</cfif>><cfoutput>#getLang('content',29)#</cfoutput></option>
											<option value="4"<cfif attributes.yayin_type eq 4>selected</cfif>><cfoutput>#getLang('content',31)#</cfoutput></option>
										</select>
									</div>
									<div class="col col-1 col-sm-12">
										<cfquery name="GET_LANGUAGE" datasource="#DSN#">
												SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
										</cfquery>
										<select name="durum_type" id="durum_type">
											<option value=""><cfoutput>#getLang('main',344)#</cfoutput></option>
											<option value="1"<cfif attributes.durum_type eq 1> selected</cfif>><cfoutput>#getLang('main',81)#</cfoutput></option>
											<option value="2"<cfif attributes.durum_type eq 2> selected</cfif>><cfoutput>#getLang('main',82)#</cfoutput></option>
										</select>
									</div>
									<div class="col col-1 col-sm-12">
										<select name="language_id" id="language_id">
											<option value=""><cfoutput>#getLang('main',1584)#</cfoutput></option>
											<cfoutput query="get_language">
											  <option value="#language_short#" <cfif attributes.language_id eq language_short>selected</cfif>>#language_set#</option>
											</cfoutput>
										</select>
									</div>
									<div class="col col-1 col-sm-12">
										<cfsavecontent variable="message"><cfoutput>#getLang('main',125)#</cfoutput></cfsavecontent>
										<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
									</div>
									<div class="col col-4 col-sm-12">
										<cf_wrk_search_button>
									</div>
							</div><!--search bitti -->
						</div>
					</div>
				</div>
		</cf_big_list_search_area>
		<cf_big_list_search_detail_area>
			<div class="row form-inline">
				<div class="form-group">
                    <div class="input-group">
							<input type="hidden" name="product_id"  id="product_id" value="<cfif isdefined("attributes.product_id")><cfoutput>#attributes.product_id#</cfoutput></cfif>">
							<input type="text" name="product_name" id="product_name" placeholder="<cfoutput>#getLang('main',245)#</cfoutput>" value="<cfif isdefined("attributes.product_name")><cfoutput>#attributes.product_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');" style="width:100px;">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form.product_id&field_name=form.product_name','list');"></span>
					</div>
				</div>
					
				<div class="form-group">
                    <div class="input-group">		
							<input type="hidden" name="brand_id"  id="brand_id" value="<cfif isdefined("attributes.brand_id")><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
							<input name="brand_name" type="text" placeholder="<cfoutput>#getLang('main',1435)#</cfoutput>"  id="brand_name" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','form','3','100');" value="<cfif isdefined("attributes.brand_name")><cfoutput>#attributes.brand_name#</cfoutput></cfif>" autocomplete="off" style="width:100px;">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=form.brand_id&brand_name=form.brand_name','small');"></span>
					</div>
				</div>
				<div class="form-group">
                    <div class="input-group">
							<input type="hidden" name="productcat_id" id="productcat_id" value="<cfif isdefined("attributes.productcat_id")><cfoutput>#attributes.productcat_id#</cfoutput></cfif>">
							<input name="product_cat" type="text" id="product_cat" placeholder="<cfoutput>#getLang('main',1604)#</cfoutput>"  onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');" value="<cfif isdefined("attributes.product_cat")><cfoutput>#attributes.product_cat#</cfoutput></cfif>" autocomplete="off" style="width:100px;">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=form.productcat_id&field_name=form.product_cat','list');"></span>
						</div>
				</div>
				<div class="form-group">
                    <div class="input-group">
						 <cfsavecontent variable="date_alert"><cfoutput>#getLang('service',293)#</cfoutput></cfsavecontent>
						 <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
							 <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" message="#date_alert#">
						 <cfelse>
							 <cfinput type="text" name="start_date" id="start_date" value="" validate="eurodate" message="#date_alert#" style="width:70px;">
						 </cfif>
						 
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
				</div>
				<div class="form-group">
                    <div class="input-group">
						<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
							<cfsavecontent variable="date_alert"><cfoutput>#getLang('service',293)#</cfoutput>!</cfsavecontent>
							<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#"  validate="eurodate" message="#date_alert#">
						<cfelse>
							<cfinput type="text" name="finish_date" id="finish_date" value="" validate="eurodate" message="#date_alert#">
						</cfif>	
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
			</div>
							
		</cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
        <cf_big_list>
	                <thead>
						<tr>
							<th width="15"><cfoutput>#getLang('main',1165)#</cfoutput></th>
							<th><cfoutput>#getLang('content',6)#</cfoutput></th>
							<th><cfoutput>#getLang('main',218)#</cfoutput>/<cfoutput>#getLang('content',115)#</cfoutput></th>
							<th><cfoutput>#getLang('main',580)#</cfoutput></th>
							<th><cfoutput>#getLang('main',1435)#</cfoutput></th>
							<th><cfoutput>#getLang('main',245)#</cfoutput></th>
							<th><cfoutput>#getLang('main',330)#</cfoutput></th>
							<th><cfoutput>#getLang('main',71)#</cfoutput></th>
							<th><cfoutput>#getLang('main',1584)#</cfoutput></th>
							<!-- sil -->
							<th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=protein.list_banners&event=add"><img src="/images/plus_list.gif"  alt="<cfoutput>#getLang('content',7)#</cfoutput>" title="<cfoutput>#getLang('content',7)#</cfoutput>"></a></th>
							<!-- sil -->
						</tr>
					</thead>
					<tbody>
					
						<cfif get_banners.recordcount>
							<cfoutput query="get_banners" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr> 
									<td>#currentrow#</td>
									<td><a href="javascript://" onClick="windowopen('#file_web_path#content/banner/#banner_file#','medium');" class="tableyazi">#banner_name#</a></td>
									<td nowrap="nowrap"><cfif get_banners.is_flash eq 1><cf_get_lang no='193.Flash Logo'><cfif (get_banners.is_homepage) or (get_banners.is_login_page_employee eq 1) or (get_banners.is_login_page eq 1)>,</cfif></cfif>
										<cfif get_banners.is_homepage eq 1><cf_get_lang no ='33.Anasayfa'><cfif (get_banners.is_login_page_employee eq 1) or (get_banners.is_login_page eq 1)>,</cfif></cfif>
										<cfif get_banners.is_login_page eq 1><cf_get_lang no='29.Partner Portal'><cfif get_banners.is_login_page_employee eq 1>,</cfif></cfif>
										<cfif get_banners.is_login_page_employee eq 1><cf_get_lang no='31.Employee Portal'></cfif>
									</td>
									<td><cfif get_banners.banner_area_id eq 1>
											#getLang('content',110)#
										<cfelseif get_banners.banner_area_id eq 2>
											#getLang('content',112)#
										<cfelseif get_banners.banner_area_id eq 3>
											#getLang('content',116)#
										<cfelseif get_banners.banner_area_id eq 4>
											#getLang('content',119)#
										<cfelseif get_banners.banner_area_id eq 5>
											#getLang('content',122)#
										<cfelseif get_banners.banner_area_id eq 6>
											#getLang('content',123)#
										<cfelseif get_banners.banner_area_id eq 7>
											#getLang('content',127)#
										<cfelseif get_banners.banner_area_id eq 8>
											#getLang('content',128)# 1
										<cfelseif get_banners.banner_area_id eq 9>
											#getLang('content',128)# 2
										<cfelseif get_banners.banner_area_id eq 10>
											#getLang('content',128)# 3
										<cfelseif get_banners.banner_area_id eq 11>
											#getLang('content',138)#
										<cfelseif get_banners.banner_area_id eq 12>
											#getLang('content',151)#
										</cfif>
										
									<!---<cfif len(get_banners.banner_area_id)>#banner_area_id#.<cf_get_lang_main no='580.Bölge'></cfif>---></td>
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
									<td style="width:140px;">#dateformat(start_date,"dd/mm/yyyy")# - #dateformat(finish_date,"dd/mm/yyyy")#</td>
									<td style="width:90px;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
									<td style="width:40px;">#UCase(language)#</td>
									<!-- sil -->
									<td style="width:15px; text-align:center"><a href="#request.self#?fuseaction=content.upd_banner&banner_id=#banner_id#"><img src="/images/update_list.gif" alt="<cf_get_lang no='72.Banner Güncelle'>" title="<cf_get_lang no='72.Banner Güncelle'>"></a></td>
									<!-- sil -->
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
							</tr>
						</cfif>
					</tbody>
				
		</cf_big_list>
	

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
<cfinclude template="../protein_footer.cfm">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
