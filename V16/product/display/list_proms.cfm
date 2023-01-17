<cf_get_lang_set module_name="product">
<cfset xml_page_control_list = 'is_product_code_2'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.list_promotions">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.supplier_id" default="">
<cfparam name="attributes.supplier_name" default="">
<cfparam name="attributes.keyword" default="">
<!--- <cfparam name="attributes.discount_type_id_2" default=''> --->
<cfparam name="attributes.price_catid" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.prom_stage" default="">
<cfparam name="attributes.is_status" default="1">
<cfparam name="attributes.collacted_status" default="">
<cfparam name="attributes.supplier_id" default="">
<cfparam name="attributes.brand_id" default="">
<cfif session.ep.isBranchAuthorization>
	<cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
</cfif>
<cfif isdefined('attributes.supplier_id') and len (attributes.supplier_id) and not isdefined("attributes.supplier_name")>
	<cfquery name="get_company_name" datasource="#dsn#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.supplier_id#
	</cfquery>
	<cfset attributes.supplier_name = get_company_name.fullname>
</cfif>
<cfquery name="get_emp_position_cat_id" datasource="#dsn#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
	WHERE 
		PRICE_CAT_STATUS = 1 
	<cfif isDefined("attributes.pcat_id") and len(attributes.pcat_id)>
		AND PRICE_CATID = #attributes.PCAT_ID#
	</cfif>
	<!--- Pozisyon tipine gore yetki veriliyor  --->
	<cfif isDefined("xml_related_position_cat") and xml_related_position_cat eq 1>
		AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
	</cfif>
	<!--- //Pozisyon tipine gore yetki veriliyor  --->
	ORDER BY
		PRICE_CAT
</cfquery> 
<cfif isdefined("attributes.is_submitted")>
<cfinclude template="../query/get_proms.cfm">
<cfelse>
	<cfset proms.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfif isDefined("session.ep.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default="#proms.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.start_date)><cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)></cfif>
<cfif isdate(attributes.finish_date)><cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)></cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search plus="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" placeholder="#message#" name="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="is_status" id="is_status" >
						<option value=""><cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group" id="item-submit">    
                    <a href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='37554.Promosyon Ekle'>"></i></a>
                </div>
				<div class="form-group" >    
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_promotions&event=addCollacted" ><i  class="fa fa-tags "  title="<cf_get_lang dictionary_id ='37642.Toplu Promosyon Ekle'>"></i></a>
                </div> 
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-product_cat">
						<label><cf_get_lang dictionary_id='57486.Ürün Kategorisi'></label>
						<div class="input-group">
							<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
							<input type="text" name="product_cat" id="product_cat" value="<cfoutput>#attributes.product_cat#</cfoutput>">
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=search.product_catid&field_name=search.product_cat</cfoutput>');"></span>
						</div>
					</div>
					<div class="form-group" id="item-product_name">
						<label><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="input-group">
							<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
							<input type="text" name="product_name" id="product_name"  onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','','3','200');" value="<cfoutput>#attributes.product_name#</cfoutput>" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search.stock_id&field_name=search.product_name','list');"></span>
						</div>
					</div>
					<div class="form-group" id="item-price_cat">
						<label><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
						<select name="price_catid" id="price_catid">
							<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfif session.ep.isBranchAuthorization eq 0>
								<cfif attributes.price_catid is "-1">
									<option value="-1" selected><cf_get_lang dictionary_id='58722.Standart Alış'></option>
									<option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
								<cfelse>
									<option value="-1"><cf_get_lang dictionary_id='58722.Standart Alış'></option>
									<option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
								</cfif>
							<cfelse>
								<cfif attributes.price_catid is "-2">
									<option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
								<cfelse>
									<option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
								</cfif>
							</cfif>
							<cfoutput query="get_price_cat"> 
								<option value="#price_catid#"<cfif (price_catid is attributes.price_catid)> selected</cfif>>#price_cat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-ProductBrand">
						<label><cf_get_lang dictionary_id='58847.Marka'></label>
							<cf_wrkProductBrand width="120" compenent_name="getProductBrand" boxwidth="240" boxheight="150" brand_ID="#attributes.brand_id#">
					</div>
					<div class="form-group" id="item-company">
						<label><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="input-group">
							<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
							<input name="company" type="text" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" value="<cfoutput>#attributes.company#</cfoutput>" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search.company&field_comp_id=search.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.search.company.value),'list','popup_list_pars');"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-supplier_id">
						<label><cf_get_lang dictionary_id='29533.Tedarikci'></label>
						<div class="input-group">
							<input type="hidden" name="supplier_id" id="supplier_id" value="<cfoutput>#attributes.supplier_id#</cfoutput>">
							<input name="supplier_name" type="text" id="supplier_name" onFocus="AutoComplete_Create('supplier_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','supplier_id','','3','250');" value="<cfif len(attributes.supplier_id)><cfoutput>#attributes.supplier_name#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search.supplier_name&field_comp_id=search.supplier_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.search.supplier_name.value),'list','popup_list_pars');"></span>
						</div>
					</div>
					<div class="form-group" id="item-collacted_status">
						<label><cf_get_lang dictionary_id='37488.Promosyon Türü'></label>
						<select name="collacted_status" id="collacted_status">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="0" <cfif attributes.collacted_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57583.Promosyonlar'></option>
							<option value="1" <cfif attributes.collacted_status eq 1>selected</cfif>><cf_get_lang dictionary_id='58057.Toplu'> <cf_get_lang dictionary_id='57583.Promosyonlar'></option>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
					<div class="form-group">
						<label><cf_get_lang dictionary_id='58924.Sıralama'></label>
						<select name="oby" id="oby">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='37930.İsme Göre'></option>
							<option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='58925.Tarihe Göre'></option>
							<option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='37932.Promosyon No ya Göre'></option>
							<option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='37933.Çalışma Sırasına Göre'></option>
						</select>
					</div>
					<div class="form-group" id="item-date">
						<label><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-6 pl-0">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Baslama tarihi girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="col col-6 pr-0">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="finish_date" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='61492.Promotions'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<cfif attributes.collacted_status neq 1>
						<th><cf_get_lang dictionary_id='57487.No'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57518.stok kodu'></th>
					<th><cf_get_lang dictionary_id='57657.ürün'></th>
					<th><cf_get_lang dictionary_id='37592.Promosyon Başlığı'></th>
					<th><cf_get_lang dictionary_id='62823.Promotion Code'></th>
					<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th width="80"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>	
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th width="90"><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='37909.Çalışma Sırası'></th>
					<cfif session.ep.isBranchAuthorization eq 0>
					<!-- sil -->
						<th width="20" class="header_icn_none" >
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_promotions&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='37554.Promosyon Ekle'>"></i></a>
						</th>
						<th width="20">
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_promotions&event=addCollacted"><i class="fa fa-tags" title="<cf_get_lang dictionary_id ='37642.Toplu Promosyon Ekle'>"></i></a>
						</th>
						<cfif (session.ep.isBranchAuthorization) or listfindnocase(partner_url,'#cgi.http_host#',';')>
							<th>
								<a href="javascript://"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>" alt="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
							</th>
						</cfif>
					<!-- sil -->
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif proms.recordcount>
					<cfset prom_stage_list=''>
					<cfset proms_stock_list=''>
					<cfset proms_camp_list=''>
					<cfoutput query="proms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(prom_stage) and not listfind(prom_stage_list,prom_stage)>
							<cfset prom_stage_list=listappend(prom_stage_list,prom_stage)>
						</cfif>
						<cfif len(stock_id) and not listfind(proms_stock_list,stock_id)>
							<cfset proms_stock_list=listappend(proms_stock_list,stock_id)>
						</cfif>
						<cfif len(camp_id) and not listfind(proms_camp_list,camp_id)>
							<cfset proms_camp_list=listappend(proms_camp_list,camp_id)>
						</cfif>
					</cfoutput>
					<cfif len(prom_stage_list)>
						<cfset prom_stage_list=listsort(prom_stage_list,"numeric","ASC",",")>
						<cfquery name="process_type" datasource="#dsn#">
							SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#prom_stage_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
					</cfif>
					<cfif len(proms_stock_list)>
						<cfset proms_stock_list=listsort(proms_stock_list,"numeric","ASC",",")>
						<cfquery name="GET_STOCK_NAME" datasource="#DSN3#">
							SELECT S.STOCK_CODE, S.PRODUCT_NAME, S.PRODUCT_ID, S.STOCK_ID FROM STOCKS S WHERE S.STOCK_ID IN(#proms_stock_list#) ORDER BY S.STOCK_ID 
						</cfquery>
						<cfset proms_stock_list_2 = listsort(listdeleteduplicates(valuelist(GET_STOCK_NAME.STOCK_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(proms_camp_list)>
						<cfset proms_camp_list=listsort(proms_camp_list,"numeric","ASC",",")>
						<cfquery name="GET_CAMP_NAME" datasource="#DSN3#">
							SELECT CAMP_HEAD, CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID IN(#proms_camp_list#) ORDER BY CAMP_ID
						</cfquery>
					</cfif>
					<cfoutput query="proms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<cfif attributes.collacted_status neq 1> 
								<td>
									<cfif (session.ep.isBranchAuthorization) or listfindnocase(partner_url,'#cgi.http_host#',';')>
										<a href="javascript:windowopen('#request.self#?fuseaction=product.detail_promotion_unique&prom_id=#PROM_ID#','list');">#prom_no#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#prom_id#">#prom_no#</a>	
									</cfif>
								</td>
							</cfif>
							<td><cfif len(proms.stock_id)>#get_stock_name.stock_code[listfind(proms_stock_list_2,stock_id,',')]#</cfif></td>
							<td><cfif len(proms.stock_id)><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_stock_name.product_id[listfind(proms_stock_list_2,stock_id,',')]#">#get_stock_name.product_name[listfind(proms_stock_list_2,stock_id,',')]#</a></cfif></td>					
							<td>
								<cfif (session.ep.isBranchAuthorization) or listfindnocase(partner_url,'#cgi.http_host#',';')>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#PROM_ID#');">#prom_head#</a>
								<cfelse>
									<cfif len(proms.prom_relation_id)>
										<a href="#request.self#?fuseaction=product.list_promotions&event=updCollacted&prom_rel_id=#prom_relation_id#">#prom_head#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#prom_id#">#prom_head#</a>
									</cfif>
								</cfif>
							</td>
							<td>#promotion_code#</td>
							<td><cfif len(proms.camp_id)>#get_camp_name.camp_head[listfind(proms_camp_list,camp_id,',')]#<cfelse><cfif len(proms.stock_id) eq 0><cf_get_lang dictionary_id='37626.KAMPANYA HARİCİ ÜRÜNSÜZ'><cfelse><cf_get_lang dictionary_id='37627.KAMPANYA HARİCİ ÜRÜNLÜ'></cfif></cfif></td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td>#dateformat(STARTDATE,dateformat_style)#</td>
							<td>#dateformat(FINISHDATE,dateformat_style)#</td>
							<td><cfif len(prom_stage)>#process_type.stage[listfind(prom_stage_list,prom_stage,',')]#</cfif></td>
							<td><cfif prom_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td>
								<div id="upd_prom#prom_id#" style="display:none"></div> 
								<input type="text" name="prom_hierarchy#prom_id#" onkeyup="isNumber(this);" class="boxtext" maxlength="3" value="<cfif len(prom_hierarchy)>#prom_hierarchy#<cfelse>-</cfif>" onBlur="if(this.value.length && filterNum(this.value) < 0) this.value=commaSplit(0);upd_prom(this.value,#prom_id#)" id="prom_hierarchy#prom_id#">
							</td>
							<cfif session.ep.isBranchAuthorization eq 0>
								<!-- sil -->
								<td>								
									<a href="#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#prom_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a>
								</td>
								<td>	
									<cfif len(proms.prom_relation_id)>
										<a href="javascript://" onClick="window.open('#request.self#?fuseaction=product.list_promotions&event=updCollacted&prom_rel_id=#prom_relation_id#')" ><i class="fa fa-tags " title="<cf_get_lang dictionary_id='62807.Toplu Promosyon'><cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a>									
									</cfif>
								</td>
								<cfif (session.ep.isBranchAuthorization) or listfindnocase(partner_url,'#cgi.http_host#',';')> 
									<td>
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.detail_promotion_unique&prom_id=#PROM_ID#');"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='60425.Promosyon Bilgileri'>"></i></a>
									</td>
								</cfif>
								<!-- sil -->
							</cfif>			  
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="14"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = attributes.fuseaction>
		<cfif isdefined("attributes.is_submitted") and  len(attributes.is_submitted)>
			<cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif len(attributes.product_cat)> 
			<cfset adres = "#adres#&product_catid=#attributes.product_catid#">
			<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
		</cfif>
		<cfif len(attributes.product_name)> 
			<cfset adres = "#adres#&product_name=#attributes.product_name#">
			<cfset adres = "#adres#&stock_id=#attributes.stock_id#">
		</cfif>
		<cfif len(attributes.supplier_name)> 
			<cfset adres = "#adres#&supplier_name=#attributes.supplier_name#">
			<cfset adres = "#adres#&supplier_id=#attributes.supplier_id#">
		</cfif>
		<cfif isdefined("attributes.brand_name") and  len(attributes.brand_name)>
			<cfset adres = "#adres#&brand_name=#attributes.brand_name#">
			<cfset adres = "#adres#&brand_id=#attributes.brand_id#">
		</cfif>
		<cfif len(attributes.company)> 
			<cfset adres = "#adres#&company=#attributes.company#">
			<cfset adres = "#adres#&company_id=#attributes.company_id#">
		</cfif>
		<cfif len(attributes.price_catid)> 
			<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#attributes.start_date#">
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
		</cfif>
		<cfif len(attributes.is_status)> 
			<cfset adres = "#adres#&is_status=#attributes.is_status#">
		</cfif>
		<cfif len(attributes.collacted_status)> 
			<cfset adres = "#adres#&collacted_status=#attributes.collacted_status#">
		</cfif>
		<cfif isDefined('attributes.oby') and len(attributes.oby)>
			<cfset adres = "#adres#&oby=#attributes.oby#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	function upd_prom(deger,prom_id)
	{
		div_id = 'upd_prom'+prom_id;	
		if(document.getElementById('prom_hierarchy'+prom_id) != undefined && document.getElementById('prom_hierarchy'+prom_id).value.length != '')
		{
			var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_upd_prom_hierarchy&prom_id='+ prom_id +'&deger='+deger;
			AjaxPageLoad(send_address,div_id,1);
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes">
