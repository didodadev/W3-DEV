<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="product">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.keyword" default="">
<cfif session.ep.our_company_info.unconditional_list>
  <cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
		get_product_cost_action = createObject("component", "V16.product.cfc.get_product_cost");
		get_product_cost_action.dsn3 = dsn3;
		get_product_cost_action.dsn2 = dsn2;
		get_product_cost_action.dsn3_alias = dsn3_alias;
		get_product_cost_action.dsn_alias = dsn_alias;
		get_product_cost = get_product_cost_action.get_product_cost_fnc(
			module_name : '#fusebox.circuit#',
			product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
			product_types : '#iif(isdefined("attributes.product_types"),"attributes.product_types",DE(""))#',
			pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
			company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
			brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
			cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
			keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			special_code : '#iif(isdefined("attributes.special_code"),"attributes.special_code",DE(""))#',
			inventory_calc_type : '#iif(isdefined("attributes.inventory_calc_type"),"attributes.inventory_calc_type",DE(""))#'
		);
	</cfscript>
	<cfset arama_yapilmali=0>
  <cfelse>
	<cfset get_product_cost.recordcount=0>
	<cfset arama_yapilmali=1>
  </cfif>
<cfelse>
  <cfif isdefined("attributes.is_form_submitted") and 
	(
		(isdefined("attributes.keyword") and len(attributes.keyword)) or 
		(isdefined("attributes.cat") and len(attributes.cat)) or
		(isdefined("attributes.inventory_calc_type") and len(attributes.inventory_calc_type)) or 
		(isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)) or 
		(isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined("attributes.pos_manager") and len(attributes.pos_manager)) or 
		(isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))
	)>
	<cfscript>
		get_product_cost_action = createObject("component", "V16.product.cfc.get_product_cost");
		get_product_cost_action.dsn3 = dsn3;
		get_product_cost_action.dsn2 = dsn2;
		get_product_cost_action.dsn3_alias = dsn3_alias;
		get_product_cost_action.dsn_alias = dsn_alias;
		get_product_cost = get_product_cost_action.get_product_cost_fnc(
			module_name : '#fusebox.circuit#',
			product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
			product_types : '#iif(isdefined("attributes.product_types"),"attributes.product_types",DE(""))#',
			pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
			company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
			brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
			cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
			keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			special_code : '#iif(isdefined("attributes.special_code"),"attributes.special_code",DE(""))#',
			inventory_calc_type : '#iif(isdefined("attributes.inventory_calc_type"),"attributes.inventory_calc_type",DE(""))#'
		);
	</cfscript>
	<cfset arama_yapilmali=0>
  <cfelse>
	<cfset get_product_cost.recordcount=0>
	<cfset arama_yapilmali=1>
  </cfif>
</cfif>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT 
		COMPETITIVE_ID
	FROM
		PRODUCT_COMP_PERM 
	WHERE 
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset COMPETITIVE_LIST = ValueList(get_competitive_list.competitive_id)>
<cfinclude template="../query/get_price_cat.cfm">
<cfparam name="attributes.page" default=1>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_product_cost.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group">
					<select name="inventory_calc_type" id="inventory_calc_type"  style="width:125px;">
						<option value=""><cf_get_lang dictionary_id ='37510.Envanter Yöntemi'></option>
						<option value="1"<cfif isdefined('attributes.inventory_calc_type') and inventory_calc_type eq 1> selected</cfif>><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'></option><!--- 1:fifo --->
						<option value="3"<cfif isdefined('attributes.inventory_calc_type') and inventory_calc_type eq 3> selected</cfif>><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></option><!--- 3:gpa --->
					</select>	
				</div>
				<div class="form-group">
					<select name="product_status" id="product_status" style="width:50px;">
						<option value="1"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 2)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes"  maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='input_control()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript://" title="<cf_get_lang dictionary_id='37699.Barkod ara'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_barcod_search');"><i class="fa fa-barcode"></i></a>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-product_cat">
						<label class="col col-12"><cf_get_lang dictionary_id='58137.Kategoriler'></label>
						<div class="col col-12">
							<cfinclude template="../query/get_product_cat.cfm">
							<select name="cat" id="cat" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='58137.Kategoriler'></option>
								<cfoutput query="get_product_cat">
								<cfif listlen(hierarchy,".") lte 3>
									<option value="#hierarchy#"<cfif attributes.cat eq hierarchy and len(attributes.cat) eq len(hierarchy)>selected</cfif>>#hierarchy#-#product_cat#</option>
								</cfif>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-product_types">
						<label class="col col-12"><cf_get_lang dictionary_id='57789.Ozel Kod'></label>
						<div class="col col-12">
							<select name="product_types" id="product_types" style="width:105px;">
								<option value=""><cf_get_lang dictionary_id='46862.Ürün Bilgileri'></option>
								<option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang dictionary_id='37170.TEdarik Edilmiyor'></option>
								<option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang dictionary_id='37061.TEdarik Ediliyor'></option>
								<option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang dictionary_id='37090.Hizmetler'></option>
								<option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang dictionary_id='37423.Mallar'></option>
								<option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang dictionary_id='37066.Terazi'></option>
								<option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang dictionary_id='37057.Üretiliyor'></option>
								<option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang dictionary_id='37557.Seri No Takip'></option>
								<option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang dictionary_id='37467.Karma Koli'></option>
								<option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
								<option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang dictionary_id='37063.Özelleştirilebilir'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-special_code">
						<label class="col col-12"><cf_get_lang dictionary_id='57789.Ozel Kod'></label>
						<div class="col col-12">
							<input type="text" maxlength="50" name="special_code" id="special_code" value="<cfif isdefined("attributes.special_code")><cfoutput>#attributes.special_code#</cfoutput></cfif>" style="width:120px;">
						</div>
					</div>
					<div class="form-group" id="item-">
						<label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="col col-12">
							<cf_wrkProductBrand
								width="135"
								compenent_name="getProductBrand"               
								boxwidth="240"
								boxheight="150"
								brand_ID="#attributes.brand_id#">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-pos_manager">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined("attributes.pos_code")><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
								<input name="pos_manager" type="text" id="pos_manager" style="width:135px;" onFocus="AutoComplete_Create('pos_manager','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135');" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)><cfoutput>#attributes.pos_manager#</cfoutput></cfif>" maxlength="255" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_product.pos_code&field_code=search_product.pos_code&field_name=search_product.pos_manager&select_list=1,9&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.pos_manager.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input name="company" type="text" id="company"  style="width:135px;"  onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.company&field_comp_id=search_product.company_id&select_list=2&keyword='+encodeURIComponent(document.search_product.company.value),'list');"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58258.Maliyet'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57647.Spec'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></th>
					<cfif session.ep.isBranchAuthorization><th><cf_get_lang dictionary_id='57572.Departman'> - <cf_get_lang dictionary_id='30031.Lokasyon'></th></cfif>
					<th><cf_get_lang dictionary_id='37523.Alış Net Maliyet'></th>
					<th><cf_get_lang dictionary_id='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
					<th><cf_get_lang dictionary_id='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='37511.Sabit Maliyet'></th>
					<th><cf_get_lang dictionary_id='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='37511.Sabit Maliyet'> %</th>
					<th><cf_get_lang dictionary_id='37518.Fiyat Koruma'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='37497.Toplam Maliyet'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_product_cost.recordcount>
					<cfoutput query="get_product_cost" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product_cost.product_id#" class="tableyazi">#product_code#</a></td>
							<td><a href="#request.self#?fuseaction=#fusebox.Circuit#.list_product&event=det&pid=#get_product_cost.product_id#" class="tableyazi">#PRODUCT_NAME#</a></td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#SPECT_MAIN_ID#','medium');" class="tableyazi">#SPECT_MAIN_ID#</a></td>
							<td>#dateformat(START_DATE,dateformat_style)#</td>
							<td><cfif session.ep.isBranchAuthorization eq 0>
									<a href="#request.self#?fuseaction=product.list_product_cost&event=det&pid=#get_product_cost.product_id#" class="tableyazi">
									<cfif inventory_calc_type eq 1><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'>
									<cfelseif inventory_calc_type eq 2><cf_get_lang dictionary_id='37081.Son Giren İlk Çıkar'>
									<cfelseif inventory_calc_type eq 3><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'>
									<cfelseif inventory_calc_type eq 4><cf_get_lang dictionary_id='37083.Son Alış Fiyatı'>
									<cfelseif inventory_calc_type eq 5><cf_get_lang dictionary_id='37084.İlk Alış Fiyatı'>
									<cfelseif inventory_calc_type eq 6><cf_get_lang dictionary_id='58722.Standart Alış'>
									<cfelseif inventory_calc_type eq 7><cf_get_lang dictionary_id='58721.Standart Satış'>
									<cfelseif inventory_calc_type eq 8><cf_get_lang dictionary_id='37085.Üretim Maliyeti'></cfif>
									</a>
								<cfelse>
									<cfif inventory_calc_type eq 1><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'>
									<cfelseif inventory_calc_type eq 2><cf_get_lang dictionary_id='37081.Son Giren İlk Çıkar'>
									<cfelseif inventory_calc_type eq 3><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'>
									<cfelseif inventory_calc_type eq 4><cf_get_lang dictionary_id='37083.Son Alış Fiyatı'>
									<cfelseif inventory_calc_type eq 5><cf_get_lang dictionary_id='37084.İlk Alış Fiyatı'>
									<cfelseif inventory_calc_type eq 6><cf_get_lang dictionary_id='58722.Standart Alış'>
									<cfelseif inventory_calc_type eq 7><cf_get_lang dictionary_id='58721.Standart Satış'>
									<cfelseif inventory_calc_type eq 8><cf_get_lang dictionary_id='37085.Üretim Maliyeti'></cfif>
								</cfif>
							</td>
							<cfif session.ep.isBranchAuthorization eq 0>
								<td style="text-align:right;">#tlformat(PURCHASE_NET,4)# </td>
								<td>&nbsp;#PURCHASE_NET_MONEY#</td>
								<td style="text-align:right;">#tlformat(PURCHASE_EXTRA_COST,4)# </td>
								<td>&nbsp;#PURCHASE_NET_MONEY#</td>
								<td style="text-align:right;">#tlformat(STANDARD_COST,4)# </td>
								<td>&nbsp;#STANDARD_COST_MONEY#</td>
								<td style="text-align:right;">% #tlformat(STANDARD_COST_RATE)#</td>
								<td style="text-align:right;">#tlformat(PRICE_PROTECTION,4)# </td>
								<td>&nbsp;#PRICE_PROTECTION_MONEY#</td>
								<td style="text-align:right;">#tlformat(PRODUCT_COST,4)# </td>
								<td>&nbsp;#MONEY#</td>
								<!-- sil -->
								<td width="10"><a href="#request.self#?fuseaction=product.list_product_cost&event=det&pid=#get_product_cost.product_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
								<!-- sil -->
							<cfelse>
								<td>#DEPARTMENT#</td>
								<td style="text-align:right;">#tlformat(PURCHASE_NET_LOCATION,4)# </td>
								<td>&nbsp;#PURCHASE_NET_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(PURCHASE_EXTRA_COST,4)# </td>
								<td>&nbsp;#PURCHASE_NET_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(STANDARD_COST_LOCATION,4)# </td>
								<td>&nbsp;#STANDARD_COST_MONEY_LOCATION#</td>
								<td style="text-align:right;">% #tlformat(STANDARD_COST_RATE_LOCATION)#</td>
								<td style="text-align:right;">#tlformat(PRICE_PROTECTION_LOCATION,4)# </td>
								<td>&nbsp;#PRICE_PROTECTION_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(PRODUCT_COST_LOCATION,4)# </td>
								<td>&nbsp;#MONEY_LOCATION#</td>
								<!-- sil -->
								<td width="10"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=store.popup_list_product_cost_detail&pid=#get_product_cost.product_id#&location=1','horizantal')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
								<!-- sil -->
							</cfif>	
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif not get_product_cost.recordcount>
		<div class="ui-info-bottom">
			<cfif arama_yapilmali eq 1 ><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif>
		</div>
	</cfif>
		<cfset adres = url.fuseaction>
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
		<cfset adres = '#adres#&cat=#attributes.cat#'>
		</cfif>
		<cfif len(attributes.brand_id)>
		<cfset adres = '#adres#&brand_id=#attributes.brand_id#'>
		</cfif>
		<cfif isDefined('attributes.pos_code') and len(attributes.pos_code)>
		<cfset adres = '#adres#&pos_code=#attributes.pos_code#'>
		</cfif>
		<cfif isDefined('attributes.pos_manager') and len(attributes.pos_manager)>
		<cfset adres = '#adres#&pos_manager=#attributes.pos_manager#'>
		</cfif>
		<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
		<cfset adres = '#adres#&company_id=#attributes.company_id#'>
		</cfif>		
		<cfif len(attributes.keyword)>
		<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isDefined('attributes.product_status') and len(attributes.product_status)>
		<cfset adres = '#adres#&product_status=#attributes.product_status#'>
		</cfif>
		<cfif isdefined('attributes.product_types') and len(attributes.product_types)>
		<cfset adres = '#adres#&product_types=#attributes.product_types#'>
		</cfif>
		<cfif len(attributes.brand_name)>
		<cfset adres = '#adres#&brand_name=#attributes.brand_name#'>
		</cfif>
		<cfif isDefined('attributes.employee') and len(attributes.employee)>
		<cfset adres = '#adres#&employee=#attributes.employee#'>
		</cfif>
		<cfif isDefined('attributes.company') and len(attributes.company)>
		<cfset adres = '#adres#&company=#attributes.company#'>
		</cfif>
		<cfif isDefined('attributes.special_code') and len(attributes.special_code)>
		<cfset adres = '#adres#&special_code=#attributes.special_code#'>
		</cfif>
		<cfif isDefined('attributes.inventory_calc_type') and len(attributes.inventory_calc_type)>
		<cfset adres = '#adres#&inventory_calc_type=#attributes.inventory_calc_type#'>
		</cfif>
		<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#&is_form_submitted=1">

	</cf_box>
</div>
<script type="text/javascript">
$('#keyword').focus();
//document.getElementById('keyword').focus();
function input_control()
{
	if(!$("#maxrows").val().length)
	{
		alert("<cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'>")    
		return false;
	}
	if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
	if(search_product.company.value.length == 0) search_product.company_id.value = '';
	if(search_product.pos_manager.value.length == 0) search_product.pos_code.value = '';
	<cfif not session.ep.our_company_info.unconditional_list>
		if(search_product.keyword.value.length == 0 && search_product.cat.value.length == 0 && search_product.inventory_calc_type.value.length == 0 && (search_product.brand_id.value.length == 0 || search_product.brand_name.value.length == 0) && (search_product.pos_code.value.length == 0 || search_product.pos_manager.value.length == 0) && (search_product.company_id.value.length == 0 || search_product.company.value.length == 0) )
		{
			alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz '>!");
			return false;
		}
		else
			return true;
	<cfelse>
		return true;
	</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
